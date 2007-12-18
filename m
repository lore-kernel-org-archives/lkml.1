Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540AbXLRM6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbXLRM6B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 07:58:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754516AbXLRM5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 07:57:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54078 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352AbXLRM5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 07:57:51 -0500
Date: Tue, 18 Dec 2007 13:57:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gregory Haskins <ghaskins@novell.com>, Gautham R Shenoy <ego@in.ibm.com>,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org
Subject: Re: [PATCH] sched: dynamically update the root-domain span/online
	maps
Message-ID: <20071218125719.GA18064@elte.hu>
References: <200712172339.lBHNdmDD008149@imap1.linux-foundation.org> <20071218005217.4957.3055.stgit@novell1.haskins.net> <20071218104800.GC29466@elte.hu> <20071218032812.cbb6c823.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071218032812.cbb6c823.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > i'm reluctant to apply it without test results, unless we have a 
> > very clear picture of what happened on Andrew's box and how this 
> > updated patch resolves that problem. (or once Andrew tests your 
> > patch and deems it OK.)
> 
> <wades through a pile of new compile errors>

hm, due to any of these patches?

> <tests it>
> 
> Seems OK now - resume-from-RAM actually resumes.

cool, thanks! I've added it to sched-devel.git and have updated it.

	Ingo
