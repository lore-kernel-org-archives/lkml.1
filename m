Return-Path: <linux-kernel-owner+w=401wt.eu-S1753433AbXJWK5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753433AbXJWK5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 06:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbXJWK5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 06:57:43 -0400
Received: from brick.kernel.dk ([87.55.233.238]:11198 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683AbXJWK5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 06:57:42 -0400
Date: Tue, 23 Oct 2007 12:56:15 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Boaz Harrosh <bharrosh@panasas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 09/10] Change table chaining layout
Message-ID: <20071023105615.GI5059@kernel.dk>
References: <1193076664-13652-10-git-send-email-jens.axboe@oracle.com> <Pine.LNX.4.64.0710222137520.7105@anakin> <alpine.LFD.0.999.0710221248120.30120@woody.linux-foundation.org> <20071022211617.31f5c63d@the-village.bc.nu> <alpine.LFD.0.999.0710221343330.30120@woody.linux-foundation.org> <20071022224343.4abf3c96@the-village.bc.nu> <alpine.LFD.0.999.0710221444220.30120@woody.linux-foundation.org> <471DBEF4.4030303@panasas.com> <20071023094142.GD5059@kernel.dk> <20071023103351.GA2795@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023103351.GA2795@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23 2007, Ingo Molnar wrote:
> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > It's all about the end goal - having maintainable and resilient code. 
> > And I think the sg code will be better once we get past the next day 
> > or so, and it'll be more robust. That is what matters to me, not the 
> > simplicity of the patch itself.
> 
> Linus' latest tree, which has your SG-list enhancements included, 
> certainly works fine here and does not have the problems of the first 
> iteration.

That's good to hear :-)

I have a series of pending patches where I've collected fallout patches
from people and some from myself here:

http://git.kernel.dk/?p=linux-2.6-block.git;a=shortlog;h=sg

or pullable from

git://git.kernel.dk/inux-2.6-block.git sg

As far as I can tell, all archs should now compile and work. I've tested
(compile tested) alpha/arm/ia64/m68k/mips/sh/sparc this morning and
fixed whatever showed up. It's all just a missing linux/scatterlist.h
include or ->page usage.

-- 
Jens Axboe

