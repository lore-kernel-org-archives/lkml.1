Return-Path: <linux-kernel-owner+w=401wt.eu-S1751288AbZGVOip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751288AbZGVOip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 10:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbZGVOio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 10:38:44 -0400
Received: from www.tglx.de ([62.245.132.106]:46394 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbZGVOio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 10:38:44 -0400
Date: Wed, 22 Jul 2009 16:38:18 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [RFC][PATCH] cache __next_timer_interrupt result
In-Reply-To: <20090721202505.7d56a079@skybase>
Message-ID: <alpine.LFD.2.00.0907221632090.2813@localhost.localdomain>
References: <20090721202505.7d56a079@skybase>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jul 2009, Martin Schwidefsky wrote:

> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> Each time a cpu goes to sleep on a NOHZ=y system the timer wheel is
> searched for the next timer interrupt. It can take quite a few cycles
> to find the next pending timer. This patch adds a field to tvec_base
> that caches the result of __next_timer_interrupt. The hit ratio is
> around 80% on my thinkpad under normal use, on a server I've seen

Nice, I like it.

> hit ratios from 5% to 95% dependent on the workload.

Which workloads result in lower hit ratios ? Heavy networking ?
 
Thanks,

	tglx
