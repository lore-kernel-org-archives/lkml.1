Return-Path: <linux-kernel-owner+w=401wt.eu-S1030624AbXBGMcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030624AbXBGMcE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 07:32:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030623AbXBGMcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 07:32:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60295 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030618AbXBGMcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 07:32:03 -0500
Date: Wed, 7 Feb 2007 13:32:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: v2.6.20-rt1, yum/rpm
Message-ID: <20070207123217.GA12977@elte.hu>
References: <20070205065636.GA1652@elte.hu> <1170756645.7324.8.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170756645.7324.8.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.3 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4996]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@infradead.org> wrote:

> patch below has 2 tweaks
> 1) the new RCU feature wakes up once per second, make sure this is using
> the new round_jiffies() infrastructure
> 2) the slab background reap code is waking up once per 2 seconds per
> cpu. The patch makes this more dynamic; if no work was done (no activity
> on the cpu happened) then this is made to be 4 seconds

thanks, i've applied both tweaks.

	Ingo
