Return-Path: <linux-kernel-owner+w=401wt.eu-S1760082AbXIRQwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760082AbXIRQwF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 12:52:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757100AbXIRQv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 12:51:56 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:58899 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765AbXIRQvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 12:51:55 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 18 Sep 2007 09:51:48 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Michael Kerrisk <mtk-manpages@gmx.net>
cc: Ulrich Drepper <drepper@redhat.com>, geoff@glare.org.uk,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
       Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@xenotime.net>,
       vda.linux@googlemail.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: RFC: A revised timerfd API
In-Reply-To: <46EF7DDA.2070401@gmx.net>
Message-ID: <Pine.LNX.4.64.0709180936480.22956@alien.or.mcafeemobile.com>
References: <46EF7DDA.2070401@gmx.net>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007, Michael Kerrisk wrote:

> The four designs are:
> 
> a) A multiplexing timerfd() system call.
> b) Creating three syscalls analogous to the POSIX timers API (i.e.,
>    timerfd_create/timerfd_settime/timerfd_gettime).
> c) Creating a simplified timerfd() system call that is integrated
>    with the POSIX timers API.
> d) Extending the POSIX timers API to support the timerfd concept.

If you really want to shoot yourself in your foot, I'd pick bullet B.
Bullet A makes me sea-sick, and bullets C and D, well, let's leave POSIX 
APIs being *POSIX* APIs.
Once you remove all the "ifs" and "elses" that resulted from your previous 
bullet A multiplexing implementation, timerfd_gettime and timerfd_settime 
should result in being pretty slick.
I still think we could have survived w/out all this done inside the 
kernel though.



- Davide


