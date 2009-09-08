Return-Path: <linux-kernel-owner+w=401wt.eu-S1751192AbZIHOhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751192AbZIHOhT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 10:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbZIHOhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 10:37:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbZIHOhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 10:37:17 -0400
Date: Tue, 8 Sep 2009 16:37:11 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 0/3] tracing - adding common method for
	reading/parsing user input
Message-ID: <20090908143711.GC3177@jolsa.lab.eng.brq.redhat.com>
References: <1252113181-3325-1-git-send-email-jolsa@redhat.com> <1252418499.13628.31.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252418499.13628.31.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 08, 2009 at 10:01:39AM -0400, Steven Rostedt wrote:
> On Sat, 2009-09-05 at 03:12 +0200, jolsa@redhat.com wrote:
> > As 3 different places for 4 user input files were using the same way
> > of reading and parsing user's input, I made one common routine to be
> > used. 
> > 
> > The mentioned files are:
> > 	set_graph_function
> > 	set_event
> > 	set_ftrace_filter
> > 	set_ftrace_notrace
> > 
> > wbr,
> > jirka
> > 
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> 
> Looking back, this is pretty much exactly what I did back in February:
> 
>   http://lkml.org/lkml/2009/2/25/385
> 
> The difference is that I wanted this to be a generic feature for things
> outside of tracing to use. I may just take my old patch and put the code
> in trace.c like you did.
> 
> Thanks,
> 
> -- Steve
> 
> 

ok, so are you going to take your patch, or should I do the changes you
proposed and send it out again?

wbr,
jirka
