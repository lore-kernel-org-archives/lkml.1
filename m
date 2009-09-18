Return-Path: <linux-kernel-owner+w=401wt.eu-S1756930AbZIRLvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbZIRLvM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 07:51:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756807AbZIRLvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 07:51:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49033 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756615AbZIRLvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 07:51:10 -0400
Date: Fri, 18 Sep 2009 13:50:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland Dreier <rdreier@cisco.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-rdma@vger.kernel.org,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Anton Blanchard <anton@samba.org>, general@lists.openfabrics.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [ofa-general] Re: [GIT PULL] please pull ummunotify
Message-ID: <20090918115053.GK9930@elte.hu>
References: <aday6omhz9d.fsf@cisco.com> <1253187028.8439.2.camel@twins> <adafxalejiq.fsf@cisco.com> <adaab0tej5c.fsf@cisco.com> <1253198976.14935.27.camel@laptop> <adazl8td35u.fsf@cisco.com> <adatyz1d17q.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adatyz1d17q.fsf@cisco.com>
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


* Roland Dreier <rdreier@cisco.com> wrote:

>  > But yeah, I currently don't see a very nice match to perf counters.
> 
> OK.  It would be nice to tie into something more general, but I think 
> I agree -- perf counters are missing the filtering and the "no lost 
> events" that ummunotify does have.  And I'm not sure it's worth 
> messing up the perf counters design just to jam one more not totally 
> related thing in.

The filtering can be done and has been done - see Li Zefan's patchset 
that uses filter expressions to do per event in-kernel filtering.

The OOM DoS is a bug in your patches i think, which perfcounters solves 
;-)

	Ingo
