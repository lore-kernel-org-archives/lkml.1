Return-Path: <linux-kernel-owner+w=401wt.eu-S1756850AbXFVOGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbXFVOGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 10:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756319AbXFVOGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 10:06:00 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:60273 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908AbXFVOF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 10:05:57 -0400
Date: Fri, 22 Jun 2007 10:02:40 -0400
From: Chris Mason <chris.mason@oracle.com>
To: James Morris <jmorris@namei.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Lars Marowsky-Bree <lmb@suse.de>,
       Pavel Machek <pavel@ucw.cz>, Crispin Cowan <crispin@novell.com>,
       Greg KH <greg@kroah.com>, Andreas Gruenbacher <agruen@suse.de>,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Message-ID: <20070622140240.GM6222@think.oraclecorp.com>
References: <20070621160840.GA20105@marowsky-bree.de> <20070621183311.GC18990@elf.ucw.cz> <20070621192407.GF20105@marowsky-bree.de> <Line.LNX.4.64.0706211530290.483@localhost.localdomain> <20070621195400.GK20105@marowsky-bree.de> <1182459594.20464.16.camel@moss-spartans.epoch.ncsc.mil> <20070622003436.GB6222@think.oraclecorp.com> <Line.LNX.4.64.0706212044590.2100@localhost.localdomain> <20070622121742.GC6222@think.oraclecorp.com> <Line.LNX.4.64.0706220858170.5751@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Line.LNX.4.64.0706220858170.5751@localhost.localdomain>
User-Agent: Mutt/1.5.12-2006-07-14
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2007 at 09:48:12AM -0400, James Morris wrote:
> On Fri, 22 Jun 2007, Chris Mason wrote:
> 
> > > The validity or otherwise of pathname access control is not being 
> > > discussed here.
> > > 
> > > The point is that the pathname model does not generalize, and that 
> > > AppArmor's inability to provide adequate coverage of the system is a 
> > > design issue arising from this.
> > 
> > I'm sorry, but I don't see where in the paragraphs above you aren't
> > making a general argument against the pathname model.
> 
> There are two distinct concepts here.
> 
> A. Pathname labeling - applying access control to pathnames to objects, 
> rather than labeling the objects themselves.
> 
> Think of this as, say, securing your house by putting a gate in the street 
> in front of the house, regardless of how many other possible paths there 
> are to the house via other streets, adjoining properties etc.
> 
> Pathname labeling and mediation is simply mediating a well-known path to 
> the object.  In this analogy, object labeling would instead ensure that 
> all of the accessible doors, windows and other entrances of the house were 
> locked, so that someone trying to break in from the rear alley would 
> not get in simply by bypassing the front gate and opening any door.
> 
> What you do with AppArmor, instead of addressing the problem, is just 
> redefine the environment along the lines of "set your house into a rock 
> wall so there is only one path to it".
> 
> 
> B. Pathname access control as a general abstraction for OS security.
> 
> Which is what was being discussed above, in response to a question from 
> Lars about technical issues, and that this _model_ doesn't generalize to 
> the rest of the OS, regardless of whether you think the mechanism of 
> pathname labeling itself is appropriate or not.

I'm sorry, but I don't see where in the paragraphs above you aren't
making a general argument against the pathname model.  I'm not trying to
get into that discussion (I'm smart enough to know I'm far too stupid to
hold my own there).

I do understand that AA is different from selinux, and that you
have valid points about the level and type of protection that AA offers.

But, this is a completely different discussion than if AA is
solving problems in the wild for its intended audience, or if the code
is somehow flawed and breaking other parts of the kernel.

We've been over the "AA is different" discussion in threads about a
billion times, and at the last kernel summit.  I think Lars and others
have done a pretty good job of describing the problems they are trying
to solve, can we please move on to discussing technical issues around
that?

-chris



