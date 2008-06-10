Return-Path: <linux-kernel-owner+w=401wt.eu-S1756242AbYFJPaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbYFJPaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 11:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbYFJPaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 11:30:19 -0400
Received: from mail.vyatta.com ([216.93.170.194]:54451 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098AbYFJPaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 11:30:17 -0400
X-Spam-Flag: NO
X-Spam-Score: -1.568
Date: Tue, 10 Jun 2008 08:30:14 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
       David Miller <davem@davemloft.net>, fubar@us.ibm.com,
       netdev@vger.kernel.org, bonding-devel@lists.sourceforge.net
Subject: Re: [PATCH] driver core: Suppress sysfs warnings for
 device_rename().
Message-ID: <20080610083014.66052504@extreme>
In-Reply-To: <20080610110908.46b2ade4@gondolin.boeblingen.de.ibm.com>
References: <20080515095246.3b6a0d1d@gondolin.boeblingen.de.ibm.com>
	<20080515.010139.219194657.davem@davemloft.net>
	<20080515113131.2cea2bce@gondolin.boeblingen.de.ibm.com>
	<20080515.030054.247673168.davem@davemloft.net>
	<20080515120619.6c867bfb@gondolin.boeblingen.de.ibm.com>
	<20080520125913.777ed67d@gondolin.boeblingen.de.ibm.com>
	<20080520225244.GG15912@kroah.com>
	<20080521100556.3352c5b7@gondolin.boeblingen.de.ibm.com>
	<20080610110908.46b2ade4@gondolin.boeblingen.de.ibm.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2008 11:09:08 +0200
Cornelia Huck <cornelia.huck@de.ibm.com> wrote:

> On Wed, 21 May 2008 10:05:56 +0200,
> Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> 
> Just digging through my backlog: Is there any further interest in this
> patch?
> 
> > On Tue, 20 May 2008 15:52:44 -0700,
> > Greg KH <greg@kroah.com> wrote:
> > 
> > > On Tue, May 20, 2008 at 12:59:13PM +0200, Cornelia Huck wrote:
> > > > OK, here is an actually-compiled patch with proper description and
> > > > s-o-b. Comments?
> > > 
> > > Looks good to me, feel free to add an:
> > > 	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> > > 
> > > to it.
> > > 
> > > David, are you going to take this through your tree?
> > 
> > Here it is again, respun against today's git:
> > 
> > 
> > driver core: Suppress sysfs warnings for device_rename().
> > 
> > Renaming network devices to an already existing name is not
> > something we want sysfs to print a scary warning for, since the
> > callers can deal with this correctly. So let's introduce
> > sysfs_create_link_nowarn() which gets rid of the common warning.
> > 
> > Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> > Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> > 

I you want to put the warnings back this is a reasonable way.
