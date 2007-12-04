Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042AbXLDM4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbXLDM4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 07:56:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbXLDM42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 07:56:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35802 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557AbXLDM42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:56:28 -0500
Date: Tue, 4 Dec 2007 13:56:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Chris Clayton <chris2553@googlemail.com>, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] x86 intel_cacheinfo.c section fix
Message-ID: <20071204125607.GD31590@elte.hu>
References: <200711291419.49261.chris2553@googlemail.com> <20071202004248.GF15974@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071202004248.GF15974@stusta.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0005]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Adrian Bunk <bunk@kernel.org> wrote:

> free_cache_attributes() must be __cpuinit since it calls the __cpuinit 
> cache_remove_shared_cpu_map().

thanks, picked this up as a .24 fix.

	Ingo
