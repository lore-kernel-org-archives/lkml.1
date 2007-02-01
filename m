Return-Path: <linux-kernel-owner+w=401wt.eu-S1422834AbXBAMSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422834AbXBAMSp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 07:18:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422836AbXBAMSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 07:18:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50075 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422835AbXBAMSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 07:18:44 -0500
Date: Thu, 1 Feb 2007 13:17:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: jbohac@suse.cz, linux-kernel@vger.kernel.org,
       Vojtech Pavlik <vojtech@suse.cz>, arjan@infradead.org,
       tglx@linutronix.de, johnstul@us.ibm.com
Subject: Re: [patch 0/9] x86_64: reliable TSC-based gettimeofday
Message-ID: <20070201121731.GB3900@elte.hu>
References: <20070201095952.589234000@jet.suse.cz> <200702011220.59484.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702011220.59484.ak@suse.de>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@suse.de> wrote:

> The big strategic problem is how to marry your patchkit to John 
> Stultz's clocksources work which is also competing for merge. Any 
> thoughts on that?

the only sane thing would be to do it ontop of -mm: the stuff in -mm, 
barring some catastrophy, is hopefully destined for v2.6.21. We could do 
my quick optional hack for those who want fast gettimeofday now ahead of 
that queue - but this approximation thing should be definitely ontop.

	Ingo
