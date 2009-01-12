Return-Path: <linux-kernel-owner+w=401wt.eu-S1756519AbZALSVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519AbZALSVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 13:21:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756280AbZALSU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 13:20:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53925 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756270AbZALSUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 13:20:55 -0500
Date: Mon, 12 Jan 2009 19:20:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: checkpatch warning of struct indentation
Message-ID: <20090112182038.GA10392@elte.hu>
References: <alpine.DEB.1.10.0901121253350.22796@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901121253350.22796@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4977]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Hi,
> 
> I'm now seeing the following warnings from checkpatch:
> 
> #325: FILE: kernel/trace/trace_stat.c:21:
> +	void 			*stat;
> 
> ERROR: "foo 	*bar" should be "foo *bar"
> #334: FILE: kernel/trace/trace_stat.c:27:
> +	struct tracer_stat 	*ts;
> 
> ERROR: "foo		*bar" should be "foo	*bar"
> #337: FILE: kernel/trace/trace_stat.c:30:
> +	struct dentry		*file;
> 
> This is for:
> 
> struct tracer_stat_session {
>         struct list_head        session_list;
>         struct tracer_stat      *ts;
>         struct list_head        stat_list;
>         struct mutex            stat_mutex;
>         struct dentry           *file;
> };
> 
> Which looks a hell of a lot better than:
> 
> struct tracer_stat_session {
>         struct list_head session_list;
>         struct tracer_stat *ts;
>         struct list_head stat_list;
>         struct mutex stat_mutex;
>         struct dentry *file;
> };
> 
> We probably do not want to warn on such things.

yeah, those warnings look bogus.

	Ingo
