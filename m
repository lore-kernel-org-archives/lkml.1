Return-Path: <linux-kernel-owner+w=401wt.eu-S933034AbXIAXnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933034AbXIAXnu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 19:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757620AbXIAXnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 19:43:41 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:30253 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757547AbXIAXnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 19:43:40 -0400
Date: Sat, 01 Sep 2007 17:42:30 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: read-only /sys/block/sda/device/queue_depth
In-reply-to: <fa.opJB7DxTb+exFimOMpdmVACjitE@ifi.uio.no>
To: Yan Seiner <yan@seiner.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <46D9F8E6.8010101@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-2; format=flowed
Content-transfer-encoding: 7bit
References: <fa.opJB7DxTb+exFimOMpdmVACjitE@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yan Seiner wrote:
> I'm running into the same issue reported here:
> 
> <http://readlist.com/lists/vger.kernel.org/linux-kernel/72/361184.html>
> 
> I am using the ata_piix module.  If I read the docs correctly, I should 
> be able to use ahci as well; I need to rebuild the kernel though (debian 
> insists on putting ata_piix into the initrd....)
> 
> dionysus:~# ls -l /sys/block/sd[abcde]/device/queue_depth
> -r--r--r-- 1 root root 4096 2007-09-01 06:00 
> /sys/block/sda/device/queue_depth
> -r--r--r-- 1 root root 4096 2007-09-01 06:00 
> /sys/block/sdb/device/queue_depth
> -r--r--r-- 1 root root 4096 2007-09-01 06:00 
> /sys/block/sdc/device/queue_depth
> -r--r--r-- 1 root root 4096 2007-09-01 06:00 
> /sys/block/sdd/device/queue_depth
> -r--r--r-- 1 root root 4096 2007-09-01 06:00 
> /sys/block/sde/device/queue_depth
> 
> If I change the perms to rw, I get an Input/Output error.  AFAICT, the 
> drives support queueing, but it's disabled.

ata_piix does not support NCQ. You have to use AHCI mode for that.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

