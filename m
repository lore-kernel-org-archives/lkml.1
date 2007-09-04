Return-Path: <linux-kernel-owner+w=401wt.eu-S1755872AbXIDWpD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbXIDWpD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 18:45:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754341AbXIDWoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 18:44:54 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2165 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336AbXIDWox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 18:44:53 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 4 Sep 2007 15:44:49 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Michael Kerrisk <mtk-manpages@gmx.net>
cc: Andrew Morton <akpm@linux-foundation.org>, corbet@lwn.net,
       jengelh@computergmbh.de, hch@lst.de, stable@kernel.org,
       Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       tglx@linutronix.de, rdunlap@xenotime.net
Subject: Re: [PATCH] Revised timerfd() interface
In-Reply-To: <20070904204932.208520@gmx.net>
Message-ID: <Pine.LNX.4.64.0709041541500.7326@alien.or.mcafeemobile.com>
References: <20070825064114.107820@gmx.net> <Pine.LNX.4.64.0708300458120.7717@alien.or.mcafeemobile.com>
 <46DD116C.4040301@gmx.net> <20070904011800.762523a4.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0709040805490.6887@alien.or.mcafeemobile.com>
 <20070904204932.208520@gmx.net>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Sep 2007, Michael Kerrisk wrote:

> > Useless like it'd be a motorcycle w/out a cup-holder :)
> > Seriously, the ability to get the previous values from "something" could 
> > have a meaning if this something is a shared global resource (like 
> > signals
> > for example). In the timerfd case this makes little sense, since you can 
> > create as many timerfd as you like and you do not need to share a single 
> > one by changing/restoring the original context.
> 
> Davide,
> 
> As I think about this more, I see more problems with
> your argument.  timerfd needs the ability to get and 
> get-while-setting just as much as the earlier APIs.
> Consider a library that creates a timerfd file descriptor that
> is handed off to an application: that library may want
> to modify the timer settings without having to create a
> new file descriptor (the app mey not be able to be told about
> the new fd).  Your argument just doesn't hold, AFAICS.

Such hypotethical library, in case it really wanted to offer such 
functionality, could simply return an handle instead of the raw fd, and 
take care of all that stuff in userspace.
Again, mimicking POSIX APIs doesn't always take you in the right place.



- Davide


