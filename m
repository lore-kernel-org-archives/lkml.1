Return-Path: <linux-kernel-owner+w=401wt.eu-S1757503AbXJKMcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503AbXJKMcG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 08:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbXJKMb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 08:31:56 -0400
Received: from static-71-246-207-116.washdc.fios.verizon.net ([71.246.207.116]:57301
	"EHLO mail.gnupooh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbXJKMbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 08:31:55 -0400
X-Greylist: delayed 1771 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Oct 2007 08:31:55 EDT
Message-ID: <470E109C.6020903@gnupooh.org>
Date: Thu, 11 Oct 2007 08:01:32 -0400
From: Rick Niles <fniles@gnupooh.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Help with rtc to hpet conversion of OSGPS driver
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm the Linux maintainer for the OSGPS (open source GPS) project.  Our 
last release version was based off Fedora 5 and since we have had some 
hardware issues with our on board interrupt line I was using the RTC 
interrupt to service the tracking loops.  I've been trying to make the 
driver work with Fedora 7 and the 2.6.22 kernel, but the rtc_register() 
and other RTC functions seems to have been removed. I see they've been 
replaced by the corresponding HPET functions, which is great. However, 
hpet_register() always returns -16 (EBUSY).  This could be because I 
lack the correct hardware (I'm running 32-bit Linux on a Athlon64 with 
an NVIDIA chipset) or some other reason.

I'm looking for any help here.   The RTC version of the code can be 
viewed at:
http://osgps.cvs.sourceforge.net/osgps/osgps/linuxmod.c?revision=1.12&view=markup

Can device drivers still use the real-time clock at all?  Does the 
tickless kernel effect this at all?

Thanks for any help you can lend,
Rick Niles.

