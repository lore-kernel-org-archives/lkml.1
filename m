Return-Path: <linux-kernel-owner+w=401wt.eu-S1756747AbXJOHrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbXJOHrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 03:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbXJOHrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 03:47:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56236 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbXJOHrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 03:47:12 -0400
Date: Mon, 15 Oct 2007 09:47:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Milton Miller <miltonm@bga.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched domain debug sysctl fixes
Message-ID: <20071015074700.GC32064@elte.hu>
References: <mm-sched-0@bga.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mm-sched-0@bga.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Milton Miller <miltonm@bga.com> wrote:

> The following 5 patches provide fixes for the sysctl code added under 
> CONFIG_DEBUG_SCHED.  After debugging a boot failure dereferencing not 
> per-cpu data for an impossible cpu, I found the other issues by 
> inspection.
> 
> Following these fixes, /proc/sysctl/kernel/sched_debug/ should work 
> with exclusive cpusets, cpu hotplug, offline and not present cpus, and 
> will show all 11 files.

thanks, great fixes! They should show up in the next sched-devel git 
tree.

	Ingo
