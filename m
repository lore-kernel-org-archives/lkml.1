Return-Path: <linux-kernel-owner+w=401wt.eu-S1756870AbXGIRxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870AbXGIRxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 13:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754284AbXGIRxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 13:53:12 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49985 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752852AbXGIRxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 13:53:10 -0400
Message-ID: <469275F5.3050906@garzik.org>
Date: Mon, 09 Jul 2007 13:52:53 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Bruce Allen <ballen@gravity.phys.uwm.edu>
CC: Mark Lord <liml@rtr.ca>, David Greaves <david@dgreaves.com>,
       Douglas Gilbert <dougg@torque.net>, Tejun Heo <htejun@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Kai Makisara <Kai.Makisara@kolumbus.fi>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Dvorak <fermentol@gmail.com>,
       Smartmontools Mailing List 
	<smartmontools-support@lists.sourceforge.net>,
       Klaus Fuerstberger <kfuerstberger@arcor.de>,
       Bruce Allen <bruce.allen@aei.mpg.de>
Subject: Re: SMART problems in 2.6.22
References: <Pine.LNX.4.63.0707081910050.21572@trinity.phys.uwm.edu> <Pine.LNX.4.63.0707082003360.23123@trinity.phys.uwm.edu> <469198E4.6000200@garzik.org> <Pine.LNX.4.63.0707091232480.7386@trinity.phys.uwm.edu>
In-Reply-To: <Pine.LNX.4.63.0707091232480.7386@trinity.phys.uwm.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bruce Allen wrote:
> On Sun, 8 Jul 2007, Jeff Garzik wrote:
> 
> Jeff, thanks for the quick feedback.
> 
>> On the base point, libata has never enabled SMART on its own.  That's 
>> always up to the BIOS, etc.
> 
> OK, clear.
> 
>> It's possible that the recent addition of ACPI support will cause 
>> disks to be in different modes than previously expected.  ACPI 
>> supplies ATA taskfiles to be pushed to the disk, and who knows what's 
>> in there...
> 
> Is there a simple way I can have affected users test this?  Is there a 
> kernel boot flag or sysctl setting or something else they can use to 
> disable the ACPI stuff so see if the problem then goes away?

The 'noacpi' module option.

	Jeff



