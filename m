Return-Path: <linux-kernel-owner+w=401wt.eu-S1754390AbZC0Goj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbZC0Goj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 02:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686AbZC0Goa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 02:44:30 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:26382 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbZC0Go3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 02:44:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wdRWZd3BzmlBotaBAAi9EcXr+yUq6la5ry10xoInR9f9sg+y7jVZ7CFbqCbdOo0O8q
         ttQIUOy9C9lxhyBndon5rZ9XD7M1xmLXZABSsW26PR7IkEk8jqYMCRn/eRmP0UXDb3Ta
         y4xLRQZui3LUIw/OwEfTo/Tc3ADHBhdfemfjA=
Date: Fri, 27 Mar 2009 07:44:25 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/ftrace: factorize the tracing files creation
Message-ID: <20090327064424.GB5959@nowhere>
References: <1238109938-11840-1-git-send-email-fweisbec@gmail.com> <alpine.DEB.2.00.0903261949480.1917@gandalf.stny.rr.com> <alpine.DEB.2.00.0903262002490.1917@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903262002490.1917@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 08:04:43PM -0400, Steven Rostedt wrote:
> 
> 
> On Thu, 26 Mar 2009, Steven Rostedt wrote:
> 
> > 
> > On Fri, 27 Mar 2009, Frederic Weisbecker wrote:
> > 
> > > Impact: cleanup
> > > 
> > > Most of the tracing files creation follow the same pattern:
> > > 
> > > ret = debugfs_create_file(...)
> > > if (!ret)
> > > 	pr_warning("Couldn't create ... entry\n")
> > > 
> > > Unify it!
> > > 
> > 
> > I could have sworn I did this before. I found this patch with the 
> > timestamp dated Feb 8, 2008.  This is even before we came up with the name 
> > "ftrace" and I was still calling it "mcount".
> > 
> > Oh well, it somehow never got out :-(
> > 
> > I'll Ack yours ;-)
> > 
> > 
> > Old patch:
> > 
> > From: Steven Rostedt <srostedt@redhat.com>
> > Subject: clean up trace debugfs error messages
> > 
> > The debugfs creation had a bunch of cut and paste errors
> > in the prints. This patch creates a single function to
> > create the debugfs file and print out the error if it
> > fails.
> > 
> > Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> 
> I always wondered why Ingo never pulled it in. I can not find any record 
> of me emailing it. I've not only searched Google, but it is not in any of 
> my "sent" folders either. I must have been suffering a senior moment, and 
> thought I emailed it when I never did :-/
> 
> -- Steve
> 


Be care, that's not the first time! Remember this old copy_from_user_inatomic() ?

:-)

