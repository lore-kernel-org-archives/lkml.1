Return-Path: <linux-kernel-owner+w=401wt.eu-S1755723AbYDJKpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723AbYDJKpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 06:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbYDJKpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 06:45:40 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38903 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754433AbYDJKpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 06:45:38 -0400
Message-ID: <47FDEFC8.9070105@garzik.org>
Date: Thu, 10 Apr 2008 06:45:28 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: [BUG] linux-next: Tree for April 10 - kernel panic while loading
 ata driver on powermac
References: <20080410181404.b76939a6.sfr@canb.auug.org.au> <47FDEAFA.10407@linux.vnet.ibm.com>
In-Reply-To: <47FDEAFA.10407@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kamalesh Babulal wrote:
> Hi Stephen,
> 
> The next-20080410 kernel panics while bootup over the PowerMac G5 box, while
> loading the ATA driver.

IDE driver, you mean.


> [    3.704000] NIP [c0000000000222a8] ._insw_ns+0x10/0x30
> [    3.704000] LR [c00000000021cd10] .ata_input_data+0x1f4/0x264
> [    3.704000] Call Trace:

> [    3.704000] [c0000002760db3b0] [c00000000021fc34] .try_to_identify+0x298/0x690
> [    3.704000] [c0000002760db470] [c000000000220168] .do_probe+0x13c/0x2f0
> [    3.704000] [c0000002760db510] [c00000000022059c] .ide_probe_port+0x280/0x670
> [    3.704000] [c0000002760db5e0] [c000000000220d84] .ide_device_add_all+0x2f8/0x670
> [    3.704000] [c0000002760db690] [c000000000221160] .ide_device_add+0x64/0x74

> [    3.704000] [c0000002760db930] [c00000000019241c] .pci_device_probe+0x10c/0x184
> [    3.704000] [c0000002760db9e0] [c0000000002068ac] .driver_probe_device+0x120/0x1e4
> [    3.704000] [c0000002760dba70] [c0000000002069d0] .__driver_attach+0x60/0xa4
> [    3.704000] [c0000002760dbb00] [c0000000002050e8] .bus_for_each_dev+0x7c/0xcc
> [    3.704000] [c0000002760dbbb0] [c000000000206388] .driver_attach+0x28/0x40
> [    3.704000] [c0000002760dbc30] [c000000000206154] .bus_add_driver+0xd4/0x274
> [    3.704000] [c0000002760dbcd0] [c000000000206f04] .driver_register+0x90/0x14c
> [    3.704000] [c0000002760dbd70] [c000000000191c80] .__pci_register_driver+0x68/0xc8
> [    3.704000] [c0000002760dbe10] [c0000000003ccfb8] .pmac_ide_probe+0x48/0x94

Regards,

	Jeff



