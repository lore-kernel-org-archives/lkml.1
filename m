Return-Path: <linux-kernel-owner+w=401wt.eu-S1030608AbXBMAoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030608AbXBMAoN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 19:44:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030605AbXBMAoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 19:44:12 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:44662 "EHLO
	pd5mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030608AbXBMAoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 19:44:11 -0500
Date: Mon, 12 Feb 2007 18:43:24 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: SATA Drive No Longer Recognized In New 2.6.20 Kernel
In-reply-to: <fa.TnmEtAvuWo/QaHolplJ1wxgmx8A@ifi.uio.no>
To: Joseph Cosby <jo-cosby@hotmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <45D109AC.6080102@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.N6er7HcCs0nD4LsKNkIdtRxShpk@ifi.uio.no>
 <fa.TnmEtAvuWo/QaHolplJ1wxgmx8A@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joseph Cosby wrote:
> Hi,
> Until recently I was using the 2.6.18 kernel. I have a SATA hard drive
> that was detected by the kernel, using the PIIX driver. But after
> updating to 2.6.20, the hard drive is no longer detected by the kernel.
> I used make oldconfig to create the 2.6.20 config file, and I noticed a
> new option CONFIG_ATA. I did not use this, because as I understand it is
> not necessary and is experimental. Do I need to use this or is there
> something else in the new kernel that needs to be enabled for this
> driver?
> 
> My 2.6.20 config file follows.
> The hard drive has vendor ID 8086 and device ID 27c0. It is listed in the
> modules.pcilist file of 2.6.18 but not 2.6.20.
> 
> If anybody can share any advice please CC me in response.

Yes, you do need CONFIG_ATA if you were using ata_piix before (and of 
course the PIIX driver also needs to be enabled). All of the libata 
drivers were moved from under the SCSI menu into a new ATA menu (in 
2.6.19 I think).

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

