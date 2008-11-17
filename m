Return-Path: <linux-kernel-owner+w=401wt.eu-S1753767AbYKQQZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767AbYKQQZA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 11:25:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbYKQQYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 11:24:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44422 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974AbYKQQYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 11:24:48 -0500
Date: Mon, 17 Nov 2008 17:24:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Soeren Sandmann <sandmann@daimi.au.dk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Bug #11954] sysprof tracer ABI regression in 2.6.28rc1
Message-ID: <20081117162431.GG12081@elte.hu>
References: <VwdsQNEjR_C.A.CiD.9_FIJB@chimera> <Q7OAnAv0V3D.A.MbF.8AGIJB@chimera> <ye8k5b2eetz.fsf@camel11.daimi.au.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ye8k5b2eetz.fsf@camel11.daimi.au.dk>
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


* Soeren Sandmann <sandmann@daimi.au.dk> wrote:

> There are no ABI guarantees for the sysprof tracer at this point, 
> given that it is in debugfs [...]

to avoid situations like this, it would be nice to print out the 
format string itself in the trace header, in printf format string 
style. That way if there's a trivial expansion in trace format, it can 
be detected (and even followed) by user-space - without some ugly 
version based API.

	Ingo
