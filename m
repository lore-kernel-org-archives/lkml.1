Return-Path: <linux-kernel-owner+w=401wt.eu-S932538AbZIDAJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932538AbZIDAJ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 20:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756592AbZIDAJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 20:09:58 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:33961 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586AbZIDAJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 20:09:57 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=w4iE+TBsmj5y1WloLYF40w==:17 a=Gcw-aV9ETPAvEENxTgAA:9
 a=wFi6mghf-P8OSW1YKicA:7 a=t-4xqaY_qgryhO_ZSaDWz3y7G2cA:4
From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
To: linux-kernel@vger.kernel.org
Subject: mvsas issues
Date: Thu, 3 Sep 2009 18:09:58 -0600
User-Agent: KMail/1.12.90 (Linux/2.6.31-rc8; KDE/4.3.64; x86_64; svn-1004284; 2009-07-29)
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200909031809.58107.tfjellstrom@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just got a Marvell SAS card, And I've been trying to copy one set of disks 
over to another before one of the drives dies for good...

I've just gotten these errors:

[ 2753.780685] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5                                                                                                                                                                        
[ 2753.780690] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5                                                                                                                                                                        
[ 2753.780726] sd 2:0:4:0: [sdg] Unhandled error code                                                                                                                                                                                       
[ 2753.780732] sd 2:0:4:0: [sdg] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT                                                                                                                                                          
[ 2753.780740] end_request: I/O error, dev sdg, sector 184697600                                                                                                                                                                            
[ 2753.780749] Buffer I/O error on device md1, logical block 46173904                                                                                                                                                                       
[ 2753.780758] Buffer I/O error on device md1, logical block 46173905                                                                                                                                                                       
[ 2753.780764] Buffer I/O error on device md1, logical block 46173906                                                                                                                                                                       
[ 2753.780769] Buffer I/O error on device md1, logical block 46173907                                                                                                                                                                       
[ 2753.780775] Buffer I/O error on device md1, logical block 46173908                                                                                                                                                                       
[ 2753.780780] Buffer I/O error on device md1, logical block 46173909                                                                                                                                                                       
[ 2753.780786] Buffer I/O error on device md1, logical block 46173910                                                                                                                                                                       
[ 2753.780793] Buffer I/O error on device md1, logical block 46173911                                                                                                                                                                       
[ 2753.780799] Buffer I/O error on device md1, logical block 46173912                                                                                                                                                                       
[ 2753.780804] Buffer I/O error on device md1, logical block 46173913                                                                                                                                                                       
[ 2753.780914] sd 2:0:0:0: [sdc] Unhandled error code                                                                                                                                                                                       
[ 2753.780918] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT                                                                                                                                                          
[ 2753.780925] end_request: I/O error, dev sdc, sector 3145736                                                                                                                                                                              
[ 2753.780959] sd 2:0:0:0: [sdc] Unhandled error code                                                                                                                                                                                       
[ 2753.780963] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT                                                                                                                                                          
[ 2753.780970] end_request: I/O error, dev sdc, sector 2097272                                                                                                                                                                              
[ 2753.780981] sd 2:0:0:0: [sdc] Unhandled error code                                                                                                                                                                                       
[ 2753.780985] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT                                                                                                                                                          
[ 2753.780991] end_request: I/O error, dev sdc, sector 2097264                                                                                                                                                                              
[ 2753.781002] sd 2:0:0:0: [sdc] Unhandled error code                                                                                                                                                                                       
[ 2753.781006] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT                                                                                                                                                          
[ 2753.781012] end_request: I/O error, dev sdc, sector 1049856                                                                                                                                                                              
[ 2753.781023] sd 2:0:0:0: [sdc] Unhandled error code                                                                                                                                                                                       
[ 2753.781028] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT                                                                                                                                                          
[ 2753.781034] end_request: I/O error, dev sdc, sector 1048832                                                                                                                                                                              
[ 2753.781044] sd 2:0:0:0: [sdc] Unhandled error code                                                                                                                                                                                       
[ 2753.781048] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT                                                                                                                                                          
[ 2753.781055] end_request: I/O error, dev sdc, sector 18920                                                                                                                                                                                
[ 2753.781065] sd 2:0:0:0: [sdc] Unhandled error code                                                                                                                                                                                       
[ 2753.781070] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT                                                                                                                                                          
[ 2753.781076] end_request: I/O error, dev sdc, sector 18912                                                                                                                                                                                
[ 2753.781086] sd 2:0:0:0: [sdc] Unhandled error code                                                                                                                                                                                       
[ 2753.781090] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT                                                                                                                                                          
[ 2753.781096] end_request: I/O error, dev sdc, sector 18776                                                                                                                                                                                
[ 2753.781108] sd 2:0:0:0: [sdc] Unhandled error code                                                                                                                                                                                       
[ 2753.781112] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT                                                                                                                                                          
[ 2753.781119] end_request: I/O error, dev sdc, sector 15624                                                                                                                                                                                
[ 2753.781129] sd 2:0:0:0: [sdc] Unhandled error code                                                                                                                                                                                       
[ 2753.781133] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT                                                                                                                                                          
[ 2753.781139] end_request: I/O error, dev sdc, sector 14600                                                                                                                                                                                
[ 2753.781149] sd 2:0:0:0: [sdc] Unhandled error code                                                                                                                                                                                       
[ 2753.781154] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT                                                                                                                                                          
[ 2753.781160] end_request: I/O error, dev sdc, sector 13576                                                                                                                                                                                
[ 2753.781176] sd 2:0:0:0: [sdc] Unhandled error code                                                                                                                                                                                       
[ 2753.781181] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT                                                                                                                                                          
[ 2753.781187] end_request: I/O error, dev sdc, sector 12552                                                                                                                                                                                
[ 2753.781198] sd 2:0:0:0: [sdc] Unhandled error code                                                                                                                                                                                       
[ 2753.781202] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT                                                                                                                                                          
[ 2753.781208] end_request: I/O error, dev sdc, sector 5384                                                                                                                                                                                 
[ 2753.781221] sd 2:0:0:0: [sdc] Unhandled error code
[ 2753.781225] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
[ 2753.781232] end_request: I/O error, dev sdc, sector 2504
[ 2753.781255] sd 2:0:0:0: [sdc] Unhandled error code
[ 2753.781259] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
[ 2753.781266] end_request: I/O error, dev sdc, sector 976296680
[ 2753.781306] sd 2:0:0:0: [sdc] Unhandled error code
[ 2753.781310] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
[ 2753.781316] end_request: I/O error, dev sdc, sector 15800320
[ 2753.781528] sd 2:0:0:0: [sdc] Unhandled error code
[ 2753.781533] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
[ 2753.781539] end_request: I/O error, dev sdc, sector 15799296
[ 2753.781732] sd 2:0:2:0: [sde] Unhandled error code
[ 2753.781737] sd 2:0:2:0: [sde] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
[ 2753.781743] end_request: I/O error, dev sde, sector 15799296
[ 2753.781928] sd 2:0:2:0: [sde] Unhandled error code
[ 2753.781932] sd 2:0:2:0: [sde] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
[ 2753.781938] end_request: I/O error, dev sde, sector 15798272
[ 2753.782132] sd 2:0:3:0: [sdf] Unhandled error code
[ 2753.782137] sd 2:0:3:0: [sdf] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
[ 2753.782144] end_request: I/O error, dev sdf, sector 15799296
[ 2753.782334] sd 2:0:3:0: [sdf] Unhandled error code
[ 2753.782339] sd 2:0:3:0: [sdf] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
[ 2753.782345] end_request: I/O error, dev sdf, sector 15798272
[ 2753.782529] sd 2:0:1:0: [sdd] Unhandled error code
[ 2753.782533] sd 2:0:1:0: [sdd] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
[ 2753.782540] end_request: I/O error, dev sdd, sector 976295936
[ 2753.782576] sd 2:0:1:0: [sdd] Unhandled error code
[ 2753.782581] sd 2:0:1:0: [sdd] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
[ 2753.782587] end_request: I/O error, dev sdd, sector 15800248
[ 2753.782774] sd 2:0:1:0: [sdd] Unhandled error code
[ 2753.782778] sd 2:0:1:0: [sdd] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
[ 2753.782785] end_request: I/O error, dev sdd, sector 15799224
[ 2753.783580] JBD2: Detected IO errors while flushing file data on md2:8
[ 2753.783672] Aborting journal on device md2:8.
[ 2753.783691] mpage_da_map_blocks block allocation failed for inode 379 at 
logical offset 519411 with max blocks 1024 with error -30
[ 2753.783701] This should not happen.!! Data will be lost
[ 2753.784754] EXT4-fs error (device md2) in ext4_da_writepages: Journal has 
aborted
[ 2753.784761] EXT4-fs (md2): Remounting filesystem read-only
[ 2784.780045] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 2784.780049] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 3000.628252] INFO: task rsync:9019 blocked for more than 120 seconds.
[ 3000.628259] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables 
this message.
[ 3000.628266] rsync         D 0000000000000000     0  9019      1 0x00000004
[ 3000.628277]  ffff88012fb428c0 0000000000000082 ffff8800b050b818 
ffff88008006ae98
[ 3000.628287]  ffff8800988d0130 0000000000014800 000000000000f800 
ffff8800b38051c0
[ 3000.628296]  ffff8800b38054b8 000000021b937c38 0000000000000000 
0000000000001000
[ 3000.628304] Call Trace:
[ 3000.628320]  [<ffffffff81017015>] ? read_tsc+0xa/0x20
[ 3000.628330]  [<ffffffff810661e9>] ? getnstimeofday+0x55/0xaf
[ 3000.628341]  [<ffffffff810f7cb8>] ? sync_buffer+0x0/0x40
[ 3000.628350]  [<ffffffff812dc68b>] ? io_schedule+0x63/0xa5
[ 3000.628358]  [<ffffffff810f7cf3>] ? sync_buffer+0x3b/0x40
[ 3000.628367]  [<ffffffff812dc89e>] ? __wait_on_bit_lock+0x3f/0x84
[ 3000.628375]  [<ffffffff810f7cb8>] ? sync_buffer+0x0/0x40
[ 3000.628383]  [<ffffffff812dc94e>] ? out_of_line_wait_on_bit_lock+0x6b/0x77
[ 3000.628392]  [<ffffffff8105ef14>] ? wake_bit_function+0x0/0x23
[ 3000.628424]  [<ffffffffa033ffac>] ? do_get_write_access+0x69/0x421 [jbd2]
[ 3000.628434]  [<ffffffff81054b00>] ? __mod_timer+0xf7/0x109
[ 3000.628442]  [<ffffffff81061c8a>] ? ktime_get_ts+0x21/0x49
[ 3000.628468]  [<ffffffffa0340386>] ? jbd2_journal_get_write_access+0x22/0x33 
[jbd2]
[ 3000.628521]  [<ffffffffa0376295>] ? 
__ext4_journal_get_write_access+0x4b/0x53 [ext4]
[ 3000.628574]  [<ffffffffa035efc6>] ? ext4_delete_entry+0x7c/0x15c [ext4]
[ 3000.628618]  [<ffffffffa03625d7>] ? ext4_unlink+0x107/0x1c8 [ext4]
[ 3000.628632]  [<ffffffff810e289e>] ? vfs_unlink+0x72/0xa6
[ 3000.628644]  [<ffffffff810e405c>] ? do_unlinkat+0xad/0x134
[ 3000.628656]  [<ffffffff810314e5>] ? do_page_fault+0x25f/0x27b
[ 3000.628668]  [<ffffffff811731b1>] ? __up_read+0x13/0x8e
[ 3000.628678]  [<ffffffff812dda95>] ? page_fault+0x25/0x30
[ 3000.628693]  [<ffffffff81010a02>] ? system_call_fastpath+0x16/0x1b
[ 3001.780200] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 3001.780209] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5

seemingly once one disk errors, it causes the entire controller to timeout, 
and it makes ext4 very unhappy.

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
