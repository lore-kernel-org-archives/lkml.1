Return-Path: <linux-kernel-owner+w=401wt.eu-S1752898AbXLYExj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbXLYExj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 23:53:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbXLYEx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 23:53:29 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:43571 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbXLYEx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 23:53:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=VV5LVxy4uOEWMUCxRuWZ7zs7hMPZB3xqm39LBhWB93zDnWhuvqMEZ+1EWxWGl7FMaqL9Yp5mNgtj20DXKjXJ7nxg4FYPaIbKemdNPe1BpgI8MeU1i8zPGxbuLRkEHeqX8c5lnp6qWLwlwWNEHICFEDZdfK+oJztpPrUpRsGQ7Ts=
Message-ID: <9599edfc0712242053s2ce0aea5wf1950df08f3b19a0@mail.gmail.com>
Date: Mon, 24 Dec 2007 23:53:25 -0500
From: "Jeff Mitchell" <jeffrey.mitchell@gmail.com>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: HSM violation errors
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing errors in dmesg and the like.  It appears to be somewhat
similar to the issue reported here:
http://kerneltrap.org/mailarchive/linux-kernel/2007/8/25/164711 except
that my machine doesn't freeze, and everything seems normal --
hopefully nothing like silent corruption is going on.  Also it's on
brand new hardware...Intel ICH8 mobile chipset with AHCI.  Output from
dmesg, hdparm -I /dev/sda and hdparm --drq-hsm-error /dev/sda is
below...please let me know if there's anything else that would be of
use (and, of course, if this is something I should be worried about
:-)  ).

Thanks.
Jeff


dmesg:

ata1.00: exception Emask 0x2 SAct 0xfffd SErr 0x0 action 0x2 frozen
ata1.00: spurious completions during NCQ issue=0x1 SAct=0xfffd
FIS=005040a1:00000002
ata1.00: cmd 61/08:00:56:4c:d4/00:00:01:00:00/40 tag 0 cdb 0x0 data 4096 out
         res 50/00:08:46:4c:d4/00:00:01:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 61/08:10:a6:fb:c5/00:00:01:00:00/40 tag 2 cdb 0x0 data 4096 out
         res 50/00:08:46:4c:d4/00:00:01:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 61/08:18:fe:00:c8/00:00:01:00:00/40 tag 3 cdb 0x0 data 4096 out
         res 50/00:08:46:4c:d4/00:00:01:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 61/08:20:be:e5:cf/00:00:01:00:00/40 tag 4 cdb 0x0 data 4096 out
         res 50/00:08:46:4c:d4/00:00:01:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 61/08:28:46:f6:cf/00:00:01:00:00/40 tag 5 cdb 0x0 data 4096 out
         res 50/00:08:46:4c:d4/00:00:01:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 61/08:30:96:ef:d3/00:00:01:00:00/40 tag 6 cdb 0x0 data 4096 out
         res 50/00:08:46:4c:d4/00:00:01:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 61/08:38:b6:ef:d3/00:00:01:00:00/40 tag 7 cdb 0x0 data 4096 out
         res 50/00:08:46:4c:d4/00:00:01:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 61/08:40:e6:ef:d3/00:00:01:00:00/40 tag 8 cdb 0x0 data 4096 out
         res 50/00:08:46:4c:d4/00:00:01:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 61/18:48:f6:ef:d3/00:00:01:00:00/40 tag 9 cdb 0x0 data 12288 out
         res 50/00:08:46:4c:d4/00:00:01:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 61/08:50:86:02:d4/00:00:01:00:00/40 tag 10 cdb 0x0 data 4096 out
         res 50/00:08:46:4c:d4/00:00:01:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 61/08:58:a6:4b:d4/00:00:01:00:00/40 tag 11 cdb 0x0 data 4096 out
         res 50/00:08:46:4c:d4/00:00:01:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 61/10:60:ae:4b:d4/00:00:01:00:00/40 tag 12 cdb 0x0 data 8192 out
         res 50/00:08:46:4c:d4/00:00:01:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 61/10:68:d6:4b:d4/00:00:01:00:00/40 tag 13 cdb 0x0 data 8192 out
         res 50/00:08:46:4c:d4/00:00:01:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 61/18:70:06:4c:d4/00:00:01:00:00/40 tag 14 cdb 0x0 data 12288 out
         res 50/00:08:46:4c:d4/00:00:01:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 61/08:78:46:4c:d4/00:00:01:00:00/40 tag 15 cdb 0x0 data 4096 out
         res 50/00:08:46:4c:d4/00:00:01:00:00/40 Emask 0x2 (HSM violation)
ata1: soft resetting port
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: configured for UDMA/133
ata1: EH complete
sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA




hdparm -I /dev/sda:

/dev/sda:

ATA device, with non-removable media
        Model Number:       Hitachi HTS722016K9A300
        Serial Number:      071014DP1D10DFG5A80P
        Firmware Revision:  DCDOC54P
        Transport:          Serial, ATA8-AST, SATA 1.0a, SATA II
Extensions, SATA Rev 2.5; Revision: ATA8-AST T13 Project D1697
Revision 0b
Standards:
        Supported: 8 7 6 5
        Likely used: 8
Configuration:
        Logical         max     current
        cylinders       16383   16383
        heads           16      16
        sectors/track   63      63
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
        R/W multiple sector transfer: Max = 16  Current = 8
        Advanced power management level: 128 (0x80)
        Recommended acoustic management value: 128, current value: 128
        DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6
             Cycle time: min=120ns recommended=120ns
        PIO: pio0 pio1 pio2 pio3 pio4
             Cycle time: no flow control=120ns  IORDY flow control=120ns
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
           *    NOP cmd
           *    DOWNLOAD_MICROCODE
           *    Advanced Power Management feature set
                Power-Up In Standby feature set
           *    SET_FEATURES required to spinup after power up
                SET_MAX security extension
           *    Automatic Acoustic Management feature set
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
           *    WRITE_UNCORRECTABLE command
           *    SATA-I signaling speed (1.5Gb/s)
           *    SATA-II signaling speed (3.0Gb/s)
           *    Native Command Queueing (NCQ)
           *    Host-initiated interface power management
           *    Phy event counters
           *    unknown 76[12]
                Non-Zero buffer offsets in DMA Setup FIS
                DMA Setup Auto-Activate optimization
                Device-initiated interface power management
                In-order data delivery
           *    Software settings preservation
           *    SMART Command Transport (SCT) feature set
           *    SCT LBA Segment Access (AC2)
           *    SCT Error Recovery Control (AC3)
           *    SCT Features Control (AC4)
           *    SCT Data Tables (AC5)
Security:
        Master password revision code = 65534
                supported
        not     enabled
        not     locked
                frozen
        not     expired: security count
                supported: enhanced erase
        64min for SECURITY ERASE UNIT. 66min for ENHANCED SECURITY ERASE UNIT.
Checksum: correct



hdparm --drq-hsm-error /dev/sda:

/dev/sda:
 triggering "stuck DRQ" host state machine error

do_drq_hsm_error: Success
ata status=0x40 ata error=0x00
