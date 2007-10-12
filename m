Return-Path: <linux-kernel-owner+w=401wt.eu-S1759726AbXJLEU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759726AbXJLEU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 00:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754830AbXJLEUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 00:20:50 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:64054 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371AbXJLEUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 00:20:49 -0400
Date: Thu, 11 Oct 2007 22:20:18 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Help with rtc to hpet conversion of OSGPS driver
In-reply-to: <fa.nKddWg8u6TJNw86Rid83rey2q6Q@ifi.uio.no>
To: Rick Niles <fniles@gnupooh.org>
Cc: linux-kernel@vger.kernel.org
Message-id: <470EF602.40404@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.nKddWg8u6TJNw86Rid83rey2q6Q@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rick Niles wrote:
> I'm the Linux maintainer for the OSGPS (open source GPS) project.  Our 
> last release version was based off Fedora 5 and since we have had some 
> hardware issues with our on board interrupt line I was using the RTC 
> interrupt to service the tracking loops.  I've been trying to make the 
> driver work with Fedora 7 and the 2.6.22 kernel, but the rtc_register() 
> and other RTC functions seems to have been removed. I see they've been 
> replaced by the corresponding HPET functions, which is great. However, 
> hpet_register() always returns -16 (EBUSY).  This could be because I 
> lack the correct hardware (I'm running 32-bit Linux on a Athlon64 with 
> an NVIDIA chipset) or some other reason.
> 
> I'm looking for any help here.   The RTC version of the code can be 
> viewed at:
> http://osgps.cvs.sourceforge.net/osgps/osgps/linuxmod.c?revision=1.12&view=markup 
> 
> 
> Can device drivers still use the real-time clock at all?  Does the 
> tickless kernel effect this at all?
> 
> Thanks for any help you can lend,
> Rick Niles.

Am I missing why you can't just use a normal kernel timer for this? You 
shouldn't have to mess with the RTC or HPET directly..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

