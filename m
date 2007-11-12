Return-Path: <linux-kernel-owner+w=401wt.eu-S1757568AbXKLXk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568AbXKLXk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 18:40:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbXKLXkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 18:40:14 -0500
Received: from enyo.dsw2k3.info ([195.71.86.239]:34696 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbXKLXkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 18:40:12 -0500
Date: Tue, 13 Nov 2007 00:39:55 +0100
From: Matthias Schniedermeyer <ms@citd.de>
To: Tuomo Valkonen <tuomov@iki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [poll] Is the megafreeze development model broken?
Message-ID: <20071112233955.GA25059@citd.de>
References: <fgtfqa$h9j$1@ger.gmane.org> <m1sl3b4t5k.fsf@ebiederm.dsl.xmission.com> <slrnfjgmit.l07.tuomov@jolt.modeemi.cs.tut.fi> <20071112152057.GJ9771@stusta.de> <47387BB5.4090908@smsglobal.net> <20071112171456.GN9771@stusta.de> <slrnfjh2nn.aam.tuomov@jolt.modeemi.cs.tut.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <slrnfjh2nn.aam.tuomov@jolt.modeemi.cs.tut.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.11.2007 17:18, Tuomo Valkonen wrote:
> On 2007-11-12, Adrian Bunk <bunk@kernel.org> wrote:
> > Geeks like you and me want the latest software
> > (I'm using Debian unstable/testing).
> >
> > But most users want a Linux installation that simply works - and this 
> > includes all software on the system at all times.
> 
> I'm not in either category. I want a truly stable (as in "quality", not
> as in "static" as the distros use the term) base system that simply 
> works, but I want to follow certain interesting software more closely.

That's the problem(tm).

Contrary to Closed Source Software all(!) OSS-Software is 
interdependent. There is no "Stand-Alone"-Software. There is always at 
least "libc". (Scripts depend on a script-interpreter, which in turn 
depends at least on libc, so there is nothing(tm) that doesn't depend on 
libc)

Where is not uncommon for Closed Source Software to not have external 
dependencies or to bring along it's dependent librarys.

e.g. (On Debian sid, *)
"kdebase" has a nice little total dependency-list of only 254 packages.
or
"openoffice.org" just 265 dependent packages.

"gimp" comes with light backage, only 146 packages.

Not to speak about such nice little (meta-)packages like "kde" or
"gnome" that are 649 and 684 packages.

All that interdependency form a nice little (:-) web.
(Sometimes called the dependency hell)

What i want to say is this: You can't say that you only want to update a
specific region of your web, at least not without the risk of ripping
your web here and there.

I'm using Linux since 1995, i can life with it's problems and i like 
Linux more that ever. :-)

And despite me always using the latest kernel and Debian SID/unstable 
for the past few years, for home & work, i have neven been badly burned. 
Not that there weren't a few bruises here and there. There is nothing 
like a fried X for breakfast. (Which Debian managed at least 2 or 3 
times in the past years)
;-)



*:
apt-rdepends <(meta)packagename> | grep "  Depends" | cut -d '(' -f0,1 | perl -pe 's/ +$//' | sort | uniq | wc -l
e.g.
apt-rdepends kde | grep "  Depends" | cut -d '(' -f0,1 | sort | perl -pe 's/ +$//' | uniq | wc -l

Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

