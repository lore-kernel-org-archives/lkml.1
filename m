Return-Path: <linux-kernel-owner+w=401wt.eu-S1758249AbYGPBI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249AbYGPBI5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 21:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755156AbYGPBIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 21:08:47 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:38056 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753085AbYGPBIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 21:08:46 -0400
Date: Tue, 15 Jul 2008 21:08:36 -0400
From: Theodore Tso <tytso@mit.edu>
To: Tiago Assumpcao <tiago@assumpcao.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, pageexec@freemail.hu,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] Linux 2.6.25.10
Message-ID: <20080716010836.GL8185@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Tiago Assumpcao <tiago@assumpcao.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	pageexec@freemail.hu, Greg KH <greg@kroah.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, stable@kernel.org
References: <alpine.LFD.1.10.0807151425170.2867@woody.linux-foundation.org> <487D3C17.31467.1C3C0441@pageexec.freemail.hu> <alpine.LFD.1.10.0807151620450.2867@woody.linux-foundation.org> <487D3A13.3040507@assumpcao.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487D3A13.3040507@assumpcao.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 09:00:19PM -0300, Tiago Assumpcao wrote:
> For all the above: no. And this is the point of divergence.
> For you, as a person who "writes software", every bug is equivalent. You  
> need to resolve problems, not classify them.
>
> However, as I previously explained [http://lkml.org/lkml/2008/7/15/654],  
> security issues are identified and communicated through what can be a  
> long and complicated (due to DNAs, etc.) process. If it culminates at  
> implementation, without proper information forwarding from the  
> development team, it will never reach the "upper layers" -- vendors,  
> distributors, end users, et al.

Look if you want this, pay $$$ to a distribution and get their
supported distribution.  It costs time and effort to classify bugs as
security related (or not), and the people who care about this the most
also want to freeze a kernel version to simplify their application
testing, *but* get new drivers and bus support code back-ported so
they can use the latest hardware (while still keeping their
applications and 3rd party proprietary kernel modules from Nvidia and
Vertias stable and working) *and* they want the latest security fixes
(and only security fixes, since other fixes might destablize their
application).  People who want this can get it, today.  Just pick up
the phone and give a call to your favoriate enterprise Linux
distribution.  It will cost you money, but hey, the people who want
this sort of thing typically are willing to pay for the service.

I'll note that trying to classify bugs as being "security-related" at
the kernel.org level often doesn't help the distro's, since many of
these bugs won't even apply to whatever version of the kernel the
distro's snapshotted 9-18 months ago.  So if the distro snapshotted
2.6.18 in Fall 2006, and their next snapshot will be sometime two
years later in the fall of this year, they will have no use for some
potential local denial of service attack that was introduced by
accident in 2.6.24-rc3, and fixed in 2.6.25-rc1.  It just doesn't
matter to them.

So basically, if there are enough kernel.org users who care, they can
pay someone to classify and issue CVE numbers for each and every
potential "security bug" that might appear and then disappear.  Or
they can volunteer and do it themselves.  Of course, this will provide
aid and comfort to Microsoft-shills masquerading as analysts who
misuse CVE numbers to generate reports "proving" that Microsoft is
more secure (because they don't do their development in the open, so
issues that appear and disappear in development snapshots don't get
CVE numbers assigned), but hopefully most users are sophsitcated
enough not to get taken in by that kind of bogus study.  :-)

The one thing which is really pointless to do is to ask kernel
developers to do all of this classification work to get CVE numbers,
etc., for free.  In free software, people do what they (or their
company) deem to be valuable for them.  Flaming and complaining that
the kernel git logs aren't providing free marketing for PaX/grsecurity
isn't going to do much good.

      	    					- Ted
