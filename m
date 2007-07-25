Return-Path: <linux-kernel-owner+w=401wt.eu-S1765206AbXGYXMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765206AbXGYXMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 19:12:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760295AbXGYXL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 19:11:58 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:65142 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759998AbXGYXL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 19:11:57 -0400
Date: Wed, 25 Jul 2007 17:12:55 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: very big device. try to use READ CAPACITY(16)
In-reply-to: <fa.zVvXcMRLRvR5DEG+ZLYeulb/+oA@ifi.uio.no>
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: linux-kernel@vger.kernel.org
Message-id: <46A7D8F7.7030002@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-2; format=flowed
Content-transfer-encoding: 7bit
References: <fa.zVvXcMRLRvR5DEG+ZLYeulb/+oA@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arkadiusz Miskiewicz wrote:
> Hello,
> 
> What does "very big device. try to use READ CAPACITY(16)" mean for user? Is 
> this advice for driver developer or for user (if for user then what does it 
> mean exactly) ?

It isn't really advice at all, just indicates that the sd driver needed 
to use the bigger version of READ CAPACITY for that device. It looks 
like that message has now been reworded to "trying to use" instead of 
"try to use", so it doesn't sound like it's saying the user has to do 
something.

> 
> 
> sdc : very big device. try to use READ CAPACITY(16).
> SCSI device sdc: 4823210240 512-byte hdwr sectors (2469484 MB)
> sdc: Write Protect is off
> sdc: Mode Sense: 00 12 00 00
> SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support 
> DPO or FUA
> sdc : very big device. try to use READ CAPACITY(16).
> SCSI device sdc: 4823210240 512-byte hdwr sectors (2469484 MB)
> sdc: Write Protect is off
> sdc: Mode Sense: 00 12 00 00
> SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support 
> DPO or FUA
>  sdc: unknown partition table
> sd 0:2:0:0: Attached scsi disk sdc
> 
> 2.6.21.6, stex driver
> 

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

