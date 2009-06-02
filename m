Return-Path: <linux-kernel-owner+w=401wt.eu-S1757251AbZFBOQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251AbZFBOQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 10:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754269AbZFBOQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 10:16:25 -0400
Received: from mx1.emlix.com ([193.175.82.87]:49097 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308AbZFBOQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 10:16:25 -0400
From: "Oskar Schirmer" <os@emlix.com>
Date: Tue, 2 Jun 2009 16:15:29 +0200
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Mundt <lethal@linux-sh.org>, jw@emlix.com, os@emlix.com,
       dhowells@redhat.com, rmk@arm.linux.org.uk, cooloney@kernel.org,
       geert@linux-m68k.org, vapier.adi@gmail.com, gerg@uclinux.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v3] flat: fix data sections alignment
Message-ID: <20090602141529.GA8325@emlix.com>
References: <E1LfGwO-0007Kq-6c@mailer.emlix.com> <20090310073350.GH10393@linux-sh.org> <20090402135343.d18d17a5.akpm@linux-foundation.org> <20090409142553.GA3330@emlix.com> <20090505140847.GB25409@emlix.com> <20090527114955.GA23343@emlix.com> <20090527134357.601c3c87.akpm@linux-foundation.org> <20090528000801.GA30594@linux-sh.org> <20090527171631.ed4de515.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090527171631.ed4de515.akpm@linux-foundation.org>
Organization: emlix GmbH
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 17:16:31 -0700, Andrew Morton wrote:
> On Thu, 28 May 2009 09:08:02 +0900
> Paul Mundt <lethal@linux-sh.org> wrote:
> 
> > On Wed, May 27, 2009 at 01:43:57PM -0700, Andrew Morton wrote:
> > > On Wed, 27 May 2009 13:49:56 +0200
> > > Johannes Weiner <jw@emlix.com> wrote:
> > > > On Tue, May 05, 2009 at 04:08:47PM +0200, Johannes Weiner wrote:
> > > > > On Thu, Apr 09, 2009 at 04:25:53PM +0200, Johannes Weiner wrote:
> > > > > > On Thu, Apr 02, 2009 at 01:53:43PM -0700, Andrew Morton wrote:
> > > > > > Paul and Mike had complaints.  Paul acked the last revision.  Mike?
> > > > > > We need this for upstream to compile on our configuration.
> > > 
> > > Who is Mike?
> > > 
> > > (A pox upon email clients which strip real names)
> > > 
> > > > > Can we get this merged?  Nobody complained.
> > > > 
> > > > <periodic echo-request>
> > > > 
> > > > What are the plans on this now?  I assume it drowned in other changes...
> > > > Is it too late to get this in .30 now?
> > > 
> > > The patch had a fairly shaky start and it's been unclear to me that
> > > everyone is happy with it and has tested it.
> > > 
> > >  arch/arm/include/asm/flat.h      |    3 --
> > >  arch/blackfin/include/asm/flat.h |    1 
> > >  arch/h8300/include/asm/flat.h    |    1 
> > >  arch/m32r/include/asm/flat.h     |    1 
> > >  arch/m68k/include/asm/flat.h     |    1 
> > >  arch/sh/include/asm/flat.h       |    1 
> > >  fs/binfmt_flat.c                 |   46 ++++++++++++++++++++++++++-------------
> > > 
> > > I guess ARM is the major architecture amongst that lot.  Have Russell
> > > and co had a decent look through this?
> > > 
> > The problem here is that the ARM nommu people seem to have disappeared
> > shortly after getting their changes merged. I see no activity within the
> > kernel for ARM nommu since 2006.
> 
> heh, OK.  Oskar touched it last, so he's now ARM nommu maintainer.

Well, I'ld need some test device for that purpose.
Someone around who can provide one?

  Oskar
