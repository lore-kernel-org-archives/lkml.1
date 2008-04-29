Return-Path: <linux-kernel-owner+w=401wt.eu-S1758712AbYD2IH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712AbYD2IH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 04:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbYD2IHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 04:07:11 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:50111 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbYD2IHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 04:07:09 -0400
Date: Tue, 29 Apr 2008 11:06:31 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@mailshack.com>, jdike@addtoit.com
Subject: Re: [2.6 patch] fs/block_dev.c:I_BDEV() mustn't be inline
Message-ID: <20080429080631.GB28059@cs181133002.pp.htv.fi>
References: <20080424215739.GA32378@elte.hu> <alpine.LFD.1.10.0804241510420.2779@woody.linux-foundation.org> <20080426151516.GA27894@elte.hu> <alpine.LFD.1.10.0804260955300.2813@woody.linux-foundation.org> <20080426172222.GD17345@elte.hu> <20080428153831.GC2813@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804281736230.3119@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804281736230.3119@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 05:41:11PM -0700, Linus Torvalds wrote:
>...
> > -inline struct block_device *I_BDEV(struct inode *inode)
> > +struct block_device *I_BDEV(struct inode *inode)
> >  {
> >  	return &BDEV_I(inode)->bdev;
> >  }
> 
> There is NO WAY IN HELL this function shouldn't be inlined,
>...

Then CONFIG_OPTIMIZE_INLINING already broke it in your tree.

> 			Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

