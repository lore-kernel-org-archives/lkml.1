Return-Path: <linux-kernel-owner+w=401wt.eu-S1756963AbXFOQRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963AbXFOQRs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 12:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753776AbXFOQRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 12:17:41 -0400
Received: from DELFT.AURA.CS.CMU.EDU ([128.2.206.88]:45759 "EHLO
	delft.aura.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbXFOQRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 12:17:39 -0400
Date: Fri, 15 Jun 2007 12:17:12 -0400
To: Bernd Paysan <bernd.paysan@gmx.de>
Cc: Theodore Tso <tytso@mit.edu>, Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sean <seanlkml@sympatico.ca>, Adrian Bunk <bunk@stusta.de>,
       Valdis.Kletnieks@vt.edu, Daniel Hazelton <dhazelton@enter.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070615161712.GA29094@delft.aura.cs.cmu.edu>
Mail-Followup-To: Bernd Paysan <bernd.paysan@gmx.de>,
	Theodore Tso <tytso@mit.edu>, Alexandre Oliva <aoliva@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sean <seanlkml@sympatico.ca>, Adrian Bunk <bunk@stusta.de>,
	Valdis.Kletnieks@vt.edu, Daniel Hazelton <dhazelton@enter.net>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
	debian developer <debiandev@gmail.com>, david@lang.hm,
	Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
References: <alpine.LFD.0.98.0706141026150.14121@woody.linux-foundation.org> <orzm326s3w.fsf@oliva.athome.lsd.ic.unicamp.br> <20070615052432.GC14911@thunk.org> <200706151202.13708.bernd.paysan@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706151202.13708.bernd.paysan@gmx.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Jan Harkes <jaharkes@cs.cmu.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2007 at 12:02:11PM +0200, Bernd Paysan wrote:
> > the GPLv3 license.  That's not their fault, it's the fault of people
> > who wrote the GPLv3 license, promulgated the GPLv3 license, and who is
> > attempting to convince everyone that the GPLv3 license is the only
> > valid license for Right Thinking FSF automatons to use.
> 
> Ah no, it's their fault. The GPLv2 always was clear that there will be some 
> future releases of the GPL, and that you should keep "upgrading" possible.
...
> enough. I try to give up. I suggest everyone who has some assertions about 
> what the GPLv2 does read it through and find the place where it says so. 

Ok, open your local copy of the GPL (you should have a copy in
/usr/share/common-licences/GPL if you use Debian).

Now read along with me...

|                    GNU GENERAL PUBLIC LICENSE
|                       Version 2, June 1991

Ok, we have that settled, this license describes GPL version 2,
specifically, no if's or later's. Bunch of legal mumbo jumbo follows
until we reach...

|                     END OF TERMS AND CONDITIONS

And we've reached the end of the license. Now it it followed up by some
helpful text for the reader...

|            How to Apply These Terms to Your New Programs
...
|  To do so, attach the following notices to the program.  It is safest
| to attach them to the start of each source file to most effectively
| convey the exclusion of warranty; and each file should have at least
| the "copyright" line and a pointer to where the full notice is found.
|
|    <one line to give the program's name and a brief idea of what it does.>
|    Copyright (C) <year>  <name of author>
|
|    This program is free software; you can redistribute it and/or modify
|    it under the terms of the GNU General Public License as published by
|    the Free Software Foundation; either version 2 of the License, or
|    (at your option) any later version.

Look, some example boiler plate that is suggested to be placed in the
source code _to most effectively convey_ that the code is GPL licensed.
So clearly there must be less effective ways, one of which may just be
to include a COPYING or LICENSE file along with the distributed source.

And the author of this example boiler place is clearly 'talking' to the
the copyright owner/licensor (i.e. not the licencee), giving suggestions
about adding contact information and even possible commands that could
be added to interactive programs. So that '(at your option)' may just be
a suggestion to the licensor, or maybe not. But that isn't really here
not there.

Files that don't have such boiler plate do not convey the terms of the
license as effectively, but they are still covered by the license that
was included with the kernel, which is clearly version 2.

Now ofcourse we were looking at the official GPLv2, so I ran a diff
against the COPYING file in the kernel tree. The only differences I can
see are the included clarification by Linus at the top, some formatting
differences and the fact that the FSF version seems to refer to the
'GNU Lesser General Public License', while Linus's version has,
'GNU Library General Public License'.

> Unfortunately, I haven't seen GPL citations from the Linus-fanboy curve, 
> only suggestions that the GPL "does not say something" which it clearly 
> does.

I hope this helps.

Jan
