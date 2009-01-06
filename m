Return-Path: <linux-kernel-owner+w=401wt.eu-S1754401AbZAFRqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401AbZAFRqy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 12:46:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbZAFRqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 12:46:46 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:32974 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbZAFRqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 12:46:45 -0500
Date: Tue, 6 Jan 2009 18:48:25 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Theodore Tso <tytso@mit.edu>, Jan Beulich <jbeulich@novell.com>,
       ccache@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] Recent change to kernel spikes out ccache/distcc
Message-ID: <20090106174825.GA16365@uranus.ravnborg.org>
References: <E1LKDeQ-0002xz-7E@closure.thunk.org> <496386EF.76E4.0078.0@novell.com> <20090106173300.GA10903@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106173300.GA10903@mit.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 12:33:00PM -0500, Theodore Tso wrote:
> On Tue, Jan 06, 2009 at 03:29:35PM +0000, Jan Beulich wrote:
> > >>> "Theodore Ts'o" <tytso@mit.edu> 06.01.09 16:15 >>>
> > >In the short term, though, it would be nice if we could get back a
> > >simple way of making a kernel  object file using just cc, so that ccache
> > >and distcc could be functional again.   Does that seem reasonable?
> > 
> > Making the new logic dependent on a config option would seem reasonable
> > to me - of course at the expense of the respective Makefile becoming
> > even less readable.
> 
> Too late.  :-) It's pretty unreadable already.... 

I'm all ears for inputs how to make them even a little more readable.
We actually used several iteratiosn of Jan's patch just to improve
readability in areas the patch touched.

I think at least half of the unreadability comes from the fact that
people do not realise the steps needed to actually build the kernel.

It is a little bit more involved than doing a simple sequence
of gcc; ld.

We have btw. 1140 Makefiles in the kernel of a total of 28000 lines.

Yes - exactly 28000 lines as reported by:
find -name 'Makefile*' | xargs cat | wc -l

But numbers aside - any inputs appreciated.

	Sam
