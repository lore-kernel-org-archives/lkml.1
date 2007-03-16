Return-Path: <linux-kernel-owner+w=401wt.eu-S965410AbXCPQGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965410AbXCPQGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 12:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965414AbXCPQGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 12:06:17 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:49152 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965410AbXCPQGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 12:06:16 -0400
X-AuthUser: davidel@xmailserver.org
Date: Fri, 16 Mar 2007 09:02:27 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Thomas Gleixner <tglx@linutronix.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 6/13] signal/timer/event fds v6 - timerfd core ...
In-Reply-To: <1174031144.13341.249.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0703160901040.13402@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.9367.1174004538.6>
 <1174031144.13341.249.camel@localhost.localdomain>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2007, Thomas Gleixner wrote:

> On Thu, 2007-03-15 at 17:22 -0700, Davide Libenzi wrote:
> > +static void timerfd_setup(struct timerfd_ctx *ctx, int clockid, int flags,
> > +			  const struct itimerspec *ktmr)
> > +{
> > +	enum hrtimer_mode htmode;
> > +
> > +	htmode = (flags & TFD_TIMER_ABSTIME) ? HRTIMER_MODE_ABS: HRTIMER_MODE_REL;
> > +
> > +	ctx->ticks = 0;
> > +	ctx->texp = timespec_to_ktime(ktmr->it_value);
> 
> I know, I'm racking your nerves. texp is only used for setup. No need to
> carry it in the ctx data structure. :)

Heh, I had that feeling, that I had forgot one of those :)


- Davide


