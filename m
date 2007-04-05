Return-Path: <linux-kernel-owner+w=401wt.eu-S1767194AbXDESm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767194AbXDESm0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 14:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767204AbXDESm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 14:42:26 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34975 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767194AbXDESmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 14:42:25 -0400
Date: Thu, 5 Apr 2007 19:42:23 +0100 (BST)
From: James Simmons <jsimmons@infradead.org>
To: Valdis.Kletnieks@vt.edu
cc: Alan Hourihane <alanh@fairlite.demon.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/01] New FBDev driver for Intel Vermilion Range
In-Reply-To: <8776.1175794703@turing-police.cc.vt.edu>
Message-ID: <Pine.LNX.4.64.0704051940490.16544@pentafluge.infradead.org>
References: <1175769886.10382.29.camel@localhost> <8776.1175794703@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> One non-technical question here...
> 
> > +config FB_VERMILION
> > +	tristate "Vermilion support"
> > +	depends on FB && PCI && X86
> > +	select FB_MODE_HELPERS
> > +	select FB_CFB_FILLRECT
> > +	select FB_CFB_COPYAREA
> > +	select FB_CFB_IMAGEBLIT
> > +	help
> > +	  This driver supports the Vermilion Range chipset
> 
> Is 'Vermillion' the project codename, or the name that end users will actually
> see when hardware ships?  Most of the Intel graphics chopsets have been
> named things like i810, i925, and so on - if the user-visible name is known,
> that should probably be reflected in the 'tristate' string and help
> text (FB_VERMILLION in the code is fine by be though).

I have to agree. I went looking for info on this card and I can't find 
anything. Please name it what the end user will expect.

