Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759466Ab0BZC5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 21:57:32 -0500
Received: from kroah.org ([198.145.64.141]:52482 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754681Ab0BZC5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 21:57:31 -0500
Date: Thu, 25 Feb 2010 18:57:21 -0800
From: Greg KH <greg@kroah.com>
To: Hank Janssen <hjanssen@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Problem with auto-detecting a HV environment from within Linux
Message-ID: <20100226025721.GA10310@kroah.com>
References: <20100225164436.GA3310@kroah.com>
 <1FB5E1D5CA062146B38059374562DF725B6A4277@TK5EX14MBXC130.redmond.corp.microsoft.com>
 <20100225173611.GA14124@kroah.com>
 <1FB5E1D5CA062146B38059374562DF725B6A5633@TK5EX14MBXC130.redmond.corp.microsoft.com>
 <20100225230639.GB20900@kroah.com>
 <1FB5E1D5CA062146B38059374562DF725B6A5806@TK5EX14MBXC130.redmond.corp.microsoft.com>
 <20100226004646.GA31483@kroah.com>
 <8AFC7968D54FB448A30D8F38F259C56212EDCD14@TK5EX14MBXC116.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8AFC7968D54FB448A30D8F38F259C56212EDCD14@TK5EX14MBXC116.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 02:14:55AM +0000, Hank Janssen wrote:
> 
> 
> >Ok, below are 2 patches that I will queue up in my tree.
> >
> >Can you test them to verify that they work properly?
> 
> Will do. We will let you know as soon as we test it.

In looking at the second patch again, I think you will need to put some
spaces in the DMI strings to get it to match up properly.  Look at what
the files in:
	/sys/class/dmi/id/
look like exactly to get it to line up.  The module id stuff strips
spaces out, so I can't get the real value there.

thanks,

greg k-h
