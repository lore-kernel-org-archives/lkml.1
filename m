Return-Path: <linux-kernel-owner+w=401wt.eu-S1751667AbXCLTAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667AbXCLTAm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 15:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbXCLTAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 15:00:42 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:33740 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbXCLTAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 15:00:41 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 12 Mar 2007 12:00:34 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Thomas Gleixner <tglx@linutronix.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 6/9] signalfd/timerfd v3 - timerfd core ...
In-Reply-To: <Pine.LNX.4.64.0703121142120.6936@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0703121158060.6936@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.5031.1173654242.6>
 <1173694763.13341.81.camel@localhost.localdomain>
 <Pine.LNX.4.64.0703121142120.6936@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2007, Davide Libenzi wrote:

> On Mon, 12 Mar 2007, Thomas Gleixner wrote:
> 
> > Davide,
> > 
> > On Sun, 2007-03-11 at 16:04 -0700, Davide Libenzi wrote:
> > > +static int timerfd_setup(struct timerfd_ctx *ctx, int clockid, int tmrtype,
> > > +			 const struct itimerspec *ktmr)
> > > +{
> > > +	enum hrtimer_mode htmode;
> > > +	ktime_t texp, tintv;
> > > +
> > > +	if (clockid != CLOCK_MONOTONIC &&
> > > +	    clockid != CLOCK_REALTIME)
> > > +		return -EINVAL;

Maybe a function in hrtimer.c/h like hrtimer_valid_clockid(clockid_t id) 
to avoid bolting in clockid_t values in timerfd.c?



- Davide


