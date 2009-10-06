Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694AbZJFJKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbZJFJKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 05:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004AbZJFJKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 05:10:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59805 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755454AbZJFJKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 05:10:44 -0400
Date: Tue, 6 Oct 2009 11:09:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
       lizf@cn.fujitsu.com, hch@infradead.org
Subject: Re: [RFC][PATCH 0/9] perf trace: support for general-purpose
	scripting
Message-ID: <20091006090954.GA19325@elte.hu>
References: <1254809398-8078-1-git-send-email-tzanussi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254809398-8078-1-git-send-email-tzanussi@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0048]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tom Zanussi <tzanussi@gmail.com> wrote:

> Known problems/shortcomings:
> 
> Probably the biggest problem right now is the sorting hack I added as 
> the last patch.  It's just meant as a temporary thing, but is there 
> because tracing scripts in general want to see events in the order 
> they happened i.e. timestamp order. [...]

Btw., have you seen the -M/--multiplex option to perf record? It 
multiplexes all events into a single buffer - making them all ordered. 
(The events are in causal ordering in this case even if there's some TSC 
asynchronity)

	Ingo
