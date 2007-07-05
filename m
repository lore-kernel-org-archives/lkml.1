Return-Path: <linux-kernel-owner+w=401wt.eu-S1761424AbXGEWaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761424AbXGEWaA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 18:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758575AbXGEW3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 18:29:52 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:42813 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757389AbXGEW3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 18:29:51 -0400
X-Sasl-enc: 5upCGeUwr3TViqjtdoUsXH/4DWyrCNxO24eQhoeyV6NV 1183674588
Message-ID: <468D7034.7060107@whitby.id.au>
Date: Fri, 06 Jul 2007 07:57:00 +0930
From: Rod Whitby <rod@whitby.id.au>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, jeff@garzik.org,
       Rod Whitby <rod@whitby.id.au>
Subject: Re: Libata PATA status
References: <20070703185116.59c8f5f5@the-village.bc.nu>
In-Reply-To: <20070703185116.59c8f5f5@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> Chipsets
> ========
> ARTOP
> 	No reports, but nobody appears to be using one

The NSLU2-Linux project (http://www.nslu2-linux.org) relies on the
pata-artop driver for the arm/ixp4xx-based Iomega NAS100d and D-Link
DSM-G600 NAS devices (both of which are supported in recent mainline
kernels).

Latest kernels (2.6.22-rc5 is the latest we've tested) have no reported
problems with pata-artop.  We have a handful of people (including
myself) who we know are using 2.6.22-rc5 on those devices and are
booting from the internal drive using the pata-artop driver.

I'm happy for anyone to contact me in the future if new versions of the
pata-artop driver need to be tested.  There are people using it :-)

> VIA
> 	Solid. Sent acpi patch for -mm to try and fix the one remaining
> 	mystery "how to spot VIA with onboard SATA bridges properly. If
> 	you've got a VIA board with SATA ports that appear as PATA
> 	channels please drop me an email as I'd like to get more info
> 	on what is affected.

Our project is also working on adding support to the kernel for the
Freecom FSG-3 NAS device.  It uses the sata-via driver for it's VIA_6421
chipset, but the main drive is a PATA drive (the device also has an
eSATA external port).

We're currently stuck at 2.6.18 with vendor patches for scsi/sata-via,
and would love to move to 2.6.22 and libata, but are having problems
with the latest sata-via driver for this chipset booting from an IDE
drive.  I'll contact you separately for this issue (as it's off-topic on
this thread).

Thanks,

-- Rod Whitby
-- NSLU2-Linux Project Lead
