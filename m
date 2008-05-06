Return-Path: <linux-kernel-owner+w=401wt.eu-S1757180AbYEFXmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180AbYEFXmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 19:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762826AbYEFXmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 19:42:22 -0400
Received: from ribosome.natur.cuni.cz ([195.113.57.20]:33731 "EHLO
	ribosome.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762084AbYEFXmU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 19:42:20 -0400
Message-ID: <4820ECD4.2020500@ribosome.natur.cuni.cz>
Date: Wed, 07 May 2008 01:42:12 +0200
From: =?UTF-8?B?TWFydGluIE1PS1JFSsWg?= <mmokrejs@ribosome.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080328 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Robert Hancock <hancockr@shaw.ca>, Jan Engelhardt <jengelh@medozas.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23.17 & 2.6.24.5 and maybe earlier: pata_marvell: need to
 disable DMA to get rid of '(ATA bus error)', 'ata7.00: status: { DRDY ERR
 }', 'ata7.00: error: { ICRC ABRT }'
References: <fa.+9Q+WQnyiYTlpbXVIzn6aT2/gS0@ifi.uio.no>	<fa.fKUfeQYS9BFD60fOMormQ25ard4@ifi.uio.no>	<fa.QYXSW2xjSxf6xnmd0rQGJhHLnrc@ifi.uio.no>	<fa.qfeYSQtlsXzGvFvBQEdF9TFFpNg@ifi.uio.no>	<481BD12D.1030406@shaw.ca>	<4820529D.2040609@ribosome.natur.cuni.cz>	<20080506140825.759db8f2@core>	<4820711C.1010902@ribosome.natur.cuni.cz>	<20080506160452.61725e6c@core>	<48208647.3090500@ribosome.natur.cuni.cz> <20080506200421.64491c30@core>
In-Reply-To: <20080506200421.64491c30@core>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Tue, 06 May 2008 18:24:39 +0200
> Martin MOKREJŠ <mmokrejs@ribosome.natur.cuni.cz> wrote:
> 
>> Alan Cox wrote:
>>> O> /dev/sde:
>>>> ATA device, with non-removable media
>>>>         Model Number:       Delock 54111 512MB                      
>>>>         Serial Number:      
>>>>         Firmware Revision:  Ver1.27 
>>> Does seem to think its ATA not CFA I guess you'll need to specify pio for
>>> that device specifically.
>> Sorry for my ignorance ... How?
> 
> On a current kernel (Tejun only recently added this)
> 
> libata.force= ...
> 
> see Documentation/kernel-parameters.txt

Good, but as I have said, I am using 2.6.24.5 or below. According
to Google the patch was included in 2.6.25-rc3 so I am out of luck.

My original post:
http://www.gossamer-threads.com/lists/linux/kernel/914136?page=last

<quote>
I tried 'libata.force=7.00:pio4' but it did not help.
</quote>


And, nobody has so far asnwered my post with
Subject: 2.6.25: pata_marvell/ahci/libata regression: ata7: SATA link down (SStatus 0 SControl 300)

Basically, I cannot boot with 2.6.25. So I am stuck. Please
push the libata.force patch into 2.6.24 tree
(http://www.mail-archive.com/linux-ide@vger.kernel.org/msg15454.html).
Currently I can only use libata.dma=0.

