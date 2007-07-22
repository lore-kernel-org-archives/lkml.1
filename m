Return-Path: <linux-kernel-owner+w=401wt.eu-S932680AbXGVXbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680AbXGVXbR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 19:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754698AbXGVXbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 19:31:08 -0400
Received: from ns2.suse.de ([195.135.220.15]:40088 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585AbXGVXbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 19:31:07 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Andre Noll <maan@systemlinux.org>
Subject: Re: Linus 2.6.23-rc1
Date: Mon, 23 Jul 2007 01:31:00 +0200
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <200707230022.11831.ak@suse.de> <20070722232338.GI30660@skl-net.de>
In-Reply-To: <20070722232338.GI30660@skl-net.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707230131.00302.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 July 2007 01:23:38 Andre Noll wrote:
> On 00:22, Andi Kleen wrote:
> > > /usr/bin/ld: section .text [ffffffffff700500 -> ffffffffff7007e3] overlaps section .gnu.version_d [ffffffffff7004d8 -> ffffffffff70050f]
> > 
> > Does this patch fix it?
> 
> Nope, with 0x600 I still get the same error. But it helped to further
> increase VDSO_TEXT_OFFSET to 0xc00. I tried 0x700, 0x800,... and 0xc00
> is the smallest value in this series that makes the error go away, i.e.
> the patch below works for me.

Can you send (privately) readelf -a output from your vdso.so ? 
Your linker must be doing something weird.

0xc00 is quite wasteful.

-Andi
