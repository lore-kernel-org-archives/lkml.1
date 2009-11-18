Return-Path: <linux-kernel-owner+w=401wt.eu-S1758358AbZKRTjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358AbZKRTjd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 14:39:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758023AbZKRTjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 14:39:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39722 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754776AbZKRTjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 14:39:31 -0500
Date: Wed, 18 Nov 2009 20:39:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Luck, Tony" <tony.luck@intel.com>, Paul Mackerras <paulus@samba.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ia64 support for tools/perf/
Message-ID: <20091118193927.GA30470@elte.hu>
References: <4b02d7f43514327a@agluck-desktop.sc.intel.com>
 <20091117172139.GB5967@elte.hu>
 <57C9024A16AD2D4C97DC78E552063EA3E3876A5B@orsmsx505.amr.corp.intel.com>
 <1258563396.3918.698.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258563396.3918.698.camel@laptop>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, 2009-11-17 at 09:25 -0800, Luck, Tony wrote:
> > > Btw., are you planning HAVE_PERF_EVENTS support for IA64? (It's nice 
> > > stuff, i can only recommend it! ;-)
> > 
> > My first goal is getting the s/w events hooked up and working.  I'm 
> > still wondering about how to get the h/w counters to co-exist with 
> > perfmon (which has been part of ia64 API for many years).
> 
> A first approach could be to make them mutually exclusive at runtime. 
> When there's a perf_event user, perfmon users get FAIL and vs.
> 
> This is basically the state for x86 perf_event vs oprofile atm.

Yep, this is probably the least intrusive approach. Mixing the 
implementations beyond trivial exclusion would probably be pain.

	Ingo
