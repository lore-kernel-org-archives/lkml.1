Return-Path: <linux-kernel-owner+w=401wt.eu-S1757341AbZHGKMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbZHGKMI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 06:12:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963AbZHGKMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 06:12:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37292 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755970AbZHGKME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 06:12:04 -0400
Date: Fri, 7 Aug 2009 12:11:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, tzanussi@gmail.com, lizf@cn.fujitsu.com,
       a.p.zijlstra@chello.nl, penberg@cs.helsinki.fi, efault@gmx.de,
       eduard.munteanu@linux360.ro, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, laijs@cn.fujitsu.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/tracing] perf_counter: Support for ftrace
	event records sampling
Message-ID: <20090807101136.GA20896@elte.hu>
References: <1249601154-5597-1-git-send-email-fweisbec@gmail.com> <tip-24cb4fabe71f1d896b504cec82277ad7426a3d6d@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tip-24cb4fabe71f1d896b504cec82277ad7426a3d6d@git.kernel.org>
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


* tip-bot for Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Commit-ID:  24cb4fabe71f1d896b504cec82277ad7426a3d6d
> Gitweb:     http://git.kernel.org/tip/24cb4fabe71f1d896b504cec82277ad7426a3d6d
> Author:     Frederic Weisbecker <fweisbec@gmail.com>
> AuthorDate: Fri, 7 Aug 2009 01:25:54 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Fri, 7 Aug 2009 09:30:33 +0200
> 
> perf_counter: Support for ftrace event records sampling

this commit triggers a new build warning:

kernel/perf_counter.c: In function ‘perf_counter_output’:
kernel/perf_counter.c:2650: warning: ‘tp’ may be used uninitialized in this function

	Ingo
