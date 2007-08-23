Return-Path: <linux-kernel-owner+w=401wt.eu-S1759121AbXHWDPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759121AbXHWDPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 23:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753965AbXHWDPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 23:15:05 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:4695 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758391AbXHWDOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 23:14:52 -0400
Date: Wed, 22 Aug 2007 22:56:15 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Broadcom Linux <bcm43xx-dev@lists.berlios.de>
Subject: Re: 2.6.23-rc3-mm1: fix b43 compilation
Message-ID: <20070823025614.GA4855@tuxdriver.com>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <200708221833.59375.rjw@sisk.pl> <200708222356.44088.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708222356.44088.mb@bu3sch.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 11:56:43PM +0200, Michael Buesch wrote:
> On Wednesday 22 August 2007 18:33:58 Rafael J. Wysocki wrote:
> > On Wednesday, 22 August 2007 11:06, Andrew Morton wrote:
> > > 
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc3/2.6.23-rc3-mm1/
> > > 
> > > - git-ixgbe.patch got dropped - git-net.patch destroyed it
> > > 
> > > - then git-net got dropped as it doesn't work
> > 
> > Apparently, the b43 driver is expecting another version of mac80211.
> > 
> > This patch fixes the compilation, but I'm not sure what about the
> > functionality. ;-)
> 
> There seems to be a screwup somehow.
> These mac80211 API functions were recently changed to include
> the additional parameter. So it seems you carry an old version of mac80211.

I think what happened is because Andrew dropped Dave M.'s net tree.
Since mac80211 has been getting merged through Dave M., crucial bits
are missing which then break the bits from wireless-dev.

Andrew, if you find that you need to drop git-net again then I'll be
happy to provide you with a wireless-dev patch that does not depend on
Dave's tree.  The mm-master branch in wireless-dev has dropped those
patches which have gone to Dave M. in the hopes of avoiding conflicts.
Dependencies are another matter... :-)

John
-- 
John W. Linville
linville@tuxdriver.com
