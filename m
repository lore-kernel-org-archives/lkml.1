Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbZGJJWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbZGJJWo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 05:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbZGJJWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 05:22:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34051 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348AbZGJJWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 05:22:36 -0400
Date: Fri, 10 Jul 2009 11:22:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Chris Wilson <chris@chris-wilson.co.uk>, Jason Baron <jbaron@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Cc: Ben Gamari <bgamari.foss@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] perf tool: Add a trace point event parser.
Message-ID: <20090710092225.GE27445@elte.hu>
References: <1246869094-21237-1-git-send-email-chris@chris-wilson.co.uk> <1246869094-21237-2-git-send-email-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246869094-21237-2-git-send-email-chris@chris-wilson.co.uk>
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


* Chris Wilson <chris@chris-wilson.co.uk> wrote:

> Accept events of the form tp=i915/i915_wait and convert those to the
> ftrace event id by expanding the short name to
> '/sys/kernel/debug/tracing/events/i915/i915_wait/id'. (Substituting the
> real debugfs mount path as appropriate.)
> 
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> ---
>  tools/perf/util/parse-events.c |  133 +++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 131 insertions(+), 2 deletions(-)

Ok - this looks useful. Mind working with Jason Baron (Cc:-ed) who 
incidentally posted a similar series on some joint solution?

Thanks,

	Ingo
