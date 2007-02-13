Return-Path: <linux-kernel-owner+w=401wt.eu-S1750700AbXBMOqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750700AbXBMOqB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 09:46:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750704AbXBMOqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 09:46:00 -0500
Received: from roc.holo.8d.com ([64.254.227.115]:35963 "EHLO roc.holo.8d.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750700AbXBMOqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 09:46:00 -0500
Message-ID: <45D1CF22.6010706@8d.com>
Date: Tue, 13 Feb 2007 09:45:54 -0500
From: Raphael Assenat <raph@8d.com>
User-Agent: Mozilla Thunderbird 1.0 (X11/20050118)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add PCI device ID for IT8152 RISC-to-PCI chip
References: <45CCD60D.5050001@8d.com> <20070209212856.GK7584@csclub.uwaterloo.ca>
In-Reply-To: <20070209212856.GK7584@csclub.uwaterloo.ca>
X-Enigmail-Version: 0.89.5.0
X-Enigmail-Supports: pgp-inline, pgp-mime
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -2.6
X-Spam-Report: -2.6 points, 5.0 required autolearn=ham
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:
> On Fri, Feb 09, 2007 at 03:14:05PM -0500, Raphael Assenat wrote:
> 
>>This patch adds a PCI device ID (0x8152) for the IT8152F/G
>>Advanced RISC-to-PCI Companion Chip.
>>
>>-- 
>>Raphael Assenat
>>8D Technologies Inc.
> 
> 
>>This patch adds a PCI device ID for the IT8152F/G 
>>Advanced RISC-to-PCI Companion Chip.
>>
>>Signed-off-by: Raphael Assenat <raph@8d.com>
>>
>>--- linux-2.6.20/include/linux/pci_ids.h	2007-02-04 13:44:54.000000000 -0500
>>+++ linux-2.6.20-8d/include/linux/pci_ids.h	2007-02-09 15:00:38.000000000 -0500
>>@@ -1626,6 +1626,7 @@
>> #define PCI_VENDOR_ID_ROCKWELL		0x127A
>> 
>> #define PCI_VENDOR_ID_ITE		0x1283
>>+#define PCI_DEVICE_ID_ITE_8152		0x8152
>> #define PCI_DEVICE_ID_ITE_8211		0x8211
>> #define PCI_DEVICE_ID_ITE_8212		0x8212
>> #define PCI_DEVICE_ID_ITE_8872		0x8872
> 
> 
> Oh that one.  Anyone ever have a reliable PCI bus with one of these?
> The one system on a board I have worked with in the past had so many
> problems with the PCI bus that we have to switch to another board
> instead.  Too bad since the ARM cpu was much faster and better and
> handling network traffic (we switched to a Geode SC1200 based board).
> 
> At the time my theory was that the cpu would interrupt DMA transfers
> when it wanted access to system memory, which would break the PCI
> transfers.  But that was just my theory.
Really? I have no idea if it's possible to get a reliable PCI bus or
not with this chip. Right now, we only use it for it's built-in OHCI 
USB host controller and UART. You're making me hope I never have to 
use it for interfacing a PCI card!

Best regards,

-- 
Raphael Assenat
8D Technologies Inc.
