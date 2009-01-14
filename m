Return-Path: <linux-kernel-owner+w=401wt.eu-S1758432AbZANOWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758432AbZANOWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 09:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754008AbZANOWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 09:22:06 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:57675 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbZANOWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 09:22:04 -0500
X-BigFish: VPS-37(zz1432R62a3L98dR936eQ1805Mzzzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 7,
X-WSS-ID: 0KDGT85-02-7FT-01
Date: Wed, 14 Jan 2009 15:21:24 +0100
From: Robert Richter <robert.richter@amd.com>
To: Maynard Johnson <maynardj@us.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: Re: [PATCH 01/18] oprofile: rename kernel-wide identifiers
Message-ID: <20090114142123.GA11465@erda.amd.com>
References: <1231366655-17837-1-git-send-email-robert.richter@amd.com> <1231366655-17837-2-git-send-email-robert.richter@amd.com> <496CD537.5050803@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <496CD537.5050803@us.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 14 Jan 2009 14:21:25.0659 (UTC) FILETIME=[6213AEB0:01C97653]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.01.09 11:53:59, Maynard Johnson wrote:
> Robert Richter wrote:
> > This patch renames kernel-wide identifiers to something more oprofile
> > specific names.
> Are these oprofile-specific names going to be exported outside the oprofile kernel driver at some point?  If not, I don't really see the need for these changes.  Maybe I'm missing something . . .

These names are visible as symbols when compiling into the
kernel. There would be a collision with any other non-static variable
or function in any other file.

 $ nm .build/oprofile-x86_64-standard.obj/vmlinux | grep oprofile_cpu_buffer_size
 ffffffff808bf428 B oprofile_cpu_buffer_size

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

