Return-Path: <linux-kernel-owner+w=401wt.eu-S964888AbXBTEHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964888AbXBTEHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 23:07:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965650AbXBTEHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 23:07:55 -0500
Received: from nz-out-0506.google.com ([64.233.162.226]:61788 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964888AbXBTEHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 23:07:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=o7fZ5aDPCJshrKm1HJZIJNvb8oWreOb6xFoNitU7Wiyp2mHNc2JweVKXarj7eQl8yRkN5qrWwZz3bhVJVeFIewjfzffQQguocCftiZLC1jtdJ0P6/FINYQVQFhD+kYZKwh04BzuRrPdyLWYo3BsjTHkD0lMCBhrAx0/VuM/c1gI=
Message-ID: <45DA7416.4040101@gmail.com>
Date: Tue, 20 Feb 2007 13:07:50 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: auxsvr@gmail.com
CC: linux-kernel@vger.kernel.org
Subject: Re: ata command timeout
References: <200702192119.50954.auxsvr@gmail.com>
In-Reply-To: <200702192119.50954.auxsvr@gmail.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

auxsvr@gmail.com wrote:
> Hello,
> 
> I have been running 2.6.18 for two months and the last couple of days these 
> error messages have appeared in my logs 
> (sata_promise kernel module, sda:SATA sdb:PATA disks):
> 
>                                                ata1: command timeout
> Feb 17 22:23:14 linux kernel: ata1: no sense translation for status: 0x40
> Feb 17 22:23:14 linux kernel: ata1: translated ATA stat/err 0x40/00 to SCSI 
> SK/ASC/ASCQ 0xb/00/00
> Feb 17 22:23:14 linux kernel: ata1: status=0x40 { DriveReady }
> Feb 17 22:23:14 linux kernel: sd 0:0:0:0: SCSI error: return code = 0x08000002
> Feb 17 22:23:14 linux kernel: sda: Current: sense key: Aborted Command
> Feb 17 22:23:14 linux kernel:     Additional sense: No additional sense 
> information
> Feb 17 22:23:14 linux kernel: end_request: I/O error, dev sda, sector 
> 145179585
> Feb 17 22:23:14 linux kernel: Buffer I/O error on device sda2, logical block 
> 2787300
> Feb 17 22:23:14 linux kernel: lost page write due to I/O error on sda2
> 
> and 
> 
>                                                ata1: command timeout
> Feb 19 20:39:31 linux kernel: ata1: no sense translation for status: 0x40
> Feb 19 20:39:31 linux kernel: ata1: translated ATA stat/err 0x40/00 to SCSI 
> SK/ASC/ASCQ 0xb/00/00
> Feb 19 20:39:31 linux kernel: ata1: status=0x40 { DriveReady }
> Feb 19 20:39:31 linux kernel: sd 0:0:0:0: SCSI error: return code = 0x08000002
> Feb 19 20:39:31 linux kernel: sda: Current: sense key: Aborted Command
> Feb 19 20:39:31 linux kernel:     Additional sense: No additional sense 
> information
> Feb 19 20:39:31 linux kernel: end_request: I/O error, dev sda, sector 89553479
> 
> without any other ill-effects that I know of(I did smart tests on the drive; 
> all passed successfully).
> I have read that hddtemp may be the cause of this (I am running version 0.3) 
> so is there any reason
> to worry and prepare for a HDD replacement?

Not really.  If the problem occurs very infrequently, you don't need to
worry about it too much.  Command timeouts do occur on otherwise healthy
systems from time to time.

-- 
tejun
