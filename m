Return-Path: <linux-kernel-owner+w=401wt.eu-S1756543AbZF2JOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbZF2JOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 05:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbZF2JOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 05:14:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54875 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbZF2JOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 05:14:24 -0400
Date: Mon, 29 Jun 2009 11:14:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/fastboot: document the need of initcall_debug
Message-ID: <20090629091422.GA9724@elte.hu>
References: <4A48735E.9050002@cn.fujitsu.com> <20090629082152.GA2921@elte.hu> <4A488304.9000104@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A488304.9000104@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> Ingo Molnar wrote:
> > * Li Zefan <lizf@cn.fujitsu.com> wrote:
> > 
> >> To use boot tracer, one should pass initcall_debug as well as
> >> ftrace=initcall to the command line.
> > 
> > I think both should be auto-enabled if BOOT_TRACER is enabled, for 
> > ease of use - agreed?
> 
> If both are auto-enabled, we'll always do boot tracing. But we 
> want BOOT_TRACER to be enabled and only enable boot tracing when 
> it's needed.
> 
> But maybe we can make ftrace=initcall implies initcall_debug=1?

That's reasonable indeed.

	Ingo
