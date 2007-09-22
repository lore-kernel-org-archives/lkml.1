Return-Path: <linux-kernel-owner+w=401wt.eu-S1754900AbXIVV0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbXIVV0h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 17:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbXIVV02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 17:26:28 -0400
Received: from www.osadl.org ([213.239.205.134]:47612 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752496AbXIVV01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 17:26:27 -0400
Subject: Re: RFC: A revised timerfd API
From: Thomas Gleixner <tglx@linutronix.de>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Michael Kerrisk <mtk-manpages@gmx.net>,
       Ulrich Drepper <drepper@redhat.com>, geoff@gclare.org.uk,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>, Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <rdunlap@xenotime.net>, vda.linux@googlemail.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
In-Reply-To: <Pine.LNX.4.64.0709221359190.22085@alien.or.mcafeemobile.com>
References: <46EF7DDA.2070401@gmx.net>
	 <Pine.LNX.4.64.0709180936480.22956@alien.or.mcafeemobile.com>
	 <46F514C9.5010208@gmx.net>
	 <Pine.LNX.4.64.0709221359190.22085@alien.or.mcafeemobile.com>
Content-Type: text/plain
Date: Sat, 22 Sep 2007 23:26:25 +0200
Message-Id: <1190496385.4035.124.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-09-22 at 14:07 -0700, Davide Libenzi wrote:
> On Sat, 22 Sep 2007, Michael Kerrisk wrote:
> 
> > So I'm inclined to implement option (b), unless someone has strong
> > objections.  Davide, could I persuade you to help?
> 
> I guess I better do, otherwise you'll continue to stress me ;)
> 
> int timerfd_create(int clockid);
> int timerfd_settime(int ufd, int flags,
>                     const struct itimerspec *utmr,
>                     struct itimerspec *otmr);
> int timerfd_gettime(int ufd, struct itimerspec *otmr);
> 
> Patch below. Builds, not tested yet (you need to remove the "broken" 
> status from CONFIG_TIMERFD in case you want to test - and plug the new 
> syscall to arch/xxx).
> May that work for you?
> Thomas-san, hrtimer_try_to_cancel() does not touch ->expires and I assume
> it'll never do, granted?

Davide-san, I have no intention to change that, but remember there is
this file "Documentation/stable_api_nonsense.txt" :)

	tglx



