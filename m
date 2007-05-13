Return-Path: <linux-kernel-owner+w=401wt.eu-S1759749AbXEMUIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759749AbXEMUIQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 16:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757420AbXEMUIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 16:08:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39275 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757349AbXEMUII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 16:08:08 -0400
Date: Sun, 13 May 2007 22:07:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: tglx@linutronix.de, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
       linux-acpi@vger.kernel.org
Subject: Re: [patch 3/3] clockevents: Fix resume logic - updated version
Message-ID: <20070513200739.GA4137@elte.hu>
References: <20070512030754.90488f79.akpm@linux-foundation.org> <1178970253.22481.143.camel@localhost.localdomain> <20070512095145.0cf58a57.akpm@linux-foundation.org> <1178989302.22481.185.camel@localhost.localdomain> <20070512102350.04126320.akpm@linux-foundation.org> <1178999770.22481.211.camel@localhost.localdomain> <20070512181140.50140334.akpm@linux-foundation.org> <1179043652.22481.243.camel@localhost.localdomain> <1179074887.22481.271.camel@localhost.localdomain> <20070513120937.024a4368.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070513120937.024a4368.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> Yeah, I expect quite a few people will start seeing that.  iirc it was 
> triggered by a couple of changes: a local_irq_save/local_irq_restore 
> in sched_clock() and a change Jeremy made to the softlockup detector.

hm, i specifically asked to not do local_irq_save/restore in 
sched_clock(). It's the _scheduler_ clock and it very absolutely 
positively needs no flags save/restore.

	Ingo
