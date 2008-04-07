Return-Path: <linux-kernel-owner+w=401wt.eu-S1757529AbYDGK0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529AbYDGK0g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 06:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756076AbYDGK02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 06:26:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42179 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756047AbYDGK02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 06:26:28 -0400
Date: Mon, 7 Apr 2008 12:26:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Karsten Wiese <fzu@wemgehoertderstaat.de>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: Fix call to set_cyc2ns_scale() from
	time_cpufreq_notifier()
Message-ID: <20080407102615.GA31102@elte.hu>
References: <200804071214.45791.fzu@wemgehoertderstaat.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804071214.45791.fzu@wemgehoertderstaat.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0518]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Karsten Wiese <fzu@wemgehoertderstaat.de> wrote:

> In time_cpufreq_notifier() the cpu id to act upon is held in 
> freq->cpu. Use it instead of smp_processor_id() in the call to 
> set_cyc2ns_scale(). This makes the preempt_*able() unnecessary and 
> lets set_cyc2ns_scale() update the intended cpu's cyc2ns.

thanks Karsten, applied.

	Ingo
