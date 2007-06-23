Return-Path: <linux-kernel-owner+w=401wt.eu-S1756100AbXFWKvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100AbXFWKvm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 06:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753709AbXFWKvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 06:51:35 -0400
Received: from 1wt.eu ([62.212.114.60]:3108 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626AbXFWKve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 06:51:34 -0400
Date: Sat, 23 Jun 2007 12:50:57 +0200
From: Willy Tarreau <w@1wt.eu>
To: Alberto Gonzalez <info@gnebu.es>
Cc: Paolo Ornati <ornati@fastwebnet.it>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Question about fair schedulers
Message-ID: <20070623105057.GD7070@1wt.eu>
References: <200706230007.15622.info@gnebu.es> <200706231118.43408.info@gnebu.es> <20070623103012.GC7070@1wt.eu> <200706231245.30317.info@gnebu.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706231245.30317.info@gnebu.es>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2007 at 12:45:30PM +0200, Alberto Gonzalez wrote:
> On Saturday 23 June 2007, Willy Tarreau wrote:
> 
> > > But the bottom line is that on a desktop, tasks should receive
> > > different -unfair- amounts of CPU time to work correctly. The "fair"
> > > concept still looks wrong to me.
> >
> > "fair" means what it means : stop starving some tasks for no apparent
> > reasons. If one task adjusts its priority, it can get more CPU than others,
> > but the distribution will still be fair according to the priorities.
> 
> Ok, this was the kind of technical explanation I was looking for, thanks.
> 
> > > Nicing tasks might not be hard at all, but expecting normal users to do
> > > so is not realistic. Either the scheduler or the applications should make
> > > these decisions for them (us).
> >
> > No, I cannot agree with you. The users have to solutions to start their
> > player: - typing "mplayer xxx.mpeg" on the command line ; then they can
> > prepend "nice" in front of it
> >
> >   - clicking on an icon in their windows-like window managers, which makes
> >     executes the command for them.
> >
> > If they decide to use the second solution, it means that the default
> > settings assigned to the icon should fit the application (that applies to
> > the nice value too). And if their distro ships with those pre-defined icons
> > with stupid priorities, they should complain to the distro vendor or switch
> > to another one. And if the window manager by itself does not make it easy
> > to adjust priorities when starting processes, it's poorly designed because
> > it is it and only it which forces the user to open a command line and
> > manually set "nice".
> >
> > So there are plenty of really transparent solutions for the user, but maybe
> > there are a lot of wrong tools and configurations...
> 
> Ok, so if I understand correctly, the problem I had in my simple test will be 
> solved by distributions once a fair scheduler goes into mainline?

No, there is no reason to wait for a fair scheduler at all. A *desktop* distro
*must* take process priorities into account, otherwise it's broken by design.
If you don't know where in your distro you can say "more CPU for the video"
and "less CPU for the encoder", then ask your vendor. It's something so much
basic and obvious that I cannot imagine not being supported. Even my mp3 player
script has been setting its prio for the last 8 years in order to avoid skips!

> This is 
> fine then. As long as someone (but not end users) takes care of giving the 
> right priority to tasks of different nature it should work fine.

Yes, it should.

Regards,
Willy

