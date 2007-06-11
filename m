Return-Path: <linux-kernel-owner+w=401wt.eu-S1762692AbXFKJWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762692AbXFKJWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 05:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbXFKJWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 05:22:43 -0400
Received: from eazy.amigager.de ([213.239.192.238]:32940 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbXFKJWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 05:22:42 -0400
Date: Mon, 11 Jun 2007 11:22:40 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Bad behaviour after hdparm -M  128
Message-ID: <20070611092240.GC29775@dose.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <4666C4B9.8060408@shaw.ca> <20070606154442.GB13166@khazad-dum.debian.net> <20070606162425.GA3943@atjola.homenet> <20070606164854.GA18984@khazad-dum.debian.net> <20070606175112.GA4659@atjola.homenet> <20070606210337.GA31549@khazad-dum.debian.net> <20070606213617.GA6580@atjola.homenet> <20070606215232.GC31549@khazad-dum.debian.net> <466827FF.1030304@rtr.ca> <20070608015004.GA16785@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070608015004.GA16785@khazad-dum.debian.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 22:50:04 -0300, Henrique de Moraes Holschuh wrote:

[...]

> I just tracked it down to hdparm.  Version 6.9 (the one in Debian stable)
> doesn't work right with libata.  Version 7.5 (the one in Debian unstable)
> works fine.
> 
> So, at least in my side, there are *no* kernel bugs.  Maybe this is also the
> case for the poster that reported the problem?

I also use Debian unstable.

Here is the relevant part of the hdparm -I output:

/dev/sda:

ATA device, with non-removable media
        Model Number:       ST98823AS                               
        Serial Number:      5PK0GTK8
        Firmware Revision:  7.01    
Standards:
        Supported: 7 6 5 4 
        Likely used: 7
Configuration:
        Logical         max     current
        cylinders       16383   16383
        heads           16      16
        sectors/track   63      63
        --
        CHS current addressable sectors:   16514064
        LBA    user addressable sectors:  156301488
        LBA48  user addressable sectors:  156301488
        device size with M = 1024*1024:       76319 MBytes
        device size with M = 1000*1000:       80026 MBytes (80 GB)
Capabilities:
        LBA, IORDY(can be disabled)
        Queue depth: 32
        Standby timer values: spec'd by Standard, no device specific
        minimum
        R/W multiple sector transfer: Max = 16  Current = ?
        Advanced power management level: unknown setting (0x8080)
        Recommended acoustic management value: 128, current value: 0
        DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5
        *udma6 
             Cycle time: min=120ns recommended=120ns
        PIO: pio0 pio1 pio2 pio3 pio4 
             Cycle time: no flow control=240ns  IORDY flow control=120ns
Commands/features:
Commands/features:
        Enabled Supported:
           *    SMART feature set
                Security Mode feature set
           *    Power Management feature set
           *    Write cache
           *    Look-ahead
           *    Host Protected Area feature set
           *    WRITE_BUFFER command
           *    READ_BUFFER command
           *    DOWNLOAD_MICROCODE
           *    Advanced Power Management feature set
                SET_MAX security extension
           *    48-bit Address feature set
           *    Device Configuration Overlay feature set
           *    Mandatory FLUSH_CACHE
           *    FLUSH_CACHE_EXT
           *    SMART error logging
           *    SMART self-test
           *    WRITE_{DMA|MULTIPLE}_FUA_EXT
           *    IDLE_IMMEDIATE with UNLOAD
           *    SATA-I signaling speed (1.5Gb/s)
           *    Native Command Queueing (NCQ)
           *    Phy event counters
                Device-initiated interface power management
           *    Software settings preservation
           *    SMART Command Transport (SCT) feature set

Regards,
Tino
