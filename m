Return-Path: <linux-kernel-owner+w=401wt.eu-S1423038AbXBBBEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423038AbXBBBEP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 20:04:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161131AbXBBBEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 20:04:15 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:24271 "EHLO
	pd5mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161122AbXBBBEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 20:04:14 -0500
Date: Thu, 01 Feb 2007 18:59:53 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: smp and irq conflict
In-reply-to: <45C0FAE300242D46@vsmtp14.tin.it>
To: Lapo TIN <lapolapolapo@tin.it>
Cc: james.garcia@lausd.net, linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <45C28D09.4030506@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <45C0FAE300242D46@vsmtp14.tin.it>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lapo TIN wrote:
> I need to capture at 25 frame per second from each channel...
> So 25 x 8 total frames per second on the pci.
> 
> 
> So do you think I have to change the motherboard ?
> What is important ? the chipset ? is there specification I need ?

What resolution are you using? 720x480 with 24 bits per pixel and 25fps 
will use about 25MB/sec on the PCI bus, there is no way you can keep up 
with 8 channels running on a standard 32-bit 33MHz PCI bus which can 
only transfer 133 MB/sec at most. If you need this much transfer rate, 
you likely need PCI Express or PCI-X capture cards or at least a 
motherboard which has multiple PCI buses (which most desktop boards 
don't typically have).

You may be able to reduce the resolution and/or frame rate in order to 
allow the PCI bus to cope. Also, do you have enough CPU and disk speed 
in order to cope with all these streams?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

