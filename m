Return-Path: <linux-kernel-owner+w=401wt.eu-S1765437AbYEAVZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765437AbYEAVZE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 17:25:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760856AbYEAVYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 17:24:55 -0400
Received: from ribosome.natur.cuni.cz ([195.113.57.20]:46755 "EHLO
	ribosome.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693AbYEAVYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 17:24:54 -0400
Message-ID: <481A3518.5030308@ribosome.natur.cuni.cz>
Date: Thu, 01 May 2008 23:24:40 +0200
From: =?UTF-8?B?TWFydGluIE1PS1JFSsWg?= <mmokrejs@ribosome.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080328 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23.17 & 2.6.24.5 and maybe earlier: pata_marvell: need to
 disable DMA to get rid of '(ATA bus error)', 'ata7.00: status: { DRDY ERR
 }', 'ata7.00: error: { ICRC ABRT }'
References: <4819FDAF.7050005@ribosome.natur.cuni.cz> <20080501200851.2e14d3b8@core>
In-Reply-To: <20080501200851.2e14d3b8@core>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Alan Cox wrote:
>> To get rid of the errors, I can use libata.dma=0 kernel
>> command-line parameter. Unfortunately, this sets all libata
>> devices to PIO4 mode. How can I set just this one? I tried
>> 'libata.force=7.00:pio4' but it did not help.
> 
> libata.dma=3 will stop DMA being used for CF devices (except those that
> decide to pretend to be ATA classes). This one comes up a lot as many CF
> adapters are simply not adequate for UDMA.
> 
>> Where are the flags documented? linux/Documentation/ directory
>> contains almost nothing about pata_marvell. :(
> 
> The flags are all common across drivers.

Oh, please tell me where can I read more. ;-) What does the number
3 mean? How can I force certain parameters over ata7.00 device only?

Thanks!
Maritn
