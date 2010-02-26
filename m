Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934740Ab0BZAVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 19:21:19 -0500
Received: from kroah.org ([198.145.64.141]:55242 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934681Ab0BZAVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 19:21:18 -0500
Date: Thu, 25 Feb 2010 16:21:12 -0800
From: Greg KH <greg@kroah.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Hank Janssen <hjanssen@microsoft.com>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Problem with auto-detecting a HV environment from within Linux
Message-ID: <20100226002112.GB30698@kroah.com>
References: <20100225164436.GA3310@kroah.com>
 <1FB5E1D5CA062146B38059374562DF725B6A4277@TK5EX14MBXC130.redmond.corp.microsoft.com>
 <20100225173611.GA14124@kroah.com>
 <1FB5E1D5CA062146B38059374562DF725B6A5633@TK5EX14MBXC130.redmond.corp.microsoft.com>
 <20100225230639.GB20900@kroah.com>
 <1FB5E1D5CA062146B38059374562DF725B6A5806@TK5EX14MBXC130.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FB5E1D5CA062146B38059374562DF725B6A5806@TK5EX14MBXC130.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 11:40:52PM +0000, Haiyang Zhang wrote:
> > -----Original Message-----
> > From: Greg KH [mailto:greg@kroah.com]
> > Sent: Thursday, February 25, 2010 6:07 PM
> > If so, what is the vendor and product id of this device?
> 
> The Vendor:Device Id is: 1414:5353
> 00:08.0 VGA compatible controller [0300]: Microsoft Corporation Device [1414:5353]
> 
> This hasn't been changed since the first release of HyperV. I will ask
> around about the future stability of the VGA card (and the DMI).

Thanks for the device id.

I'll make up a patch for testing now, as we should be able to just
trigger on this pci device id, and do the dmi test to be "safe" as well.
Any future changes can easily be added to the tables.

thanks,

greg k-h
