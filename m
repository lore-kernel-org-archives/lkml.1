Return-Path: <linux-kernel-owner+w=401wt.eu-S1756478AbZHFS54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478AbZHFS54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 14:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756004AbZHFS5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 14:57:54 -0400
Received: from kroah.org ([198.145.64.141]:36179 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755951AbZHFS5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 14:57:52 -0400
Date: Thu, 6 Aug 2009 11:53:22 -0700
From: Greg KH <greg@kroah.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
       Richard Purdie <rpurdie@rpsys.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
Subject: Re: [RFC PATCH V2 1/2] introduce ALS sysfs class
Message-ID: <20090806185322.GB28664@kroah.com>
References: <1249547498.2670.499.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249547498.2670.499.camel@rzhang-dt>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 04:31:38PM +0800, Zhang Rui wrote:
> 
> Introduce ALS sysfs class device.
> 
> ALS sysfs class device provides a standard sysfs interface
> for Ambient Light Sensor devices.
> 
> Only two sysfs I/F are introduced currently.
> /sys/class/als/alsX/illuminance:
> 	indicates the amount of light incident upon a specified surface area.
> /sys/class/als/alsX/mappings:
> 	exports ambient light illuminance to display luminance mappings
> 	that can be used by an OS to calibrate its ambient light policy
> 	for a given sensor configuration.
> 	The OS can use this information to extrapolate an ALS response curve
> 	- noting that these values may be treated differently depending on the
> 	OS implementation but should be used in some form to calibrate ALS policy.
> 
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> ---
>  Documentation/als/sysfs.txt |  138 ++++++++++++++++++++++

This needs to be in Documentation/ABI instead.

thanks,

greg k-h
