Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945AbYJ3UfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbYJ3UfB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 16:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753737AbYJ3Uex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 16:34:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44373 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753424AbYJ3Uex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 16:34:53 -0400
Date: Thu, 30 Oct 2008 21:34:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/2] ftrace: handle NMIs safely
Message-ID: <20081030203434.GL27407@elte.hu>
References: <20081030200831.467420488@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081030200831.467420488@goodmis.org>
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

> The robustness of ftrace has been the focus of the code modification 
> in 2.6.28. There is one remaining issue that needed to be addressed. 
> This was the case of NMIs.

applied to tip/tracing/nmisafe, thanks Steve!

this looks a lot nicer approach than either putting some sort of lock 
into NMI context (yuck) or the disabling of NMIs (not really possible 
in a generic way architecturally).

the impact is quite non-trivial, so i dont think this is v2.6.28 
material.

	Ingo
