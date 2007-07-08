Return-Path: <linux-kernel-owner+w=401wt.eu-S1756754AbXGHXB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754AbXGHXB5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 19:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbXGHXBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 19:01:50 -0400
Received: from no-way.org ([212.55.212.131]:59284 "EHLO no-way.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280AbXGHXBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 19:01:49 -0400
X-Greylist: delayed 530 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Jul 2007 19:01:48 EDT
Date: Mon, 9 Jul 2007 00:52:46 +0200
From: Flavio Curti <lists.fcu@no-way.org>
To: linux-kernel@vger.kernel.org
Subject: panics with 16port Promise Supertrack EX Controller
Message-ID: <20070708225246.GD16285@no-way.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello

I have a problem with a server running 2.6.22rc4. The machine panics
after some days of running fine, the machine inst heavy loaded.

The Controller detects as stex device:

scsi0 : stex
scsi 0:0:0:0: Direct-Access Promise 1X2 Mirror      1.10 PQ: 0 ANSI: 3
scsi 0:0:2:0: Direct-Access Promise  12+2 Disk RAID6  1.10 PQ: 0 ANSI: 3
scsi 0:0:16:0: Processor Promise RAID Console     1.00 PQ: 0 ANSI: 3
sd 0:0:0:0: [sda] 976642048 512-byte hardware sectors (500041 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 976642048 512-byte hardware sectors (500041 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:2:0: [sdb] Very big device.  Trying to use READ CAPACITY(16).
sd 0:0:2:0: [sdb] 11719704576 512-byte hardware sectors (6000489 MB)
sd 0:0:2:0: [sdb] Write Protect is off
sd 0:0:2:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:2:0: [sdb] Very big device.  Trying to use READ CAPACITY(16).
sd 0:0:2:0: [sdb] 11719704576 512-byte hardware sectors (6000489 MB)
sd 0:0:2:0: [sdb] Write Protect is off
sd 0:0:2:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1
sd 0:0:2:0: [sdb] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:2:0: Attached scsi generic sg1 type 0
scsi 0:0:16:0: Attached scsi generic sg2 type 3

Im not sure where the problem is (controller/lvm/ext3), so if anyone has
an idea, Im happy to try it out...

Thank you

Flavio Curti

--
http://no-way.org/~fcu/

--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="stex-panic.txt"

Jul  8 00:19:13 dorade.cyberlink.ch ------------[ cut here ]------------ 
Jul  8 00:19:13 dorade.cyberlink.ch kernel BUG at block/as-iosched.c:1084! 
Jul  8 00:19:13 dorade.cyberlink.ch invalid opcode: 0000 [#1] 
Jul  8 00:19:13 dorade.cyberlink.ch SMP 
Jul  8 00:19:13 dorade.cyberlink.ch  
Jul  8 00:19:13 dorade.cyberlink.ch Modules linked in:
Jul  8 00:19:13 dorade.cyberlink.ch  i2c_i801
Jul  8 00:19:13 dorade.cyberlink.ch  i2c_core
Jul  8 00:19:13 dorade.cyberlink.ch  
Jul  8 00:19:13 dorade.cyberlink.ch CPU:    2 
Jul  8 00:19:13 dorade.cyberlink.ch EIP:    0060:[<c02a9f17>]    Not tainted VLI 
Jul  8 00:19:13 dorade.cyberlink.ch EFLAGS: 00210046   (2.6.22-rc7-dorade #1) 
Jul  8 00:19:13 dorade.cyberlink.ch EIP is at as_dispatch_request+0x387/0x390 
Jul  8 00:19:13 dorade.cyberlink.ch eax: 00000000   ebx: c5ee10c0   ecx: c5ee10d4   edx: 00000000 
Jul  8 00:19:13 dorade.cyberlink.ch esi: 00000000   edi: 00000001   ebp: 00000000   esp: cd90bbd4 
Jul  8 00:19:13 dorade.cyberlink.ch ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068 
Jul  8 00:19:13 dorade.cyberlink.ch Process vsftpd (pid: 5332, ti=cd90a000 task=f780d030 task.ti=cd90a000)
Jul  8 00:19:13 dorade.cyberlink.ch  
Jul  8 00:19:13 dorade.cyberlink.ch Stack: 
Jul  8 00:19:13 dorade.cyberlink.ch c012abe7 
Jul  8 00:19:13 dorade.cyberlink.ch f784c5cc 
Jul  8 00:19:13 dorade.cyberlink.ch c5f11000 
Jul  8 00:19:13 dorade.cyberlink.ch f784c5cc 
Jul  8 00:19:13 dorade.cyberlink.ch 00200286 
Jul  8 00:19:13 dorade.cyberlink.ch c5ee8be4 
Jul  8 00:19:13 dorade.cyberlink.ch c5f11000 
Jul  8 00:19:13 dorade.cyberlink.ch f7a16000 
Jul  8 00:19:13 dorade.cyberlink.ch  
Jul  8 00:19:13 dorade.cyberlink.ch        
Jul  8 00:19:13 dorade.cyberlink.ch c5ee8be4 
Jul  8 00:19:13 dorade.cyberlink.ch c02a0810 
Jul  8 00:19:13 dorade.cyberlink.ch f7a16000 
Jul  8 00:19:13 dorade.cyberlink.ch 00200287 
Jul  8 00:19:13 dorade.cyberlink.ch c0370076 
Jul  8 00:19:13 dorade.cyberlink.ch f784c580 
Jul  8 00:19:13 dorade.cyberlink.ch 00000000 
Jul  8 00:19:13 dorade.cyberlink.ch c5f11000 
Jul  8 00:19:13 dorade.cyberlink.ch c5ee8be4 
Jul  8 00:19:13 dorade.cyberlink.ch  
Jul  8 00:19:13 dorade.cyberlink.ch Call Trace: 
Jul  8 00:19:13 dorade.cyberlink.ch  [<c012abe7>] 
Jul  8 00:19:13 dorade.cyberlink.ch lock_timer_base+0x27/0x60 
Jul  8 00:19:13 dorade.cyberlink.ch  [<c02a0810>] 
Jul  8 00:19:13 dorade.cyberlink.ch elv_next_request+0x20/0x130 
Jul  8 00:19:13 dorade.cyberlink.ch  [<c0370076>] 
Jul  8 00:19:13 dorade.cyberlink.ch scsi_dispatch_cmd+0x146/0x230 
Jul  8 00:19:13 dorade.cyberlink.ch  [<c03752b5>] 
Jul  8 00:19:13 dorade.cyberlink.ch scsi_request_fn+0x185/0x2c0 
Jul  8 00:19:13 dorade.cyberlink.ch  [<c02a3e45>] 
Jul  8 00:19:13 dorade.cyberlink.ch __generic_unplug_device+0x25/0x30 
Jul  8 00:19:13 dorade.cyberlink.ch  [<c02a4e55>] 
Jul  8 00:19:13 dorade.cyberlink.ch generic_unplug_device+0x15/0x30 
Jul  8 00:19:13 dorade.cyberlink.ch  [<c03dc582>] 
Jul  8 00:19:13 dorade.cyberlink.ch dm_table_unplug_all+0x22/0x30 
Jul  8 00:19:13 dorade.cyberlink.ch  [<c03da437>] 
Jul  8 00:19:13 dorade.cyberlink.ch dm_unplug_all+0x17/0x30 
Jul  8 00:19:13 dorade.cyberlink.ch  [<c02a163c>] 
Jul  8 00:19:13 dorade.cyberlink.ch blk_backing_dev_unplug+0xc/0x10 
Jul  8 00:19:13 dorade.cyberlink.ch  [<c0192dab>] 
Jul  8 00:19:13 dorade.cyberlink.ch sync_buffer+0x2b/0x40 
Jul  8 00:19:13 dorade.cyberlink.ch  [<c04d99c2>] 
Jul  8 00:19:13 dorade.cyberlink.ch __wait_on_bit+0x42/0x70 
Jul  8 00:19:13 dorade.cyberlink.ch  [<c0192d80>] 
Jul  8 00:19:13 dorade.cyberlink.ch sync_buffer+0x0/0x40 
Jul  8 00:19:13 dorade.cyberlink.ch __wait_on_buffer+0x24/0x30 
Jul  8 00:19:13 dorade.cyberlink.ch sync_dirty_buffer+0x7e/0xd0 
Jul  8 00:19:13 dorade.cyberlink.ch  [<c01f77e1>] 
Jul  8 00:19:13 dorade.cyberlink.ch start_this_handle+0x81/0x3c0 
Jul  8 00:19:13 dorade.cyberlink.ch  [<c01f86e5>] 
Jul  8 00:19:13 dorade.cyberlink.ch journal_dirty_data+0x1c5/0x210 
Jul  8 00:19:13 dorade.cyberlink.ch  [<c01e70e8>] 
Jul  8 00:19:13 dorade.cyberlink.ch ext3_journal_dirty_data+0x18/0x50 
Jul  8 00:19:13 dorade.cyberlink.ch  [<c01f7bd7>] 
Jul  8 00:19:13 dorade.cyberlink.ch journal_start+0xb7/0xe0 
Jul  8 00:19:13 dorade.cyberlink.ch  [<c01e643e>] 
Jul  8 00:19:13 dorade.cyberlink.ch walk_page_buffers+0x3e/0x80 
Jul  8 00:19:13 dorade.cyberlink.ch  [<c01e8f91>] 
Jul  8 00:19:13 dorade.cyberlink.ch ext3_ordered_commit_write+0x51/0xf0 
Jul  8 00:19:13 dorade.cyberlink.ch  [<c01e70d0>] 
Jul  8 00:19:13 dorade.cyberlink.ch ext3_journal_dirty_data+0x0/0x50 
Jul  8 00:19:13 dorade.cyberlink.ch  [<c0153741>] 
Jul  8 00:19:13 dorade.cyberlink.ch generic_file_buffered_write+0x281/0x680 
Jul  8 00:19:13 dorade.cyberlink.ch 01 
Jul  8 00:19:13 dorade.cyberlink.ch c7 
Jul  8 00:19:13 dorade.cyberlink.ch 00 
Jul  8 00:19:13 dorade.cyberlink.ch e9 
Jul  8 00:19:13 dorade.cyberlink.ch ff 
Jul  8 00:19:13 dorade.cyberlink.ch fe 
Jul  8 00:19:13 dorade.cyberlink.ch 74 
Jul  8 00:19:13 dorade.cyberlink.ch 26 
Jul  8 00:19:13 dorade.cyberlink.ch 40 
Jul  8 00:19:13 dorade.cyberlink.ch 50 
Jul  8 00:19:13 dorade.cyberlink.ch 83 
Jul  8 00:19:13 dorade.cyberlink.ch  
Jul  8 00:19:13 dorade.cyberlink.ch EIP: [<c02a9f17>] 
Jul  8 00:19:13 dorade.cyberlink.ch as_dispatch_request+0x387/0x390
Jul  8 00:19:13 dorade.cyberlink.ch  SS:ESP 0068:cd90bbd4 

--6c2NcOVqGQ03X4Wi--
