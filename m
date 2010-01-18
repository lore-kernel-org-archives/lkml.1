Return-Path: <linux-kernel-owner+w=401wt.eu-S1754302Ab0ARHiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab0ARHiQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 02:38:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754161Ab0ARHiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 02:38:15 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41314 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab0ARHiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 02:38:14 -0500
Subject: Re: [GIT PULL] perf scheduling updates: flexible/pinned groups
 reordering, optimizations
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>
In-Reply-To: <1263730935-9770-1-git-send-regression-fweisbec@gmail.com>
References: <1263730935-9770-1-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jan 2010 08:38:05 +0100
Message-ID: <1263800285.4283.11.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-01-17 at 13:22 +0100, Frederic Weisbecker wrote:
> Ingo,
> 
> Please pull the perf/scheduling branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	perf/scheduling
> 
> It brings more progresses wrt scheduling ordering between pinned
> and flexible events.
> 
> There is still some work to do, for example concerning context spinlocks
> that could be acquired once instead of multiple times in some areas.
> 
> But this set is still much more optimized than what we had before,
> especially because of the third patch.

Looks very nice, thanks Frederic!

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

