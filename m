Return-Path: <linux-kernel-owner+w=401wt.eu-S934049AbXCTT3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934049AbXCTT3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 15:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934050AbXCTT3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 15:29:47 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:41348 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934049AbXCTT3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 15:29:46 -0400
X-Greylist: delayed 1898 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Mar 2007 15:29:45 EDT
Message-ID: <46002EB0.6070400@interia.pl>
Date: Tue, 20 Mar 2007 19:57:52 +0100
From: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 1.5.0.10 (X11/20070308)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: EXT3 problem in 2.6.21-rc4
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-EMID: 9cc5cacc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Weird. Just hapened. Still 4GB free on disk (20GB 2,5"). Any ideas anyone?

% ls -l /usr/src/linux
?rwSr-sr-- 28061 3764423985 237198795 3,1G lis 13  1914 /usr/src/linux
% ls -l -a /usr/src/linux-2.6.21-rc4
ls: nie mo¿na przeczytaæ dowi±zania symbolicznego /usr/src/linux-2.6.21-rc4/.tmp_versions: B³±d wej¶cia/wyj¶cia
razem 1,3T
[...]
lrwsr-S--T  8364  599366840 3493511603    850M lip 19  1912 .tmp_versions
?----wxr-T 45188 1309409102  619553225    3,4G pa¼  9  1989 .tmp_vmlinux1
-rw-r--r--     1 root       root           634 mar 19 18:24 ..tmp_vmlinux1.cmd
c--S--x--- 12283 1911685683  281835036 225, 13 cze  7  2008 .tmp_vmlinux2


EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 3720608827, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 4177819258, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 3708988132, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 4154199969, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 2382585585, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 3984842019, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 1135397564, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 2334269441, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 703529465, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 2801821759, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 3534137166, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 1837862895, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 1349241298, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 228490873, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 3415021299, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 3758117438, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 3140030466, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 3077434551, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 687732172, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 4200268501, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 2843986867, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 554274631, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 2039785270, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 1338763619, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 2381771149, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 612403760, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 1795851264, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 461442976, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks in system zones - Block = 2097407, count = 1
EXT3-fs error (device hda1): ext3_free_blocks_sb: bit already cleared for block 2097407
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 1844885271, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 4278682426, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 1592355726, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 2086373438, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 4265911113, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 553650592, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 1345656576, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 2668136967, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 104860152, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 4000263936, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 2819648091, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 2883443427, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 2230652234, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 232905523, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 603475737, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 537141248, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 11200002, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 4262674913, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 3221235905, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 4076727557, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 3537960983, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 270709626, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 244367841, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 1706328175, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 813833984, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks in system zones - Block = 4325378, count = 1
EXT3-fs error (device hda1): ext3_free_blocks_sb: bit already cleared for block 4325378
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 947937838, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 3976138792, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks in system zones - Block = 819218, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 669572958, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 2149515437, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 683586765, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 3794545732, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 2379116364, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 3238527001, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 553648408, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 70457088, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 1862538256, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 60818683, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 4206302976, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 1750374739, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 454206063, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 4245873251, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 2113490185, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 1979731107, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 2147518592, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 44105621, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 2718003430, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 2197628674, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 192938320, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 4199874011, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 1400635555, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 2685071213, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 4238737694, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 10932624, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 90178615, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 16625412, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 226505239, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 4246700690, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 2147569794, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks not in datazone - block = 2583550731, count = 1
EXT3-fs error (device hda1): ext3_new_block: Allocating block in system zone - blocks from 1572901, length 1
usb 1-1: USB disconnect, address 5
EXT3-fs error (device hda1): ext3_new_block: Allocating block in system zone - blocks from 819218, length 1
EXT3-fs error (device hda1): ext3_new_block: Allocating block in system zone - blocks from 1081599, length 1
EXT3-fs error (device hda1): ext3_free_blocks_sb: bit already cleared for block 1633736
EXT3-fs error (device hda1): ext3_free_blocks_sb: bit already cleared for block 1607377
EXT3-fs error (device hda1): ext3_free_blocks_sb: bit already cleared for block 561154
EXT3-fs error (device hda1): ext3_free_blocks_sb: bit already cleared for block 2308097
EXT3-fs error (device hda1): ext3_free_blocks_sb: bit already cleared for block 2265653
EXT3-fs error (device hda1): ext3_new_block: Allocating block in system zone - blocks from 4325378, length 1
init_special_inode: bogus i_mode (117123)
init_special_inode: bogus i_mode (117123)
EXT3-fs error (device hda1): ext3_new_block: Allocating block in system zone - blocks from 4128814, length 1
EXT3-fs error (device hda1): ext3_new_block: Allocating block in system zone - blocks from 2097407, length 1
init_special_inode: bogus i_mode (152707)
EXT3-fs error (device hda1): ext3_new_block: Allocating block in system zone - blocks from 330, length 1
init_special_inode: bogus i_mode (117123)
EXT3-fs error (device hda1): ext3_free_blocks_sb: bit already cleared for block 2650881
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks in system zones - Block = 1572901, count = 1
usb 1-1: new high speed USB device using ehci_hcd and address 6
usb 1-1: configuration #1 chosen from 1 choice
scsi3 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 6
usb-storage: waiting for device to settle before scanning
scsi 3:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-H12N  UL01 PQ: 0 ANSI: 0
sr0: scsi3-mmc drive: 125x/125x writer dvd-ram cd/rw xa/form2 cdda tray
sr 3:0:0:0: Attached scsi CD-ROM sr0
sr 3:0:0:0: Attached scsi generic sg0 type 5
usb-storage: device scan complete
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks in system zones - Block = 4325378, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks in system zones - Block = 4128814, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks in system zones - Block = 2097407, count = 1
usb 1-1: USB disconnect, address 6
EXT3-fs error (device hda1): ext3_new_block: Allocating block in system zone - blocks from 4325378, length 1
EXT3-fs error (device hda1): ext3_new_block: Allocating block in system zone - blocks from 2097407, length 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks in system zones - Block = 819218, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks in system zones - Block = 1081599, count = 1
EXT3-fs error (device hda1): ext3_new_block: Allocating block in system zone - blocks from 819218, length 1
EXT3-fs error (device hda1): ext3_new_block: Allocating block in system zone - blocks from 1081599, length 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks in system zones - Block = 4325378, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks in system zones - Block = 2097407, count = 1
EXT3-fs error (device hda1): ext3_new_block: Allocating block in system zone - blocks from 4128814, length 1
EXT3-fs error (device hda1): ext3_new_block: Allocating block in system zone - blocks from 4325378, length 1
EXT3-fs error (device hda1): ext3_new_block: Allocating block in system zone - blocks from 1572901, length 1
usb 1-1: new high speed USB device using ehci_hcd and address 7
usb 1-1: configuration #1 chosen from 1 choice
scsi4 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 7
usb-storage: waiting for device to settle before scanning
scsi 4:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-H12N  UL01 PQ: 0 ANSI: 0
sr0: scsi3-mmc drive: 125x/125x writer dvd-ram cd/rw xa/form2 cdda tray
sr 4:0:0:0: Attached scsi CD-ROM sr0
sr 4:0:0:0: Attached scsi generic sg0 type 5
usb-storage: device scan complete
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks in system zones - Block = 4325378, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks in system zones - Block = 4128814, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks in system zones - Block = 1572901, count = 1
usb 1-1: USB disconnect, address 7
EXT3-fs error (device hda1): ext3_new_block: Allocating block in system zone - blocks from 4325378, length 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks in system zones - Block = 819218, count = 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks in system zones - Block = 1081599, count = 1
EXT3-fs error (device hda1): ext3_new_block: Allocating block in system zone - blocks from 819218, length 1
EXT3-fs error (device hda1): ext3_new_block: Allocating block in system zone - blocks from 1081599, length 1
EXT3-fs error (device hda1): ext3_free_blocks: Freeing blocks in system zones - Block = 4325378, count = 1
init_special_inode: bogus i_mode (56210)
EXT3-fs error (device hda1): ext3_new_block: Allocating block in system zone - blocks from 4325378, length 1
attempt to access beyond end of device
hda1: rw=0, want=5561616200, limit=39070017
attempt to access beyond end of device
hda1: rw=0, want=5561616200, limit=39070017
init_special_inode: bogus i_mode (171034)
attempt to access beyond end of device
hda1: rw=0, want=5561616200, limit=39070017
attempt to access beyond end of device
hda1: rw=0, want=5561616200, limit=39070017
EXT3-fs error (device hda1): ext3_new_block: Allocating block in system zone - blocks from 4128814, length 1


----------------------------------------------------------------------
Jestes kierowca? To poczytaj! >>> http://link.interia.pl/f199e

