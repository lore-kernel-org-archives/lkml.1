Return-Path: <linux-kernel-owner+w=401wt.eu-S1760203AbXHNKUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760203AbXHNKUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 06:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758968AbXHNKQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 06:16:03 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:16285 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758812AbXHNKP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 06:15:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=rk6V8Sv1ZNyEcwcyptZG3i6jhoxy1pVjrglDVvzSjJkNogbaAIvcXtrtMRVW3V5X8a08bRxBQAaExjHB2/N1kt7W7KUCGyIw1VItG9ba7HDG7OEhkAnL6szUaaHTNCV2yrHsikdy3Dpgu+Go/SwKVbOYsbULOZQl6U4Pz2lUP9g=
Message-ID: <46C180D8.9060005@gmail.com>
Date: Tue, 14 Aug 2007 19:15:52 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: Andreas Radke <a.radke@arcor.de>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: sata drive loosing connection/resetting port
References: <20070813220241.3f4b8df5@workstation64.home> <6bffcb0e0708131311k51238bb0l63eeb2fce53e3481@mail.gmail.com>
In-Reply-To: <6bffcb0e0708131311k51238bb0l63eeb2fce53e3481@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski wrote:
> Hi Andreas,
> 
> [Adding Jeff and linux-ide to CC]
> 
> On 13/08/07, Andreas Radke <a.radke@arcor.de> wrote:
>> running ArchLinux kernel 2.6.22.2 on a Abit IP35 Pro motherboard with
>> Pro Intel P35 chipset (ICH9R + Jmicron) i have these entries all few
>> minutes:
>>
>> ata1.00: exception Emask 0x10 SAct 0x0 SErr 0x400101 action 0x2 frozen
>> ata1.00: (irq_stat 0x08000000, interface fatal error)
>> ata1.00: cmd ca/00:f8:18:d2:27/00:00:00:00:00/e6 tag 0 cdb 0x0 data
>> 126976 out res 50/00:00:80:2b:3d/00:00:00:00:00/e0 Emask 0x10 (ATA bus
>> error) ata1: soft resetting port
>> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> ata1.00: configured for UDMA/133
>> ata1: EH complete
>> sd 0:0:0:0: [sda] 145226112 512-byte hardware sectors (74356 MB)
>> sd 0:0:0:0: [sda] Write Protect is off
>> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
>> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
>> support DPO or FUA
>>
>>
>> hard disc is a Western Digital 10k Raptor connected to the ICH9R. on
>> the second port of the southbridge is another Samsung hard disc drive
>> connected without errors. both controllers are running ahci mode.
>>
>> lsmod:
>> sr_mod                 16548  0
>> cdrom                  38312  1 sr_mod
>> sd_mod                 25088  6
>> pata_jmicron            5888  0
>> ahci                   22404  4
>> libata                119440  2 pata_jmicron,ahci
>>
>> i've tried changing the SATA cables and also the power wire to the
>> disc without success. i checked the disc successfully with Hitachi
>> drive fitness test. it has worked without any trouble so far in a Intel
>> P965 ICH8 based mainboard.
>>
>> any idea how to find the reason?

Most likely a hardware issue.

* Please try a different harddrive/cable and connect to a different port.

* Get a different power supply and see whether that changes anything.

-- 
tejun
