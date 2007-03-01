Return-Path: <linux-kernel-owner+w=401wt.eu-S933204AbXCAJRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933204AbXCAJRk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 04:17:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933195AbXCAJRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 04:17:39 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:46588 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933204AbXCAJRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 04:17:37 -0500
Date: Thu, 1 Mar 2007 12:15:28 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Andrea Arcangeli <andrea@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070301091527.GH7217@2ka.mipt.ru>
References: <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com> <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu> <Pine.LNX.4.64.0702221130050.1356@alien.or.mcafeemobile.com> <20070228094522.GA17716@elte.hu> <Pine.LNX.4.64.0702280740250.5935@alien.or.mcafeemobile.com> <Pine.LNX.4.64.0702280836080.12485@woody.linux-foundation.org> <20070228231228.GA12328@elte.hu> <20070301013301.GK21944@v2.random>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070301013301.GK21944@v2.random>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Thu, 01 Mar 2007 12:15:56 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 02:33:01AM +0100, Andrea Arcangeli (andrea@suse.de) wrote:
> On Thu, Mar 01, 2007 at 12:12:28AM +0100, Ingo Molnar wrote:
> > more capable by providing more special system calls like sys_upcall() to 
> > execute a user-space function. (that way a syslet could still execute 
> > user-space code without having to exit out of kernel mode too 
> > frequently) Or perhaps a sys_x86_bytecode() call, that would execute a 
> > pre-verified, kernel-stored sequence of simplified x86 bytecode, using 
> > the kernel stack.
> 
> Which means the userspace code would then run with kernel privilege
> level somehow (after security verifier, whatever). You remember I
> think it's a plain crazy idea...

Syslets/threadlets do not execute userspace code in kernel - they behave
similar to threads. sys_upcall() would be a wrapper for quite complex
threadlet machinery.

-- 
	Evgeniy Polyakov
