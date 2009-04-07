Return-Path: <linux-kernel-owner+w=401wt.eu-S1755618AbZDGMXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618AbZDGMXo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 08:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbZDGMXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 08:23:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52225 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754802AbZDGMX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 08:23:29 -0400
Date: Tue, 7 Apr 2009 14:23:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 05/10] tracing/ftrace: factorize the tracing files
	creation
Message-ID: <20090407122315.GD11641@elte.hu>
References: <20090406163706.097842409@goodmis.org> <20090406163830.773115333@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090406163830.773115333@goodmis.org>
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

> --- a/kernel/trace/trace_event_profile.c
> +++ b/kernel/trace/trace_event_profile.c
> @@ -6,7 +6,7 @@
>   */
>  
>  #include "trace.h"
> -
> +#if 0
>  int ftrace_profile_enable(int event_id)
>  {
>  	struct ftrace_event_call *event;
> @@ -29,3 +29,4 @@ void ftrace_profile_disable(int event_id)
>  	}
>  }
>  
> +#endif

uhm, that's not a very nice to do ;-)

	Ingo
