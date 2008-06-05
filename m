Return-Path: <linux-kernel-owner+w=401wt.eu-S1757480AbYFEMQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480AbYFEMQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 08:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756315AbYFEMQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 08:16:06 -0400
Received: from usermail.globalproof.net ([194.146.153.18]:37501 "EHLO
	usermail.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756267AbYFEMQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 08:16:05 -0400
X-Greylist: delayed 1302 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jun 2008 08:16:04 EDT
From: "Denys Fedoryshchenko" <denys@visp.net.lb>
To: linux-kernel@vger.kernel.org
Subject: strange timestamp in dmesg
Date: Thu, 5 Jun 2008 14:54:07 +0300
Message-Id: <20080605115256.M13181@visp.net.lb>
X-Mailer: OpenWebMail 2.52 
X-OriginatingIP: 195.69.208.251 (denys@visp.net.lb)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I notice that timestamp shifting back in dmesg.
Probably it is because machine is dual CPU opteron. I am not sure that such
behaviour is good, and i think even dangerous, and maybe affect something else.


Here is dmesg example
[    7.065265] sky2 eth1: enabling interface
[    7.093844] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    8.308842] Fusion MPT base driver 3.04.06
[    8.308850] Copyright (c) 1999-2007 LSI Corporation
[    7.719943] Fusion MPT SAS Host driver 3.04.06
[    7.773135] Fusion MPT SPI Host driver 3.04.06
[    7.773196] ACPI: PCI Interrupt 0000:02:05.0[A] -> GSI 26 (level, low) ->
IRQ 26
[    7.773233] mptbase: ioc0: Initiating bringup
[    7.983821] ioc0: LSI53C1020A A1: Capabilities={Initiator}
[    8.051145] scsi1 : ioc0: LSI53C1020A A1, FwRev=01032700h, Ports=1,
MaxQ=222, IRQ=26
[    9.730853] scsi 1:0:0:0: Direct-Access     SEAGATE  ST373207LW       0004
PQ: 0 ANSI: 3
[    9.730853]  target1:0:0: Beginning Domain Validation
[    9.690641]  target1:0:0: Ending Domain Validation
[   10.586005]  target1:0:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI
WRFLOW PCOMP (6.25 ns, offset 63)
[    9.622284] sd 1:0:0:0: [sdb] 143374744 512-byte hardware sectors (73408 MB)
[    9.624360] sd 1:0:0:0: [sdb] Write Protect is off
[    9.624360] sd 1:0:0:0: [sdb] Mode Sense: ab 00 10 08
[    9.695636] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,
supports DPO and FUA
[    9.759418] sd 1:0:0:0: [sdb] 143374744 512-byte hardware sectors (73408 MB)
[    9.630037] sd 1:0:0:0: [sdb] Write Protect is off
[    9.630037] sd 1:0:0:0: [sdb] Mode Sense: ab 00 10 08
[    9.700212] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,
supports DPO and FUA
[    9.700212]  sdb: sdb1 sdb2
[    9.769373] sd 1:0:0:0: [sdb] Attached SCSI disk
[    9.774370] scsi 1:0:1:0: Direct-Access     SEAGATE  ST373207LW       0004
PQ: 0 ANSI: 3
[    9.774393]  target1:0:1: Beginning Domain Validation
[    9.733244]  target1:0:1: Ending Domain Validation
[    9.733289]  target1:0:1: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI
WRFLOW PCOMP (6.25 ns, offset 63)
[   10.631379] sd 1:0:1:0: [sdc] 143374744 512-byte hardware sectors (73408 MB)
[   10.632811] sd 1:0:1:0: [sdc] Write Protect is off
[   10.632819] sd 1:0:1:0: [sdc] Mode Sense: ab 00 10 08
[    9.671056] sd 1:0:1:0: [sdc] Write cache: enabled, read cache: enabled,
supports DPO and FUA
[    9.801761] sd 1:0:1:0: [sdc] 143374744 512-byte hardware sectors (73408 MB)
[    9.673388] sd 1:0:1:0: [sdc] Write Protect is off
[    9.673395] sd 1:0:1:0: [sdc] Mode Sense: ab 00 10 08
[    9.806210] sd 1:0:1:0: [sdc] Write cache: enabled, read cache: enabled,
supports DPO and FUA
[    9.806220]  sdc: sdc1
[    9.682136] sd 1:0:1:0: [sdc] Attached SCSI disk
[   13.786405] SGI XFS with large block numbers, no debug enabled
[   13.633457] XFS mounting filesystem sdb2
[   13.724345] Starting XFS recovery on filesystem: sdb2 (logdev: internal)
[   14.251356] Ending XFS recovery on filesystem: sdb2 (logdev: internal)
[   15.379298] XFS mounting filesystem sdc1
[   15.468255] Starting XFS recovery on filesystem: sdc1 (logdev: internal)
[   14.514314] Ending XFS recovery on filesystem: sdc1 (logdev: internal)
[   14.767260] warning: `squid' uses 32-bit capabilities (legacy support in use)
[   17.589751] e1000: eth0: e1000_watchdog: NIC Link is Up 1000 Mbps Full
Duplex, Flow Control: RX/TX


--
Denys Fedoryshchenko
Technical Manager
Virtual ISP S.A.L.

