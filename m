Return-Path: <linux-kernel-owner+w=401wt.eu-S1752041AbZJWV75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbZJWV75 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 17:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbZJWV74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 17:59:56 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:34916 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbZJWV74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 17:59:56 -0400
Date: Fri, 23 Oct 2009 23:59:58 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Nicolas Pitre <nico@fluxnic.net>, "Luck, Tony" <tony.luck@intel.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Robert Richter <robert.richter@amd.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jean Delvare <khali@linux-fr.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] to rebase or not to rebase on linux-next
Message-ID: <20091023215958.GA4139@merkur.ravnborg.org>
References: <20091022122042.e535d43c.sfr@canb.auug.org.au> <20091023112732.GB5886@elte.hu> <4AE19A74.1090709@garzik.org> <20091023123555.GA25366@elte.hu> <57C9024A16AD2D4C97DC78E552063EA3E33D0174@orsmsx505.amr.corp.intel.com> <20091023134115.GD27097@elte.hu> <alpine.LFD.2.00.0910231424440.21460@xanadu.home> <20091023191631.GA1879@elte.hu> <1256326512.26028.34.camel@gandalf.stny.rr.com> <20091023205400.GA8356@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091023205400.GA8356@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 23, 2009 at 10:54:00PM +0200, Ingo Molnar wrote:
> 
> Maintainer trees pushed towards linux-next should strive to be Git 
> based, append-mostly, 'nice', 'intended for upstream' and defendable 
> as-is IMO, and rebasing a _maintainer tree_ should really be a rare act 
> of last resort.

As maintainer I try to put some effort in crediting people
where credit belongs.
In other words collecting "Acked-by:", "Tested-by", "Reviewed-by".

Adding this require a rebase as soon as said patch hits git.

One could use topic brances and I do not know what.
But frankly - working with this on and off and
in limited spare time makes it sometimes hard enough
to do the basic steps correct.
Trying to fool around with several topics branches and
such does simply not fit.

I try to say with the above that rebasing is sometimes 
a way to get the job done without making things too complicated.

And -next has btw caught a lot of integration issues
for kbuild in the past.
Both for varoious architectures but sometimes also
other ways to do the same thing.
And sometimes I'm in the situation that I have to decide:

1) wait another 10 days before I have ~1 hour that I can
dedicate to test stuff
2) do some rudimentary testing and drop in in -next.

It depends but sometimes I go for option 2) knowing
that it is risky.

	Sam
