Return-Path: <linux-kernel-owner+w=401wt.eu-S1752354AbXBYQnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbXBYQnx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 11:43:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbXBYQnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 11:43:53 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:57160 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352AbXBYQnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 11:43:52 -0500
Date: Sat, 24 Feb 2007 21:34:21 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070224183421.GA6835@2ka.mipt.ru>
References: <20070221211355.GA7302@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070221211355.GA7302@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 10:13:55PM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> this is the v3 release of the syslet/threadlet subsystem:
> 
>    http://redhat.com/~mingo/syslet-patches/

There is no %xgs.

--- ./arch/i386/kernel/process.c~	2007-02-24 22:56:14.000000000 +0300
+++ ./arch/i386/kernel/process.c	2007-02-24 22:53:19.000000000 +0300
@@ -426,7 +426,6 @@
 
 	regs.xds = __USER_DS;
 	regs.xes = __USER_DS;
-	regs.xgs = __KERNEL_PDA;
 	regs.orig_eax = -1;
 	regs.eip = (unsigned long) async_thread_helper;
 	regs.xcs = __KERNEL_CS | get_kernel_rpl();


-- 
	Evgeniy Polyakov
