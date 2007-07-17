Return-Path: <linux-kernel-owner+w=401wt.eu-S933401AbXGQTz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933401AbXGQTz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 15:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbXGQTzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 15:55:45 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2066 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757369AbXGQTzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 15:55:44 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 17 Jul 2007 12:55:38 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Michael Kerrisk <mtk-manpages@gmx.net>
cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: timerfd(2) draft man page plus questions
In-Reply-To: <469C6C9B.4070801@gmx.net>
Message-ID: <Pine.LNX.4.64.0707171253570.26781@alien.or.mcafeemobile.com>
References: <469C6C9B.4070801@gmx.net>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007, Michael Kerrisk wrote:

> Hi Davide,
> 
> Below is my current draft of the timerfd.2 man page.  There are a number of
>  points that I'm not sure of, and a few questions, all marked "FIXME
> Davide" -- could you take a look at those please.
> 
> Aside from that there are a couple of questions I have on details of the
> call (one of which I already started to cover off list).
> 
> 1. timer_settime() and setitimer() both permit the caller to obtain the old
> value of the timer when modifying an existing timer.  Why doesn't timerfd()
> provide this functionality?

I don't know ;) Would it be any useful?



> 2. What if there are more expirations than can fit in a uint32_t?  (Why
> wasn't this value uint64_t, as with eventfd()?)  (Actually, there seems to
> be a bug which means that at the moment only a single byte of info is being
> returned, but I'll cover that in a separate mail.)

I just sent a patch to Andrew to make that an uint64_t and to fix the cast 
in __put_user.



- Davide



