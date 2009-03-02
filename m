Return-Path: <linux-kernel-owner+w=401wt.eu-S1757786AbZCBXyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786AbZCBXyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 18:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbZCBXyC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 18:54:02 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56903 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043AbZCBXyA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 18:54:00 -0500
Date: Tue, 3 Mar 2009 00:53:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Brownell <david-b@pacbell.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com,
       tglx@linutronix.de
Subject: Re: lockdep and threaded IRQs (was: ...)
Message-ID: <20090302235327.GB19084@elte.hu>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <200903021520.30826.david-b@pacbell.net> <20090302232650.GA14515@elte.hu> <200903021542.25153.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903021542.25153.david-b@pacbell.net>
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


* David Brownell <david-b@pacbell.net> wrote:

> On Monday 02 March 2009, Ingo Molnar wrote:
> > If you want to work on genirq threaded IRQ handlers them please 
> > check out and test the threaded IRQ handlers patches that are 
> > being worked on at lkml. See:
> > 
> > [patch 0/4] genirq: add infrastructure for threaded interrupt handlers V2
> 
> I did check them out, as noted earlier in this thread.
> 
> The significant omission is lack of support for chaining
> such threads.  Example, an I2C device that exposes
> several dozen IRQs with mask/ack/... operations that
> require I2C access.

Well, those are rarely used, embedded-only constructs - the main 
focus of IRQ threading patches are the more common patterns.

Since you care about them - could you please send patches on top 
of the IRQ threading patches to add support for them?

Thanks,

	Ingo
