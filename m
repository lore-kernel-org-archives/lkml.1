Return-Path: <linux-kernel-owner+w=401wt.eu-S932495AbYBBSAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932495AbYBBSAe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 13:00:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbYBBSA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 13:00:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57662 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbYBBSA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 13:00:26 -0500
Date: Sat, 2 Feb 2008 19:00:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Brownell <david-b@pacbell.net>
Cc: Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] sleepy linux self-test
Message-ID: <20080202180002.GB26560@elte.hu>
References: <20080130131748.GA3796@elf.ucw.cz> <200801311755.33899.david-b@pacbell.net> <20080202124759.GB25773@elf.ucw.cz> <200802020931.38689.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802020931.38689.david-b@pacbell.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
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

> > > Plus, the way you're doing it now is violating the locking 
> > > protocol used by that driver.
> > 
> > Yep, you are right, but that is the easy issue to fix.
> 
> Which is why I was puzzled that you didn't start out doing it the 
> "right" way ... even just hard-wiring the dubious assumption that 
> "rtc0" is the right RTC to use.  :)

because this was mostly about an quick & easy hack to see whether it 
makes sense at all to automate the testing of suspend/resume. (People 
who want to use RTC functionality might not have the desire to get into 
extending it straight away - they just want something rather obvious 
done and that's it.)

	Ingo
