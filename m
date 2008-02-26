Return-Path: <linux-kernel-owner+w=401wt.eu-S1761467AbYBZOiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761467AbYBZOiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 09:38:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbYBZOiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 09:38:16 -0500
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:51754 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751952AbYBZOiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 09:38:15 -0500
Date: Tue, 26 Feb 2008 14:37:45 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Michael Buesch <mb@bu3sch.de>,
       Gordon Farquharson <gordonfarquharson@gmail.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       linville@tuxdriver.com, stefano.brivio@polimi.it,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       viro@ftp.linux.org.uk
Subject: Re: [RFC] [PATCH] Fix b43 driver build for arm
Message-ID: <20080226143744.GA24332@fluff.org.uk>
References: <97a0a9ac0802181403ja79c32v864b093414b2755@mail.gmail.com> <200802191141.26952.mb@bu3sch.de> <97a0a9ac0802191644x693cd34cq6b167756df9c65f4@mail.gmail.com> <200802201544.05192.mb@bu3sch.de> <20080220193709.GD21139@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080220193709.GD21139@uranus.ravnborg.org>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 08:37:09PM +0100, Sam Ravnborg wrote:
> On Wed, Feb 20, 2008 at 03:44:04PM +0100, Michael Buesch wrote:
> > On Wednesday 20 February 2008 01:44:38 Gordon Farquharson wrote:
> > > Hi Michael
> > > 
> > > On Feb 19, 2008 3:41 AM, Michael Buesch <mb@bu3sch.de> wrote:
> > > 
> > > > > [2] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=7492d4a416d68ab4bd254b36ffcc4e0138daa8ff
> > > > >
> > > >
> > > > That doesn't cause me to magically sign off this sort of patches, too.
> > > > The sanity check is clearly broken in file2alias.c, as it checks something
> > > > from the target kernel against the host environment it is compiled on.
> > > > That doesn't make any sense at all.
> > > 
> > > I think that you make some good points, but I'm at a loss as to how to
> > > fix the problem. Do you have any suggestions?
> > 
> > Remove the broken sanity check, if it's not possible the check there.
> The check is valid for > 99% of the kernel builds as
> cross compile builds are not that typical.
> And the check is there for the sake of modutils.

I build all of my ARM kernels on an x86 box, it is much faster
and I don't have to ensure I have a read/write capable filesystem
for any of my ARM boards.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
