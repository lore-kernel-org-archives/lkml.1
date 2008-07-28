Return-Path: <linux-kernel-owner+w=401wt.eu-S1753214AbYG1OIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbYG1OIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 10:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbYG1OIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 10:08:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36268 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbYG1OIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 10:08:05 -0400
Date: Mon, 28 Jul 2008 16:07:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: linux-kernel@vger.kernel.org, pj@sgi.com, menage@google.com,
       a.p.zijlstra@chello.nl, vegard.nossum@gmail.com
Subject: Re: [PATCH] cpuset: Rework sched domains and CPU hotplug handling
Message-ID: <20080728140748.GB18144@elte.hu>
References: <1216852381-23445-1-git-send-email-maxk@qualcomm.com> <488B7DC5.20302@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488B7DC5.20302@qualcomm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0009]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Max Krasnyansky <maxk@qualcomm.com> wrote:

> Max Krasnyansky wrote:
> > This is an updated version of my previous cpuset patch:
> >   "Make rebuild_sched_domains() usable from any context (take 2)"
> 
> Folks,
> 
> Any comments on this patch ? We need this to complete sched domain 
> handling fixes/improvements that we started with the cpu_active_map, 
> and to avoid circular locking issues in the cpu hotplug -> 
> rebuild_sched_domains path.

Paul, Peter, any comments?

	Ingo
