Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341AbZHEWbD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbZHEWbD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 18:31:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbZHEWbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 18:31:00 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:35633 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbZHEWaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 18:30:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=reFD3TQEztQzr/yFHRELPT/o/50aTFvxraxDU3Tu7E3St3CQ9m5vyPlT983gV/hDyj
         P3olxkMn6JxZ7++vL7QuyaVSKbePUoyoUZL78LlFyA2uwVMoeFgLUEV0VBu3GcRBSxwN
         UsEetiQJa/elqMh2wUIaUWigAhiBDdSWp1Les=
Date: Thu, 6 Aug 2009 00:30:17 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH 3/5] tracing/filters: Cleanup useless headers
Message-ID: <20090805223016.GG5025@nowhere>
References: <1249111408-8657-1-git-send-email-fweisbec@gmail.com> <1249111408-8657-4-git-send-email-fweisbec@gmail.com> <4A767359.3030405@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A767359.3030405@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03, 2009 at 01:19:21PM +0800, Li Zefan wrote:
> 15:23, Frederic Weisbecker wrote:
> > Cleanup remaining headers inclusion that were only useful when
> > the filter framework and its tracing related filesystem user interface
> > weren't yet separated.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Tom Zanussi <tzanussi@gmail.com>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  kernel/trace/trace_events_filter.c |    3 ---
> >  1 files changed, 0 insertions(+), 3 deletions(-)
> > 
> > diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> > index b9aae72..a2f8bef 100644
> > --- a/kernel/trace/trace_events_filter.c
> > +++ b/kernel/trace/trace_events_filter.c
> > @@ -18,9 +18,6 @@
> >   * Copyright (C) 2009 Tom Zanussi <tzanussi@gmail.com>
> >   */
> >  
> > -#include <linux/debugfs.h>
> > -#include <linux/uaccess.h>
> > -#include <linux/module.h>
> 
> But module.h is needed for the use of EXPORT_SYMBOL_GPL().


Oh, indeed, I'll fix that in the v2.

Thanks.


> 
> >  #include <linux/ctype.h>
> >  #include <linux/mutex.h>
> >  

