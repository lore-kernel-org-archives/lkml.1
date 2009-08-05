Return-Path: <linux-kernel-owner+w=401wt.eu-S933943AbZHEJRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933943AbZHEJRY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 05:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933894AbZHEJRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 05:17:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34411 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933933AbZHEJRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 05:17:21 -0400
Date: Wed, 5 Aug 2009 11:16:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       lwoodman@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 4/4] tracing, page-allocator: Add a postprocessing
	script for page-allocator-related ftrace events
Message-ID: <20090805091635.GA16718@elte.hu>
References: <1249409546-6343-1-git-send-email-mel@csn.ul.ie> <1249409546-6343-5-git-send-email-mel@csn.ul.ie> <20090804112246.4e6d0ab1.akpm@linux-foundation.org> <4A787D84.2030207@redhat.com> <20090804121332.46df33a7.akpm@linux-foundation.org> <20090804204857.GA32092@csn.ul.ie> <20090805074103.GD19322@elte.hu> <20090805090742.GA21950@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090805090742.GA21950@csn.ul.ie>
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


* Mel Gorman <mel@csn.ul.ie> wrote:

> > I.e. we'd have your patch in the end, but also with some 
> > feel-good thoughts made about it on a higher level, so that we 
> > can be reasonably sure that we have a meaningful set of 
> > tracepoints.
> 
> Ok, I think I could put together such a description for the page 
> allocator tracepoints using the leader and your mail as starting 
> points. I reckon the best place for the end result would be 
> Documentation/vm/tracepoints.txt

The canonical place for that info is Documentation/trace/ - we 
already have a collection of similar bits there:

 events.txt  kmemtrace.txt  power.txt               tracepoints.txt
 ftrace.txt  mmiotrace.txt  ring-buffer-design.txt

	Ingo
