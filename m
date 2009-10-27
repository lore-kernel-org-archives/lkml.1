Return-Path: <linux-kernel-owner+w=401wt.eu-S1756569AbZJ0IAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569AbZJ0IAV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 04:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756487AbZJ0IAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 04:00:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49273 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756170AbZJ0IAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 04:00:20 -0400
Date: Tue, 27 Oct 2009 08:59:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Nicolas Pitre <nico@fluxnic.net>, "Luck, Tony" <tony.luck@intel.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Robert Richter <robert.richter@amd.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jean Delvare <khali@linux-fr.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC] to rebase or not to rebase on linux-next
Message-ID: <20091027075954.GA32640@elte.hu>
References: <4AE19A74.1090709@garzik.org> <20091023123555.GA25366@elte.hu> <57C9024A16AD2D4C97DC78E552063EA3E33D0174@orsmsx505.amr.corp.intel.com> <20091023134115.GD27097@elte.hu> <alpine.LFD.2.00.0910231424440.21460@xanadu.home> <20091023191631.GA1879@elte.hu> <1256326512.26028.34.camel@gandalf.stny.rr.com> <20091023205400.GA8356@elte.hu> <20091023215958.GA4139@merkur.ravnborg.org> <1256599588.26028.340.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256599588.26028.340.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Fri, 2009-10-23 at 23:59 +0200, Sam Ravnborg wrote:
> > On Fri, Oct 23, 2009 at 10:54:00PM +0200, Ingo Molnar wrote:
> > > 
> > > Maintainer trees pushed towards linux-next should strive to be Git 
> > > based, append-mostly, 'nice', 'intended for upstream' and 
> > > defendable as-is IMO, and rebasing a _maintainer tree_ should 
> > > really be a rare act of last resort.
> > 
> > As maintainer I try to put some effort in crediting people where 
> > credit belongs. In other words collecting "Acked-by:", "Tested-by", 
> > "Reviewed-by".
> > 
> > Adding this require a rebase as soon as said patch hits git.
> 
> I've been saying for a while that git really needs a way to "annotate" 
> a commit. And have git log show those annotations by default. 
> Signed-off-by must be in the original commit. But Acked-by, Tested-by 
> and Reviewed-by almost always come after it hits some git repo.

For any reasonably complex change you simply need to wait a bit anyway 
to gather feedback. And for trivial/obvious/small patches it makes 
little sense to upset the Git history just to add the tags.

(And if there's frequent problems with small changes that were supposed 
to be easy you need to revisit the quality process.)

So no, the rewinding of published for-pull git trees are not fine in 
Linux. It's OK to post a declaredly RFC git tree with some 
to-be-reworked patches in it - but it's not OK to publish a git tree for 
pull and rebase it after that. You'll certainly see me complain if you 
do that (and Linus will complain to me if i do that).

Now with tip:tracing/core we sometimes ran into a situaton where we did 
rebases to make the tree fast-forward all the time - but that's not 
necessary as Linus has made it clear that the occasional merge commit is 
not a problem. (if the mechanism to remove them is to rebase) We can 
certainly do that to make the Git flow even more append-only.

	Ingo
