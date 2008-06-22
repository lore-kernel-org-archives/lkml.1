Return-Path: <linux-kernel-owner+w=401wt.eu-S1756538AbYFVOWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538AbYFVOWb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 10:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756246AbYFVOV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 10:21:56 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35781 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756217AbYFVOVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 10:21:53 -0400
From: Paul Jackson <pj@sgi.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, "Jack Steiner" <steiner@sgi.com>,
       "Mike Travis" <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>
Date: Sun, 22 Jun 2008 07:21:51 -0700
Message-Id: <20080622142151.5591.4139.sendpatchset@polaris-admin.engr.sgi.com>
Subject: [PATCH 0/5 v2] x86 boot: various E820 & EFI related fixes - what changed in v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches differ from their previous versions,
submitted a week ago, on the evening of Sun, 15 Jun 2008,
in the following ways:
 1) The "x86_64 build reserve_bootmem_generic fix" patch
    is dropped, because it is already fixed in linux-next.
    Thanks to Yinghai Lu.
 2) The "allow overlapping ebda and efi memmap memory ranges"
    patch is reworked.  Instead of allowing overlapping early
    memory reservations on EFI boots, rather it allows
    particular early memory reservations to overlap, if they
    have been so marked.  Only the EBDA "BIOS reserved"
    reservation is so marked for now; only it can overlap.
    Thanks to H. Peter Anvin and Huang Ying.
 3) The patches "remap efi systab runtime from phys to virt"
    and "virtualize the efi runtime function callback addresses"
    are dropped.  They were incorrect.  I fixed my EFI firmware
    to follow the spec instead.  Thanks to Huang Ying.

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
