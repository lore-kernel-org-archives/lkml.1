Return-Path: <linux-kernel-owner+w=401wt.eu-S932910AbXK2ThW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932910AbXK2ThW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 14:37:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759568AbXK2ThH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 14:37:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55025 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757820AbXK2ThE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 14:37:04 -0500
Date: Thu, 29 Nov 2007 20:36:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: Dave Jones <davej@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
Subject: Re: [BUG] jiffies counter leaps in 2.6.24-rc3
Message-ID: <20071129193624.GA15245@elte.hu>
References: <20071124175112.58193424@morte> <200711241948.58881.rjw@sisk.pl> <20071124194635.58f5a44b@morte> <200711242031.26134.rjw@sisk.pl> <20071129095034.24b3fc59@morte> <20071129103511.GD10577@elte.hu> <20071129174548.GC12481@redhat.com> <20071129185743.46daa8ad@morte> <20071129182402.GE12481@redhat.com> <20071129202546.7a65a13c@morte>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071129202546.7a65a13c@morte>
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
X-Mailing-List: linux-kernel@vger.kernel.org


* Stefano Brivio <stefano.brivio@polimi.it> wrote:

> On Thu, 29 Nov 2007 13:24:02 -0500
> Dave Jones <davej@redhat.com> wrote:
> 
> > On Thu, Nov 29, 2007 at 06:57:43PM +0100, Stefano Brivio wrote:
> 
> >  > Do you want me to comment out adjust_jiffies() and see what happens?
> >  
> > Just for laughs, why not.
> 
> I wanted to laugh, but the behaviour didn't change at all. How boring.

just to make sure there is no tsc impact, does booting with "notsc" 
change anything?

if not, does booting with idle=halt or idle=poll help? [your power usage 
will go up so it's not very useful - but it could help exclude a few 
sources of trouble.]

	Ingo
