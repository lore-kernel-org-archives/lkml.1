Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbZJAPM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbZJAPM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 11:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbZJAPM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 11:12:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41484 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753612AbZJAPM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 11:12:56 -0400
Date: Thu, 1 Oct 2009 17:12:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Clark Williams <williams@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, jeff@garzik.org, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, rusty@rustcorp.com.au, cl@linux-foundation.org,
       dhowells@redhat.com, arjan@linux.intel.com
Subject: Re: [PATCH 19/19] workqueue: implement concurrency managed
	workqueue
Message-ID: <20091001151211.GA24308@elte.hu>
References: <1254384558-1018-1-git-send-email-tj@kernel.org> <1254384558-1018-20-git-send-email-tj@kernel.org> <20091001074959.dbdf6f6a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091001074959.dbdf6f6a.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu,  1 Oct 2009 17:09:18 +0900 Tejun Heo <tj@kernel.org> wrote:
> 
> > To solve the above issues, this patch implements concurrency-managed
> > workqueue.
> 
> Seems reasonable.
> 
> This approach would appear to rule out the option of setting a work 
> thread's state (scheduling policy, scheduling priority, uid, etc) to 
> anything other than some default.
> 
> I guess that's unlikely to be a problem if we haven't yet had a need 
> to do that, but I'd be a bit surprised to discover that nobody has 
> done that sort of thing yet?  Nobody has niced up their workqueue 
> threads?

tuna in -rt might do that perhaps?

	Ingo
