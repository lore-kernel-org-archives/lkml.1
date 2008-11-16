Return-Path: <linux-kernel-owner+w=401wt.eu-S1752480AbYKPGn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbYKPGn3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 01:43:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbYKPGnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 01:43:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47489 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbYKPGnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 01:43:21 -0500
Date: Sun, 16 Nov 2008 07:43:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] tracing/function-return-tracer: Add a barrier to
	ensure return stack index is incremented in memory
Message-ID: <20081116064304.GC32215@elte.hu>
References: <491E27E8.7050401@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491E27E8.7050401@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Impact: Fix possible race condition in ftrace function return tracer
> 
> This fixes a possible race condition if index incrementation
> is not immediately flushed in memory.
> 
> Thanks for Andi Kleen and Steven Rostedt for pointing out this issue
> and give me this solution.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>

applied, thanks Frederic!

	Ingo
