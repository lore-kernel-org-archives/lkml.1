Return-Path: <linux-kernel-owner+w=401wt.eu-S932850AbXF2Mbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932850AbXF2Mbq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 08:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763599AbXF2MaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 08:30:09 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1576 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757658AbXF2MaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 08:30:04 -0400
Date: Thu, 28 Jun 2007 21:15:22 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Arjan van de Ven <arjan@infradead.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Zolt?n HUBERT <zoltan.hubert@zzaero.com>, linux-kernel@vger.kernel.org,
       seife@suse.de
Subject: Re: Please release a stable kernel Linux 3.0
Message-ID: <20070628211522.GI5339@ucw.cz>
References: <200706212349.54983.zoltan.hubert@zzaero.com> <200706221700.08135.rjw@sisk.pl> <467C02AA.2080105@redhat.com> <200706242254.59695.rjw@sisk.pl> <200706212349.54983.zoltan.hubert@zzaero.com> <9a8748490706211529yca0588dgd1f7e0b86f7e4a62@mail.gmail.com> <467AFCEC.2070203@redhat.com> <20070621230126.GF10008@csclub.uwaterloo.ca> <467B04EB.2010105@redhat.com> <1182469541.2704.13.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706242254.59695.rjw@sisk.pl> <1182469541.2704.13.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > >> Even the good ones that get lots of fixes aren't all that good. The
> > >> biggest problem ATM is that suspend is badly broken and keeps getting
> > >> worse...
> > > 
> > > I wasn't under the impression suspend had really ever worked.  Such a
> > > messy problem to solve.
> > > 
> > 
> > It never worked reliably for everyone, but with each new release it
> > seems to get worse.
> 
> the thing is just fundamentally not designed right. Declaring it stable
> ain't gonna fix that. Having someone do a right design (which will
> obviously will go through some breakage period, even if it's an
> evolution of the current design) is a required step of getting s/r more
> reliable... but the current one doesn't get stable just by declaring it
> so.

Ok, I guess one more pair of eyes would help.


> > >> Even the good ones that get lots of fixes aren't all that good. The
> > >> biggest problem ATM is that suspend is badly broken and keeps getting
> > >> worse...
> > > 
> > > Can you please provide me with any links to suspend-related bug reports from
> > > you?
> > 
> > I get so many suspend/resume bug reports that I've given up trying
> > to get them fixed. And there are so many bugs that are even worse,
> > like crashes during normal use, data corruption, etc. that suspend
> > bugs don't get much attention. But here are the ones for Fedora 6;
> > the list would be much longer if I included Fedora 5 and 7:

(list of 20 bugs in redhat bugzilla).

...well, it looks a bit better from my side. Number of suspend bugs in
suse bugzilla is certainly lower, and I guess it works a bit better,
too. (But we do not claim s2ram support for machines outside of s2ram
whitelist).

Now, perhaps redhat should get someone to work on suspend/hibernation
support (kernel level)? IIRC you had Nigel at one point, but he was
working on something else?

Rafael and me am trying to look after hibernation, but I believe noone
is really working on suspend :-(.
						Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
