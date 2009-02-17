Return-Path: <linux-kernel-owner+w=401wt.eu-S1752743AbZBQKiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbZBQKiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 05:38:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbZBQKhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 05:37:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49061 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbZBQKhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 05:37:52 -0500
Date: Tue, 17 Feb 2009 11:37:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 12/15] ftrace: add traceon traceoff commands to
	enable/disable the buffers
Message-ID: <20090217103729.GB6602@elte.hu>
References: <20090217051227.957864159@goodmis.org> <20090217051407.422977785@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090217051407.422977785@goodmis.org>
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

> +	if (*count != -1)
> +		(*count)--;

minor nit: it's a tiny bit more compact as:

> +	if (*count != -1)
> +		--*count;

and this:

>  	return register_tracer(&function_trace);
>  }
>  
>  device_initcall(init_function_trace);
> +

there should be no newline between device_initcall() and the 
preceding function. (we can think of it as a late attribute of 
the function, attached to the function. We do the same for 
EXPORT_SYMBOL's too, etc.)

	Ingo
