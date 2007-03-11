Return-Path: <linux-kernel-owner+w=401wt.eu-S964812AbXCKXw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964812AbXCKXw7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 19:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964813AbXCKXw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 19:52:59 -0400
Received: from rwcrmhc15.comcast.net ([204.127.192.85]:42354 "EHLO
	rwcrmhc15.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964812AbXCKXw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 19:52:58 -0400
X-Greylist: delayed 93380 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Mar 2007 19:52:58 EDT
Subject: Re: [patch 6/9] signalfd/timerfd v3 - timerfd core ...
From: Nicholas Miell <nmiell@comcast.net>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1173657008.2964.6.camel@entropy>
References: <send-serie.davidel@xmailserver.org.5031.1173654242.6>
	 <Pine.LNX.4.64.0703111610360.4936@alien.or.mcafeemobile.com>
	 <1173657008.2964.6.camel@entropy>
Content-Type: text/plain
Date: Sun, 11 Mar 2007 16:52:57 -0700
Message-Id: <1173657177.2964.9.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-03-11 at 16:50 -0700, Nicholas Miell wrote:
> You should probably make it behave like the other things that use
> itimerspec, just to avoid confusion -- i.e. timers are relative by
> default, there's a flag that makes them absolute, they expire when
> it_value specifies, and repeat every it_interval nanoseconds if
> it_interval is non-zero.
> 
> i.e.
> 
> int timerfd(int ufd, int clockid, int flags, const struct timespec
> *utmr);
> 
> with TFD_TIMER_ABS in flags making the timer absolute instead of
> relative (and no TFD_TIMER_REL or TFD_TIMER_SEQ at all).
> 

Sorry, that should be

int timerfd(int ufd, int clockid, int flags, const struct itimerspec
*utmr);

and TFD_TIMER_ABSTIME.

-- 
Nicholas Miell <nmiell@comcast.net>

