Return-Path: <linux-kernel-owner+w=401wt.eu-S1757220AbYISCmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220AbYISCmg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 22:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755722AbYISCm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 22:42:28 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:57649 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223AbYISCm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 22:42:27 -0400
X-Greylist: delayed 2513 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Sep 2008 22:42:27 EDT
Message-Id: <200809190200.m8J20Rt4030923@www262.sakura.ne.jp>
Subject: [2.6.27-rc6-mm1] Boot hangs while initializing SCSI disk.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Fri, 19 Sep 2008 11:00:27 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Boot process seems to fallen into infinite loop, as CPU usage became 100%
after printing below messages.
Comparing two outputs, it hangs just before printing
"sd 2:0:0:0: [sda] 8388608 512-byte hardware sectors (4295 MB)" line.

Config is at http://I-love.SAKURA.ne.jp/tmp/config-2.6.27-rc6-mm1

Regards.

---------- Fedora 9 (2.6.27-rc6) ----------
Creating block device nodes.
Loading mptbase module
Fusion MPT base driver 3.04.07
Copyright (c) 1999-2008 LSI Corporation
modprobe used greatest stack depth: 6836 bytes left
Loading mptscsih module
modprobe used greatest stack depth: 6812 bytes left
Loading mptspi module
Fusion MPT SPI Host driver 3.04.07
mptspi 0000:00:10.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
mptbase: ioc0: Initiating bringup
ioc0: LSI53C1030 B0: Capabilities={Initiator}
scsi2 : ioc0: LSI53C1030 B0, FwRev=01032920h, Ports=1, MaxQ=128, IRQ=17
scsi 2:0:0:0: Direct-Access     VMware,  VMware Virtual S 1.0  PQ: 0 ANSI: 2
scsi target2:0:0: Beginning Domain Validation
scsi target2:0:0: Domain Validation skipping write tests
scsi target2:0:0: Ending Domain Validation
scsi target2:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 127)
sd 2:0:0:0: [sda] 8388608 512-byte hardware sectors (4295 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Cache data unavailable
sd 2:0:0:0: [sda] Assuming drive cache: write through
sd 2:0:0:0: [sda] 8388608 512-byte hardware sectors (4295 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Cache data unavailable
sd 2:0:0:0: [sda] Assuming drive cache: write through
 sda: sda1
sd 2:0:0:0: [sda] Attached SCSI disk
sd 2:0:0:0: Attached scsi generic sg1 type 0
modprobe used greatest stack depth: 5064 bytes left
Creating root device.
input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio1/input/input3
Mounting root filesystem.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.


---------- Fedora 9 (2.6.27-rc6-mm1 (snapshot 2008-09-18-18-08)) ----------
Creating block device nodes.
Loading mptbase module
Fusion MPT base driver 3.04.07
Copyright (c) 1999-2008 LSI Corporation
Loading mptscsih module
Loading mptspi module
Fusion MPT SPI Host driver 3.04.07
mptspi 0000:00:10.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
mptbase: ioc0: Initiating bringup
ioc0: LSI53C1030 B0: Capabilities={Initiator}
scsi2 : ioc0: LSI53C1030 B0, FwRev=01032920h, Ports=1, MaxQ=128, IRQ=17
scsi 2:0:0:0: Direct-Access     VMware,  VMware Virtual S 1.0  PQ: 0 ANSI: 2
scsi target2:0:0: Beginning Domain Validation
scsi target2:0:0: Domain Validation skipping write tests
scsi target2:0:0: Ending Domain Validation
scsi target2:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 127)
input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio1/input/input3

(hangs at here and CPU usage becomes 100%)
