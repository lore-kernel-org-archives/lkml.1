Return-Path: <linux-kernel-owner+w=401wt.eu-S964875AbXIFXhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964875AbXIFXhX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 19:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932646AbXIFXhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 19:37:10 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:47989 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932631AbXIFXhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 19:37:07 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 6 Sep 2007 16:37:03 -0700 (PDT)
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
In-Reply-To: <20070906065816.194530@gmx.net>
Message-ID: <Pine.LNX.4.64.0709061629250.14600@alien.or.mcafeemobile.com>
References: <20070825064114.107820@gmx.net> <Pine.LNX.4.64.0708300458120.7717@alien.or.mcafeemobile.com>
 <46DD116C.4040301@gmx.net> <20070904011800.762523a4.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0709040805490.6887@alien.or.mcafeemobile.com>
 <20070904204932.208520@gmx.net> <Pine.LNX.4.64.0709041541500.7326@alien.or.mcafeemobile.com>
 <20070905000831.313400@gmx.net> <Pine.LNX.4.64.0709050901420.11426@alien.or.mcafeemobile.com>
 <20070905162352.236680@gmx.net> <Pine.LNX.4.64.0709051251290.11804@alien.or.mcafeemobile.com>
 <20070905225033.236700@gmx.net> <Pine.LNX.4.64.0709051604320.5320@alien.or.mcafeemobile.com>
 <20070906065816.194530@gmx.net>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Sep 2007, Michael Kerrisk wrote:

> You are asserting this in the face of two previous APIs designed 
> by people who (at least in the case of POSIX timers) probably 
> thoroughly examined and discussed existing APIs and practice.

You really think that. Uhmm, ok.



> This function is *not at all* equivalent to the "get"
> functionality of the previous APIs.  The "get" functionality
> of POSIX timers (for example) returns a structure that contains
> the timer interval and the *time until the next expiration of
> the timer* (not the initial timer string, as your code above
> does).
> So come up with a reliable, race-free way of doing that in
> userspace.  Then make it work for both CLOCK_MONOTONIC and
> CLOCK_REALTIME timers.  (You'll certainly need to be making
> some additional system calls, by the way: at least some
> calls to clock_gettime().)

No, I don't think I will. Since 1) it's so trivial it's not even 
challenging 2) you know it can be done (I assume) 3) it solves a non-case 
made up to justify an API/kernel-code bloating.
But you don't need *my* signoff. Cook a working patch, make a case for it, 
and gather support and signoffs. I won't be acking it because, as I said 
many times, I think it's useless bloating.



- Davide


