Return-Path: <linux-kernel-owner+w=401wt.eu-S1755116AbZBRA3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbZBRA3X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 19:29:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbZBRA3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 19:29:10 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33841 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbZBRA3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 19:29:09 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] Add tracepoints to track pagecache transition
Cc: kosaki.motohiro@jp.fujitsu.com, Atsushi Tsuji <a-tsuji@bk.jp.nec.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Jason Baron <jbaron@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Kazuto Miyoshi <miyoshi@linux.bs1.fc.nec.co.jp>, rostedt@goodmis.org,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>
In-Reply-To: <20090217143321.GB5888@nowhere>
References: <20090217201651.576E.A69D9226@jp.fujitsu.com> <20090217143321.GB5888@nowhere>
Message-Id: <20090218091726.898D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Wed, 18 Feb 2009 09:29:04 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

> > And, both function is freqentlly called one.
> > I worry about performance issue. can you prove no degression?
> 
> It would be very hard to prove. Tracepoints are very cheap in that they only
> add the overhead of a single branch check while off.

this is typical reviewing comment.

Memory folks adage says,
	Don't believe theory, you believe benchmark result.

I don't oppose your theorical background opinion :)


> But are there some plans about writing a tracer or so for pagecache?



