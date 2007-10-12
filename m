Return-Path: <linux-kernel-owner+w=401wt.eu-S1759498AbXJLESu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759498AbXJLESu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 00:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbXJLESl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 00:18:41 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:44726 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbXJLESk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 00:18:40 -0400
Date: Thu, 11 Oct 2007 22:18:15 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: ioremap_nocache and mem= parameter with k 2.6.18
In-reply-to: <1192116465.689041.176900@57g2000hsv.googlegroups.com>
To: mirco_cremasco@hotmail.com, linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <470EF587.3000204@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <1192116465.689041.176900@57g2000hsv.googlegroups.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

mirco_cremasco@hotmail.com wrote:
> Hi,
> I'm using a driver for a framegrabber device that needs to alloc a
> huge buffer of ram for dma transfers....
> So it works:
> 1) Having 2GB of ram installed, boot the kernel with mem=1024M
> parameter
> 2) remap the unmapped memory above first GB using ioremap_nocache
> function, using PAGE_ALIGN().
> 
> This works fine with kernel 2.6.9 but it doesn't with newer ones
> 2.6.18, 2.6.20, 2.6.22.
> With newer kernel ioremap returns 0.
> It seems like memory above 1G has been marked reserved, IMHO.
> 
> What changes in the mm?
> I'm not the driver's developer, but I'd like to understand and
> possibly find a workaround...

It doesn't make sense to use ioremap_nocache on RAM. It's only meant for 
mapping MMIO memory regions on a device.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

