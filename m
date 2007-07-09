Return-Path: <linux-kernel-owner+w=401wt.eu-S1759883AbXGISDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759883AbXGISDK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 14:03:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753748AbXGISC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 14:02:58 -0400
Received: from trinity.phys.uwm.edu ([129.89.57.159]:57702 "EHLO
	trinity.phys.uwm.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbXGISC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 14:02:57 -0400
Date: Mon, 9 Jul 2007 13:02:28 -0500 (CDT)
From: Bruce Allen <ballen@gravity.phys.uwm.edu>
X-X-Sender: ballen@trinity.phys.uwm.edu
To: Jan Dvorak <fermentol@gmail.com>,
       Klaus Fuerstberger <kfuerstberger@arcor.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
cc: Mark Lord <liml@rtr.ca>, David Greaves <david@dgreaves.com>,
       Douglas Gilbert <dougg@torque.net>, Tejun Heo <htejun@gmail.com>,
       Smartmontools Mailing List 
	<smartmontools-support@lists.sourceforge.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Kai Makisara <Kai.Makisara@kolumbus.fi>,
       Bruce Allen <bruce.allen@aei.mpg.de>
Subject: Re: SMART problems in 2.6.22
In-Reply-To: <469275F5.3050906@garzik.org>
Message-ID: <Pine.LNX.4.63.0707091256330.7386@trinity.phys.uwm.edu>
References: <Pine.LNX.4.63.0707081910050.21572@trinity.phys.uwm.edu>
 <Pine.LNX.4.63.0707082003360.23123@trinity.phys.uwm.edu> <469198E4.6000200@garzik.org>
 <Pine.LNX.4.63.0707091232480.7386@trinity.phys.uwm.edu> <469275F5.3050906@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

>>> It's possible that the recent addition of ACPI support will cause disks to 
>>> be in different modes than previously expected.  ACPI supplies ATA 
>>> taskfiles to be pushed to the disk, and who knows what's in there...
>> 
>> Is there a simple way I can have affected users test this?  Is there a 
>> kernel boot flag or sysctl setting or something else they can use to 
>> disable the ACPI stuff so see if the problem then goes away?
>
> The 'noacpi' module option.

OK, thanks.

Klaus, Jan: could you please see if your problem with 2.6.22 goes away 
with noacpi passed as a flag to libata?

Jeff: I will add the noacpi test suggestion into the Debian bug report 
here http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=428975 to try to 
ensure that Klaus sees it.

Cheers,
 	Bruce
