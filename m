Return-Path: <linux-kernel-owner+w=401wt.eu-S932535AbXHEFLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535AbXHEFLR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 01:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbXHEFLB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 01:11:01 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:11971 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbXHEFLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 01:11:01 -0400
Date: Sat, 04 Aug 2007 23:10:50 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: spurious NCQ completions from FUJITSU MHW2120BH
In-reply-to: <fa.y0XijGKloFk3CDz3kVQUCU51GDU@ifi.uio.no>
To: Cal Peake <cp@absolutedigital.net>
Cc: Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Message-id: <46B55BDA.1080900@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 8BIT
References: <fa.+Y6uPNp+jT45Cb8RRlG6/M5Gw1I@ifi.uio.no>
 <fa.y0XijGKloFk3CDz3kVQUCU51GDU@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cal Peake wrote:
> On Fri, 3 Aug 2007, Meelis Roos wrote:
> 
>> Todays git gave me some EH errors during fsck (30 times mounted and time 
>> to check), then recovered and works fine. Seems to be spurious NCQ 
>> completion. The disk is
>>
>> Device Model:     FUJITSU MHW2120BH
>> Firmware Version: 00000012
>> User Capacity:    120�034�123�776 bytes
> 
> As a data point: I've got the same drive w/ same revision in my laptop and 
> haven't had any NCQ errors pop up. Currently running 2.6.23-rc2.
> 
>  ata1.00: ATA-8: FUJITSU MHW2120BH, 00000012, max UDMA/100
>  ata1.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 0/32)
>  ata1.00: configured for UDMA/100
> 
> Might be dependent on the controller and/or the driver. Got a nVidia MCP51 
> using sata_nv here.

That would be because you're not using NCQ. Patches to add NCQ support 
for MCP51 are only in -mm tree, not in mainline.

Also, AHCI is the only controller type that is easily able to detect this..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

