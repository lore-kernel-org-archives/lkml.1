Return-Path: <linux-kernel-owner+w=401wt.eu-S965484AbXCLAQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965484AbXCLAQZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 20:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965236AbXCLAQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 20:16:24 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:32883 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965280AbXCLAQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 20:16:17 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 11 Mar 2007 17:16:14 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Nicholas Miell <nmiell@comcast.net>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 6/9] signalfd/timerfd v3 - timerfd core ...
In-Reply-To: <1173657008.2964.6.camel@entropy>
Message-ID: <Pine.LNX.4.64.0703111715460.4936@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.5031.1173654242.6> 
 <Pine.LNX.4.64.0703111610360.4936@alien.or.mcafeemobile.com>
 <1173657008.2964.6.camel@entropy>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Mar 2007, Nicholas Miell wrote:

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

Sounds sane to me. Will do...


- Davide


