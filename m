Return-Path: <linux-kernel-owner+w=401wt.eu-S964934AbXIJMIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964934AbXIJMIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 08:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757386AbXIJMIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 08:08:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42674 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757419AbXIJMIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 08:08:04 -0400
Date: Mon, 10 Sep 2007 14:07:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND][PATCH 0/4] Virtual Machine Time Accounting
Message-ID: <20070910120758.GA26835@elte.hu>
References: <46E5325D.1020902@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E5325D.1020902@bull.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Laurent Vivier <Laurent.Vivier@bull.net> wrote:

> Ingo, please, could you have a look to these patches ?
> 
> The aim of these four patches is to introduce Virtual Machine time 
> accounting.
> 
> [PATCH 1/4] as recent CPUs introduce a third running state, after 
> "user" and "system", we need a new field, "guest", in cpustat to store 
> the time used by the CPU to run virtual CPU. Modify /proc/stat to 
> display this new field.

the concept certainly looks sane to me.

The heavy-handed use of #ifdefs uglifies the code to a large degree, but 
this is not a fundamental problem: since basically all distros have KVM 
enabled (and lguest benefits from this too), could you just make all 
this new code unconditional?

	Ingo
