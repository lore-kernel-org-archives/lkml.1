Return-Path: <linux-kernel-owner+w=401wt.eu-S1754474AbZIXT3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbZIXT3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 15:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754387AbZIXT3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 15:29:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58050 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754414AbZIXT3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 15:29:15 -0400
Date: Thu, 24 Sep 2009 21:29:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: John Kacur <jkacur@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-perf-users@vger.kernel.org,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 0/3]Share common code between builtin-report,
	builtin-annotate
Message-ID: <20090924192913.GA2533@elte.hu>
References: <alpine.LFD.2.00.0909241744030.11383@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0909241744030.11383@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* John Kacur <jkacur@redhat.com> wrote:

> builtin-annotate.c started out largely as a copy of builtin-report.c 
> In the meantime, fixes and enhancements have gone into builtin-report 
> but not always into builtin-annotate
> 
> The goal here it to share code where possible. The first step is these 
> three patches - more work is comming.
> 
> These three patches add util/sort.c and util/sort.h and move that 
> functionality out of builtin-report and builtin-annotate.

Very nice patches! I've applied them to tip:perf/core, thanks John.

	Ingo
