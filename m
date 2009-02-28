Return-Path: <linux-kernel-owner+w=401wt.eu-S1756492AbZB1ArW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492AbZB1ArW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 19:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbZB1ArN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 19:47:13 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:49702 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745AbZB1ArM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 19:47:12 -0500
Date: Fri, 27 Feb 2009 17:47:10 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: "Woodruff, Richard" <r-woodruff2@ti.com>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH B 06/10] OMAP3 pwrdm: add CORE SAR handling (for USBTLL
 module)
In-Reply-To: <20090223143801.GA27145@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.0902271721290.1141@utopia.booyaka.com>
References: <20090128024301.27240.39391.stgit@localhost.localdomain> <20090128024421.27240.95450.stgit@localhost.localdomain> <13B9B4C6EF24D648824FF11BE89671620376DEB7A5@dlee02.ent.ti.com> <alpine.DEB.2.00.0901290042020.32081@utopia.booyaka.com>
 <alpine.DEB.2.00.0901290212360.18004@utopia.booyaka.com> <20090131142213.GL1394@n2100.arm.linux.org.uk> <alpine.DEB.2.00.0902052050220.8131@utopia.booyaka.com> <20090223143801.GA27145@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell,

On Mon, 23 Feb 2009, Russell King - ARM Linux wrote:

> On Thu, Feb 05, 2009 at 08:52:17PM -0700, Paul Walmsley wrote:
> > On Sat, 31 Jan 2009, Russell King - ARM Linux wrote:
> > > On Thu, Jan 29, 2009 at 02:15:44AM -0700, Paul Walmsley wrote:
> > > > On Thu, 29 Jan 2009, Paul Walmsley wrote:
> > > > 
> > > > > > TLLSAR is not functional till ES3.1 (and beyound).  Is it possible to flag it this way?
> > > > > 
> > > > > Yes, it's easy in this case.  Thanks for the note.  I will send along an 
> > > > > updated patch for this.
> > > > 
> > > > N.B. - fixxing this required a separate change to the omap_chip flag 
> > > > system, so I'll send the two necessary patches to the linux-omap mailing 
> > > > list for further testing.
> > > 
> > > I'll hold off on this patch then.
> > 
> > The patches that obsolete patch B 06 have lasted a week on linux-omap@vger 
> > without any comment, so am passing them along in subsequent E-mails.
> 
> It seems that the patches don't obsolete this patch, but instead
> require this patch to be applied first.

The motivation was to make your life easier; otherwise several later 
patches would need to be updated and re-posted.  

> We really really need to get out of this pattern of building fixes
> on top of bad patches.  If a patch is the wrong approach then it is
> the wrong approach and should be dropped, or it should be merged with
> the patches which fix stuff up to the new approach.

How would you like me to handle patch rewrites when they affect later 
patches in the series, as this one did?  Shall I re-send updates of any 
later affected patches?


- Paul
