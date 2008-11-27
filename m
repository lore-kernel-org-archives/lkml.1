Return-Path: <linux-kernel-owner+w=401wt.eu-S1754922AbYK0QVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922AbYK0QVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 11:21:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754462AbYK0QVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 11:21:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58442 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754435AbYK0QVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 11:21:23 -0500
Date: Thu, 27 Nov 2008 17:21:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: walimis <walimisdev@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: about use wild cards for set_ftrace_filter and so on
Message-ID: <20081127162117.GA3467@elte.hu>
References: <20081127152124.GA24616@ubuntu.mshome.net> <alpine.DEB.1.10.0811271032360.18691@gandalf.stny.rr.com> <20081127155047.GB24616@ubuntu.mshome.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081127155047.GB24616@ubuntu.mshome.net>
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


* walimis <walimisdev@gmail.com> wrote:

> I only add a note, but I wonder whether enough.
> If needed, I can add a example to this document.
> 
> Impact: imporve document

[ You need to slightly improve the commit log as well ;-) ]

> +Note: you'd better to use '' to enclose wild cards, otherwise in some
> +case you can't get the correct result.
> +
>   # echo hrtimer_* > /debug/tracing/set_ftrace_filter

Why not fix the example too? Something like:

> +Note: you'd better to use '' to enclose wild cards, otherwise in some
> +case you can't get the correct result due to shell wildcard 
> +extension:.
> +
>   # echo 'hrtimer_*' > /debug/tracing/set_ftrace_filter

looks good otherwise.

	Ingo
