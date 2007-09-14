Return-Path: <linux-kernel-owner+w=401wt.eu-S1758419AbXINU2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758419AbXINU2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 16:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbXINU2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 16:28:42 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:33059 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbXINU2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 16:28:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=Z7DNhPslHIhJuzp1ZKiGb/Re8R5O4IbnpZDgsHKi8O/a3j7nRZ7+pFOJtNz8FtmQDJM1iadMKy1XJ7JyMqCxoCtKSjeSkkG8Bb96srLF4MYLDvVgzjQCiO11U/JGeJ5njVgv2XHbSr/tOl2AObhvJn5F4Dlp3pC+gPaeHLyGWqg=
From: auxsvr@gmail.com
To: linux-kernel@vger.kernel.org
Subject: Re: sata_nv issues with MCP51 SATA controller
Date: Fri, 14 Sep 2007 23:24:49 +0300
User-Agent: KMail/1.9.5
References: <46E8EABF.3060409@pvv.org> <46EAAF99.6030809@garzik.org> <46EAD526.1040601@pvv.org>
In-Reply-To: <46EAD526.1040601@pvv.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200709142324.50263.auxsvr@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I get a similar, if not identical, problem with an ASUS A8N SLI nforce4 based 
motherboard. The PC (with a seagate SATA-2 120 GB HDD) ran fine for two 
years , last Christmas windows xp (I didn't change either hardware or 
drivers) started crashing and the filesystem got corrupted beyond repair 
within 8 hours after every installation. The system log contained entries 
about bad sectors and, based on the seagate diagnosis tool, I returned the 
system to the supplier. According to the retail shop, neither the disk nor 
the system had any problems, so I was coerced to pay for a replacement disk. 
The replacement HDD (seagate again, 120 GB) ran fine until a month ago (this 
time the system is connected to a UPS), when the same problem occurred! I 
moved the disk to a linux system with the promise tx2plus controller (the one 
I'm typing this from), found bad sectors, formatted it and everything works 
fine for at least 6 hours of continuous disk writes and reads in this system. 
If I return the disk to the nforce4 system, it becomes corrupted within some 
hours of disk access, no matter whether linux or windows is installed, 
regardless of NCQ settings, drivers and cables.

The symptoms are the same in both cases: the system crashes, then runs for 
some hours, then the controller stops completely responding (ata1: exception 
Emask 0x10 SAct 0x0 SErr 0x1810000 action 0x2 frozen is the first error 
message), the disk access LED blinks continuously, linux 2.6.18 (opensuse 
10.2) throws lots of error messages similar to the ones you mention above, 
linux says that the device is dead and the system becomes unusable (no disk 
access). After a reboot, the filesystem is fine for some time, afterwards 
similar error messages appear, seek errors appear and the filesystem becomes 
completely destroyed. The positive part of this ordeal is that the linux SATA 
error handling works fine and linux recovered the first time, without access 
to the drive of course, while windows crashed badly and I was unable to find 
out what was happening in the beginning.

I cannot say with certainty that this is a hardware error or damage, seagate 
technical support insists that their HDD is at fault, which is obviously 
wrong, the PC is (after the second incident) connected to a UPS and was 
checked by the service at the shop, and the most weird thing I cannot 
explain is that the system ran fine for 8 months after I changed the 
disk, even though the disk wasn't damaged! Either the motherboard is damaged 
or faulty (how can you explain that it ran fine for 8 months after I changed 
the disk?)  or there is some very weird interaction with the HDD and the SATA 
controller, which isn't unlikely, considering the problems reported about 
combinations of nforce4 and maxtor HDDs, yet still doesn't explain the 2 year 
and 8 month period of normal operation. I'm going to contact the service 
again and see how this comes out.
