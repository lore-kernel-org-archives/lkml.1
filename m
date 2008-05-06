Return-Path: <linux-kernel-owner+w=401wt.eu-S1764267AbYEFOyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764267AbYEFOyo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 10:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763024AbYEFOya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 10:54:30 -0400
Received: from ribosome.natur.cuni.cz ([195.113.57.20]:49947 "EHLO
	ribosome.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763003AbYEFOy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 10:54:27 -0400
Message-ID: <4820711C.1010902@ribosome.natur.cuni.cz>
Date: Tue, 06 May 2008 16:54:20 +0200
From: =?UTF-8?B?TWFydGluIE1PS1JFSsWg?= <mmokrejs@ribosome.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080328 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Robert Hancock <hancockr@shaw.ca>, Jan Engelhardt <jengelh@medozas.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23.17 & 2.6.24.5 and maybe earlier: pata_marvell: need to
 disable DMA to get rid of '(ATA bus error)', 'ata7.00: status: { DRDY ERR
 }', 'ata7.00: error: { ICRC ABRT }'
References: <fa.+9Q+WQnyiYTlpbXVIzn6aT2/gS0@ifi.uio.no>	<fa.fKUfeQYS9BFD60fOMormQ25ard4@ifi.uio.no>	<fa.QYXSW2xjSxf6xnmd0rQGJhHLnrc@ifi.uio.no>	<fa.qfeYSQtlsXzGvFvBQEdF9TFFpNg@ifi.uio.no>	<481BD12D.1030406@shaw.ca>	<4820529D.2040609@ribosome.natur.cuni.cz> <20080506140825.759db8f2@core>
In-Reply-To: <20080506140825.759db8f2@core>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Alan Cox wrote:
>> ata7.00: ATA-0: Delock 54111 512MB, Ver1.27, max UDMA/33
>> ata7.00: 1006992 sectors, multi 0: LBA 
> 
> For some reason your CF card seems to think it is an ATA device not a CFA
> device. What does the identify data for it look like (hdparm -I)

# hdparm -I /dev/sde

/dev/sde:

ATA device, with non-removable media
        Model Number:       Delock 54111 512MB                      
        Serial Number:      
        Firmware Revision:  Ver1.27 
Standards:
        Likely used: 4
Configuration:
        Logical         max     current
        cylinders       999     999
        heads           16      16
        sectors/track   63      63
        --
        bytes/track: 32256      bytes/sector: 512
        CHS current addressable sectors:    1006992
        LBA    user addressable sectors:    1006992
        device size with M = 1024*1024:         491 MBytes
        device size with M = 1000*1000:         515 MBytes 
Capabilities:
        LBA, IORDY(may be)(cannot be disabled)
        Buffer size: 1.0kB      bytes avail on r/w long: 4
        Standby timer values: spec'd by Vendor
        R/W multiple sector transfer: Max = 1   Current = 0
        DMA: mdma0 mdma1 mdma2 udma0 *udma1 udma2 
             Cycle time: min=120ns recommended=120ns
        PIO: pio0 pio1 pio2 pio3 pio4 
             Cycle time: no flow control=120ns  IORDY flow control=120ns
Security: 
                supported
        not     enabled
        not     locked
        not     frozen
        not     expired: security count
                supported: enhanced erase
#
