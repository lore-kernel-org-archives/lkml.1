Return-Path: <linux-kernel-owner+w=401wt.eu-S1754074AbXLRKss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbXLRKss (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 05:48:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753185AbXLRKsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 05:48:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36507 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180AbXLRKsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 05:48:38 -0500
Date: Tue, 18 Dec 2007 11:48:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org
Subject: Re: [PATCH] sched: dynamically update the root-domain span/online
	maps
Message-ID: <20071218104800.GC29466@elte.hu>
References: <200712172339.lBHNdmDD008149@imap1.linux-foundation.org> <20071218005217.4957.3055.stgit@novell1.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071218005217.4957.3055.stgit@novell1.haskins.net>
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


* Gregory Haskins <ghaskins@novell.com> wrote:

> http://marc.info/?l=linux-mm-commits&m=119793598429477&w=2
> 
> I have confirmed that it builds and boots clean, and it passes 
> checkpatch. However, my test machine seems to be having problems with 
> suspend-to-ram that are unrelated to this patch that prevent me from 
> verifying the fix entirely. If Gautham or Andrew could confirm that it 
> resolves their suspend-to-ram issue, I would be most appreciative.

i'm reluctant to apply it without test results, unless we have a very 
clear picture of what happened on Andrew's box and how this updated 
patch resolves that problem. (or once Andrew tests your patch and deems 
it OK.)

	Ingo
