Return-Path: <linux-kernel-owner+w=401wt.eu-S933843AbYDWAGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933843AbYDWAGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 20:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760468AbYDWAGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 20:06:08 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:34839 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760151AbYDWAGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 20:06:07 -0400
Date: Wed, 23 Apr 2008 03:05:29 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, rmk@arm.linux.org.uk
Subject: Re: [git patch] free_irq() fixes
Message-ID: <20080423000529.GG28933@cs181133002.pp.htv.fi>
References: <20080422221733.GA16260@havoc.gtf.org> <alpine.LFD.1.10.0804221518520.2779@woody.linux-foundation.org> <480E6DE5.6010103@garzik.org> <alpine.LFD.1.10.0804221616280.2779@woody.linux-foundation.org> <480E796E.4070001@garzik.org> <alpine.LFD.1.10.0804221651400.2779@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804221651400.2779@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 04:52:44PM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 22 Apr 2008, Jeff Garzik wrote:
> > [...]
> > > Since the #irq-remove project involves removal of the 'irq' argument
> > > from interrupt handlers (unused 99.8% of the time),
> > [...]
> > 
> > After going over every irq handler (read: almost every driver in the kernel,
> > plus arch code), my #irq-remove branch has confirmed what my gut already knew
> > -- the 'irq' argument is completely unused for almost every driver.  So I was
> > taking that line of thought as far as it went.
> 
> Ok, that's just not going to happen.
> 
> What's the upside? Really?
> 
> I can tell you the downsides:
>  - tons of huge patches with ugly churn
>...

If it goes like the regs removal in one big patch around -rc1 into your 
tree this shouldn't be a problem.

> 		Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

