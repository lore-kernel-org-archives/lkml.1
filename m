Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965834Ab0BZTR0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 14:17:26 -0500
Received: from kroah.org ([198.145.64.141]:46598 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965789Ab0BZTRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 14:17:25 -0500
Date: Fri, 26 Feb 2010 11:16:44 -0800
From: Greg KH <greg@kroah.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Hank Janssen <hjanssen@microsoft.com>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Problem with auto-detecting a HV environment from within Linux
Message-ID: <20100226191644.GA18182@kroah.com>
References: <20100225164436.GA3310@kroah.com>
 <1FB5E1D5CA062146B38059374562DF725B6A4277@TK5EX14MBXC130.redmond.corp.microsoft.com>
 <20100225173611.GA14124@kroah.com>
 <1FB5E1D5CA062146B38059374562DF725B6A5633@TK5EX14MBXC130.redmond.corp.microsoft.com>
 <20100225230639.GB20900@kroah.com>
 <1FB5E1D5CA062146B38059374562DF725B6A5806@TK5EX14MBXC130.redmond.corp.microsoft.com>
 <20100226004646.GA31483@kroah.com>
 <8AFC7968D54FB448A30D8F38F259C56212EDCD14@TK5EX14MBXC116.redmond.corp.microsoft.com>
 <20100226025721.GA10310@kroah.com>
 <1FB5E1D5CA062146B38059374562DF725B6A6D15@TK5EX14MBXC130.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FB5E1D5CA062146B38059374562DF725B6A6D15@TK5EX14MBXC130.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 07:07:14PM +0000, Haiyang Zhang wrote:
> > From: Greg KH [mailto:greg@kroah.com]
> > Sent: Thursday, February 25, 2010 9:57 PM
> > In looking at the second patch again, I think you will need to put some
> > spaces in the DMI strings to get it to match up properly.  Look at what
> > the files in:
> > 	/sys/class/dmi/id/
> > look like exactly to get it to line up.  The module id stuff strips
> > spaces out, so I can't get the real value there.
> 
> Thanks for your help! I have applied the two patches -- auto loading
> of hv_vmbus works fine after a space was inserted into the DMI strings
> ("Microsoft Corporation", "Virtual Machine").

Great, I'll add a space and then queue them up for the merge window.

> Also, according to our Hyper-V team, we have no plan to change the
> virtual VGA card id and DMI info.

That's good to know, but if it changes in the future, we can trivially
add new device ids.

thanks,

greg k-h
