Return-Path: <linux-kernel-owner+w=401wt.eu-S1754744AbYLSADm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbYLSADm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 19:03:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752762AbYLSACZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 19:02:25 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:46447 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371AbYLSACV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 19:02:21 -0500
Date: Thu, 18 Dec 2008 16:02:18 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Johannes Schindelin <Johannes.Schindelin@gmx.de>
Cc: David Howells <dhowells@redhat.com>, torvalds@osdl.org,
       git@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Simplified GIT usage guide
Message-ID: <20081219000218.GA23990@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20081212182827.28408.40963.stgit@warthog.procyon.org.uk> <alpine.DEB.1.00.0812121952320.5873@eeepc-johanness>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0812121952320.5873@eeepc-johanness>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2008 at 07:57:38PM +0100, Johannes Schindelin wrote:
> Hi,
> 
> On Fri, 12 Dec 2008, David Howells wrote:
> 
> >  Documentation/git-haters-guide.txt | 1283 ++++++++++++++++++++++++++++++++++++
> 
> I am sure we want to have something like that in git.git.

So am I.  Except that I am not being sarcastic.  ;-)

> > +I don't really know what I'm doing with GIT either.
> 
> Strike the "either".

Not in my case.  And I am far from alone.

Let's face it, if you really do know what you are doing with GIT, you
probably are not a GIT-hater, and thus not in the target audience for
Dave's document.

> > +===============
> > +OVERVIEW OF GIT
> > +===============
> 
> Your overview seems to be what "Git from the bottom up" is all about (see 
> the Git Wiki for more information where to find it).
> 
> From my experience with new users, this is exactly the wrong way to go 
> about it.  You don't introduce object types of the Git database before 
> telling the users what the heck they are good for.  And most users do not 
> need to bother with tree objects either, anyway.  So maybe you just tell 
> them what the heck the object types are good for, without even teaching 
> them the object types at all.
> 
> So I think that your document might do a good job scaring people away from 
> Git.  But I do not believe that your document, especially in the tone it 
> is written, does a good job of helping Git newbies.
> 
> Ciao,
> Dscho
> 
> P.S.: No, I haven't read the whole document.  Still, I think I am 
> qualified enough to estimate what the average reader's first impression 
> would be.

Not sure I agree.  You might well know too much about git to understand
what it looks like to a new user, particularly a new user with a
couple decades experience with earlier source-code control system.
(RCS, anyone?)

In particular, David's guide was quite helpful to me.  It would have been
even more helpful had it existed when I first tried (unsuccessfully)
to use GIT.  In particular, GIT's requirement that I tell it about new
versions of existing files (either with "git add" or "git commit -a")
was extremely counter-intuitive, and caused me no end of pain.

There might well be a need for different approaches for different types
of newbies.  Guys like myself who have used source-code control tools
of one type or another for a couple decades can -definitely- benefit
from Dave's approach.  In particular, Dave's broad-brush description of
GIT's internals is enough to explain why the heck I should have to tell
GIT about a new version of a file THAT IT ALREADY KNOWS ABOUT!!!
"Why should I need to add a file that is already there???"

Don't get me wrong -- as I have gained experience with GIT over the past
six months or so, I have found a number of situations where GIT's
insisting that I tell it about new versions of existing files has been
helpful, for example, when I suddenly realize that a given change should
be applied in multiple commits, with different groups of files in each
commit.  In that case, doing a series of "git add" and "git commit"
commands works very nicely.

So I am -not- suggesting changing git.  Once you get used to it, it
works out well.  I suppose that you could have a "git new-version"
command as a synonym for "git add", but I doubt that it is worth it.

But the "git add" issue turned me away from git several times in the past
three years.  And for quite some time, I used git in read-only mode,
because very strange things happened (from my viewpoint) whenever I
tried changing anything.

After using GIT reasonably heavily for the past six months, I am actually
learning to like it, and have even starting using it for my own projects.
But my experience is that git is at best an acquired taste for those of
us who grew up with traditional source-code control systems.  Such
people will benefit greatly from a git-haters guide, and git's user
population will grow as a result.

							Thanx, Paul
