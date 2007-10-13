Return-Path: <linux-kernel-owner+w=401wt.eu-S1762605AbXJMVNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762605AbXJMVNK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 17:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbXJMVM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 17:12:57 -0400
Received: from www.tglx.de ([62.245.132.106]:42452 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571AbXJMVM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 17:12:56 -0400
Date: Sat, 13 Oct 2007 23:12:46 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Roland Dreier <roland@digitalvampire.org>
cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: x86: merge some trivially mergeable headers
In-Reply-To: <87bqb2u4ez.fsf@shaolin.home.digitalvampire.org>
Message-ID: <alpine.LFD.0.9999.0710132307360.12017@localhost.localdomain>
References: <87bqb2u4ez.fsf@shaolin.home.digitalvampire.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Oct 2007, Roland Dreier wrote:

> Merge errno.h, resource.h, rtc.h, sections.h, serial.h and sockios.h,
> where i386 and x86_64 have no or only trivial comment/include guard
> differences.
> 
> Build tested on both 32-bit and 64-bit, and booted on 64-bit.
> 
> Signed-off-by: Roland Dreier <roland@digitalvampire.org>
> ---
> Not sure who's merging this type of stuff so I just picked a grab bag
> of people to put on the To: line.
> 
> Also I'm not sure if someone else is already working on this, so I'm
> just sending out about 15 minutes of work.  If this is helpful I'll do
> more of the easy ones...

Roland, thanks for providing this. I have some of those already, but I 
really appreciate the help. I take yours and the previously posted and 
push them out into a cleanup branch on my x86 git tree.

I guess it will be unavoidable that there will be some overlap on the low 
hanging fruit merges, but anyone who is tackling a more complex one should 
make this public upfront so we can avoid the redundant work.

Thanks,
	tglx
 
