Return-Path: <linux-kernel-owner+w=401wt.eu-S936031AbYD1QDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936031AbYD1QDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 12:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934006AbYD1QCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 12:02:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55701 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933920AbYD1QCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 12:02:53 -0400
Date: Mon, 28 Apr 2008 09:01:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@mailshack.com>, jdike@addtoit.com
Subject: Re: [2.6 patch] fs/buffer.c:init_buffer() mustn't be inline
In-Reply-To: <20080428153829.GB2813@cs181133002.pp.htv.fi>
Message-ID: <alpine.LFD.1.10.0804280901130.3119@woody.linux-foundation.org>
References: <20080424215739.GA32378@elte.hu> <alpine.LFD.1.10.0804241510420.2779@woody.linux-foundation.org> <20080426151516.GA27894@elte.hu> <alpine.LFD.1.10.0804260955300.2813@woody.linux-foundation.org> <20080426172222.GD17345@elte.hu>
 <20080428153829.GB2813@cs181133002.pp.htv.fi>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 28 Apr 2008, Adrian Bunk wrote:
<
> This patch fixes the following build error with UML and gcc 4.3:
> 
> <--  snip  -->
> 
> ...
>   CC      fs/buffer.o
> /home/bunk/linux/kernel-2.6/git/linux-2.6/fs/buffer.c: In function ‘init_page_buffers’:
> /home/bunk/linux/kernel-2.6/git/linux-2.6/fs/buffer.c:51: sorry, unimplemented: inlining failed in call to ‘init_buffer’: function body not available
> /home/bunk/linux/kernel-2.6/git/linux-2.6/fs/buffer.c:1007: sorry, unimplemented: called from here
> make[2]: *** [fs/buffer.o] Error 1

Can somebody tell why this is not a gcc bug?

		Linus
