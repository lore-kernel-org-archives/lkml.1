Return-Path: <linux-kernel-owner+w=401wt.eu-S1757420AbXIZKEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbXIZKEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 06:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754821AbXIZKEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 06:04:32 -0400
Received: from mailout08.sul.t-online.de ([194.25.134.20]:55201 "EHLO
	mailout08.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754658AbXIZKEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 06:04:31 -0400
Message-ID: <46FA2E84.90708@t-online.de>
Date: Wed, 26 Sep 2007 12:03:48 +0200
From: Bernd Schmidt <bernds_cb1@t-online.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070810)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: "Berck E. Nash" <flyboy@gmail.com>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-rc7-mm1 AHCI ATA errors -- won't boot
References: <46F7FBCB.4030803@gmail.com> <46F9E2CB.9000002@garzik.org>
In-Reply-To: <46F9E2CB.9000002@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: S+JbQkZSghuBoKtkmVB5DzYEcDyfUe9m0sYQfVs14LKu4MzSOPOKYcU1yfSclAEwPD
X-TOI-MSGID: f328cb85-93a3-4f5f-8e99-23b5dcb5b24c
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Would it also be possible for you to send along 'hdparm --Istdout' 
> output for your config disk thingy, /dev/sdd ?

One of these appears in my system as well (ASUS P5W-DH Deluxe 
mainboard).  Here's the hdparm output:

/dev/sdb:
0040 3fff c837 0010 0000 0000 003f 0000
0000 0000 3030 3030 3030 305f 5f5f 5f5f
5f5f 5f5f 5f30 5f41 0003 3e00 0004 5247
4c31 3033 3634 436f 6e66 6967 2020 4469
736b 2020 2020 2020 2020 2020 2020 2020
2020 2020 2020 2020 2020 2020 2020 8001
0000 2f00 4000 0200 0000 0007 3fff 0010
003f fc10 00fb 0101 0280 0000 0000 0407
0003 0078 0078 0078 0078 0000 0000 0000
0000 0000 0000 0000 0201 0000 0000 0000
007e 001b 0068 5060 4000 0000 1000 4000
407f 0000 0000 0000 fffe 0000 c0fe 0000
0000 0000 0000 0000 0001 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0001 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0017 2040
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 baa5

Since about 2.6.17 or 2.6.18, it has been causing long delays while booting:
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: qc timeout (cmd 0xec)
ata2.00: failed to IDENTIFY (I/O error, err_mask=0x5)
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: COMRESET failed (errno=-16)
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: ATA-6: Config  Disk, RGL10364, max UDMA/133
ata2.00: 640 sectors, multi 1: LBA
ata2.00: configured for UDMA/133


Bernd
