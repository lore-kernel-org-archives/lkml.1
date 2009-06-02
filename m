Return-Path: <linux-kernel-owner+w=401wt.eu-S1756098AbZFBAaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbZFBAaM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 20:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440AbZFBAaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 20:30:00 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:59265 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbZFBA37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 20:29:59 -0400
Subject: Re: [tip:timers/ntp] ntp: adjust SHIFT_PLL to improve NTP
 convergence
From: John Stultz <johnstul@us.ibm.com>
To: Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
       Miroslav Lichvar <mlichvar@redhat.com>
In-Reply-To: <4A246D0B.40204@redhat.com>
References: <200905051956.n45JuVo9025575@imap1.linux-foundation.org>
	 <tip-22cfbbfd9f67b67fe073010f51cb71d3632387d5@git.kernel.org>
	 <1243542817.29511.523.camel@jstultz-laptop>  <20090601232223.GH749@elte.hu>
	 <1243900716.11263.42.camel@jstultz-laptop>  <4A246D0B.40204@redhat.com>
Content-Type: text/plain
Date: Mon, 01 Jun 2009 17:29:59 -0700
Message-Id: <1243902599.11263.52.camel@jstultz-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-01 at 20:06 -0400, Rik van Riel wrote:
> John Stultz wrote:
> > On Tue, 2009-06-02 at 01:22 +0200, Ingo Molnar wrote:
> 
> >> I might be missing something here - but Linux converging faster 
> >> seems like a genuinely good thing. What non-Linux problem could 
> >> there be? Linux's convergence is really Linux's private issue. 
> > 
> > Yea. It does seem that way. Miroslav can likely expand on the issue to
> > help clarify, but as I understand it, the example is if you have a
> > number of systems that are peers in an NTP network. All of them are
> > using the same userland NTP daemon. However, if the rate of change that
> > corrections are applied is different in half of them, you will have
> > problems getting all the systems to converge together. 
> 
> Would this not be true already, because the convergence
> of Linux system suddenly became a lot slower in 2.6.19?

Yes, this is true. But some folks have considered Linux to have had a
faulty NTP implementation up until 2.6.19.

> Damned if we do, damned if we don't - except the new
> behaviour introduced by your patches is nicer.

It would seem this way, so I'm not throwing the patch out yet. I'm just
suggesting we hold off including it until we've tried attacking the
issue from a few other angles. Miroslav understands the details behind
the NTP protocol much better then I, so I'd like to try to address them
before going out on our own.

I just want to avoid the kernel from oscillating between fast(and maybe
incorrect)convergence and ntp-spec-compliance.

thanks
-john


