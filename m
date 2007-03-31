Return-Path: <linux-kernel-owner+w=401wt.eu-S933279AbXCaB3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933279AbXCaB3z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 21:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933286AbXCaB3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 21:29:55 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:47614 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933279AbXCaB3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 21:29:54 -0400
X-AuthUser: davidel@xmailserver.org
Date: Fri, 30 Mar 2007 18:29:52 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [patch 1/13] signal/timer/event fds v8 - anonymous inode source
 ...
In-Reply-To: <20070330160850.d7988a87.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703301828350.3721@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.28743.1174415834.1>
 <20070330123943.8df1aa92.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0703301532500.3721@alien.or.mcafeemobile.com>
 <20070330160850.d7988a87.akpm@linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2007, Andrew Morton wrote:

> I'd say panic.  There's no much point in limping along with an
> incorrectly-working kernel, only to have some small number of apps fail
> mysteriously later on.

Panic it is ...


> > > Can we make this optional if CONFIG_EMBEDDED?  You plan on converting epoll
> > > to use this facility, but with CONFIG_EPOLL=n, this is all dead code?
> > 
> > Hmmm, the whole point is that all this stuff works with or without epoll. 
> > And epoll need no changes to support this.
> 
> I'm suggesting that all known clients of anon_inode be made optional. 
> Hence anon_iode can become optional too.
> 
> It's a desirable objective, at least.  The default, really.

Ok, I'll put them under Kconf.



- Davide


