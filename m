Return-Path: <linux-kernel-owner+w=401wt.eu-S936937AbXGQVEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936937AbXGQVEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 17:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765164AbXGQVEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 17:04:23 -0400
Received: from mail.gmx.net ([213.165.64.20]:37029 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760832AbXGQVEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 17:04:20 -0400
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
Content-Type: text/plain; charset="us-ascii"
Date: Tue, 17 Jul 2007 23:04:17 +0200
From: "Michael Kerrisk" <mtk-manpages@gmx.net>
In-Reply-To: <Pine.LNX.4.64.0707171253570.26781@alien.or.mcafeemobile.com>
Message-ID: <20070717210417.257740@gmx.net>
MIME-Version: 1.0
References: <469C6C9B.4070801@gmx.net>
 <Pine.LNX.4.64.0707171253570.26781@alien.or.mcafeemobile.com>
Subject: Re: timerfd(2) draft man page plus questions
To: Davide Libenzi <davidel@xmailserver.org>
X-Authenticated: #24879014
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1+UAms9pL2UXoqFXyDT7DLdxUSwwJMaJJNkm0sYah
 W3WuQ9Qt4rjQxwXNKxR5g86AKf07SROl0G4w== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: 6RmucuwWf2IsFPH2F21oPmx4dWxlc5aA
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > 1. timer_settime() and setitimer() both permit the caller to obtain 
> > the old value of the timer when modifying an existing timer.  Why 
> > doesn't timerfd() provide this functionality?
> 
> I don't know ;) Would it be any useful?

Well given that the two older APIs both provide this
functionality, it seems that it is desired in applications. It 
is a shame that the new API doesn't have this.  It could be 
added (I'm inclined to say, it should be): the only problem
is that the syscall is now out in the wild, so a change at
this point would not be ABI compatible.  However, it only just 
got into the wild (and hasn't made it into glibc yet), so now
would be a good time to fix it, if you are agreeable, and the
kernel gatekeepers are prepared to tolerate the ABI change.

Cheers,

Michael
-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7 

Want to help with man page maintenance?  
Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages , 
read the HOWTOHELP file and grep the source 
files for 'FIXME'.

