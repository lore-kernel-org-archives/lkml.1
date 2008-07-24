Return-Path: <linux-kernel-owner+w=401wt.eu-S1754264AbYGXWsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbYGXWsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 18:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbYGXWsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 18:48:04 -0400
Received: from bromo.msbb.uc.edu ([129.137.3.146]:55801 "HELO
	bromo.msbb.uc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751149AbYGXWsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 18:48:03 -0400
Date: Thu, 24 Jul 2008 18:48:01 -0400
From: Jack Howarth <howarth@bromo.msbb.uc.edu>
To: Daniel Barkalow <barkalow@iabervon.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: merging branches remotely with git?
Message-ID: <20080724224801.GA32241@bromo.msbb.uc.edu>
References: <20080724173030.GA7609@bromo.msbb.uc.edu> <alpine.LNX.1.00.0807241453470.19665@iabervon.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.00.0807241453470.19665@iabervon.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel,
   If I execute...

git clone git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/my-wireless-testing.git
cd my-wireless-testing
git pull git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

I get the error...

You asked me to pull without telling me which branch you
want to merge with, and 'branch.master.merge' in
your configuration file does not tell me either.  Please
name which branch you want to merge on the command line and
try again (e.g. 'git pull <repository> <refspec>').
See git-pull(1) for details on the refspec.

If you often merge with the same branch, you may want to
configure the following variables in your configuration
file:

    branch.master.remote = <nickname>
    branch.master.merge = <remote-ref>
    remote.<nickname>.url = <url>
    remote.<nickname>.fetch = <refspec>

See git-config(1) for details.

All I want to do is merge the latest linus-kernel git into the
my-wireless-testing git so that I can have both the ath9k drivers
and the alsa 1.0.17 drivers. What do I need to do to eliminate the
above error? 
             Jack
ps Which git represents the git patches (like 2.6.26-git11) which are
placed as patches on the www.kernel.org web page under the section
The latest snapshot for the stable Linux kernel tree is:.

On Thu, Jul 24, 2008 at 03:09:18PM -0400, Daniel Barkalow wrote:
> On Thu, 24 Jul 2008, Jack Howarth wrote:
> 
> >     I am trying to do a local merge of the linus-kernel git and
> > the my-wireless-testing git. Is this possible? I have cloned both
> > locally with...
> > 
> > git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> > git clone git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/my-wireless-testing.git
> > 
> > I thought from the git documentation that I was supposed to be able to
> > create a merge automatically with...
> > 
> > git merge git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/my-wireless-testing.git
> >
> > however this reports...
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git - not something we can merge
> > 
> > Any advice on how this can be done would be appreciated.
> 
> In the my-wireless-testing directory:
> 
> git pull git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> 
> or:
> 
> git pull ../linux-2.6.git (which gets it from the other clone you made).
> 
> "git merge" is for merging branches you have (copies of) in the same 
> repository. There's also "git fetch" for getting local copies of branches 
> (and tags) elsewhere, and "git pull" does a "fetch" and a "merge", with 
> the ability to put the information only in a temporary location in 
> between.
> 
> What part of the documentation confused you? It probably needs to be 
> clarified.
> 
> 	-Daniel
> *This .sig left intentionally blank*
