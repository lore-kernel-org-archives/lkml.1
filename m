Return-Path: <linux-kernel-owner+w=401wt.eu-S1756717AbZAaAld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbZAaAld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 19:41:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbZAaAlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 19:41:25 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53658 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbZAaAlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 19:41:24 -0500
Date: Sat, 31 Jan 2009 01:41:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kbuild: drop check for CONFIG_ in headers_check
Message-ID: <20090131004111.GB13709@elte.hu>
References: <1233342254.21493.8.camel@localhost.localdomain> <20090130225642.GA17950@uranus.ravnborg.org> <20090130234012.GF4922@elte.hu> <200901310127.03142.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200901310127.03142.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnd Bergmann <arnd@arndb.de> wrote:

> On Saturday 31 January 2009, Ingo Molnar wrote:
> > Jaswinder, i think we now have a realistic chance to reach a zero baseline 
> > with these warnings, for v2.6.29. Here are the remaining warnings (summed 
> > up per file) on x86 (after Sam's patch):
> > 
> >      17 /dev/shm/tip/usr/include/linux/reiserfs_fs.h
> >      12 /dev/shm/tip/usr/include/linux/soundcard.h
> >       3 /dev/shm/tip/usr/include/linux/nubus.h
> >       2 /dev/shm/tip/usr/include/linux/in6.h
> >       1 /dev/shm/tip/usr/include/mtd/jffs2-user.h
> >       1 /dev/shm/tip/usr/include/linux/socket.h
> >       1 /dev/shm/tip/usr/include/linux/coda_psdev.h
> >       1 /dev/shm/tip/usr/include/linux/bsg.h
> > 
> 
> Ah, that doesn't look too bad. On a related subject, was there ever a 
> conclusion about whether we want to support __KERNEL_STRICT_NAMES in 
> every header? When that is set, headers cannot use most of the standard 
> types (dev_t, mode_t, off_t, pid_t, suseconds_t, timer_t, uid_t, gid_t, 
> loff_t, time_t, clock_t, caddr_t, pgoff_t, {u_,u,}int{8,16,32,64}_6}) 
> but have to use the __kernel_* versions of that.

hm, that looks quite ugly and unnatural. Could the usr/* exporting scripts 
convert these types automatically to the __kernel_* versions?

	Ingo
