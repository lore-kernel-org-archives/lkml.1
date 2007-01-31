Return-Path: <linux-kernel-owner+w=401wt.eu-S933163AbXAaM2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933163AbXAaM2t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 07:28:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933167AbXAaM2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 07:28:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54624 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933163AbXAaM2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 07:28:48 -0500
Date: Wed, 31 Jan 2007 13:27:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 16/23] clocksource: arm update for new flags
Message-ID: <20070131122710.GF1847@elte.hu>
References: <20070131033710.420168478@mvista.com> <20070131033808.050999950@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070131033808.050999950@mvista.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.8 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	0.5 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4571]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> Update ARM for new flags.
> 
> Signed-Off-By: Daniel Walker <dwalker@mvista.com>

> -	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,

see my general objection to this change (under the [PATCH 22/23] 
subject), but even looking at the pure patch note that it does the flag 
update incorrectly and in a bisect-boot-unfriendly way: the queue at 
this point changes kernel functionality and has side-effects. The right 
way to do flags updates is to first introduce them, then change things 
over.

	Ingo
