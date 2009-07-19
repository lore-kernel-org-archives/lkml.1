Return-Path: <linux-kernel-owner+w=401wt.eu-S1751042AbZGSSri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751042AbZGSSri (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 14:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750844AbZGSSrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 14:47:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46647 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbZGSSrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 14:47:36 -0400
Date: Sun, 19 Jul 2009 20:47:19 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/3] tracing: removing struct module* parameter from
	ftrace_init_module code path
Message-ID: <20090719184719.GA3040@jolsa.redhat.com>
References: <1247773468-11594-1-git-send-email-jolsa@redhat.com> <1247773468-11594-3-git-send-email-jolsa@redhat.com> <20090718101653.GC24164@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090718101653.GC24164@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 18, 2009 at 12:16:53PM +0200, Ingo Molnar wrote:
> 
> * jolsa@redhat.com <jolsa@redhat.com> wrote:
> 
> > The "struct module*" is not being used in the ftrace_init_module 
> > code path, removing it.
> >
> > wbr,
> > jirka
> > 
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > 
> > ---
> >  arch/x86/kernel/ftrace.c |    3 +--
> >  include/linux/ftrace.h   |    4 +---
> >  kernel/trace/ftrace.c    |   25 +++++++++++--------------
> >  3 files changed, 13 insertions(+), 19 deletions(-)
> 
> patch didnt apply cleanly to the latest tracing tree:
> 
>   http://people.redhat.com/mingo/tip.git/README
> 
> and the other bits had some fuzz as well. Mind merging + resending 
> this?
> 
> 	Ingo

sure, np.. I made it against the linus' tree, I'll use the 
tip tree next time

jira
