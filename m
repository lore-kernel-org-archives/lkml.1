Return-Path: <linux-kernel-owner+w=401wt.eu-S1755668AbZF2VCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668AbZF2VCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 17:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbZF2VCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 17:02:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44414 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269AbZF2VCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 17:02:08 -0400
Date: Mon, 29 Jun 2009 23:02:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vince Weaver <vince@deater.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>
Subject: Re: [numbers] perfmon/pfmon overhead of 17%-94%
Message-ID: <20090629210206.GB13125@elte.hu>
References: <Pine.LNX.4.64.0906240937120.10620@pianoman.cluster.toy> <20090624151010.GA12799@elte.hu> <Pine.LNX.4.64.0906261417560.23467@pianoman.cluster.toy> <Pine.LNX.4.64.0906261520030.23653@pianoman.cluster.toy> <20090627060432.GB16200@elte.hu> <20090627064404.GA19368@elte.hu> <Pine.LNX.4.64.0906291354380.1404@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0906291354380.1404@pianoman.cluster.toy>
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


* Vince Weaver <vince@deater.net> wrote:

>> If the 5 thousand cycles measurement overhead _still_ matters to 
>> you under such circumstances then by all means please submit the 
>> patches to improve it. Despite your claims this is totally 
>> fixable with the current perfcounters design, Peter outlined the 
>> steps of how to solve it, you can utilize ptrace if you want to.
>
> Is it really "totally" fixible?  I don't just mean getting the 
> overhead from ~3000 down to ~100, I mean down to zero.

The thing is, not even pfmon gets it down to zero:

  pfmon -e INSTRUCTIONS_RETIRED --follow-fork --aggregate-results ~/million
  1000001 INSTRUCTIONS_RETIRED

So ... do you take the hardliner purist view and consider it crap 
due to that imprecision, or do you take the pragmatist view of also 
considering the relative relevance of any imperfection? ;-)

	Ingo
