Return-Path: <linux-kernel-owner+w=401wt.eu-S1756428AbZKBSSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428AbZKBSSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 13:18:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756132AbZKBSSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 13:18:41 -0500
Received: from icculus.org ([67.106.77.212]:58740 "EHLO icculus.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756029AbZKBSSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 13:18:40 -0500
Date: Mon, 2 Nov 2009 13:18:41 -0500 (EST)
From: "Ryan C. Gordon" <icculus@icculus.org>
X-X-Sender: icculus@caridad.icculuslan
To: Julien BLACHE <jb@jblache.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: FatELF patches...
In-Reply-To: <87zl75h2mh.fsf@sonic.technologeek.org>
Message-ID: <alpine.OSX.1.10.0911021258270.464@caridad.icculuslan>
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan> <1257103201.2865.6.camel@chumley> <yw1xy6mq0z2s.fsf@unicorn.mansr.com> <alpine.OSX.1.10.0911011540400.53392@caridad.local> <20091102000147.424f104b@lxorguk.ukuu.org.uk>
 <alpine.OSX.1.10.0911012023020.55434@caridad.local> <87zl75h2mh.fsf@sonic.technologeek.org>
User-Agent: Alpine 1.10 (OSX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> With my Debian Developer hat on...

I'm repeating myself now, so I'm sorry if this is getting tedious for 
anyone. FatELF isn't meant to replace the package managers.

tl;dr: If all you have is an apt-get hammer, everything looks like a .deb nail.

> That usually ships as sources or prebuilt binaries in a tarball - target
> /opt and voila! For a bigger audience you'll see a lot of experimental
> stuff that gets packaged (even in quick'n'dirty mode).

"A lot" is hard to quantify. We can certainly see thousands of forum posts 
for help with software that hadn't been packaged yet.

> > software that isn't appropriate for an apt/yum repository
> 
> Just create a repository for the damn thing if you want to distribute it
> that way. There's no "appropriate / not appropriate" that applies here.

I can't imagine most people are interested in building repositories and 
telling their users how to add it to their package manager, period, but 
even less so when you have to build different repositories for different 
sets of users, and not know what to build for whatever is the next popular 
distribution. For things like Gentoo, which for years didn't have a way to 
extend portage, what was the solution?

(har har, don't run Gentoo is the solution, let's get the joke out of our 
systems here.)

> > software that distros refuse to package but is still perfectly useful
> 
> Look at what happens today. A lot of that gets packaged by third
> parties, and more often than not they involve distribution
> maintainers. (See debian-multimedia, PLF for Mandriva, ...)

I'm hearing a lot of "a lot" ... what actually happens today is that you 
depend on the kindness of strangers to package your software or you make a 
bunch of incompatible packages for different distributions.

> > closed-source software
> 
> Why do we even care?

Maybe you don't care, but that doesn't mean no one cares.

I am on Team Stallman. I'll take a crappy free software solution over a 
high quality closed-source one, and strive to improve the free software 
one until it is indisputably better. Most of my free time goes towards 
this very endeavor.

But still, let's not be jerks about it.

> Tarball,

Ugh.

> /opt,

Ugh.

> static build.

Ugh!

I think we can do better than that when we're outside of the package 
managers, but it's a rant for another time.

> And, about the /lib, /lib32, /lib64 situation Debian and Debian-derived
> systems, the solution to that is multiarch and it's being worked
> on. It's a lot better and cleaner than the fat binary kludge.

Having read the multiarch wiki briefly, I'm pleased to see other people 
find the current system "unwieldy," but it seems like FatELF "kludge" 
solves several of the points in the "unresolved issues" section.

YMMV, I guess.

--ryan.

