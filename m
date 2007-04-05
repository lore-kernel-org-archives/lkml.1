Return-Path: <linux-kernel-owner+w=401wt.eu-S1767208AbXDES6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767208AbXDES6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 14:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767222AbXDES6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 14:58:18 -0400
Received: from anchor-post-31.mail.demon.net ([194.217.242.89]:3045 "EHLO
	anchor-post-31.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767208AbXDES6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 14:58:18 -0400
Subject: Re: [PATCH 01/01] New FBDev driver for Intel Vermilion Range
From: Alan Hourihane <alanh@fairlite.demon.co.uk>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <8776.1175794703@turing-police.cc.vt.edu>
References: <1175769886.10382.29.camel@localhost>
	 <8776.1175794703@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Thu, 05 Apr 2007 19:58:13 +0100
Message-Id: <1175799493.10105.40.camel@jetpack.demon.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-05 at 13:38 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 05 Apr 2007 11:44:46 BST, Alan Hourihane said:
> 
> > Attached is a patch against 2.6.21-rc5 which adds the Intel Vermilion
> > Range support.
> 
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

I've asked the question and the part number would be...

LE80578

So, if that desperately needs changing let me know and I'll submit
another patch, or maybe someone can make the tweak for me.

Thanks,

Alan.

