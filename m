Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbZKBCWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbZKBCWY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 21:22:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbZKBCWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 21:22:23 -0500
Received: from icculus.org ([67.106.77.212]:41759 "EHLO icculus.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065AbZKBCWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 21:22:23 -0500
Date: Sun, 1 Nov 2009 21:21:47 -0500 (EST)
From: "Ryan C. Gordon" <icculus@icculus.org>
X-X-Sender: icculus@caridad.local
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: =?ISO-8859-15?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
       linux-kernel@vger.kernel.org
Subject: Re: FatELF patches...
In-Reply-To: <20091102000147.424f104b@lxorguk.ukuu.org.uk>
Message-ID: <alpine.OSX.1.10.0911012023020.55434@caridad.local>
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan> <1257103201.2865.6.camel@chumley> <yw1xy6mq0z2s.fsf@unicorn.mansr.com> <alpine.OSX.1.10.0911011540400.53392@caridad.local> <20091102000147.424f104b@lxorguk.ukuu.org.uk>
User-Agent: Alpine 1.10 (OSX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> So why exactly do we want FatELF. It was obsoleted in the early 1990s
> when architecture handling was introduced into package managers.

I'm not minimizing your other points by trimming down to one quote. Some 
of it I already covered, but mostly I suspect I'm talking way too much, so 
I'll spare everyone a little. I'm happy to address your other points if 
you like, though, even the one where you said I was being desperate.  :)

Most of your points are "package managers solve this problem" but they 
simply do not solve all of them.

Package managers are a _fantastic_ invention. They are a killer feature 
over other operating systems, including ones people pay way too much money 
to use. That being said, there are lots of places where using a package 
manager doesn't make sense: experimental software that might have an 
audience but isn't ready for wide adoption, software that isn't 
appropriate for an apt/yum repository, software that distros refuse to 
package but is still perfectly useful, closed-source software, and 
software that wants to work between distros that don't have 
otherwise-compatible rpm/debs (or perhaps no package manager at all).

I'm certain I'm about to get a flood of replies that say "you can make a 
cross-distro-compatible RPM if you just follow these steps" but that 
completely misses the point. Not all software comes from yum, or even from 
an .rpm, even if most of it _should_. This isn't about replacing or 
competing with apt-get or yum.

I'm certain if we made a Venn diagram, there would be an overlap. But 
FatELF solves different problems than package managers, and in the case of 
ia32 compatibility packages, it helps the package manager solve its 
problems better.

--ryan.

