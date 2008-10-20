Return-Path: <linux-kernel-owner+w=401wt.eu-S1753023AbYJTQbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbYJTQbh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 12:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbYJTQb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 12:31:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47132 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbYJTQb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 12:31:29 -0400
Date: Mon, 20 Oct 2008 18:31:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3] ftrace: separate ftrace from ftrace
Message-ID: <20081020163108.GA1035@elte.hu>
References: <20081006230610.024517480@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081006230610.024517480@goodmis.org>
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

> There has been a lot of confusion between ftrace the infrastructure 
> and ftrace the function tracer within ftrace.  Developers have added 
> dependencies on HAVE_FTRACE when they did not need to. The HAVE_FTRACE 
> was the architecture supported the function tracer.
> 
> This patch series renames the ftrace function tracer to just that, 
> FUNCTION_TRACER.  And even renames the tracer shown to users from 
> 'ftrace' to 'function'.
> 
> Now, when referring to ftrace, it means the ftrace infrastructure, and 
> when referring to the function trace, it is now called the function 
> tracer.
> 
> The second patch cause a lot of files to be touched. Mostly Makefiles 
> and Kconfig files. As well as default configs.

applied the following bits to tip/tracing/ftrace:

 3ce83ae: ftrace: rename the ftrace tracer to function
 606576c: ftrace: rename FTRACE to FUNCTION_TRACER
 c2db805: ftrace: fix depends
 bd95b88: ftrace: release functions from hash
 c513867: ftrace: do not enclose logic in WARN_ON

thanks Steve! I left out the defconfig bits - out of sync symbol names 
there do not hurt, and those files are high-flux anyway and generally 
updated by the arch maintainers regularly.

	Ingo
