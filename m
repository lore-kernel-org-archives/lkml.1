Return-Path: <linux-kernel-owner+w=401wt.eu-S1754379AbYINMKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379AbYINMKa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 08:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbYINMKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 08:10:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43685 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753008AbYINMKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 08:10:18 -0400
Date: Sun, 14 Sep 2008 14:10:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Krzysztof Helt <krzysztof.h1@wp.pl>
Subject: Re: [PATCH] x86: identify_cpu_without_cpuid v2
Message-ID: <20080914121000.GB16097@elte.hu>
References: <1221383726-10834-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221383726-10834-1-git-send-email-yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> Krzysztof found some old cyrix cpu mtrr etc cpu feature was not detected
> 
> this one is based on Krzysztof' patch, and call c_identify in early_identify_cpu.
> 
> need to call c_identify() for cpus without cpuid earlier...
> v2: Krzysztof point out need to give cyrix another chance about cpuid checking again
>     after c_identify enable cpuid for it
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> Cc: Krzysztof Helt <krzysztof.h1@wp.pl>

applied them to tip/x86/unify-cpu-detect:

 afae865: x86: move transmeta cap read to early_init_transmeta()
 aef93c8: x86: identify_cpu_without_cpuid v2

thanks Yinghai!

	Ingo
