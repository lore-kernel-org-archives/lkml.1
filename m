Return-Path: <linux-kernel-owner+w=401wt.eu-S1757499AbXIVRKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499AbXIVRKT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 13:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbXIVRKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 13:10:07 -0400
Received: from www.osadl.org ([213.239.205.134]:44492 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751097AbXIVRKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 13:10:05 -0400
Subject: Re: RFC: A revised timerfd API
From: Thomas Gleixner <tglx@linutronix.de>
To: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Ulrich Drepper <drepper@redhat.com>, geoff@gclare.org.uk,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>, Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <rdunlap@xenotime.net>, vda.linux@googlemail.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
In-Reply-To: <46F514C9.5010208@gmx.net>
References: <46EF7DDA.2070401@gmx.net>
	 <Pine.LNX.4.64.0709180936480.22956@alien.or.mcafeemobile.com>
	 <46F514C9.5010208@gmx.net>
Content-Type: text/plain
Date: Sat, 22 Sep 2007 19:10:02 +0200
Message-Id: <1190481002.4035.51.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael,

On Sat, 2007-09-22 at 15:12 +0200, Michael Kerrisk wrote:
> Davide, Andrew, Linus, et al.
> 
> At the start of this thread
> (http://thread.gmane.org/gmane.linux.kernel/581115 ), I proposed 4
> alternatives to Davide's original timerfd API.  Based on the feedback in
> that thread (and one or two earlier comments):
> 
> Let's dismiss option (a), since it is an unlovely multiplexing interface.
> 
> Option (b) seems a viable.  The most notable concern was from Thomas
> Gleixner, that we might end up duplicating code from the POSIX timers API
> within the timerfd API -- some eventual refactoring might mitigate this
> problem.

It should be possible to use the timerfd syscalls as wrappers for the
posix timer implementation and add the discussed SIGEV_TIMERFD only
internally in the kernel to signal the posix timer code new delivery
mechanism.

	tglx


	

