Return-Path: <linux-kernel-owner+w=401wt.eu-S932647AbXBQFGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932647AbXBQFGm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 00:06:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932651AbXBQFGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 00:06:42 -0500
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:29844 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932647AbXBQFGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 00:06:41 -0500
In-Reply-To: <45D639F3.8030609@shaw.ca>
References: <fa.bxsB54F+7+006rE+o/VWUj5keQk@ifi.uio.no> <45D639F3.8030609@shaw.ca>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <92CB3192-9176-4D30-B818-16A9C979F5E9@kernel.crashing.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: 2.6.20 kernel hang with USB drive and vfat doing ftruncate
Date: Fri, 16 Feb 2007 23:05:43 -0600
To: Robert Hancock <hancockr@shaw.ca>
X-Mailer: Apple Mail (2.752.2)
X-PopBeforeSMTPSenders: kumar-chaos@kgala.com,kumar-statements@kgala.com,kumar@kgala.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - nommos.sslcatacombnetworking.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.crashing.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 16, 2007, at 5:10 PM, Robert Hancock wrote:

> Kumar Gala wrote:
>> I'm seeing an issue with a stock 2.6.20 kernel running on an  
>> embedded PPC.  I've got a usb flash drive plugged in and the  
>> filesystem on the drive is vfat.  Running with 64M and no swap.
>> If I execute a series of large (100M+) ftruncate() on the disk the  
>> kernel will hang and never return.  It seems to be stuck in the  
>> idle loop().
>
> On FAT filesystems this forces the entire file contents of that  
> size to be written out with zeros. Are you sure the kernel just  
> isn't busy writing out all that data to the disk?

I'm pretty sure, seeing as if I run the test it takes maybe 20-30  
seconds to create the file if it succeeds.  However, I've weighted 10  
minutes and still no prompt.

I'm also able to break in with a HW debugger and am always in the  
idle loop.

- k
