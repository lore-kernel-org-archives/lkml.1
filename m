Return-Path: <linux-kernel-owner+w=401wt.eu-S1763519AbYFKQ2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763519AbYFKQ2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 12:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753386AbYFKQ1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 12:27:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57457 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbYFKQ1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 12:27:46 -0400
Date: Wed, 11 Jun 2008 09:24:14 -0700
From: Greg KH <greg@kroah.com>
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       kernel-janitors@vger.kernel.org, linux-next@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [ANNOUNCE] linux-staging tree created
Message-ID: <20080611162414.GB22134@kroah.com>
References: <20080610190540.GA25066@kroah.com> <1213146346.16146.17.camel@nigel-laptop> <20080611032948.GB4483@kroah.com> <1213156812.16146.37.camel@nigel-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1213156812.16146.37.camel@nigel-laptop>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2008 at 02:00:12PM +1000, Nigel Cunningham wrote:
> Hi Greg.
> 
> On Tue, 2008-06-10 at 20:29 -0700, Greg KH wrote:
> > On Wed, Jun 11, 2008 at 11:05:46AM +1000, Nigel Cunningham wrote:
> > > Hi.
> > > 
> > > Would you consider including TuxOnIce in it?
> > > 
> > > I do still want to get it merged and would appreciate feedback.
> > 
> > Is the patch "stand-alone", only adding new code in discrete chunks like
> > a new driver or filesystem would?
> 
> ﻿The patch I distribute now does have a few parts to it that could be
> separated into distinct patches (cryptoapi LZF support, fuse freezer
> support), but the bulk of it is TuxOnIce itself, which just adds new
> files and inserts the hooks necessary to share the lowlevel code with
> [u]swsusp. I think, therefore, it would akin to adding a new driver or
> filesystem.
> 
> > If not, I don't think it is relevant.  Odds are you want to be your own
> > series of patches, like we discussed years ago, right?
> 
> I don't think I do want to have my own series of patches, because
> TuxOnIce doesn't remove or rework swsusp or uswsusp, but sits along side
> them. I'm not trying to mutate swsusp into TuxOnIce, because that would
> require a complete rework of swsusp from the ground up (TuxOnIce does
> everything but the atomic copy/restore ﻿and associated prep/cleanup
> differently).

Like always, you need to divide your changes up into logical chunks in
order to get them approved and reviewed.  For such a core functionality
like suspend, this is extra important.

I do not think that -staging is proper for this kind of feature at this
point in time.

thanks,

greg k-h
