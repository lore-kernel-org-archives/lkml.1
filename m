Return-Path: <linux-kernel-owner+w=401wt.eu-S1753783AbYGYGde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbYGYGde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 02:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751624AbYGYGd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 02:33:27 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:24376 "EHLO
	pd6mo1no-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751027AbYGYGd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 02:33:27 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=s4iqQIGtSRUGZ3Qmbw8A:9 a=v4lzy1jRXkewvtap5hEPbh2qiTgA:4 a=l5CJCkEaLgEA:10 a=MOvHZsPHpEQA:10
Message-ID: <488973B1.2050906@shaw.ca>
Date: Fri, 25 Jul 2008 00:33:21 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Jeffrey Baker <jwbaker@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24 + ICH8M + high SATA load == death
References: <fa.jLiwalGvgxgx1tE0LwecyOikre0@ifi.uio.no>
In-Reply-To: <fa.jLiwalGvgxgx1tE0LwecyOikre0@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeffrey Baker wrote:
> On 2.6.24 with a SATA controller: Intel Corporation 82801HBM/HEM
> (ICH8M/ICH8M-E) SATA AHCI Controller (rev 03) and a   Vendor: ATA
> Model: SAMSUNG MCBQE32G Rev: PS10 flash disk, I get this error when
> doing 32 parallel runs of pgbench:
> 
> ata1.00: exception Emask 0x10 SAct 0x0 SErr 0x50000 action 0xa frozen
> ata1.00: irq_stat 0x00400001, PHY RDY changed
> ata1: SError: { PHYRdyChg CommWake }
> ata1.00: cmd c8/00:10:67:38:97/00:00:00:00:00/e1 tag 0 dma 8192 in
>          res 50/00:00:76:38:97/00:00:00:00:00/e1 Emask 0x10 (ATA bus error)
> ata1.00: status: { DRDY }
> 
> Afterwards the machine was in some kind of bad state where it would do
> only about 1MB/s to the disk, and I had to power it off.
> 
> Basically I have no idea what any of that gibberish means.  Note that
> this device is about 80 times faster than the spinning disk it
> replaced, so it may be stressing parts of the software that are not
> normally stressed.  Note also that it could just be crap hardware.  I
> don't really know.  However, I do note that someone recently posted a
> very similar error using Western Digital disks and the same SATA
> controller.  I don't think the problem is cables, since this is a
> laptop.  Any advice welcome.

PHYRdyChg in SError basically means that the controller detected that 
the drive disconnected or lost communication with it. Almost certainly a 
hardware problem of some sort. Power issue, perhaps?
