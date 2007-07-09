Return-Path: <linux-kernel-owner+w=401wt.eu-S1758291AbXGIRgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758291AbXGIRgH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 13:36:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754459AbXGIRf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 13:35:56 -0400
Received: from trinity.phys.uwm.edu ([129.89.57.159]:39838 "EHLO
	trinity.phys.uwm.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368AbXGIRfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 13:35:55 -0400
Date: Mon, 9 Jul 2007 12:35:04 -0500 (CDT)
From: Bruce Allen <ballen@gravity.phys.uwm.edu>
X-X-Sender: ballen@trinity.phys.uwm.edu
To: Jeff Garzik <jeff@garzik.org>
cc: Mark Lord <liml@rtr.ca>, David Greaves <david@dgreaves.com>,
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
In-Reply-To: <469198E4.6000200@garzik.org>
Message-ID: <Pine.LNX.4.63.0707091232480.7386@trinity.phys.uwm.edu>
References: <Pine.LNX.4.63.0707081910050.21572@trinity.phys.uwm.edu>
 <Pine.LNX.4.63.0707082003360.23123@trinity.phys.uwm.edu> <469198E4.6000200@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jul 2007, Jeff Garzik wrote:

Jeff, thanks for the quick feedback.

> On the base point, libata has never enabled SMART on its own.  That's 
> always up to the BIOS, etc.

OK, clear.

> It's possible that the recent addition of ACPI support will cause disks 
> to be in different modes than previously expected.  ACPI supplies ATA 
> taskfiles to be pushed to the disk, and who knows what's in there...

Is there a simple way I can have affected users test this?  Is there a 
kernel boot flag or sysctl setting or something else they can use to 
disable the ACPI stuff so see if the problem then goes away?

Cheers,
 	Bruce
