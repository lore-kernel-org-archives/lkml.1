Return-Path: <linux-kernel-owner+w=401wt.eu-S1756713AbZISJsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbZISJsT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 05:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754889AbZISJsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 05:48:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33584 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805AbZISJsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 05:48:18 -0400
Date: Sat, 19 Sep 2009 11:48:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 8/8] perf: Add the timechart tool
Message-ID: <20090919094816.GB2295@elte.hu>
References: <20090912130306.5d0086ea@infradead.org> <20090912130713.6a77bbc0@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090912130713.6a77bbc0@infradead.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> ---
>  tools/perf/Makefile            |    7 +
>  tools/perf/builtin-timechart.c | 1120 ++++++++++++++++++++++++++++++++++++++++
>  tools/perf/builtin.h           |    1 +
>  tools/perf/perf.c              |    1 +
>  4 files changed, 1129 insertions(+), 0 deletions(-)

i've applied your latest patches (sans the perf record --timechart 
thing) - thanks Arjan.

There's a few missing things with the main timechart command:

 - it's not in tools/perf/common-cmds.h that way 'perf help' does not 
   list 'timechart' as an available command.

 - there's no tools/perf/Documentation/perf-timechart.txt file - hence 
   'perf help timechart' does not work and there's no manpage/etc.

	Ingo
