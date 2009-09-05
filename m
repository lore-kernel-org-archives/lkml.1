Return-Path: <linux-kernel-owner+w=401wt.eu-S934647AbZIEBPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934647AbZIEBPe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 21:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934489AbZIEBPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 21:15:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934452AbZIEBPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 21:15:32 -0400
Date: Sat, 5 Sep 2009 03:15:25 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/3] tracing - adding common method for reading/parsing
	user input
Message-ID: <20090905011525.GA2513@jolsa.redhat.com>
References: <1252071073-27134-1-git-send-email-jolsa@redhat.com> <1252072289.799.3.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252072289.799.3.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04, 2009 at 09:51:29AM -0400, Steven Rostedt wrote:
> 
> On Fri, 2009-09-04 at 15:31 +0200, jolsa@redhat.com wrote:
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
> 
> Hi Jolsa,
> 
> I'll take a look at these. I know there's duplicate code that I even
> wrote a "generic" handler for others to use, that basically got a NAK
> from Andrew Morton. I probably could have put it into the ftrace code
> directly, but never did so.
> 
> It will be interesting to look at your patches, especially when those
> functions all do things quite differently, with the exception of
> set_ftrace_filter and set_ftrace_notrace.
> 
> Note, all your patches have [PATCH 0/3] in the subject. I think I can
> figure out the order, but you will want to fix that on your next
> version.

oops, script fault ;) I resent v2, plz check

> 
> Currently I'm bug fixing other areas that need a bit of attention. I'll
> add this to my queue.

thanks,
jirka

> 
> Thanks,
> 
> -- Steve
> 
> 
