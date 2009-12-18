Return-Path: <linux-kernel-owner+w=401wt.eu-S1752216AbZLRTfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbZLRTfn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 14:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbZLRTff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 14:35:35 -0500
Received: from cantor.suse.de ([195.135.220.2]:40941 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916AbZLRTfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 14:35:32 -0500
Date: Fri, 18 Dec 2009 10:53:03 -0800
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Alexander Beregalov <a.beregalov@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: vt665x depend on WIRELESS
Message-ID: <20091218185303.GA23226@suse.de>
References: <1261156988-14346-1-git-send-email-a.beregalov@gmail.com>
 <20091218094552.f06aad32.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091218094552.f06aad32.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 09:45:52AM -0800, Randy Dunlap wrote:
> On Fri, 18 Dec 2009 20:23:08 +0300 Alexander Beregalov wrote:
> 
> > Fix build error when NET or/and WIRELESS are not enabled.
> > 
> > Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
> > ---
> >  drivers/staging/vt6655/Kconfig |    2 +-
> >  drivers/staging/vt6656/Kconfig |    2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/staging/vt6655/Kconfig b/drivers/staging/vt6655/Kconfig
> > index 825bbc4..6a186be 100644
> > --- a/drivers/staging/vt6655/Kconfig
> > +++ b/drivers/staging/vt6655/Kconfig
> > @@ -1,6 +1,6 @@
> >  config VT6655
> >     tristate "VIA Technologies VT6655 support"
> > -   depends on PCI
> > +   depends on PCI && WIRELESS
> >     select WIRELESS_EXT
> >     select WEXT_PRIV
> >     ---help---
> > diff --git a/drivers/staging/vt6656/Kconfig b/drivers/staging/vt6656/Kconfig
> > index 87bcd26..6fceae4 100644
> > --- a/drivers/staging/vt6656/Kconfig
> > +++ b/drivers/staging/vt6656/Kconfig
> > @@ -1,6 +1,6 @@
> >  config VT6656
> >  	tristate "VIA Technologies VT6656 support"
> > -	depends on USB
> > +	depends on USB && WIRELESS
> >  	select WIRELESS_EXT
> >  	select WEXT_PRIV
> >  	---help---
> > -- 
> 
> 	depends on WLAN
> 
> would be better, and the patch has already been submitted to Greg...
> I don't know where it is in his "system" though.

It just got applied :)

thanks,

greg k-h
