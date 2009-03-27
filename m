Return-Path: <linux-kernel-owner+w=401wt.eu-S932589AbZC0AFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932589AbZC0AFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 20:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762147AbZC0AEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 20:04:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:37021 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757290AbZC0AEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 20:04:46 -0400
Date: Thu, 26 Mar 2009 20:04:43 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/ftrace: factorize the tracing files creation
In-Reply-To: <alpine.DEB.2.00.0903261949480.1917@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0903262002490.1917@gandalf.stny.rr.com>
References: <1238109938-11840-1-git-send-email-fweisbec@gmail.com> <alpine.DEB.2.00.0903261949480.1917@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Mar 2009, Steven Rostedt wrote:

> 
> On Fri, 27 Mar 2009, Frederic Weisbecker wrote:
> 
> > Impact: cleanup
> > 
> > Most of the tracing files creation follow the same pattern:
> > 
> > ret = debugfs_create_file(...)
> > if (!ret)
> > 	pr_warning("Couldn't create ... entry\n")
> > 
> > Unify it!
> > 
> 
> I could have sworn I did this before. I found this patch with the 
> timestamp dated Feb 8, 2008.  This is even before we came up with the name 
> "ftrace" and I was still calling it "mcount".
> 
> Oh well, it somehow never got out :-(
> 
> I'll Ack yours ;-)
> 
> 
> Old patch:
> 
> From: Steven Rostedt <srostedt@redhat.com>
> Subject: clean up trace debugfs error messages
> 
> The debugfs creation had a bunch of cut and paste errors
> in the prints. This patch creates a single function to
> create the debugfs file and print out the error if it
> fails.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>

I always wondered why Ingo never pulled it in. I can not find any record 
of me emailing it. I've not only searched Google, but it is not in any of 
my "sent" folders either. I must have been suffering a senior moment, and 
thought I emailed it when I never did :-/

-- Steve

