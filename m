Return-Path: <linux-kernel-owner+w=401wt.eu-S933195AbXFEPdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933195AbXFEPdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 11:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932676AbXFEPdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 11:33:32 -0400
Received: from rtr.ca ([64.26.128.89]:3770 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932425AbXFEPdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 11:33:31 -0400
Message-ID: <46658249.8030606@rtr.ca>
Date: Tue, 05 Jun 2007 11:33:29 -0400
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: David Greaves <david@dgreaves.com>
Cc: Tejun Heo <htejun@gmail.com>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       IDE Linux <linux-ide@vger.kernel.org>, ballen@gravity.phys.uwm.edu
Subject: Re: 2.6.22-rc3 hibernate(?) disables SMART on ide
References: <46609290.5030701@dgreaves.com> <46613C53.8010205@gmail.com> <4661E6CA.1080203@dgreaves.com> <46643DE5.3080904@rtr.ca> <46644A71.7060300@dgreaves.com> <4664E3F5.9080904@rtr.ca> <466526FA.3090506@dgreaves.com>
In-Reply-To: <466526FA.3090506@dgreaves.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Greaves wrote:
> Mark Lord wrote:
>> That's odd.  Could you try that again,
>> with the latest (either v7.3 or v7.4) version of hdparm
>> (from sourceforge) ?
> 
> Using Debian's 7.3 via apt-get experimental - is that OK or would you like me to
> compile the upstream?

No, what you have is good, thanks.

> cu:~# hdparm -K1 /dev/hda
> 
> /dev/hda:
>  setting drive keep features to 1 (on)
>  HDIO_DRIVE_CMD(keepsettings) failed: Input/output error
> 
> dmesg:
> skge eth0: Link is up at 1000 Mbps, full duplex, flow control both
> hda: drive_cmd: status=0x51 { DriveReady SeekComplete Error }
> hda: drive_cmd: error=0x04 { DriveStatusError }
> ide: failed opcode was: 0xef

I just find it odd that the drive rejects the command,
but Seagate do seem to be the first to drop older features nowadays.
But I thought their PATA units might have kept that functionality.

I have some modern seagate SATA drives here -- I'll try it on those too,
just for my own education.

Thanks.
