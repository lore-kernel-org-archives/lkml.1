Return-Path: <linux-kernel-owner+w=401wt.eu-S1755723AbXFXMcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723AbXFXMcd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 08:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754246AbXFXMcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 08:32:25 -0400
Received: from vsmtp14.tin.it ([212.216.176.118]:53514 "EHLO vsmtp14.tin.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754212AbXFXMcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 08:32:24 -0400
Message-ID: <467E6456.4030503@tiscali.it>
Date: Sun, 24 Jun 2007 14:32:22 +0200
From: Enrico Sardi <enricoss@tiscali.it>
Reply-To: enricoss@tiscali.it
User-Agent: Mozilla Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: hsm violation
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

I found the following messages in the kernel log:
---------------------------------

[   45.288000] set_level status: 0
[   45.572000] set_level status: 0
[   45.740000] set_level status: 0
[   46.820000] set_level status: 0
[   47.092000] set_level status: 0
[   61.176000] ata1.00: exception Emask 0x2 SAct 0x2 SErr 0x0 action 0x2 
frozen
[   61.176000] ata1.00: (spurious completions during NCQ issue=0x0 
SAct=0x2 FIS=005040a1:00000004)
[   61.176000] ata1.00: cmd 60/08:08:37:cc:00/00:00:0c:00:00/40 tag 1 
cdb 0x0 data 4096 in
[   61.176000]          res 50/00:08:27:3c:ed/00:00:0b:00:00/40 Emask 
0x2 (HSM violation)
[   61.488000] ata1: soft resetting port
[   61.660000] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   61.660000] ata1.00: ata_hpa_resize 1: sectors = 312581808, 
hpa_sectors = 312581808
[   61.660000] ata1.00: ata_hpa_resize 1: sectors = 312581808, 
hpa_sectors = 312581808
[   61.660000] ata1.00: configured for UDMA/100
[   61.660000] ata1: EH complete
[   61.660000] SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
[   61.660000] sda: Write Protect is off
[   61.660000] sda: Mode Sense: 00 3a 00 00
[   61.660000] SCSI device sda: write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[  101.972000] set_level status: 0
[  102.200000] set_level status: 0
[  102.404000] set_level status: 0
[  103.284000] set_level status: 0
[  103.476000] set_level status: 0
[  103.912000] set_level status: 0
[  104.284000] set_level status: 0
[  104.660000] set_level status: 0
[  113.576000] set_level status: 0
[  559.020000] set_level status: 0
[  559.476000] set_level status: 0
[  559.632000] set_level status: 0
[  561.744000] set_level status: 0
[  563.560000] set_level status: 0
[  564.224000] set_level status: 0
[  564.688000] set_level status: 0
[  567.096000] set_level status: 0
[  567.712000] set_level status: 0
[  569.060000] set_level status: 0
[  569.524000] set_level status: 0
[  569.828000] set_level status: 0
[  570.204000] set_level status: 0
[  570.504000] set_level status: 0
[  571.724000] set_level status: 0
[  572.012000] set_level status: 0
[  572.360000] set_level status: 0
[  572.696000] set_level status: 0
[  573.016000] set_level status: 0
[  574.092000] set_level status: 0
[  574.348000] set_level status: 0
[  604.476000] set_level status: 0
[  604.764000] set_level status: 0
[  605.048000] set_level status: 0
[  605.244000] set_level status: 0
[  605.400000] set_level status: 0
[  605.540000] set_level status: 0
[  605.688000] set_level status: 0
[  606.528000] set_level status: 0
[  606.820000] set_level status: 0
[  608.336000] set_level status: 0

----------------------------------------------

This is the result of hdparm -I /dev/sda:


/dev/sda:

ATA device, with non-removable media
    Model Number:       Hitachi HTS541616J9SA00
    Serial Number:      SB2461***V3AWE
    Firmware Revision:  SB4OC70P
Standards:
    Used: ATA/ATAPI-7 T13 1532D revision 1
    Supported: 7 6 5 4
Configuration:
    Logical        max    current
    cylinders    16383    16383
    heads        16    16
    sectors/track    63    63
    --
    CHS current addressable sectors:   16514064
    LBA    user addressable sectors:  268435455
    LBA48  user addressable sectors:  312581808
    device size with M = 1024*1024:      152627 MBytes
    device size with M = 1000*1000:      160041 MBytes (160 GB)
Capabilities:
    LBA, IORDY(can be disabled)
    Queue depth: 32
    Standby timer values: spec'd by Vendor, no device specific minimum
    R/W multiple sector transfer: Max = 16    Current = 16
    Advanced power management level: 128 (0x80)
    Recommended acoustic management value: 128, current value: 254
    DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 *udma5
         Cycle time: min=120ns recommended=120ns
    PIO: pio0 pio1 pio2 pio3 pio4
         Cycle time: no flow control=120ns  IORDY flow control=120ns
Commands/features:
    Enabled    Supported:
       *    SMART feature set
            Security Mode feature set
       *    Power Management feature set
       *    Write cache
       *    Look-ahead
       *    Host Protected Area feature set
       *    WRITE_BUFFER command
       *    READ_BUFFER command
       *    NOP cmd
       *    DOWNLOAD_MICROCODE
       *    Advanced Power Management feature set
            Power-Up In Standby feature set
       *    SET_FEATURES required to spinup after power up
            SET_MAX security extension
            Automatic Acoustic Management feature set
       *    48-bit Address feature set
       *    Device Configuration Overlay feature set
       *    Mandatory FLUSH_CACHE
       *    FLUSH_CACHE_EXT
       *    SMART error logging
       *    SMART self-test
       *    General Purpose Logging feature set
       *    WRITE_{DMA|MULTIPLE}_FUA_EXT
       *    64-bit World wide name
       *    IDLE_IMMEDIATE with UNLOAD
       *    SATA-I signaling speed (1.5Gb/s)
       *    Native Command Queueing (NCQ)
       *    Host-initiated interface power management
       *    Phy event counters
            Non-Zero buffer offsets in DMA Setup FIS
            DMA Setup Auto-Activate optimization
            Device-initiated interface power management
            In-order data delivery
       *    Software settings preservation
Security:
    Master password revision code = 65534
        supported
    not    enabled
    not    locked
        frozen
    not    expired: security count
    not    supported: enhanced erase
    82min for SECURITY ERASE UNIT.
Checksum: correct

-----------------------------------------------------


I'm using Ubuntu feisty fawn (2.6.20-16-generic) on an Acer Travelmate 
6292 (Santa Rosa).

Many thanks!

Enrico


