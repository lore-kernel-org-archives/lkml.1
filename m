Return-Path: <linux-kernel-owner+w=401wt.eu-S1757492AbXLLAF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492AbXLLAF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 19:05:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbXLLAFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 19:05:19 -0500
Received: from main.gmane.org ([80.91.229.2]:51080 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159AbXLLAFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 19:05:17 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Orion Poplawski <orion@cora.nwra.com>
Subject: sata_mv hotplug flaky?
Date: Tue, 11 Dec 2007 17:04:49 -0700
Message-ID: <fjn8j2$mji$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: inferno.cora.nwra.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure what the latest status of sata_mv hotplug should be, but it 
seems close.  I'm currently running 2.6.24-0.81.rc4.git7.fc9 with a 
MV88SX5081.  Pulled a couple drives and re-added.  One device got 
re-added, but the other did not.  It seems like I got the system to 
probe and re-add the first drive by doing a "mount -a", but haven't been 
able (no idea how) to re-add the second.


Dec 11 16:51:10 saga kernel: ata8: exception Emask 0x10 SAct 0x0 SErr 
0x180002 action 0xe frozen
Dec 11 16:51:10 saga kernel: ata8: edma_err 0x00000108, dev disconnect, 
EDMA self-disable
Dec 11 16:51:10 saga kernel: ata8: SError: { RecovComm 10B8B Dispar }
Dec 11 16:51:10 saga kernel: ata8: hard resetting link
Dec 11 16:51:10 saga kernel: ata8: SATA link down (SStatus 0 SControl 300)
Dec 11 16:51:10 saga kernel: ata8: failed to recover some devices, 
retrying in 5 secs
Dec 11 16:51:15 saga kernel: ata8: hard resetting link
Dec 11 16:51:15 saga kernel: ata8: SATA link down (SStatus 0 SControl 300)
Dec 11 16:51:15 saga kernel: ata8: failed to recover some devices, 
retrying in 5 secs
Dec 11 16:51:20 saga kernel: ata8: hard resetting link
Dec 11 16:51:20 saga kernel: ata8: SATA link down (SStatus 0 SControl 300)
Dec 11 16:51:20 saga kernel: ata8.00: disabled
Dec 11 16:51:20 saga kernel: ata8: EH complete
Dec 11 16:51:20 saga kernel: ata8.00: detaching (SCSI 7:0:0:0)
Dec 11 16:51:20 saga kernel: sd 7:0:0:0: [sdh] Synchronizing SCSI cache
Dec 11 16:51:20 saga kernel: sd 7:0:0:0: [sdh] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Dec 11 16:51:20 saga kernel: sd 7:0:0:0: [sdh] Stopping disk
Dec 11 16:51:20 saga kernel: sd 7:0:0:0: [sdh] START_STOP FAILED
Dec 11 16:51:20 saga kernel: sd 7:0:0:0: [sdh] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK

Dec 11 16:51:54 saga kernel: ata5: exception Emask 0x10 SAct 0x0 SErr 
0x180002 action 0xe frozen
Dec 11 16:51:54 saga kernel: ata5: edma_err 0x00000108, dev disconnect, 
EDMA self-disable
Dec 11 16:51:54 saga kernel: ata5: SError: { RecovComm 10B8B Dispar }
Dec 11 16:51:54 saga kernel: ata5: hard resetting link
Dec 11 16:51:54 saga kernel: ata5: SATA link down (SStatus 0 SControl 300)
Dec 11 16:51:54 saga kernel: ata5: failed to recover some devices, 
retrying in 5 secs
Dec 11 16:51:59 saga kernel: ata5: hard resetting link
Dec 11 16:51:59 saga kernel: ata5: SATA link down (SStatus 0 SControl 300)
Dec 11 16:51:59 saga kernel: ata5: failed to recover some devices, 
retrying in 5 secs
Dec 11 16:52:04 saga kernel: ata5: hard resetting link
Dec 11 16:52:04 saga kernel: ata5: SATA link down (SStatus 0 SControl 300)
Dec 11 16:52:04 saga kernel: ata5.00: disabled
Dec 11 16:52:04 saga kernel: ata5: EH complete
Dec 11 16:52:04 saga kernel: ata5.00: detaching (SCSI 4:0:0:0)
Dec 11 16:52:04 saga kernel: sd 4:0:0:0: [sde] Synchronizing SCSI cache
Dec 11 16:52:04 saga kernel: sd 4:0:0:0: [sde] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Dec 11 16:52:04 saga kernel: sd 4:0:0:0: [sde] Stopping disk
Dec 11 16:52:04 saga kernel: sd 4:0:0:0: [sde] START_STOP FAILED
Dec 11 16:52:04 saga kernel: sd 4:0:0:0: [sde] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK

Dec 11 16:52:59 saga kernel: ata8: exception Emask 0x10 SAct 0x0 SErr 
0x0 action 0xe frozen
Dec 11 16:52:59 saga kernel: ata8: edma_err 0x00000010, dev connect
Dec 11 16:52:59 saga kernel: ata8: hard resetting link
Dec 11 16:53:00 saga kernel: ata8: SATA link up 1.5 Gbps (SStatus 113 
SControl 300)
Dec 11 16:53:00 saga kernel: ata8.00: ATA-6: WDC WD2500PD-75FZB0, 
02.05D02, max UDMA/100
Dec 11 16:53:00 saga kernel: ata8.00: 488281250 sectors, multi 0: LBA48
Dec 11 16:53:00 saga kernel: ata8.00: applying bridge limits
Dec 11 16:53:00 saga kernel: ata8.00: configured for UDMA/100
Dec 11 16:53:00 saga kernel: ata8: exception Emask 0x10 SAct 0x0 SErr 
0x0 action 0xf t4
Dec 11 16:53:00 saga kernel: ata8: edma_err 0x00000018, dev disconnect
Dec 11 16:53:00 saga kernel: ata8: hard resetting link

Dec 11 16:53:00 saga kernel: ata8: SATA link up 1.5 Gbps (SStatus 113 
SControl 300)
Dec 11 16:53:00 saga kernel: ata8.00: configured for UDMA/100
Dec 11 16:53:00 saga kernel: ata8: exception Emask 0x10 SAct 0x0 SErr 
0x0 action 0xf t3
Dec 11 16:53:00 saga kernel: ata8: edma_err 0x00000018, dev disconnect
Dec 11 16:53:00 saga kernel: ata8: hard resetting link
Dec 11 16:53:01 saga kernel: ata8: SATA link up 1.5 Gbps (SStatus 113 
SControl 300)
Dec 11 16:53:01 saga kernel: ata8.00: configured for UDMA/100
Dec 11 16:53:01 saga kernel: ata8: EH complete
Dec 11 16:53:01 saga kernel: scsi 7:0:0:0: Direct-Access     ATA 
WDC WD2500PD-75F 02.0 PQ: 0 ANSI: 5
Dec 11 16:53:01 saga kernel: sd 7:0:0:0: [sde] 488281250 512-byte 
hardware sectors (250000 MB)
Dec 11 16:53:01 saga kernel: sd 7:0:0:0: [sde] Write Protect is off
Dec 11 16:53:01 saga kernel: sd 7:0:0:0: [sde] Write cache: enabled, 
read cache: enabled, doesn't support DPO or FUA
Dec 11 16:53:01 saga kernel: sd 7:0:0:0: [sde] 488281250 512-byte 
hardware sectors (250000 MB)
Dec 11 16:53:01 saga kernel: sd 7:0:0:0: [sde] Write Protect is off
Dec 11 16:53:01 saga kernel: sd 7:0:0:0: [sde] Write cache: enabled, 
read cache: enabled, doesn't support DPO or FUA
Dec 11 16:53:01 saga kernel:  sde: sde1 sde2
Dec 11 16:53:01 saga kernel: sd 7:0:0:0: [sde] Attached SCSI disk
Dec 11 16:53:01 saga kernel: sd 7:0:0:0: Attached scsi generic sg5 type 0



-- 
Orion Poplawski
Technical Manager                     303-415-9701 x222
NWRA/CoRA Division                    FAX: 303-415-9702
3380 Mitchell Lane                  orion@cora.nwra.com
Boulder, CO 80301              http://www.cora.nwra.com

