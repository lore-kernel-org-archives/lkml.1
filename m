Return-Path: <linux-kernel-owner+w=401wt.eu-S1753648AbYL3RkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbYL3RkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 12:40:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbYL3RkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 12:40:09 -0500
Received: from main.gmane.org ([80.91.229.2]:55109 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010AbYL3RkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 12:40:08 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: 2.6.27.10: ata1.00: HPA detected: current 293044655, native 
  293046768
Date: Tue, 30 Dec 2008 11:30:07 -0600
Message-ID: <495A5A9F.9020406@shaw.ca>
References: <alpine.DEB.1.10.0812300657050.11356@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
In-Reply-To: <alpine.DEB.1.10.0812300657050.11356@p34.internal.lan>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> On one system, two Raptor 150s:
> 
> [    0.739402] ata1.00: HPA detected: current 293044655, native 293046768
> [    0.739491] ata1.00: ATA-7: WDC WD1500ADFD-00NLR5, 21.07QR5, max 
> UDMA/133
> [    0.739577] ata1.00: 293044655 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [    0.742454] ata1.00: configured for UDMA/133
> 
> [    1.059146] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [    1.061406] ata2.00: ATA-7: WDC WD1500ADFD-00NLR5, 21.07QR5, max 
> UDMA/133
> [    1.061494] ata2.00: 293046768 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [    1.064360] ata2.00: configured for UDMA/133
> 
> Two disks in a RAID-1 (mdadm) configuration, how come the first one
> has an issue w/HPA as the firmware of both disks is the same..?
> 
> l1:~# smartctl -a /dev/sda | grep -i bytes
> User Capacity:    150,038,863,360 bytes
> l1:~# smartctl -a /dev/sdb | grep -i bytes
> User Capacity:    150,039,945,216 bytes
> l1:~#
> 
> Why does this occur?

Presumably somebody or something set up a host protected area on one 
drive and not the other.. I believe there are some utilities out there 
that can be used to disable the HPA and allow the full capacity to be used.

