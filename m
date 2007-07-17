Return-Path: <linux-kernel-owner+w=401wt.eu-S934139AbXGQWGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934139AbXGQWGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 18:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757991AbXGQWGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 18:06:11 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1199 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757530AbXGQWGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 18:06:10 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 17 Jul 2007 15:06:01 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Michael Kerrisk <mtk-manpages@gmx.net>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, akpm@osdl.org
Subject: Re: timerfd(2) draft man page plus questions
In-Reply-To: <20070717210417.257740@gmx.net>
Message-ID: <Pine.LNX.4.64.0707171501420.26781@alien.or.mcafeemobile.com>
References: <469C6C9B.4070801@gmx.net> <Pine.LNX.4.64.0707171253570.26781@alien.or.mcafeemobile.com>
 <20070717210417.257740@gmx.net>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007, Michael Kerrisk wrote:

> > > 1. timer_settime() and setitimer() both permit the caller to obtain 
> > > the old value of the timer when modifying an existing timer.  Why 
> > > doesn't timerfd() provide this functionality?
> > 
> > I don't know ;) Would it be any useful?
> 
> Well given that the two older APIs both provide this
> functionality, it seems that it is desired in applications. It 
> is a shame that the new API doesn't have this.  It could be 
> added (I'm inclined to say, it should be): the only problem
> is that the syscall is now out in the wild, so a change at
> this point would not be ABI compatible.  However, it only just 
> got into the wild (and hasn't made it into glibc yet), so now
> would be a good time to fix it, if you are agreeable, and the
> kernel gatekeepers are prepared to tolerate the ABI change.

But the old status of the timer is the union of clickid, flags and utmr. 
So, in theory, the whole set should be returned back, forcing a pretty 
drastic API change.
IMHO, given that is not really clear what the real advantages would be in 
the API change, I'd rather prefer to leave the current one.



- Davide


