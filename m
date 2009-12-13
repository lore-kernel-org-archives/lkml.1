Return-Path: <linux-kernel-owner+w=401wt.eu-S1753551AbZLMOvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbZLMOvJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 09:51:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbZLMOvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 09:51:07 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:45012 "HELO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753472AbZLMOvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 09:51:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RNlqThV306AXFB9/BmUfaq9mMWXiWiP3KHyCXji1WJOMJWqzyNKxLxMOJv7yoF8KNu
         EQtGksktfBH9dqvNMobHN8CGwKLaAjF69fiFRZM8M3LZm3k+AK7NQA9YQU9Ejady3JDk
         5py79D6WuFk09jF7Kf4K/U+APl0TvgG0Cp1cU=
Date: Sun, 13 Dec 2009 15:50:58 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       joe@perches.com, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/urgent] ftrace.h: Use common pr_info fmt string
Message-ID: <20091213145056.GA5268@nowhere>
References: <1260651974.2637.4.camel@Joe-Laptop.home> <tip-4819568f23a8bef0ca99b740ca60fe2450ab0aac@git.kernel.org> <1260715695.2146.412.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260715695.2146.412.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 13, 2009 at 09:48:15AM -0500, Steven Rostedt wrote:
> On Sun, 2009-12-13 at 07:37 +0000, tip-bot for Joe Perches wrote:
> > Commit-ID:  4819568f23a8bef0ca99b740ca60fe2450ab0aac
> > Gitweb:     http://git.kernel.org/tip/4819568f23a8bef0ca99b740ca60fe2450ab0aac
> > Author:     Joe Perches <joe@perches.com>
> > AuthorDate: Sat, 12 Dec 2009 13:06:13 -0800
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Sun, 13 Dec 2009 08:14:45 +0100
> > 
> > ftrace.h: Use common pr_info fmt string
> > 
> > Reduces fmt string space a bit.
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > LKML-Reference: <1260651974.2637.4.camel@Joe-Laptop.home>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > ---
> >  include/trace/ftrace.h |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> > index d1b3de9..c4eca38 100644
> > --- a/include/trace/ftrace.h
> > +++ b/include/trace/ftrace.h
> > @@ -733,7 +733,7 @@ static int ftrace_raw_reg_event_##call(struct ftrace_event_call *unused)\
> >  	ret = register_trace_##call(ftrace_raw_event_##call);		\
> >  	if (ret)							\
> >  		pr_info("event trace: Could not activate trace point "	\
> > -			"probe to " #call "\n");			\
> > +			"probe to %s\n", #call);			\
> 
> This reduces format string space a bit, but doesn't it just add another
> string to the string tables #func == "func" as well as add code to pass
> in another parameter?
> 
> -- Steve


Yeah, I don't understand the purpose of this patch either...

