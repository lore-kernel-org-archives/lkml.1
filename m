Return-Path: <linux-kernel-owner+w=401wt.eu-S1757266AbYHGVhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266AbYHGVhN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 17:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbYHGVg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 17:36:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36850 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbYHGVg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 17:36:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: resume problem with i915/drm
Date: Thu, 7 Aug 2008 23:39:39 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Charles@schwieters.org, Matthew Garrett <mjg59@srcf.ucam.org>,
       linux-kernel@vger.kernel.org
References: <E1KQYiX-0002Nl-Ud@oaf.wireless> <200808071427.32457.jbarnes@virtuousgeek.org>
In-Reply-To: <200808071427.32457.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808072339.40143.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 7 of August 2008, Jesse Barnes wrote:
> On Tuesday, August 5, 2008 7:25 pm Charles@schwieters.org wrote:
> > -----BEGIN PGP SIGNED MESSAGE-----
> > Hash: SHA1
> >
> >
> > Hi--
> >
> >   I'm having a problem resuming (from RAM) if the i915 and drm modules
> > are loaded (these are needed for running X on my machine). Vanilla
> > kernel versions 2.6.25.x and 2.6.26.x. I get the same behavior with
> > Debian linux-image-2.6.25-2-686 kernel. I can't believe I'm the first to
> > encounter this.
> >
> > suspend-to-ram and resuming works fine with earlier kernels
> > (e.g. 2.6.17), but I haven't tested exhaustively.
> >
> > Possibly related is a failure in modprobe -r i915 after it is
> > loaded. The message printed is
> 
> [snip backtrace]
> 
> Well the backtrace makes it look like i915 didn't take care to remove some of 
> its /proc files, which is weird.
> 
> Your "screen blank on resume" problem might be a duplicate of a bug that got 
> reported awhile back (can't find it now, Matthew?).  If so, then you're not 
> the first one to see it; unfortunately we don't have a fix yet...

I think it may be related to this report:

http://marc.info/?l=linux-kernel&m=121789312607006&w=4

Thanks,
Rafael
