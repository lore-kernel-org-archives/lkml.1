Return-Path: <linux-kernel-owner+w=401wt.eu-S1758157AbXI1ODI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157AbXI1ODI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 10:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754906AbXI1OC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 10:02:56 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2270 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbXI1OCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 10:02:55 -0400
Date: Fri, 28 Sep 2007 15:02:43 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.10
Message-ID: <20070928140243.GO18163@shadowen.org>
References: <bf97f66cfc0696c8574921d53eaafcb7@pinky> <20070928084003.GA18882@elte.hu> <20070928020132.f6c6f528.akpm@linux-foundation.org> <20070928092235.GA31180@shadowen.org> <20070928093902.GA28455@elte.hu> <20070928100024.GB18163@shadowen.org> <20070928104935.GA606@elte.hu> <20070928132138.GG18163@shadowen.org> <84144f020709280637w2290aec5gf3e8f90b08f53cc8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020709280637w2290aec5gf3e8f90b08f53cc8@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2007 at 04:37:49PM +0300, Pekka Enberg wrote:
> Hi Andy,
> 
> On 9/28/07, Andy Whitcroft <apw@shadowen.org> wrote:
> > That is unfair.  Every time we discuss it I state that I disagree that
> > hiding mostly useful tests is a good thing.  I would love the tests to
> > be 100% accurate, but if I removed all the tests that can false positive
> > I would literally have none.  There is a balance to be struck and we
> > have significantly different ideas on where the balance is.
> 
> Are you disagreeing with the numbers Ingo posted? 25,000 false
> positives for the kernel is beyond silly... Existing conventions
> should matter a lot and the default configuration for a static code
> checker should really be 100%. So why not hide the potentially useful
> warnings under -Wtoo-strict or similar command line option?

I have not run across the whole kernel to find out, his estimation is
likely high as his sample (mm/sched.c) includes a particular construct
(multiple assignment) which is reported and overly common in that
piece of code.  If I take mm/signal.c (also big) I get 1/1000 files,
and those two are easily fixed.  I should note it shows some 62 actual
real violations in that file.

I do receive automated checks of every patch posted to lkml and I work
to remove the false positives from them.  The false positive ratio is
very low in those reports and it those which drive my development effort.

checkpatch is a work in progress and likely will be for many years to
come.

I have propose we 'gate' those subjective tests, and have asked for
input on that thread on the default for those tests.

-apw
