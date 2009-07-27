Return-Path: <linux-kernel-owner+w=401wt.eu-S1754173AbZG0TdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbZG0TdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 15:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbZG0TdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 15:33:18 -0400
Received: from cs20.apochromatic.org ([204.152.189.161]:51584 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbZG0TdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 15:33:17 -0400
Date: Mon, 27 Jul 2009 20:32:53 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian Hunter <adrian.hunter@nokia.com>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 32/32] ARM: OMAP: RX51: set MMC capabilities and
	power-saving flag
Message-ID: <20090727193253.GJ12665@console-pimps.org>
References: <20090710124004.1262.10422.sendpatchset@ahunter-tower> <20090710124353.1262.22788.sendpatchset@ahunter-tower> <20090725235329.GE12665@console-pimps.org> <4A6D5E40.7030608@nokia.com> <20090727082721.GG12665@console-pimps.org> <4A6D6C2E.6060306@nokia.com> <20090727091511.GH12665@console-pimps.org> <20090727102111.GI12665@console-pimps.org> <4A6D8957.7040706@nokia.com> <20090727111448.89e79b55.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090727111448.89e79b55.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 11:14:48AM -0700, Andrew Morton wrote:
> On Mon, 27 Jul 2009 14:02:47 +0300 Adrian Hunter <adrian.hunter@nokia.com> wrote:
> 
> > Matt Fleming wrote:
> > > On Mon, Jul 27, 2009 at 10:15:11AM +0100, Matt Fleming wrote:
> > >> On Mon, Jul 27, 2009 at 11:58:22AM +0300, Adrian Hunter wrote:
> > >>> Yes much nicer.  Will you add it to your patch?
> > >> Sure, I'll reply with an updated patch to 07/32 of this series.
> > >>
> > >> Thanks Adrian.
> > > 
> > > OK, slight problem. If I change omap_hsmmc.c in 07/32 you'll need to
> > > respin all your patches from [PATCH 08/32] onwards. Is that OK with you?
> > 
> > I'd like to know what Andrew wants to do, as these patches are in mm tree.
> > 
> > In the past I have seen him ask for changes to be patched on top, rather than
> > make a new patch.
> > 
> > Otherwise I am happy to redo the patch set.
> 
> Respinning the patchset produces the nicest result, but if it's just a
> matter of one modest fixup patch to be applied after the 32-patch
> series then I don't think it'll kill anyone.

My only worry is that if we have a fixup patch at the end of the series
then we break bisection because the omap_hsmmc driver will not work from
07/32 until the fixup patch. I think the only two options are,

      a) move patch 07/32 to the end of the series (I can do the fix on
      top then, no problems).

      b) respin the all patches from 07/32 onwards.

Adrian, how feasible is option a)?
