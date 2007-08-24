Return-Path: <linux-kernel-owner+w=401wt.eu-S1763291AbXHXXh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763291AbXHXXh0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 19:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbXHXXhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 19:37:17 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:44054 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbXHXXhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 19:37:15 -0400
Date: Fri, 24 Aug 2007 17:36:17 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Possible problems reading a DVD-RAM disc
In-reply-to: <fa.pKJ1f/uGrEIrPt+FdyZwKxvM2Ws@ifi.uio.no>
To: TheOneKEA <theonekea@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <46CF6B71.7030001@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.pKJ1f/uGrEIrPt+FdyZwKxvM2Ws@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

TheOneKEA wrote:
> While doing a long mega-copy from one side of a DVD-RAM disc formatted
> with the vfat filesystem to an smbfs network share, I got lots and
> lots of these in the dmesg:
> 
> Buffer I/O error on device sr0, logical block 4396
> lost page write due to I/O error on sr0
> sr 6:0:0:0: [sr0] Result: hostbyte=0x00 driverbyte=0x08
> sr 6:0:0:0: [sr0] Sense Key : 0x7 [current]
> sr 6:0:0:0: [sr0] <<vendor>> ASC=0x92 ASCQ=0x0ASC=0x92 ASCQ=0x0
> end_request: I/O error, dev sr0, sector 17584
> Buffer I/O error on device sr0, logical block 4396
> lost page write due to I/O error on sr0

Well, the drive is reporting an error on a write to the disc. It's not 
an error code in the MMC5 standard, though, so presumably it's a 
vendor-specific error code.

Not sure why it would be writing to the disc though.. Maybe if the disc 
is mounted read-write it is doing last-access-time updates or something?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

