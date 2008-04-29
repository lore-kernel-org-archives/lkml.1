Return-Path: <linux-kernel-owner+w=401wt.eu-S1759213AbYD2HqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759213AbYD2HqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 03:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753679AbYD2HqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 03:46:07 -0400
Received: from brick.kernel.dk ([87.55.233.238]:1740 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636AbYD2HqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 03:46:06 -0400
Date: Tue, 29 Apr 2008 09:46:03 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@mailshack.com>, jdike@addtoit.com,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [2.6 patch] block/blk-barrier.c:blk_ordered_cur_seq() mustn't be  inline
Message-ID: <20080429074603.GD12774@kernel.dk>
References: <20080424215739.GA32378@elte.hu> <alpine.LFD.1.10.0804241510420.2779@woody.linux-foundation.org> <20080426151516.GA27894@elte.hu> <alpine.LFD.1.10.0804260955300.2813@woody.linux-foundation.org> <20080426172222.GD17345@elte.hu> <20080428153839.GE2813@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428153839.GE2813@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28 2008, Adrian Bunk wrote:
> This patch fixes the following build error with UML and gcc 4.3:
> 
> <--  snip  -->
> 
> ...
>   CC      block/blk-barrier.o
> /home/bunk/linux/kernel-2.6/git/linux-2.6/block/blk-barrier.c: In function ???blk_do_ordered???:
> /home/bunk/linux/kernel-2.6/git/linux-2.6/block/blk-barrier.c:57: sorry, unimplemented: inlining failed in call to ???blk_ordered_cur_seq???: function body not available
> /home/bunk/linux/kernel-2.6/git/linux-2.6/block/blk-barrier.c:252: sorry, unimplemented: called from here
> /home/bunk/linux/kernel-2.6/git/linux-2.6/block/blk-barrier.c:57: sorry, unimplemented: inlining failed in call to ???blk_ordered_cur_seq???: function body not available
> /home/bunk/linux/kernel-2.6/git/linux-2.6/block/blk-barrier.c:253: sorry, unimplemented: called from here
> make[2]: *** [block/blk-barrier.o] Error 1
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Applied

-- 
Jens Axboe

