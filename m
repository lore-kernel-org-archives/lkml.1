Return-Path: <linux-kernel-owner+w=401wt.eu-S1756799AbYAaAgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799AbYAaAgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 19:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbYAaAgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 19:36:07 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:31328 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbYAaAgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 19:36:06 -0500
Date: Wed, 30 Jan 2008 18:35:18 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: intel ahci problem
In-reply-to: <fa.HTb3Q+Yq6ASOx5W2fwC4vZq2pik@ifi.uio.no>
To: Evgen L <evgen@b-k.ru>
Cc: linux-kernel@vger.kernel.org
Message-id: <47A117C6.2080205@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=KOI8-R; format=flowed
Content-transfer-encoding: 7bit
References: <fa.HTb3Q+Yq6ASOx5W2fwC4vZq2pik@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgen L wrote:
> Hi all
> 
> I have a problem with my Intel SR1550 server (S5000PAL motheboard, 
> SATA/SAS controller, 5 SATA HDD Seagate ST9120822AS ).
> The four drivers are in two md raid1, which striping by lvm and one 
> drive used separately. I have problem like below with two different 
> drives (ata3 or ata4) and ata5. I look problem like this with RedHat  
> 2.6.18-53 kernel, 2.6.24-rc8, and today 2.6.24-git5. I reading about any 
> problems like this in lkml.org. There can be this message will help to 
> fix this issue.
> The complete dmesg in attachment.
> 
> md: bind<sdd1>
> RAID1 conf printout:
> --- wd:1 rd:2
> disk 0, wo:0, o:1, dev:sdc1
> disk 1, wo:1, o:1, dev:sdd1
> md: recovery of RAID array md2
> md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> md: using maximum available idle IO bandwidth (but not more than 200000 
> KB/sec) for recovery.
> md: using 128k window, over a total of 117218176 blocks.
> ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata4.00: cmd e7/00:00:00:00:00/00:00:00:00:00/a0 tag 0
>         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata4.00: status: { DRDY }
> ata4: hard resetting link
> ata4: port is slow to respond, please be patient (Status 0x80)
> ata4: softreset failed (device not ready)
> ata4: hard resetting link
> ata4: port is slow to respond, please be patient (Status 0x80)
> ata4: softreset failed (device not ready)
> ata4: hard resetting link
> ata4: port is slow to respond, please be patient (Status 0x80)
> ata4: softreset failed (device not ready)
> ata4: limiting SATA link speed to 1.5 Gbps
> ata4: hard resetting link
> ata4: softreset failed (device not ready)
> ata4: reset failed, giving up
> ata4.00: disabled

Are you sure this is not a hardware problem (bad disk, cable, etc?) Is 
it always ata4 that fails?
