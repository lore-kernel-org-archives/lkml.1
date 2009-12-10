Return-Path: <linux-kernel-owner+w=401wt.eu-S1761270AbZLJRiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761270AbZLJRiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 12:38:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761059AbZLJRiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 12:38:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43515 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760963AbZLJRiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 12:38:23 -0500
Date: Thu, 10 Dec 2009 18:38:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       minchan.kim@gmail.com
Subject: Re: [RFC mm][PATCH 2/5] percpu cached mm counter
Message-ID: <20091210173819.GA5256@elte.hu>
References: <20091210163115.463d96a3.kamezawa.hiroyu@jp.fujitsu.com>
 <20091210163448.338a0bd2.kamezawa.hiroyu@jp.fujitsu.com>
 <20091210075454.GB25549@elte.hu>
 <20091210172040.37d259d3.kamezawa.hiroyu@jp.fujitsu.com>
 <20091210083310.GB6834@elte.hu>
 <alpine.DEB.2.00.0912101134220.5481@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0912101134220.5481@router.home>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux-foundation.org> wrote:

> On Thu, 10 Dec 2009, Ingo Molnar wrote:
> 
> >
> > No, i'm not suggesting that - i'm just suggesting that right now MM
> > stats are not very well suited to be exposed via perf. If we wanted to
> > measure/sample the information in /proc/<pid>/statm it just wouldnt be
> > possible. We have a few events like pagefaults and a few tracepoints as
> > well - but more would be possible IMO.
> 
> vital MM stats are exposed via /proc/<pid> interfaces. Performance 
> monitoring is something optional MM VM stats are used for VM decision 
> on memory and process handling.

You list a few facts here but what is your point?

	Ingo
