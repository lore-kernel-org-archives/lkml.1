Return-Path: <linux-kernel-owner+w=401wt.eu-S1757933AbZF0R3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933AbZF0R3O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 13:29:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755410AbZF0R27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 13:28:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34691 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756738AbZF0R26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 13:28:58 -0400
Date: Sat, 27 Jun 2009 19:28:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Vince Weaver <vince@deater.net>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: performance counter ~0.4% error finding retired instruction
	count
Message-ID: <20090627172854.GE21595@elte.hu>
References: <Pine.LNX.4.64.0906240937120.10620@pianoman.cluster.toy> <20090624151010.GA12799@elte.hu> <Pine.LNX.4.64.0906261417560.23467@pianoman.cluster.toy> <Pine.LNX.4.64.0906261520030.23653@pianoman.cluster.toy> <20090627060432.GB16200@elte.hu> <19013.49344.860564.948905@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19013.49344.860564.948905@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> Ingo Molnar writes:
> 
> > I measured 2000, but generally a few thousand cycles per 
> > invocation sounds about right.
> 
> We could actually do a bit better than we do, fairly easily.  We 
> could attach the counters to the child after the fork instead of 
> the parent before the fork, using a couple of pipes for 
> synchronization.  And there's probably a way to get the dynamic 
> linker to resolve the execvp call early in the child so we avoid 
> that overhead.  I think we should be able to get the overhead down 
> to tens of userspace instructions without doing anything 
> unnatural.

Definitely so.

	Ingo
