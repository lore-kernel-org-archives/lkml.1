Return-Path: <linux-kernel-owner+w=401wt.eu-S1754210AbYHVHX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbYHVHX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 03:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbYHVHXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 03:23:45 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38170 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbYHVHXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 03:23:44 -0400
Date: Fri, 22 Aug 2008 09:23:43 +0200
From: Pavel Machek <pavel@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Steven Rostedt <rostedt@goodmis.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: ftraced and suspend to ram
Message-ID: <20080822072343.GA24173@atrey.karlin.mff.cuni.cz>
References: <alpine.DEB.1.10.0808211139420.3947@gandalf.stny.rr.com> <alpine.DEB.1.10.0808211423410.678@gandalf.stny.rr.com> <200808212037.11775.rjw@sisk.pl> <200808212159.37678.rjw@sisk.pl> <20080822044649.GA356@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080822044649.GA356@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > > > The code in question is the ftraced() function in 
> > > > kernel/trace/ftrace.c
> > > 
> > > Thanks, I'll have a look in a while.
> > 
> > Can you try the appended patch, please?
> 
> makes sense - i've applied it to tip/tracing/urgent, see the tidied up 
> commit below.
> 
> It should be no big issue not being able to trace across suspend+resume 
> - and that restriction will go away with Steve's build-time based mcount 
> patching mechanism in v2.6.28.

Patch looks okay to me, but I'm not sure if another issue is not
hiding under it. Did anyone actually test ftrace + suspend after
applying this?
								Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
