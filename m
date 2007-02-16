Return-Path: <linux-kernel-owner+w=401wt.eu-S1751656AbXBPXOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656AbXBPXOZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 18:14:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbXBPXOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 18:14:24 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:63670 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbXBPXOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 18:14:24 -0500
Date: Fri, 16 Feb 2007 17:10:43 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: 2.6.20 kernel hang with USB drive and vfat doing ftruncate
In-reply-to: <fa.bxsB54F+7+006rE+o/VWUj5keQk@ifi.uio.no>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Message-id: <45D639F3.8030609@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.bxsB54F+7+006rE+o/VWUj5keQk@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala wrote:
> I'm seeing an issue with a stock 2.6.20 kernel running on an embedded 
> PPC.  I've got a usb flash drive plugged in and the filesystem on the 
> drive is vfat.  Running with 64M and no swap.
> 
> If I execute a series of large (100M+) ftruncate() on the disk the 
> kernel will hang and never return.  It seems to be stuck in the idle 
> loop().

On FAT filesystems this forces the entire file contents of that size to 
be written out with zeros. Are you sure the kernel just isn't busy 
writing out all that data to the disk?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

