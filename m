Return-Path: <linux-kernel-owner+w=401wt.eu-S1759257AbYGPVxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759257AbYGPVxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 17:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757376AbYGPVxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 17:53:05 -0400
Received: from kludge.physics.uiowa.edu ([128.255.33.129]:48183 "EHLO
	kludge.physics.uiowa.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061AbYGPVxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 17:53:03 -0400
X-Greylist: delayed 1565 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jul 2008 17:53:03 EDT
Date: Wed, 16 Jul 2008 16:26:06 -0500
From: Joseph Pingenot <trelane@digitasaru.net>
To: linux-kernel@vger.kernel.org
Message-ID: <20080716212605.GA8244@digitasaru.net>
Reply-To: trelane@digitasaru.net
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-School: University of Iowa
X-vi-or-emacs: vi *and* emacs!
X-MS-TNEF-Correlator: <AFJAUFHRUOGRESULWAOIHFEAUIOFBVHSHNRAIU.monkey@spamcen
	tral.invalid>
X-MimeOLE: Not Produced By Microsoft MimeOLE V5.50.4522.1200
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Subject: ata error message exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all.

Anyone know what is causing the following troubles:
Jul 16 16:16:27 cruftix kernel: [12538.998440] ata5.00: exception Emask
0x0 SAct 0x0 SErr 0x0 action 0x2
Jul 16 16:16:27 cruftix kernel: [12538.998450] ata5.00: irq_stat
0x00020002, device error via D2H FIS
Jul 16 16:16:27 cruftix kernel: [12538.998457] ata5.00: cmd
35/00:08:87:17:58/00:00:59:00:00/e0 tag 0 dma 4096 out
Jul 16 16:16:27 cruftix kernel: [12538.998459]          res
51/84:00:8e:17:58/00:00:59:00:00/e0 Emask 0x10 (ATA bus error)
Jul 16 16:16:27 cruftix kernel: [12538.998464] ata5.00: status: { DRDY
ERR }
Jul 16 16:16:27 cruftix kernel: [12538.998466] ata5.00: error: { ICRC
ABRT }
Jul 16 16:16:27 cruftix kernel: [12538.998478] ata5: hard resetting link
Jul 16 16:16:30 cruftix kernel: [12541.122576] ata5: SATA link up 1.5
Gbps (SStatus 113 SControl 10)
Jul 16 16:16:30 cruftix kernel: [12541.173617] ata5.00: configured for
UDMA/33
Jul 16 16:16:30 cruftix kernel: [12541.173642] ata5: EH complete
Jul 16 16:16:30 cruftix kernel: [12541.220169] sd 4:0:0:0: [sdd]
1953525168 512-byte hardware sectors (1000205 MB)
Jul 16 16:16:30 cruftix kernel: [12541.220650] sd 4:0:0:0: [sdd] Write
Protect is off
Jul 16 16:16:30 cruftix kernel: [12541.220661] sd 4:0:0:0: [sdd] Mode
Sense: 00 3a 00 00
Jul 16 16:16:30 cruftix kernel: [12541.221606] sd 4:0:0:0: [sdd] Write
cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul 16 16:16:33 cruftix kernel: [12544.539197] ata5.00: exception Emask
0x0 SAct 0x0 SErr 0x0 action 0x2
Jul 16 16:16:33 cruftix kernel: [12544.539207] ata5.00: irq_stat
0x00020002, device error via D2H FIS
Jul 16 16:16:33 cruftix kernel: [12544.539214] ata5.00: cmd
35/00:00:37:04:62/00:04:59:00:00/e0 tag 0 dma 524288 out
Jul 16 16:16:33 cruftix kernel: [12544.539216]          res
51/84:00:36:08:62/00:00:59:00:00/e0 Emask 0x10 (ATA bus error)
Jul 16 16:16:33 cruftix kernel: [12544.539221] ata5.00: status: { DRDY
ERR }
Jul 16 16:16:33 cruftix kernel: [12544.539223] ata5.00: error: { ICRC
ABRT }
Jul 16 16:16:33 cruftix kernel: [12544.539235] ata5: hard resetting link
Jul 16 16:16:35 cruftix kernel: [12546.659377] ata5: SATA link up 1.5
Gbps (SStatus 113 SControl 10)
Jul 16 16:16:35 cruftix kernel: [12546.710050] ata5.00: configured for
UDMA/33
Jul 16 16:16:35 cruftix kernel: [12546.710071] ata5: EH complete
Jul 16 16:16:35 cruftix kernel: [12546.722945] sd 4:0:0:0: [sdd]
1953525168 512-byte hardware sectors (1000205 MB)
Jul 16 16:16:35 cruftix kernel: [12546.736550] sd 4:0:0:0: [sdd] Write
Protect is off
Jul 16 16:16:35 cruftix kernel: [12546.736555] sd 4:0:0:0: [sdd] Mode
Sense: 00 3a 00 00
Jul 16 16:16:35 cruftix kernel: [12546.744332] sd 4:0:0:0: [sdd] Write
cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul 16 16:16:39 cruftix kernel: [12550.970311] ata5.00: exception Emask
0x0 SAct 0x0 SErr 0x0 action 0x2
Jul 16 16:16:39 cruftix kernel: [12550.970326] ata5.00: irq_stat
0x00020002, device error via D2H FIS
Jul 16 16:16:39 cruftix kernel: [12550.970339] ata5.00: cmd
35/00:00:87:97:6d/00:04:16:00:00/e0 tag 0 dma 524288 out
Jul 16 16:16:39 cruftix kernel: [12550.970341]          res
51/84:00:86:9b:6d/00:00:16:00:00/e0 Emask 0x10 (ATA bus error)
Jul 16 16:16:39 cruftix kernel: [12550.970347] ata5.00: status: { DRDY
ERR }
Jul 16 16:16:39 cruftix kernel: [12550.970351] ata5.00: error: { ICRC
ABRT }
Jul 16 16:16:39 cruftix kernel: [12550.970373] ata5: hard resetting link
Jul 16 16:16:42 cruftix kernel: [12553.077164] ata5: SATA link up 1.5
Gbps (SStatus 113 SControl 10)
Jul 16 16:16:42 cruftix kernel: [12553.128000] ata5.00: configured for
UDMA/33
Jul 16 16:16:42 cruftix kernel: [12553.128031] ata5: EH complete
Jul 16 16:16:42 cruftix kernel: [12553.140988] sd 4:0:0:0: [sdd]
1953525168 512-byte hardware sectors (1000205 MB)
Jul 16 16:16:42 cruftix kernel: [12553.149697] sd 4:0:0:0: [sdd] Write
Protect is off
Jul 16 16:16:42 cruftix kernel: [12553.149709] sd 4:0:0:0: [sdd] Mode
Sense: 00 3a 00 00
Jul 16 16:16:42 cruftix kernel: [12553.174631] sd 4:0:0:0: [sdd] Write
cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul 16 16:16:42 cruftix kernel: [12553.631567] ata5.00: exception Emask
0x0 SAct 0x0 SErr 0x0 action 0x2
Jul 16 16:16:42 cruftix kernel: [12553.631579] ata5.00: irq_stat
0x00020002, device error via D2H FIS
Jul 16 16:16:42 cruftix kernel: [12553.631592] ata5.00: cmd
35/00:c8:87:42:66/00:02:59:00:00/e0 tag 0 dma 364544 out
Jul 16 16:16:42 cruftix kernel: [12553.631595]          res
51/84:00:4e:45:66/00:00:59:00:00/e0 Emask 0x10 (ATA bus error)
Jul 16 16:16:42 cruftix kernel: [12553.631620] ata5.00: status: { DRDY
ERR }
Jul 16 16:16:42 cruftix kernel: [12553.631625] ata5.00: error: { ICRC
ABRT }
Jul 16 16:16:42 cruftix kernel: [12553.631649] ata5: hard resetting link
Jul 16 16:16:44 cruftix kernel: [12555.737413] ata5: SATA link up 1.5
Gbps (SStatus 113 SControl 10)
Jul 16 16:16:44 cruftix kernel: [12555.788095] ata5.00: configured for
UDMA/33
Jul 16 16:16:44 cruftix kernel: [12555.788118] ata5: EH complete
Jul 16 16:16:44 cruftix kernel: [12555.830752] sd 4:0:0:0: [sdd]
1953525168 512-byte hardware sectors (1000205 MB)
Jul 16 16:16:44 cruftix kernel: [12555.835502] sd 4:0:0:0: [sdd] Write
Protect is off
Jul 16 16:16:44 cruftix kernel: [12555.835507] sd 4:0:0:0: [sdd] Mode
Sense: 00 3a 00 00
Jul 16 16:16:44 cruftix kernel: [12555.844127] sd 4:0:0:0: [sdd] Write
cache: enabled, read cache: enabled, doesn't support DPO or FUA


(just a sampling)
I'm transferring data to an ext3 filesystem on a Seagate FreeAgent Pro
  1TB disk with an eSATA connector (Norco 4618 eSATA card with SiI 3124:

03:0d.0 RAID bus controller: Silicon Image, Inc. SiI 3124 PCI-X Serial
ATA Controller (rev 02)
        Subsystem: Silicon Image, Inc. Unknown device 7124
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV+ VGASnoop-
ParErr- Stepping+ SERR+ FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 22
        Region 0: Memory at fe7fec00 (64-bit, non-prefetchable)
[size=128]
        Region 2: Memory at fe7f0000 (64-bit, non-prefetchable)
[size=32K]
        Region 4: I/O ports at ec70 [size=16]
        Expansion ROM at f8000000 [disabled] [size=512K]
        Capabilities: [64] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [40] PCI-X non-bridge device
                Command: DPERE- ERO+ RBC=512 OST=12
                Status: Dev=ff:1f.0 64bit+ 133MHz+ SCD- USC- DC=simple
DMMRBC=2048 DMOST=12 DMCRS=128 RSCEM- 266MHz- 533MHz-
        Capabilities: [54] Message Signalled Interrupts: Mask- 64bit+
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000)

Kernel is Ubuntu Hardy's 2.6.24-19-generic.

Thanks!

-Joseph
-- 
trelane@digitasaru.net.///////////////////////////////////////////////
Joseph Pingenot                  Researcher of Spins in Nanostructures
The University of Iowa                   Free Software Developer
