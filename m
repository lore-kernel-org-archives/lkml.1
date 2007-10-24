Return-Path: <linux-kernel-owner+w=401wt.eu-S1757026AbXJXPzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026AbXJXPzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 11:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbXJXPz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 11:55:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34704 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953AbXJXPz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 11:55:28 -0400
Date: Wed, 24 Oct 2007 17:55:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Romano Giannetti <romanol@upcomillas.es>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: 2.6.24-rc1 fails with lockup and BUG:
Message-ID: <20071024155521.GA16690@elte.hu>
References: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org> <1193232344.32208.0.camel@localhost> <20071024142759.GA13657@elte.hu> <1193241191.14314.8.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193241191.14314.8.camel@localhost>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Romano Giannetti <romanol@upcomillas.es> wrote:

> Done. The results are at:
> 
> http://www.dea.icai.upcomillas.es/romano/linux/info/2624rc1_2/
> 
> in the syslog-after-failed-suspend.txt file. After the failed suspend 
> (at line 15766) there where the bunch of things in D-state. I have 
> left the file intact.
> 
> At line 17646 there is:
> 
> WARNING: at kernel/lockdep.c:2033 trace_hardirqs_on()

hm, this lockdep warning caused lockdep to turn itself off - hence we 
wont get to the really interesting warnings. We'll try to come up with a 
solution for this.

	Ingo
