Return-Path: <linux-kernel-owner+w=401wt.eu-S1751717AbXDDVXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717AbXDDVXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 17:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751769AbXDDVXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 17:23:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44349 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717AbXDDVXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 17:23:37 -0400
Date: Wed, 4 Apr 2007 23:23:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: john stultz <johnstul@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@muc.de>
Subject: Re: [PATCH -mm] fix jiffies clocksource inittime
Message-ID: <20070404212324.GA19899@elte.hu>
References: <1175716216.17711.59.camel@localhost> <20070404134310.12ad3ab8.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070404134310.12ad3ab8.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> If so: worrisome.  Startup ordering issues are fragile and tricky.  
> Time management is fragile and tricky.  The combination of the two 
> doesn't get any better ;)
> 
> An option would be to test it in 2.6.22-rcX for a while, then backport 
> to 2.6.21.x.

is the v2.6.21 release so close? From all i can see Adrian Bunk still 
has a very sizable regressions list, which necessiate a couple of weeks 
to track down. And the delta since -rc5 is pretty large too, 
necessiating an -rc6.

	Ingo
