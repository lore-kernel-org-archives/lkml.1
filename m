Return-Path: <linux-kernel-owner+w=401wt.eu-S1752282AbYKRGxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282AbYKRGxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 01:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbYKRGxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 01:53:07 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:65003 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbYKRGxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 01:53:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=x7UB//RXuhpJ/DC0uOEzU9kxTcxawL9Athl92kprKwYfDFrTkZD56dL6ZqwZSJT70t
         2lI3Tkf9gNCpfkEiuIcccjhFKzIoymW7swcLHiXNnq2ys+nvBMuaregkksInmY854oYg
         4HDJxEeiV1DRAgsfJmxjLPvKDog+/Elu7X23M=
Message-ID: <e38d12ff0811172253n12bf27cam9c047282139f5749@mail.gmail.com>
Date: Tue, 18 Nov 2008 01:53:03 -0500
From: "Andrey Vul" <andrey.vul@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: another DMAR error, this time on cdrom
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ICH9 on my laptop is starting to feel very flaky ... I hope it's
only the driver.
See previous jfs post for kernel config.

dmesg for cdrom error:
[ 3936.102010] DMAR:[DMA Read] Request device [08:00.0] fault addr fffc2000
[ 3936.102014] DMAR:[fault reason 06] PTE Read access is not set
[ 4360.068246] DMAR:[DMA Read] Request device [08:00.0] fault addr fff3d000
[ 4360.068250] DMAR:[fault reason 06] PTE Read access is not set
[ 4487.395858] DMAR:[DMA Read] Request device [08:00.0] fault addr fff5f000
[ 4487.395859] DMAR:[fault reason 06] PTE Read access is not set
[ 4698.564355] DMAR:[DMA Read] Request device [08:00.0] fault addr fff46000
[ 4698.564357] DMAR:[fault reason 06] PTE Read access is not set
[ 6191.019845] DMAR:[DMA Read] Request device [08:00.0] fault addr fff23000
[ 6191.019849] DMAR:[fault reason 06] PTE Read access is not set
[ 6191.539875] DMAR:[DMA Read] Request device [08:00.0] fault addr ffff7000
[ 6191.539879] DMAR:[fault reason 06] PTE Read access is not set
[ 6219.319302] DMAR:[DMA Read] Request device [08:00.0] fault addr fffde000
[ 6219.319306] DMAR:[fault reason 06] PTE Read access is not set
[ 6219.390362] DMAR:[DMA Read] Request device [08:00.0] fault addr fff6d000
[ 6219.390365] DMAR:[fault reason 06] PTE Read access is not set
[ 6219.466431] DMAR:[DMA Read] Request device [08:00.0] fault addr fff62000
[ 6219.466435] DMAR:[fault reason 06] PTE Read access is not set
[ 6219.541128] DMAR:[DMA Read] Request device [08:00.0] fault addr fffe4000
[ 6219.541132] DMAR:[fault reason 06] PTE Read access is not set
[ 6219.606679] DMAR:[DMA Read] Request device [08:00.0] fault addr fff32000
[ 6219.606683] DMAR:[fault reason 06] PTE Read access is not set
[ 6219.645993] DMAR:[DMA Read] Request device [08:00.0] fault addr fffd9000
[ 6219.645996] DMAR:[fault reason 06] PTE Read access is not set
[ 6219.687288] DMAR:[DMA Read] Request device [08:00.0] fault addr ffffd000
[ 6219.687291] DMAR:[fault reason 06] PTE Read access is not set
[ 6219.731193] DMAR:[DMA Read] Request device [08:00.0] fault addr ffffd000
[ 6219.731197] DMAR:[fault reason 06] PTE Read access is not set
[ 6219.840975] DMAR:[DMA Read] Request device [08:00.0] fault addr fffdd000
[ 6219.840978] DMAR:[fault reason 06] PTE Read access is not set
[ 6219.905534] DMAR:[DMA Read] Request device [08:00.0] fault addr fffbc000
[ 6219.905538] DMAR:[fault reason 06] PTE Read access is not set
[ 6219.942236] DMAR:[DMA Read] Request device [08:00.0] fault addr fff2c000
[ 6219.942240] DMAR:[fault reason 06] PTE Read access is not set
[ 6220.062157] DMAR:[DMA Read] Request device [08:00.0] fault addr fff93000
[ 6220.062161] DMAR:[fault reason 06] PTE Read access is not set
[ 6220.140800] DMAR:[DMA Read] Request device [08:00.0] fault addr fff88000
[ 6220.140804] DMAR:[fault reason 06] PTE Read access is not set
[ 6220.191590] DMAR:[DMA Read] Request device [08:00.0] fault addr ffff7000
[ 6220.191594] DMAR:[fault reason 06] PTE Read access is not set
[ 6220.252540] DMAR:[DMA Read] Request device [08:00.0] fault addr ffff7000
[ 6220.252544] DMAR:[fault reason 06] PTE Read access is not set
[ 6220.310552] DMAR:[DMA Read] Request device [08:00.0] fault addr ffff7000
[ 6220.310555] DMAR:[fault reason 06] PTE Read access is not set
[ 6220.385253] DMAR:[DMA Read] Request device [08:00.0] fault addr fff6b000
[ 6220.385257] DMAR:[fault reason 06] PTE Read access is not set
[ 6220.480281] DMAR:[DMA Read] Request device [08:00.0] fault addr ffff9000
[ 6220.480285] DMAR:[fault reason 06] PTE Read access is not set
[ 6220.557616] DMAR:[DMA Read] Request device [08:00.0] fault addr fff5f000
[ 6220.557620] DMAR:[fault reason 06] PTE Read access is not set
[ 6220.568105] DMAR:[DMA Read] Request device [08:00.0] fault addr fff5a000
[ 6220.568109] DMAR:[fault reason 06] PTE Read access is not set
[ 6220.573674] DMAR:[DMA Read] Request device [08:00.0] fault addr fffd7000
[ 6220.573677] DMAR:[fault reason 06] PTE Read access is not set
[ 6220.607093] DMAR:[DMA Read] Request device [08:00.0] fault addr fff5a000
[ 6220.607097] DMAR:[fault reason 06] PTE Read access is not set
[ 6220.677553] DMAR:[DMA Read] Request device [08:00.0] fault addr fff4e000
[ 6220.677557] DMAR:[fault reason 06] PTE Read access is not set
[10131.455968] DMAR:[DMA Read] Request device [08:00.0] fault addr fff28000
[10131.455972] DMAR:[fault reason 06] PTE Read access is not set
[10132.059236] DMAR:[DMA Read] Request device [08:00.0] fault addr fffa7000
[10132.059239] DMAR:[fault reason 06] PTE Read access is not set
[12823.403866] DMAR:[DMA Read] Request device [08:00.0] fault addr fff70000
[12823.403870] DMAR:[fault reason 06] PTE Read access is not set
[12824.842608] DMAR:[DMA Read] Request device [08:00.0] fault addr fff66000
[12824.842612] DMAR:[fault reason 06] PTE Read access is not set
[17954.788992] cp used greatest stack depth: 3888 bytes left
[18350.879117] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[18350.879135] ata2.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[18350.879138]          cdb 00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
[18350.879141]          res 40/00:03:00:fe:00/00:00:00:00:00/a0 Emask
0x4 (timeout)
[18350.879148] ata2.00: status: { DRDY }
[18350.879162] ata2: hard resetting link
[18356.233076] ata2: link is slow to respond, please be patient (ready=0)
[18360.925084] ata2: COMRESET failed (errno=-16)
[18360.925095] ata2: hard resetting link
[18366.231088] ata2: link is slow to respond, please be patient (ready=0)
[18370.974076] ata2: COMRESET failed (errno=-16)
[18370.974086] ata2: hard resetting link
[18376.330089] ata2: link is slow to respond, please be patient (ready=0)
[18406.016320] ata2: COMRESET failed (errno=-16)
[18406.016332] ata2: limiting SATA link speed to 1.5 Gbps
[18406.016338] ata2: hard resetting link
[18411.064079] ata2: COMRESET failed (errno=-16)
[18411.064089] ata2: reset failed, giving up
[18411.064095] ata2.00: disabled
[18411.064117] ata2: EH complete
[18411.064239] sr 1:0:0:0: [sr0] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
[18411.064250] end_request: I/O error, dev sr0, sector 717108
[18411.064269] Buffer I/O error on device sr0, logical block 179277
[18411.064309] Buffer I/O error on device sr0, logical block 179239
[18411.064316] Buffer I/O error on device sr0, logical block 179240
[18411.064324] Buffer I/O error on device sr0, logical block 179241
[18411.064330] Buffer I/O error on device sr0, logical block 179242
[18411.064337] Buffer I/O error on device sr0, logical block 179243
[18411.064343] Buffer I/O error on device sr0, logical block 179244
[18411.064350] Buffer I/O error on device sr0, logical block 179245
[18411.064356] Buffer I/O error on device sr0, logical block 179246
[18411.064362] Buffer I/O error on device sr0, logical block 179247
[18411.064426] sr 1:0:0:0: [sr0] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
[18411.064434] end_request: I/O error, dev sr0, sector 716700
[18411.159667] VFS: busy inodes on changed media.
[18411.159859] VFS: busy inodes on changed media.
[18411.160408] VFS: busy inodes on changed media.
[18411.160933] VFS: busy inodes on changed media.
[18411.160997] VFS: busy inodes on changed media.
[18411.531810] VFS: busy inodes on changed media.
[18411.531886] VFS: busy inodes on changed media.
[18411.531939] VFS: busy inodes on changed media.
[18411.532771] VFS: busy inodes on changed media.
[18411.532832] VFS: busy inodes on changed media.
[18411.532897] VFS: busy inodes on changed media.
[18413.873727] VFS: busy inodes on changed media.
[18413.873895] VFS: busy inodes on changed media.
[18415.873217] VFS: busy inodes on changed media.
[18415.873380] VFS: busy inodes on changed media.
[18417.873157] VFS: busy inodes on changed media.
[18417.873306] VFS: busy inodes on changed media.
[18419.873202] VFS: busy inodes on changed media.
[18419.873344] VFS: busy inodes on changed media.
[18421.873198] VFS: busy inodes on changed media.
[18421.873364] VFS: busy inodes on changed media.
[18423.873132] VFS: busy inodes on changed media.
...

I have a very strong feeling that this error and the previous jfs one
are strongly related :\

--
Andrey Vul

PS: CC this to the Intel driver maintainers.
