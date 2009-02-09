Return-Path: <linux-kernel-owner+w=401wt.eu-S1756748AbZBIRmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748AbZBIRmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 12:42:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754921AbZBIRmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 12:42:44 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:46369 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbZBIRmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:42:43 -0500
X-AuthUser: davidel@xmailserver.org
Date: Mon, 9 Feb 2009 09:42:41 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: mtk.manpages@gmail.com
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2/2] timerfd extend clockid support
In-Reply-To: <cfd18e0f0902090128i1a4902f4of0d4d830b567602f@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0902090940100.8084@alien.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0902081510150.18839@alien.or.mcafeemobile.com> <cfd18e0f0902090128i1a4902f4of0d4d830b567602f@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Feb 2009, Michael Kerrisk wrote:

> On Mon, Feb 9, 2009 at 12:23 PM, Davide Libenzi <davidel@xmailserver.org> wrote:
> > The following patch extends timerfd clockid support to cover the ones
> > supported by timer_create().
> > It exports the invalid_clockid() function outside posix-timers.c to allow
> > timerfd to properly check input parameters.
> > Andrew, this is (eventually) .30 material, and do not take the patch
> > until you have Thomas sign off.
> > Thomas, timerfd uses core hrtimer functions for its tasks. By extending
> > the clockid support, I assume that the clockids other than CLOCK_MONOTONIC
> > and CLOCK_REALTIME, behaves the same from a hrtimer caller POV. Right?
> 
> Hi Davide,
> 
> Have you done any testing of this patch?  My attempts at testing with
> clocks other than REALTIME and MONOTONIC all don't work so far.  In
> some cases, my test programs causes the system to hang.  Try
> experimenting with the (not yet well tested) test program below, to
> check the behavior with other clocks.

Michael, no I did not test it and I did not have even the time to peek 
into the core timer code to see if the usage of other timer types in 
eventfd would create problems. That's why I asked Thomas if they'd behave 
differently from an hrtimer caller POV.
I'll try to take a look by myself today or tomorrow.


- Davide


