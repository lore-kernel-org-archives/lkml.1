Return-Path: <linux-kernel-owner+w=401wt.eu-S1761048AbYEAXvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761048AbYEAXvW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 19:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754165AbYEAXvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 19:51:14 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:54703 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910AbYEAXvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 19:51:14 -0400
Date: Fri, 2 May 2008 01:51:12 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: =?UTF-8?Q?Martin_MOKREJ=C5=A0?= <mmokrejs@ribosome.natur.cuni.cz>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23.17 & 2.6.24.5 and maybe earlier: pata_marvell: need to
 disable DMA to get rid of '(ATA bus error)', 'ata7.00: status: { DRDY ERR
 }', 'ata7.00: error: { ICRC ABRT }'
In-Reply-To: <20080501200851.2e14d3b8@core>
Message-ID: <alpine.LNX.1.10.0805020150460.6463@fbirervta.pbzchgretzou.qr>
References: <4819FDAF.7050005@ribosome.natur.cuni.cz> <20080501200851.2e14d3b8@core>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 2008-05-01 21:08, Alan Cox wrote:

>> To get rid of the errors, I can use libata.dma=0 kernel
>> command-line parameter. Unfortunately, this sets all libata
>> devices to PIO4 mode. How can I set just this one? I tried
>> 'libata.force=7.00:pio4' but it did not help.
>
>libata.dma=3 will stop DMA being used for CF devices (except those that
>decide to pretend to be ATA classes). This one comes up a lot as many CF
>adapters are simply not adequate for UDMA.

Perhaps the kernel could do this automatically once it sees the
status code?
