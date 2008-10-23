Return-Path: <linux-kernel-owner+w=401wt.eu-S1752661AbYJWOIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbYJWOIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 10:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbYJWOID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 10:08:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37227 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbYJWOIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 10:08:01 -0400
Date: Thu, 23 Oct 2008 16:07:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Wenji Huang <wenji.huang@oracle.com>
Subject: Re: [PATCH 00/12 v3] ftrace: clean ups and fixes
Message-ID: <20081023140721.GA17322@elte.hu>
References: <20081023133256.926296694@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023133256.926296694@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> [
>   Changes since v2:
> 
>    Typo corrections suggested by Wenji Huang.
> 
>    Removed adding notrace to init sections. Right now it should not
>    be an issue. If we deem that it is, we can add the patch later.
>    It's a performance patch, but I have yet to measure if the improvement
>    is even measurable.
> ]
> 
> This is a series of patches to make ftrace more robust and clean ups.

i've merged them to tip/tracing/urgent, thanks Steve. There were a 
handful of conflicts i had to resolve so please double check the end 
result.

in general, the direction you've taken with these patches is very good!

	Ingo
