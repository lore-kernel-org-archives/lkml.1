Return-Path: <linux-kernel-owner+w=401wt.eu-S1758718AbYEPWBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718AbYEPWBa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 18:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945AbYEPWBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 18:01:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55381 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbYEPWBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 18:01:19 -0400
Date: Fri, 16 May 2008 14:37:21 -0700
From: Greg KH <greg@kroah.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, len.brown@intel.com,
       Shaohua Li <shaohua.li@intel.com>
Subject: Re: Suspend/Resume bug in PCI layer wrt quirks
Message-ID: <20080516213721.GA13492@kroah.com>
References: <20080515070546.6ea9c681@infradead.org> <200805152151.31936.rjw@sisk.pl> <200805161051.49919.jbarnes@virtuousgeek.org> <200805162216.31463.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805162216.31463.rjw@sisk.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 10:16:30PM +0200, Rafael J. Wysocki wrote:
> On Friday, 16 of May 2008, Jesse Barnes wrote:
> > On Thursday, May 15, 2008 12:51 pm Rafael J. Wysocki wrote:
> > > Some quirks should be called with interrupt disabled, we can't directly
> > > call them in .resume_early. Also the patch introduces
> > > pci_fixup_resume_early and pci_fixup_suspend, which matches current
> > > device core callbacks (.suspend/.resume_early).
> > >
> > > TBD: Somebody knows why we need quirk resume should double check if a
> > > quirk should be called in resume or resume_early. I changed some per my
> > > understanding, but can't make sure I fixed all.
> > >
> > > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> > 
> > I applied this one to linux-next, it should fix some of the problems people 
> > have been seeing at least...
> 
> Well, that will collide with
> pm-new-suspend-and-hibernation-callbacks-for-pci-bus-type.patch
> in the Greg's tree.
> 
> Greg, perhaps it's better if you drop it and I'll send an updated version to
> Jesse?  That will make his tree dependent on yours, but that will be okay,
> won't it?

That's up to Jesse.  I don't know if he can handle a depancy on an
external tree.

Jesse?
