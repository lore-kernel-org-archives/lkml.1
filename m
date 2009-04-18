Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919AbZDRHOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbZDRHOt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 03:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751118AbZDRHOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 03:14:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52707 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbZDRHOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 03:14:39 -0400
Date: Sat, 18 Apr 2009 09:14:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] tracing: remove format attribute of inline function
Message-ID: <20090418071426.GD7678@elte.hu>
References: <alpine.DEB.2.00.0904171717080.1016@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904171717080.1016@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Due to a cut and paste error, I added the gcc attribute for printf
> format to the static inline stub of trace_seq_printf.
> 
> This will cause a compile failure.
> 
> [ Impact: fix compiler error when CONFIG_TRACING is off ]
> 
> Reported-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Applied, thanks Steve!

We also need to make CONFIG_TRACING an interactive option as well 
which i suggested before, so that people can enable/disable this 
stuff in a convenient summary way, even if they have KERNEL_DEBUG 
enabled otherwise.

Thanks,

	Ingo
