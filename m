Return-Path: <linux-kernel-owner+w=401wt.eu-S1752423AbXCaJYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbXCaJYo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 05:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbXCaJYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 05:24:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54368 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423AbXCaJYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 05:24:44 -0400
Date: Sat, 31 Mar 2007 11:23:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] x86_64: enable clockevents and dynticks
Message-ID: <20070331092339.GA2033@elte.hu>
References: <20070331083149.997762000@sous-sol.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070331083149.997762000@sous-sol.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Chris Wright <chrisw@sous-sol.org> wrote:

> This series converts x86_64 timers to clockevents drivers and then 
> enables dynticks.  There's some minor cleanups along the way.  The 
> lapic broadcast mechanism is untested, I'm sure it still needs work, 
> there's still some cruft in lapic_setup_timer.
> 
> This is just for comments at this point, now that it's working on my 
> test box in both NO_HZ=n and NO_HZ=n configurations (typically using 
> hpet).

hm, neat - did you take a look at the x86_64 clockevents code that is in 
-rt and that has been there for a year or so and has been tested quite 
extensively?

	Ingo
