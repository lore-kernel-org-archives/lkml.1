Return-Path: <linux-kernel-owner+w=401wt.eu-S1758013AbXINUfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013AbXINUfs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 16:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752482AbXINUfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 16:35:41 -0400
Received: from ox.emgs.com ([194.248.190.99]:58573 "EHLO ox.emgs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444AbXINUfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 16:35:40 -0400
Message-ID: <46EAF099.9070805@pvv.org>
Date: Fri, 14 Sep 2007 22:35:37 +0200
From: Jon Ivar Rykkelid <jonry@pvv.org>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
Cc: Prakash Punnoor <prakash@punnoor.de>, Tejun Heo <htejun@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: Re: sata_nv issues with MCP51 SATA controller
References: <46E8EABF.3060409@pvv.org> <46E953D7.5070305@gmail.com> <46E97AFF.30202@pvv.org> <200709141529.11363.prakash@punnoor.de> <46EA97F0.9000300@pvv.org>
In-Reply-To: <46EA97F0.9000300@pvv.org>
Content-Type: multipart/mixed;
 boundary="------------090609060902040401060705"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090609060902040401060705
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi, I'm getting inmore confident that the driver is the issue.

I have now been able to reproduce the same error on the new motherboard 
as well... - (the same MB was tested to work in Windows with 
windows-drivers)...

Unless you guys can come up with something clever, I'll see if I can get 
my hands on / change to another (non-nvidia) chipset in a day or two, as 
the sata_nv with this chipset apparently isn't working.

(Or have anyone EVER been successful with the latest kernel/driver on 
this HW)?

Attaching everything relevant from /var/log/messages...


Jon Ivar Rykkelid wrote:
> I'm going to test another (identical) motherboard this evening to 
> establish whether it could be a HW-issue.
>
> I'll keep you posted
Jon Ivar



--------------090609060902040401060705
Content-Type: text/plain;
 name="sata_nv-new.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sata_nv-new.log"

Sep 14 20:09:15 mirakel kernel: ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
Sep 14 20:09:15 mirakel kernel: ata3.00: cmd 35/00:08:bf:44:1c/00:00:1d:00:00/e0 tag 0 cdb 0x0 data 4096 out
Sep 14 20:09:15 mirakel kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Sep 14 20:09:15 mirakel kernel: ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
Sep 14 20:09:15 mirakel kernel: ata4.00: cmd 35/00:08:bf:44:1c/00:00:1d:00:00/e0 tag 0 cdb 0x0 data 4096 out
Sep 14 20:09:15 mirakel kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Sep 14 20:09:16 mirakel kernel: ata3: soft resetting port
Sep 14 20:09:16 mirakel kernel: ata4: soft resetting port
Sep 14 20:09:16 mirakel kernel: ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Sep 14 20:09:16 mirakel kernel: ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Sep 14 20:09:46 mirakel kernel: ata3.00: qc timeout (cmd 0x27)
Sep 14 20:09:46 mirakel kernel: ata3.00: ata_hpa_resize 1: hpa sectors (0) is smaller than sectors (490234752)
Sep 14 20:09:46 mirakel kernel: ata3.00: failed to set xfermode (err_mask=0x40)
Sep 14 20:09:46 mirakel kernel: ata3: failed to recover some devices, retrying in 5 secs
Sep 14 20:09:46 mirakel kernel: ata4.00: qc timeout (cmd 0x27)
Sep 14 20:09:46 mirakel kernel: ata4.00: ata_hpa_resize 1: hpa sectors (0) is smaller than sectors (490234752)
Sep 14 20:09:46 mirakel kernel: ata4.00: failed to set xfermode (err_mask=0x40)
Sep 14 20:09:46 mirakel kernel: ata4: failed to recover some devices, retrying in 5 secs
Sep 14 20:09:51 mirakel kernel: ata3: hard resetting port
Sep 14 20:09:51 mirakel kernel: ata4: hard resetting port
Sep 14 20:09:51 mirakel kernel: ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Sep 14 20:09:51 mirakel kernel: ata4: SRST failed (errno=-19)
Sep 14 20:09:51 mirakel kernel: ata4: reset failed (errno=-19), retrying in 10 secs
Sep 14 20:10:01 mirakel kernel: ata4: hard resetting port
Sep 14 20:10:01 mirakel kernel: ata4: SRST failed (errno=-19)
Sep 14 20:10:01 mirakel kernel: ata4: reset failed (errno=-19), retrying in 10 secs
Sep 14 20:10:11 mirakel kernel: ata4: hard resetting port
Sep 14 20:10:11 mirakel kernel: ata4: SRST failed (errno=-19)
Sep 14 20:10:11 mirakel kernel: ata4: reset failed (errno=-19), retrying in 35 secs
Sep 14 20:10:21 mirakel kernel: ata3.00: qc timeout (cmd 0x27)
Sep 14 20:10:21 mirakel kernel: ata3.00: ata_hpa_resize 1: hpa sectors (0) is smaller than sectors (490234752)
Sep 14 20:10:21 mirakel kernel: ata3.00: failed to set xfermode (err_mask=0x40)
Sep 14 20:10:21 mirakel kernel: ata3.00: limiting speed to UDMA/133:PIO3
Sep 14 20:10:21 mirakel kernel: ata3: failed to recover some devices, retrying in 5 secs
Sep 14 20:10:26 mirakel kernel: ata3: hard resetting port
Sep 14 20:10:27 mirakel kernel: ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Sep 14 20:10:46 mirakel kernel: ata4: hard resetting port
Sep 14 20:10:46 mirakel kernel: ata4: SRST failed (errno=-19)
Sep 14 20:10:46 mirakel kernel: ata4: reset failed, giving up
Sep 14 20:10:46 mirakel kernel: ata4.00: disabled
Sep 14 20:10:46 mirakel kernel: ata4: EH complete
Sep 14 20:10:46 mirakel kernel: sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Sep 14 20:10:46 mirakel kernel: end_request: I/O error, dev sdd, sector 488391871
Sep 14 20:10:46 mirakel kernel: md: super_written gets error=-5, uptodate=0
Sep 14 20:10:46 mirakel kernel: raid5: Disk failure on sdd1, disabling device. Operation continuing on 7 devices
Sep 14 20:10:57 mirakel kernel: ata3.00: qc timeout (cmd 0x27)
Sep 14 20:10:57 mirakel kernel: ata3.00: ata_hpa_resize 1: hpa sectors (0) is smaller than sectors (490234752)
Sep 14 20:10:57 mirakel kernel: ata3.00: failed to set xfermode (err_mask=0x40)
Sep 14 20:10:57 mirakel kernel: ata3.00: disabled
Sep 14 20:10:58 mirakel kernel: ata3: EH complete
Sep 14 20:10:58 mirakel kernel: sd 2:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Sep 14 20:10:58 mirakel kernel: end_request: I/O error, dev sdc, sector 488391871
Sep 14 20:10:58 mirakel kernel: sd 2:0:0:0: [sdc] READ CAPACITY failed
Sep 14 20:10:58 mirakel kernel: sd 2:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Sep 14 20:10:58 mirakel kernel: sd 2:0:0:0: [sdc] Sense not available.
Sep 14 20:10:58 mirakel kernel: sd 2:0:0:0: [sdc] Write Protect is off
Sep 14 20:10:58 mirakel kernel: sd 2:0:0:0: [sdc] Asking for cache data failed
Sep 14 20:10:58 mirakel kernel: sd 2:0:0:0: [sdc] Assuming drive cache: write through
Sep 14 20:10:58 mirakel kernel: md: super_written gets error=-5, uptodate=0
Sep 14 20:10:58 mirakel kernel: raid5: Disk failure on sdc1, disabling device. Operation continuing on 6 devices
Sep 14 20:10:58 mirakel kernel: RAID5 conf printout:
Sep 14 20:10:58 mirakel kernel: Buffer I/O error on device md0, logical block 119194013
Sep 14 20:10:58 mirakel kernel: lost page write due to I/O error on md0
Sep 14 20:10:58 mirakel kernel: Buffer I/O error on device md0, logical block 119194014
Sep 14 20:10:58 mirakel kernel: lost page write due to I/O error on md0
Sep 14 20:10:58 mirakel kernel: Buffer I/O error on device md0, logical block 6660
Sep 14 20:10:58 mirakel kernel: lost page write due to I/O error on md0
Sep 14 20:10:58 mirakel kernel: Aborting journal on device md0.
Sep 14 20:10:58 mirakel kernel:  --- rd:8 wd:6
Sep 14 20:10:58 mirakel kernel:  disk 0, o:1, dev:hdg1
Sep 14 20:10:58 mirakel kernel:  disk 1, o:1, dev:hdo1
Sep 14 20:10:58 mirakel kernel:  disk 2, o:1, dev:dm-0
Sep 14 20:10:58 mirakel kernel:  disk 3, o:1, dev:hds1
Sep 14 20:10:58 mirakel kernel:  disk 4, o:1, dev:dm-1
Sep 14 20:10:58 mirakel kernel:  disk 5, o:0, dev:sdd1
Sep 14 20:10:58 mirakel kernel:  disk 6, o:1, dev:hdk1
Sep 14 20:10:58 mirakel kernel:  disk 7, o:0, dev:sdc1
Sep 14 20:10:58 mirakel kernel: ext3_abort called.
Sep 14 20:10:58 mirakel kernel: EXT3-fs error (device md0): ext3_journal_start_sb: Detected aborted journal
Sep 14 20:10:58 mirakel kernel: Remounting filesystem read-only
Sep 14 20:10:58 mirakel kernel: RAID5 conf printout:
Sep 14 20:10:58 mirakel kernel:  --- rd:8 wd:6
Sep 14 20:10:58 mirakel kernel:  disk 0, o:1, dev:hdg1
Sep 14 20:10:58 mirakel kernel:  disk 1, o:1, dev:hdo1
Sep 14 20:10:58 mirakel kernel:  disk 2, o:1, dev:dm-0
Sep 14 20:10:58 mirakel kernel:  disk 3, o:1, dev:hds1
Sep 14 20:10:58 mirakel kernel:  disk 4, o:1, dev:dm-1
Sep 14 20:10:58 mirakel kernel:  disk 5, o:0, dev:sdd1
Sep 14 20:10:58 mirakel kernel:  disk 6, o:1, dev:hdk1
Sep 14 20:10:58 mirakel kernel: RAID5 conf printout:
Sep 14 20:10:58 mirakel kernel:  --- rd:8 wd:6
Sep 14 20:10:58 mirakel kernel:  disk 0, o:1, dev:hdg1
Sep 14 20:10:58 mirakel kernel:  disk 1, o:1, dev:hdo1
Sep 14 20:10:58 mirakel kernel:  disk 2, o:1, dev:dm-0
Sep 14 20:10:58 mirakel kernel:  disk 3, o:1, dev:hds1
Sep 14 20:10:58 mirakel kernel:  disk 4, o:1, dev:dm-1
Sep 14 20:10:58 mirakel kernel:  disk 5, o:0, dev:sdd1
Sep 14 20:10:58 mirakel kernel:  disk 6, o:1, dev:hdk1
Sep 14 20:10:58 mirakel kernel: RAID5 conf printout:
Sep 14 20:10:58 mirakel kernel:  --- rd:8 wd:6
Sep 14 20:10:58 mirakel kernel:  disk 0, o:1, dev:hdg1
Sep 14 20:10:58 mirakel kernel:  disk 1, o:1, dev:hdo1
Sep 14 20:10:58 mirakel kernel:  disk 2, o:1, dev:dm-0
Sep 14 20:10:58 mirakel kernel:  disk 3, o:1, dev:hds1
Sep 14 20:10:58 mirakel kernel:  disk 4, o:1, dev:dm-1
Sep 14 20:10:58 mirakel kernel:  disk 6, o:1, dev:hdk1
Sep 14 20:10:59 mirakel kernel: Buffer I/O error on device md0, logical block 29
Sep 14 20:10:59 mirakel kernel: lost page write due to I/O error on md0
Sep 14 20:10:59 mirakel kernel: Buffer I/O error on device md0, logical block 30
Sep 14 20:10:59 mirakel kernel: lost page write due to I/O error on md0
Sep 14 20:10:59 mirakel kernel: Buffer I/O error on device md0, logical block 119177216
Sep 14 20:10:59 mirakel kernel: lost page write due to I/O error on md0
Sep 14 20:10:59 mirakel kernel: Buffer I/O error on device md0, logical block 119180640
Sep 14 20:10:59 mirakel kernel: lost page write due to I/O error on md0
Sep 14 20:10:59 mirakel kernel: Buffer I/O error on device md0, logical block 119180739
Sep 14 20:10:59 mirakel kernel: lost page write due to I/O error on md0
Sep 14 20:10:59 mirakel kernel: Buffer I/O error on device md0, logical block 119193951
Sep 14 20:10:59 mirakel kernel: lost page write due to I/O error on md0
Sep 14 20:10:59 mirakel kernel: Buffer I/O error on device md0, logical block 119193953
Sep 14 20:10:59 mirakel kernel: lost page write due to I/O error on md0

--------------090609060902040401060705--
