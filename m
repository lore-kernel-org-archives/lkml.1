Return-Path: <linux-kernel-owner+w=401wt.eu-S1754608AbZJZGlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbZJZGlF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 02:41:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754532AbZJZGlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 02:41:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52803 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754455AbZJZGlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 02:41:03 -0400
Date: Mon, 26 Oct 2009 07:41:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org,
       LKLM <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] powernow-k6: set transition latency value so ondemand
	governor can be used
Message-ID: <20091026064101.GB17984@elte.hu>
References: <20091024172538.e2c8776b.krzysztof.h1@poczta.fm> <20091025032813.GB2475@redhat.com> <20091025194557.1d5ed484.krzysztof.h1@poczta.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091025194557.1d5ed484.krzysztof.h1@poczta.fm>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Krzysztof Helt <krzysztof.h1@poczta.fm> wrote:

> From: Krzysztof Helt <krzysztof.h1@wp.pl>
> 
> Set the transition latency to value smaller than CPUFREQ_ETERNAL so
> governors other than "performance" work (like the "ondemand" one).
> 
> The value is found in "AMD PowerNow! Technology Platform Design Guide for 
> Embedded Processors" dated December 2000 (AMD doc #24267A). There is the 
> answer to one of FAQs on page 40 which states that suggested complete transition 
> period is 200 us.

Btw., would be nice to put this paragraph between '/* .. */' signs and 
put it into the source code - seems highly relevant when someone comes 
across that wonders what the magic number '200000' is.

	Ingo
