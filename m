Return-Path: <linux-kernel-owner+w=401wt.eu-S1751876AbYKLKVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876AbYKLKVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 05:21:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbYKLKVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 05:21:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39639 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbYKLKV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 05:21:29 -0500
Date: Wed, 12 Nov 2008 11:21:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/2] tracing/fastboot: Use the ring-buffer timestamp
	for initcall entries
Message-ID: <20081112102103.GA24482@elte.hu>
References: <20081112055454.798779203@goodmis.org> <20081112055600.657041406@goodmis.org> <20081111220051.204c43f2.akpm@linux-foundation.org> <c62985530811120045j5fc0475r8c374f4853f6823e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530811120045j5fc0475r8c374f4853f6823e@mail.gmail.com>
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


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> 2008/11/12 Andrew Morton <akpm@linux-foundation.org>:
> > On Wed, 12 Nov 2008 00:54:56 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> >> -     unsigned long long      duration;               /* usecs */
> >> +     unsigned long long      duration;
> >
> > my hard-won comment got fragged.
> 
> 
> Oops. I forgot it.
> Perhaps I should resend a patch that reset this comment?
> BTW it is nsecs actually.

no need, i fixed it up when applying your patch to tracing/fastboot, 
and also changed it to nsecs.

	Ingo
