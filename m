Return-Path: <linux-kernel-owner+w=401wt.eu-S1752713AbYJaQPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbYJaQPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 12:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750881AbYJaQPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 12:15:41 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:50958 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbYJaQPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 12:15:40 -0400
Date: Fri, 31 Oct 2008 17:16:48 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH] ftrace, kbuild: condense recordmcount.pl parameter code
Message-ID: <20081031161648.GA8254@uranus.ravnborg.org>
References: <20081022184313.179487464@goodmis.org> <20081022185135.618026303@goodmis.org> <alpine.DEB.1.10.0810271337370.8006@gandalf.stny.rr.com> <20081029190045.GC22105@uranus.ravnborg.org> <alpine.DEB.1.10.0810291529410.13214@gandalf.stny.rr.com> <20081030233733.GA16601@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081030233733.GA16601@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 12:37:33AM +0100, Ingo Molnar wrote:
> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > 
> > Sam Ravnborg pointed out that I could condense the code for the parameters of
> > recordmcount.pl by using an $(if ...) condition.
> > 
> > Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> > ---
> >  scripts/Makefile.build |   12 +++---------
> >  1 file changed, 3 insertions(+), 9 deletions(-)
> 
> Sam, would you like to see this cleanup in v2.6.28, or can it wait 
> until v2.6.29?

This is pure cleanup so it can/shall wait.

	Sam
