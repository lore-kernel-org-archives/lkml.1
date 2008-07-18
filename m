Return-Path: <linux-kernel-owner+w=401wt.eu-S1757619AbYGRLa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619AbYGRLa3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 07:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755365AbYGRLaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 07:30:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55449 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753890AbYGRLaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 07:30:21 -0400
Date: Fri, 18 Jul 2008 13:30:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: dmitry.adamushko@gmail.com, a.p.zijlstra@chello.nl,
       torvalds@linux-foundation.org, pj@sgi.com, ghaskins@novell.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpu hotplug, sched: Introduce cpu_active_map and redo
	sched domain managment (take 2)
Message-ID: <20080718113001.GC6875@elte.hu>
References: <1216122229-4865-1-git-send-email-maxk@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216122229-4865-1-git-send-email-maxk@qualcomm.com>
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


* Max Krasnyansky <maxk@qualcomm.com> wrote:

> From: Max Krasnyanskiy <maxk@qualcomm.com>
> 
> Addressed Ingo's comments and merged on top of latest Linus's tree.
> 
> This is based on Linus' idea of creating cpu_active_map that prevents 
> scheduler load balancer from migrating tasks to the cpu that is going 
> down.

applied to tip/sched/devel - thanks Max.

	Ingo
