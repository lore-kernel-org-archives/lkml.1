Return-Path: <linux-kernel-owner+w=401wt.eu-S1765964AbYBVTVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765964AbYBVTVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 14:21:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761813AbYBVTVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 14:21:16 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2975 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759027AbYBVTVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 14:21:15 -0500
Date: Fri, 22 Feb 2008 19:40:37 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Adrian Bunk <bunk@kernel.org>, Roland Dreier <rdreier@cisco.com>,
       Linus Torvalds <torvalds@osdl.org>,
       Glenn Streiff <gstreiff@NetEffect.com>,
       Faisal Latif <flatif@NetEffect.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: Merging of completely unreviewed drivers
Message-ID: <20080222184036.GA6060@ucw.cz>
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFF1@venom2> <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2> <20080221154951.GA28328@cs181133002.pp.htv.fi> <adahcg2awag.fsf@cisco.com> <20080221210124.GD28328@cs181133002.pp.htv.fi> <20080221140855.6aea8cc1@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080221140855.6aea8cc1@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-02-21 14:08:55, Arjan van de Ven wrote:
> On Thu, 21 Feb 2008 23:01:24 +0200
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > [ Linus Added to the To: since I want to hear his opinion on this
> > issue. ]
> > 
> > On Thu, Feb 21, 2008 at 12:28:55PM -0800, Roland Dreier wrote:
> > >  > This driver should really have gotten some review before being
> > >  > included in the kernel.
> > > 
> > >  > Even a simple checkpatch run finds more than > 250 stylistic
> > >  > errors (not code bugs but cases where the driver violates the
> > >  > standard code formatting rules of kernel code).
> > > 
> > > Linus has strongly stated that we should merge hardware drivers
> > > early, and I agree: although the nes driver clearly needs more
> > > work, there's no advantage to users with the hardware in forcing
> > > them to wait for 2.6.26 to merge the driver, since they'll just
> > > have to patch the grungy code in themselves anyway.  And by merging
> > > the driver early, we get fixed up for any tree-wide changes and
> > > allow janitors to help with the cleanup.
> > 
> > Is it really intended to merge drivers without _any_ kind of review?
> 
> No of course not.
> 
> I totally agree we should be more agressive in merging drivers earlier.
> A minimal review needs to happen so for a few things imo
> 1) That the driver doesn't break the build
> 2) That the driver has no obvious huge security holes
>    (this is a big deal for unsuspecting users)
> 3) that there's not an obscene amount of "uses deprecated api" compiler warnings
>    (since those are annoying for everyone else)
> 4) that people who don't have the hardware are not negatively affected
>    (say crashes without the hw or so)

5) does not introduce new and ugly user-kernel we'll have problems
fixing/removing?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
