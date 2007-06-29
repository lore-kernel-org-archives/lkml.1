Return-Path: <linux-kernel-owner+w=401wt.eu-S1756095AbXF2Iad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095AbXF2Iad (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 04:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754434AbXF2IaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 04:30:24 -0400
Received: from mail.gmx.net ([213.165.64.20]:58853 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754325AbXF2IaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 04:30:22 -0400
Cc: rob@landley.net, linux-kernel@vger.kernel.org, patrakov@ums.usu.ru
Content-Type: text/plain; charset="us-ascii"
Date: Fri, 29 Jun 2007 10:30:21 +0200
From: "Michael Kerrisk" <mtk-manpages@gmx.net>
In-Reply-To: <46843B9B.2080700@tmr.com>
Message-ID: <20070629083021.58530@gmx.net>
MIME-Version: 1.0
References: <467F8FCF.4080009@gmx.net> <4683BC76.8070805@ums.usu.ru>
 <20070628161720.298550@gmx.net> <46843B9B.2080700@tmr.com>
Subject: Re: man-pages-2.59 and man-pages-2.60 are released
To: Bill Davidsen <davidsen@tmr.com>
X-Authenticated: #24879014
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX19UJ4B2YGdUx4gWOvCHYsJWv++2XoJlOZY/cMyNYh
 IVgC3Iex9NLkM9Fhl/PRNMryjqZknOgy1thQ== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: VYXiLLVgaHItVNzNXSQlXXBiamdhZASL
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill,
 
> >> There is one little problem with this: there is no stable URL for a
> >> given version. 
> > 
> > Well, there never really was.  To date, most old tarballs have
> > had only a limited life on kernel.org.
> > 
> Why? I'm not questioning the policy, it's just that if HUGE kernel 
> versions are kept available forever, a tiny man page tar would not seem 
> to be a disk space issue.

It's not a space issue -- it's just a question of
clutter.  Even though I've been the maintainer for coming up
for 2.5 years now, Andries was still doing the uploads onto
kernel.org until about a year or so ago.  I think Andries used
to clear down old versions periodically just so it was easier to
see which version was the latest.  Since I started doing
the uploads, I hadn't cleared away any old versions, but 
yesterday I noticed that the list of files in the directory
is getting long, so that it's hard to see what version is latest.
So I created the directory "old" and moved all the old stuff in 
there.  Alexander notes that this causes some problem for the LFS
folk, since their scripts expect the tarballs to be in stable
locations for longer periods.  (I was of course unaware of this.)

> >> This hurts, e.g., automated Linux From Scratch rebuilds (the 
> >> official script grabs the URL from the book, but it becomes 
> >> invalid too soon).
[...]
> > How about a link in /pub/linux/docs/manpages/ of the form 
> > "LATEST-IS-m.xy"?  Rob Landley was wanting something like this,
> > and I guess it would be easy for LFS to build a simple
> > script that looks for that link and deduces "man-pages-m.xy" 
> > from it.  (I've just now created such a link in the directory,
> > as an example.)
> > 
> Why not just a link with a fixed name (LATEST?) which could be updated? 
> I assume installing a new version is automated 

There is no automation on my part.  Each time I do a release, I
use scp to upload the .tar.gz and .lsm files, and some kernel.org 
scripts automagically create the .bz2 and .sign files.

To maintain any sort of link will either require me to
write some script, or manually create the links.

> to create and install the 
> tar, any needed links, the push to mirrors, etc. So it would just be a 
> single step added to an automated procedure. 

Yes, I'll write a script to create suitable links.

> You could have a link in 
> "Old" as requested, and any other links as well.

Well, I think all that LFS seems to want is links that are
stable "for a while" (since I don't suppose that they want
to use really old tarballs in any case). So, for 
the benefit of LFS, I'll just be less aggressive about
moving tarballs into "Old" (I'll leave them sitting in http://www.kernel.org/pub/linux/docs/manpages/
for a few months at least.)

Cheers,

Michael
-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7 

Want to help with man page maintenance?  
Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages , 
read the HOWTOHELP file and grep the source 
files for 'FIXME'.

