Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbYKEQbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbYKEQbW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 11:31:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752504AbYKEQbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 11:31:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50403 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994AbYKEQa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 11:30:59 -0500
Date: Wed, 5 Nov 2008 17:30:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: bug: ftrace & lockdep badness
Message-ID: <20081105163052.GA28884@elte.hu>
References: <20081105123714.GA23504@osiris.boeblingen.de.ibm.com> <alpine.DEB.1.10.0811051054430.11900@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811051054430.11900@gandalf.stny.rr.com>
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

> This is the type of problems we deal with when we have the tracer 
> tracing lockdep code at the same time the lockdep code is checking 
> the tracer.

ok ... you are right, i guess we need to go back to raw locks after 
all?

	Ingo
