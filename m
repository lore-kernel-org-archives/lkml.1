Return-Path: <linux-kernel-owner+w=401wt.eu-S1764035AbXJQUIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764035AbXJQUIY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 16:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759592AbXJQUIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 16:08:07 -0400
Received: from jgarrett.org ([64.5.53.252]:2887 "EHLO jgarrett.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127AbXJQUIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 16:08:05 -0400
X-Greylist: delayed 573 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Oct 2007 16:08:04 EDT
Subject: western digital WD1500ADFD: spurious completions during NCQ
From: Jeff Garrett <jeff@jgarrett.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-ide@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-bUmvKZ2pj0WKhOs4V93Z"
Date: Wed, 17 Oct 2007 14:58:30 -0500
Message-Id: <1192651110.6103.61.camel@thog>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bUmvKZ2pj0WKhOs4V93Z
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Several threads that suggest this message is related to poor NCQ
support, but I did not see any for this drive.  It's a Western Digital
WD1500ADFD-00NLR1.  Is this the same thing, and should this drive be
blacklisted?

ata1.00: exception Emask 0x2 SAct 0x1f1 SErr 0x0 action 0x2 frozen
ata1.00: spurious completions during NCQ issue=0x0 SAct=0x1f1 FIS=004040a1:00000008
ata1.00: cmd 61/10:00:90:d3:e8/00:00:0a:00:00/40 tag 0 cdb 0x0 data 8192 out
         res 40/00:08:80:fc:34/00:00:04:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 61/40:20:8e:2e:b8/00:00:06:00:00/40 tag 4 cdb 0x0 data 32768 out
         res 40/00:08:80:fc:34/00:00:04:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 61/40:28:ce:2e:b8/00:00:06:00:00/40 tag 5 cdb 0x0 data 32768 out
         res 40/00:08:80:fc:34/00:00:04:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 61/40:30:0e:2f:b8/00:00:06:00:00/40 tag 6 cdb 0x0 data 32768 out
         res 40/00:08:80:fc:34/00:00:04:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 61/40:38:4e:2f:b8/00:00:06:00:00/40 tag 7 cdb 0x0 data 32768 out
         res 40/00:08:80:fc:34/00:00:04:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 61/40:40:8e:2f:b8/00:00:06:00:00/40 tag 8 cdb 0x0 data 32768 out
         res 40/00:08:80:fc:34/00:00:04:00:00/40 Emask 0x2 (HSM violation)
ata1: soft resetting port
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/133
ata1: EH complete

I've attached hdparm -I output.

Thanks,

Jeff Garrett

--=-bUmvKZ2pj0WKhOs4V93Z
Content-Disposition: attachment; filename=hdparm.log
Content-Type: text/x-log; name=hdparm.log; charset=UTF-8
Content-Transfer-Encoding: 7bit


/dev/sda:

ATA device, with non-removable media
	Model Number:       WDC WD1500ADFD-00NLR1                   
	Serial Number:      WD-WMAP41106896
	Firmware Revision:  20.07P20
Standards:
	Used: ATA/ATAPI-7 published, ANSI INCITS 397-2005 
	Supported: 7 6 5 4 
Configuration:
	Logical		max	current
	cylinders	16383	16383
	heads		16	16
	sectors/track	63	63
	--
	CHS current addressable sectors:   16514064
	LBA    user addressable sectors:  268435455
	LBA48  user addressable sectors:  293046768
	device size with M = 1024*1024:      143089 MBytes
	device size with M = 1000*1000:      150039 MBytes (150 GB)
Capabilities:
	LBA, IORDY(can be disabled)
	Queue depth: 32
	Standby timer values: spec'd by Standard, with device specific minimum
	R/W multiple sector transfer: Max = 16	Current = 16
	Recommended acoustic management value: 128, current value: 254
	DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6 
	     Cycle time: min=120ns recommended=120ns
	PIO: pio0 pio1 pio2 pio3 pio4 
	     Cycle time: no flow control=120ns  IORDY flow control=120ns
Commands/features:
	Enabled	Supported:
	   *	SMART feature set
	    	Security Mode feature set
	   *	Power Management feature set
	    	Write cache
	   *	Look-ahead
	   *	Host Protected Area feature set
	   *	WRITE_BUFFER command
	   *	READ_BUFFER command
	   *	NOP cmd
	   *	DOWNLOAD_MICROCODE
	    	Power-Up In Standby feature set
	   *	SET_FEATURES required to spinup after power up
	   *	SET_MAX security extension
	   *	Automatic Acoustic Management feature set
	   *	48-bit Address feature set
	   *	Device Configuration Overlay feature set
	   *	Mandatory FLUSH_CACHE
	   *	FLUSH_CACHE_EXT
	   *	SMART error logging
	   *	SMART self-test
	   *	General Purpose Logging feature set
	   *	64-bit World wide name
	   *	SATA-I signaling speed (1.5Gb/s)
	   *	Native Command Queueing (NCQ)
	   *	Phy event counters
	    	DMA Setup Auto-Activate optimization
	   *	Software settings preservation
	   *	SMART Command Transport (SCT) feature set
	   *	SCT Long Sector Access (AC1)
	   *	SCT LBA Segment Access (AC2)
	   *	SCT Error Recovery Control (AC3)
	   *	SCT Features Control (AC4)
	   *	SCT Data Tables (AC5)
	    	unknown 206[12]
Security: 
	Master password revision code = 65534
		supported
	not	enabled
	not	locked
		frozen
	not	expired: security count
	not	supported: enhanced erase
Checksum: correct

--=-bUmvKZ2pj0WKhOs4V93Z--

