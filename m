Return-Path: <linux-kernel-owner+w=401wt.eu-S1751736AbXBAP2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736AbXBAP2a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 10:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751743AbXBAP2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 10:28:30 -0500
Received: from router.emperor-sw2.exsbs.net ([208.254.201.37]:42453 "EHLO
	sade.emperorlinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbXBAP23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 10:28:29 -0500
X-Greylist: delayed 1383 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Feb 2007 10:28:29 EST
Subject: Re: 2.6.16.16 Lost CD-ROM Drive
From: "Jeremy L. Moles" <jeremy@emperorlinux.com>
Reply-To: jeremy@emperorlinux.com
To: "Brian D. McGrew" <brian@visionpro.com>
Cc: linux-precision@dell.com, linux-kernel@vger.kernel.org
In-Reply-To: <14CFC56C96D8554AA0B8969DB825FEA001C3A233@chicken.machinevisionproducts.com>
References: <14CFC56C96D8554AA0B8969DB825FEA001C3A233@chicken.machinevisionproducts.com>
Content-Type: text/plain
Organization: EmperorLinux, Inc.
Date: Thu, 01 Feb 2007 10:05:15 -0500
Message-Id: <1170342315.3984.12.camel@ripley>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-01 at 07:00 -0800, Brian D. McGrew wrote:
> Hey guys-
> 
> Have a Precision workstation with SATA hard drive and SATA CD-ROM.  If I
> load Fedora Core 5 with a stock 2.6.15 kernel, life is good.
> 
> However, I need to use 2.6.16.16.  Once I build and install this kernel,
> my CD-ROM drive is gone.  There is a log entry in dmesg that says "ATAPI
> not support.  Ignoring."  
> 
> If I go into the BIOS and set the SATA operations to Legacy/Compatible
> then everything is fine.  I've rebuilt this kernel about 100 times
> trying everything I can think of.
> 
> When I have SATA set to legacy, the HDD and CD are detected as /dev/hd*
> and when they're set to SATA Normal operation the HDD is detected as
> /dev/sda.  If I boot my old 2.6.15 (stock install) kernel then the CD is
> found as /dev/sdc.  
> 
> I've even tried taking the installation default configuration file for
> the 2.6.15 kernel and just wholesale copying it into my 2.6.16.16 kernel
> and build that way but still no go.
> 
> What am I missing to get the 2.6.16.16 kernel to see a SATA CD-ROM drive
> in normal, non-legacy move?

Try booting 2.6.16 with the following options:

libata.atapi_enabled=1 ide0=noprobe ide1=noprobe

> -brian
> 
> Brian D. McGrew        { brian@visionpro.com ||
> brian@doubledimension.com }
> --
> > Do not read this email while waxing that cat! 
> 
> _______________________________________________
> Linux-Precision mailing list
> Linux-Precision@dell.com
> http://lists.us.dell.com/mailman/listinfo/linux-precision
> Please read the FAQ at http://lists.us.dell.com/faq or search the list archives at http://lists.us.dell.com/htdig/
> 

