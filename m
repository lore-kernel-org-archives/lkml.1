Return-Path: <linux-kernel-owner+w=401wt.eu-S1757479AbYAHOxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479AbYAHOxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 09:53:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbYAHOx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 09:53:28 -0500
Received: from neuf-infra-smtp-out-sp604007av.neufgp.fr ([84.96.92.120]:55328
	"EHLO neuf-infra-smtp-out-sp604007av.neufgp.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752538AbYAHOxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 09:53:25 -0500
In-Reply-To: <4782C3DB.1090201@shaw.ca>
References: <fa.NcJePXcdrF+7E7oXv5ULIxogTYI@ifi.uio.no> <4782C3DB.1090201@shaw.ca>
Mime-Version: 1.0 (Apple Message framework v753)
Content-Type: multipart/mixed; boundary=Apple-Mail-11-305940322
Message-Id: <2A722A49-F024-44E9-9FC8-7B714FB25626@neuf.fr>
Cc: linux-kernel@vger.kernel.org, ide <linux-ide@vger.kernel.org>
From: =?ISO-8859-1?Q?Guillaume_Laur=E8s?= <guillaume-laures@neuf.fr>
Subject: Re: PROBLEM: I/O scheduler problem with an 8 SATA disks raid 5 under heavy load  ?
Date: Tue, 8 Jan 2008 15:52:35 +0100
To: Robert Hancock <hancockr@shaw.ca>
X-Mailer: Apple Mail (2.753)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail-11-305940322
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=ISO-8859-1;
	delsp=yes;
	format=flowed


Le 8 janv. 08 =E0 01:29, Robert Hancock a =E9crit :

> =46rom your report:
>
> ata5: EH in ADMA mode, notifier 0x0 notifier_error 0x0 gen_ctl =20
> 0x1501000 status 0x400
> ata5: CPB 0: ctl_flags 0x1f, resp_flags 0x1
> ata5: CPB 1: ctl_flags 0x1f, resp_flags 0x2
> ata5: CPB 2: ctl_flags 0x1f, resp_flags 0x1
> ata5: CPB 3: ctl_flags 0x1f, resp_flags 0x1
> ata5: CPB 4: ctl_flags 0x1f, resp_flags 0x1
> ata5: CPB 5: ctl_flags 0x1f, resp_flags 0x1
> ata5: CPB 6: ctl_flags 0x1f, resp_flags 0x1
> ata5: CPB 7: ctl_flags 0x1f, resp_flags 0x1
> ata5: CPB 8: ctl_flags 0x1f, resp_flags 0x2
> ata5: CPB 9: ctl_flags 0x1f, resp_flags 0x2
> ata5: CPB 10: ctl_flags 0x1f, resp_flags 0x2
> ata5: CPB 11: ctl_flags 0x1f, resp_flags 0x2
> ata5: CPB 12: ctl_flags 0x1f, resp_flags 0x2
> ata5: CPB 13: ctl_flags 0x1f, resp_flags 0x1
> ata5: CPB 14: ctl_flags 0x1f, resp_flags 0x1
> ata5: CPB 15: ctl_flags 0x1f, resp_flags 0x1
> ata5: CPB 16: ctl_flags 0x1f, resp_flags 0x1
> ata5: CPB 17: ctl_flags 0x1f, resp_flags 0x1
> ata5: CPB 18: ctl_flags 0x1f, resp_flags 0x1
> ata5: CPB 19: ctl_flags 0x1f, resp_flags 0x1
> ata5: CPB 20: ctl_flags 0x1f, resp_flags 0x1
> ata5: CPB 21: ctl_flags 0x1f, resp_flags 0x1
> ata5: CPB 22: ctl_flags 0x1f, resp_flags 0x1
> ata5: CPB 23: ctl_flags 0x1f, resp_flags 0x1
> ata5: CPB 24: ctl_flags 0x1f, resp_flags 0x1
> ata5: CPB 25: ctl_flags 0x1f, resp_flags 0x1
> ata5: CPB 26: ctl_flags 0x1f, resp_flags 0x1
> ata5: CPB 27: ctl_flags 0x1f, resp_flags 0x1
> ata5: CPB 28: ctl_flags 0x1f, resp_flags 0x1
> ata5: CPB 29: ctl_flags 0x1f, resp_flags 0x1
> ata5: CPB 30: ctl_flags 0x1f, resp_flags 0x1
> ata5: Resetting port
> ata5.00: exception Emask 0x0 SAct 0x1f02 SErr 0x0 action 0x2 frozen
> ata5.00: cmd 60/40:08:8f:eb:67/00:00:03:00:00/40 tag 1 cdb 0x0 data =20=

> 32768 in
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata5.00: cmd 60/08:40:17:eb:67/00:00:03:00:00/40 tag 8 cdb 0x0 data =20=

> 4096 in
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata5.00: cmd 60/18:48:47:eb:67/00:00:03:00:00/40 tag 9 cdb 0x0 data =20=

> 12288 in
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata5.00: cmd 60/08:50:77:eb:67/00:00:03:00:00/40 tag 10 cdb 0x0 =20
> data 4096 in
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata5.00: cmd 60/08:58:87:eb:67/00:00:03:00:00/40 tag 11 cdb 0x0 =20
> data 4096 in
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata5.00: cmd 60/48:60:d7:eb:67/00:00:03:00:00/40 tag 12 cdb 0x0 =20
> data 36864 in
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata5: soft resetting port
>
> The CPB resp_flags 0x2 entries are ones where the drive has been =20
> sent the request and the controller is waiting for a response. The =20
> timeout is 30 seconds, so that means the drive failed to service =20
> those queued commands for that length of time.
>
> It may be that your drive has a poor NCQ implementation that can =20
> starve some of the pending commands for a long time under heavy load?

Thanks for your answer. That could very well be the problem, as all 4 =20=

drives on the sata_nv HBA are older than the sata_sil ones.
I'm going to swap them to see if the problem is reproducible on the =20
sata_sil HBA. (see test #2)

- Test #1
I switched the scheduler to CFQ on all disks and ran the file =20
reorganizer all night. In the morning I ended with a drive missing in =20=

the array. And lots of SATA port resets, with plenty of 0x2 again, =20
see the attached log.

--Apple-Mail-11-305940322
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	x-unix-mode=0644;
	name=dmesg-07-01_08-01.txt
Content-Disposition: attachment;
	filename=dmesg-07-01_08-01.txt

 8 cdb 0x0 data 8192 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 60/38:48:5f:e6:7b/00:00:03:00:00/40 tag 9 cdb 0x0 data 28672 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 61/08:50:37:e2:7b/00:00:03:00:00/40 tag 10 cdb 0x0 data 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 61/08:58:87:e4:7b/00:00:03:00:00/40 tag 11 cdb 0x0 data 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 60/28:60:07:e6:7b/00:00:03:00:00/40 tag 12 cdb 0x0 data 20480 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 60/08:68:37:e6:7b/00:00:03:00:00/40 tag 13 cdb 0x0 data 4096 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 61/20:70:cf:e4:7b/00:00:03:00:00/40 tag 14 cdb 0x0 data 16384 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 61/08:78:1f:e5:7b/00:00:03:00:00/40 tag 15 cdb 0x0 data 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 61/10:80:f7:e5:7b/00:00:03:00:00/40 tag 16 cdb 0x0 data 8192 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 61/08:88:7f:e4:7b/00:00:03:00:00/40 tag 17 cdb 0x0 data 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 61/08:90:8f:e4:7b/00:00:03:00:00/40 tag 18 cdb 0x0 data 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 60/08:98:2f:e6:7b/00:00:03:00:00/40 tag 19 cdb 0x0 data 4096 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 60/08:a0:47:e6:7b/00:00:03:00:00/40 tag 20 cdb 0x0 data 4096 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 61/08:a8:ff:e4:7b/00:00:03:00:00/40 tag 21 cdb 0x0 data 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 60/38:b0:7f:e5:7b/00:00:03:00:00/40 tag 22 cdb 0x0 data 28672 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 60/18:b8:d7:e5:7b/00:00:03:00:00/40 tag 23 cdb 0x0 data 12288 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 61/08:c0:57:e4:7b/00:00:03:00:00/40 tag 24 cdb 0x0 data 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 61/18:c8:77:e3:7b/00:00:03:00:00/40 tag 25 cdb 0x0 data 12288 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 61/08:d0:f7:e4:7b/00:00:03:00:00/40 tag 26 cdb 0x0 data 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 61/10:d8:77:e2:7b/00:00:03:00:00/40 tag 27 cdb 0x0 data 8192 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 61/08:e0:87:e2:7b/00:00:03:00:00/40 tag 28 cdb 0x0 data 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 61/08:e8:a7:e2:7b/00:00:03:00:00/40 tag 29 cdb 0x0 data 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 61/18:f0:e7:e2:7b/00:00:03:00:00/40 tag 30 cdb 0x0 data 12288 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata6: EH in ADMA mode, notifier 0x0 notifier_error 0x0 gen_ctl 0x1501000 status 0x500
ata6: CPB 0: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 1: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 2: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 3: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 4: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 5: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 6: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 7: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 8: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 9: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 10: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 11: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 12: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 13: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 14: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 15: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 16: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 17: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 18: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 19: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 20: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 21: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 22: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 23: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 24: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 25: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 26: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 27: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 28: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 29: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 30: ctl_flags 0x1f, resp_flags 0x1
ata6: Resetting port
sd 5:0:0:0: SCSI error: return code = 0x06000000
end_request: I/O error, dev sdf, sector 58451119
sd 5:0:0:0: SCSI error: return code = 0x06000000
end_request: I/O error, dev sdf, sector 58451087
raid5: Disk failure on sdf1, disabling device. Operation continuing on 7 devices
ata5: soft resetting port
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata5.00: configured for UDMA/133
ata5: EH complete
SCSI device sde: 398297088 512-byte hdwr sectors (203928 MB)
sde: Write Protect is off
sde: Mode Sense: 00 3a 00 00
SCSI device sde: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
RAID5 conf printout:
 --- rd:8 wd:7
 disk 0, o:1, dev:sdb1
 disk 1, o:0, dev:sdf1
 disk 2, o:1, dev:sdg1
 disk 3, o:1, dev:sdh1
 disk 4, o:1, dev:sdd1
 disk 5, o:1, dev:sdc1
 disk 6, o:1, dev:sde1
 disk 7, o:1, dev:sda1
RAID5 conf printout:
 --- rd:8 wd:7
 disk 0, o:1, dev:sdb1
 disk 2, o:1, dev:sdg1
 disk 3, o:1, dev:sdh1
 disk 4, o:1, dev:sdd1
 disk 5, o:1, dev:sdc1
 disk 6, o:1, dev:sde1
 disk 7, o:1, dev:sda1
ata8: EH in ADMA mode, notifier 0x1 notifier_error 0x0 gen_ctl 0x1501000 status 0x1540
ata8: CPB 0: ctl_flags 0xd, resp_flags 0x1
ata8: Resetting port
ata8.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata8.00: cmd ca/00:08:b7:0b:48/00:00:00:00:00/eb tag 0 cdb 0x0 data 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata7: EH in ADMA mode, notifier 0xFFFFF notifier_error 0x0 gen_ctl 0x1501000 status 0x1540
ata7: CPB 0: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 1: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 2: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 3: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 4: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 5: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 6: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 7: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 8: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 9: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 10: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 11: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 12: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 13: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 14: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 15: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 16: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 17: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 18: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 19: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 20: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 21: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 22: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 23: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 24: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 25: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 26: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 27: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 28: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 29: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 30: ctl_flags 0x1f, resp_flags 0x1
ata7: Resetting port
ata7.00: exception Emask 0x0 SAct 0xfffff SErr 0x0 action 0x2 frozen
ata7.00: cmd 60/10:00:df:f6:07/00:00:0c:00:00/40 tag 0 cdb 0x0 data 8192 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata7.00: cmd 61/08:08:3f:f4:07/00:00:0c:00:00/40 tag 1 cdb 0x0 data 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata7.00: cmd 61/08:10:8f:f7:07/00:00:0c:00:00/40 tag 2 cdb 0x0 data 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata7.00: cmd 61/08:18:37:f6:07/00:00:0c:00:00/40 tag 3 cdb 0x0 data 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata7.00: cmd 60/28:20:f7:f6:07/00:00:0c:00:00/40 tag 4 cdb 0x0 data 20480 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata7.00: cmd 61/08:28:0f:f8:07/00:00:0c:00:00/40 tag 5 cdb 0x0 data 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata7.00: cmd 61/10:30:2f:f8:07/00:00:0c:00:00/40 tag 6 cdb 0x0 data 8192 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata7.00: cmd 60/08:38:cf:f6:07/00:00:0c:00:00/40 tag 7 cdb 0x0 data 4096 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata7.00: cmd 60/08:40:ef:f6:07/00:00:0c:00:00/40 tag 8 cdb 0x0 data 4096 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata7.00: cmd 61/08:48:df:f7:07/00:00:0c:00:00/40 tag 9 cdb 0x0 data 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata7.00: cmd 61/08:50:af:f4:07/00:00:0c:00:00/40 tag 10 cdb 0x0 data 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata7.00: cmd 61/08:58:cf:f4:07/00:00:0c:00:00/40 tag 11 cdb 0x0 data 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata7.00: cmd 61/90:60:3f:f6:07/00:00:0c:00:00/40 tag 12 cdb 0x0 data 73728 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata7.00: cmd 61/08:68:d7:f6:07/00:00:0c:00:00/40 tag 13 cdb 0x0 data 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata7.00: cmd 61/18:70:47:f7:07/00:00:0c:00:00/40 tag 14 cdb 0x0 data 12288 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata7.00: cmd 61/28:78:67:f7:07/00:00:0c:00:00/40 tag 15 cdb 0x0 data 20480 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata7.00: cmd 61/08:80:97:f7:07/00:00:0c:00:00/40 tag 16 cdb 0x0 data 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata7.00: cmd 61/08:88:0f:f5:07/00:00:0c:00:00/40 tag 17 cdb 0x0 data 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata7.00: cmd 61/08:90:4f:f5:07/00:00:0c:00:00/40 tag 18 cdb 0x0 data 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata7.00: cmd 61/08:98:6f:f5:07/00:00:0c:00:00/40 tag 19 cdb 0x0 data 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata8: soft resetting port
ata7: soft resetting port
ata7: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata7.00: configured for UDMA/133
ata7: EH complete
SCSI device sdg: 390721968 512-byte hdwr sectors (200050 MB)
sdg: Write Protect is off
sdg: Mode Sense: 00 3a 00 00
SCSI device sdg: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata8: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata8.00: configured for UDMA/133
ata8: EH complete
SCSI device sdh: 390721968 512-byte hdwr sectors (200050 MB)
sdh: Write Protect is off
sdh: Mode Sense: 00 3a 00 00
SCSI device sdh: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata8: EH in ADMA mode, notifier 0x1 notifier_error 0x0 gen_ctl 0x1501000 status 0x1540
ata8: CPB 0: ctl_flags 0xd, resp_flags 0x1
ata8: Resetting port
ata8.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata8.00: cmd ca/00:08:9f:17:23/00:00:00:00:00/e4 tag 0 cdb 0x0 data 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata7: EH in ADMA mode, notifier 0x19 notifier_error 0x0 gen_ctl 0x1501000 status 0x1540
ata7: CPB 0: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 1: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 2: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 3: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 4: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 5: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 6: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 7: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 8: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 9: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 10: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 11: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 12: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 13: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 14: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 15: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 16: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 17: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 18: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 19: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 20: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 21: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 22: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 23: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 24: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 25: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 26: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 27: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 28: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 29: ctl_flags 0x1f, resp_flags 0x1
ata7: CPB 30: ctl_flags 0x1f, resp_flags 0x1
ata7: Resetting port
ata7.00: exception Emask 0x0 SAct 0x19 SErr 0x0 action 0x2 frozen
ata7.00: cmd 60/10:00:ef:59:bc/00:00:06:00:00/40 tag 0 cdb 0x0 data 8192 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata7.00: cmd 61/08:18:cf:17:23/00:00:04:00:00/40 tag 3 cdb 0x0 data 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata7.00: cmd 61/18:20:b7:17:23/00:00:04:00:00/40 tag 4 cdb 0x0 data 12288 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata8: soft resetting port
ata7: soft resetting port
ata7: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata8: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata8.00: configured for UDMA/133
ata8: EH complete
SCSI device sdh: 390721968 512-byte hdwr sectors (200050 MB)
sdh: Write Protect is off
sdh: Mode Sense: 00 3a 00 00
SCSI device sdh: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata7.00: configured for UDMA/133
ata7: EH complete
SCSI device sdg: 390721968 512-byte hdwr sectors (200050 MB)
sdg: Write Protect is off
sdg: Mode Sense: 00 3a 00 00
SCSI device sdg: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
md: unbind<sdf1>
md: export_rdev(sdf1)
md: bind<sdf1>
RAID5 conf printout:
 --- rd:8 wd:7
 disk 0, o:1, dev:sdb1
 disk 1, o:1, dev:sdf1
 disk 2, o:1, dev:sdg1
 disk 3, o:1, dev:sdh1
 disk 4, o:1, dev:sdd1
 disk 5, o:1, dev:sdc1
 disk 6, o:1, dev:sde1
 disk 7, o:1, dev:sda1
md: recovery of RAID array md2
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
md: using 128k window, over a total of 195358208 blocks.
ata5: EH in ADMA mode, notifier 0x1 notifier_error 0x0 gen_ctl 0x1501000 status 0x1540
ata5: CPB 0: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 1: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 2: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 3: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 4: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 5: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 6: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 7: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 8: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 9: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 10: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 11: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 12: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 13: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 14: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 15: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 16: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 17: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 18: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 19: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 20: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 21: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 22: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 23: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 24: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 25: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 26: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 27: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 28: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 29: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 30: ctl_flags 0x1f, resp_flags 0x1
ata5: Resetting port
ata5.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x2 frozen
ata5.00: cmd 61/08:00:77:dd:49/00:00:17:00:00/40 tag 0 cdb 0x0 data 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5: soft resetting port
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata5.00: configured for UDMA/133
ata5: EH complete
SCSI device sde: 398297088 512-byte hdwr sectors (203928 MB)
sde: Write Protect is off
sde: Mode Sense: 00 3a 00 00
SCSI device sde: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata5: EH in ADMA mode, notifier 0x1 notifier_error 0x0 gen_ctl 0x1501000 status 0x1540
ata5: CPB 0: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 1: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 2: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 3: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 4: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 5: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 6: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 7: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 8: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 9: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 10: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 11: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 12: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 13: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 14: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 15: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 16: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 17: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 18: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 19: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 20: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 21: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 22: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 23: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 24: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 25: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 26: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 27: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 28: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 29: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 30: ctl_flags 0x1e, resp_flags 0x1
ata5: Resetting port
ata5.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x2 frozen
ata5.00: cmd 61/08:00:77:dd:49/00:00:17:00:00/40 tag 0 cdb 0x0 data 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5: soft resetting port
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata5.00: configured for UDMA/133
ata5: EH complete
SCSI device sde: 398297088 512-byte hdwr sectors (203928 MB)
sde: Write Protect is off
sde: Mode Sense: 00 3a 00 00
SCSI device sde: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata5: EH in ADMA mode, notifier 0x1 notifier_error 0x0 gen_ctl 0x1501000 status 0x1540
ata5: CPB 0: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 1: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 2: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 3: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 4: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 5: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 6: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 7: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 8: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 9: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 10: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 11: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 12: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 13: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 14: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 15: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 16: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 17: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 18: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 19: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 20: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 21: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 22: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 23: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 24: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 25: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 26: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 27: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 28: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 29: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 30: ctl_flags 0x1e, resp_flags 0x1
ata5: Resetting port
ata5.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x2 frozen
ata5.00: cmd 61/08:00:77:dd:49/00:00:17:00:00/40 tag 0 cdb 0x0 data 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5: soft resetting port
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata5.00: configured for UDMA/133
ata5: EH complete
SCSI device sde: 398297088 512-byte hdwr sectors (203928 MB)
sde: Write Protect is off
sde: Mode Sense: 00 3a 00 00
SCSI device sde: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata5: EH in ADMA mode, notifier 0x1 notifier_error 0x0 gen_ctl 0x1501000 status 0x1540
ata5: CPB 0: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 1: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 2: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 3: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 4: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 5: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 6: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 7: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 8: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 9: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 10: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 11: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 12: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 13: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 14: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 15: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 16: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 17: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 18: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 19: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 20: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 21: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 22: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 23: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 24: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 25: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 26: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 27: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 28: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 29: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 30: ctl_flags 0x1e, resp_flags 0x1
ata5: Resetting port
ata5.00: limiting speed to UDMA/100
ata5.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x2 frozen
ata5.00: cmd 61/08:00:77:dd:49/00:00:17:00:00/40 tag 0 cdb 0x0 data 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5: soft resetting port
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata5.00: configured for UDMA/100
ata5: EH complete
SCSI device sde: 398297088 512-byte hdwr sectors (203928 MB)
sde: Write Protect is off
sde: Mode Sense: 00 3a 00 00
SCSI device sde: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata5: EH in ADMA mode, notifier 0x1 notifier_error 0x0 gen_ctl 0x1501000 status 0x1540
ata5: CPB 0: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 1: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 2: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 3: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 4: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 5: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 6: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 7: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 8: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 9: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 10: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 11: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 12: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 13: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 14: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 15: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 16: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 17: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 18: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 19: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 20: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 21: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 22: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 23: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 24: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 25: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 26: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 27: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 28: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 29: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 30: ctl_flags 0x1e, resp_flags 0x1
ata5: Resetting port
ata5.00: limiting speed to UDMA/66
ata5.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x2 frozen
ata5.00: cmd 61/08:00:77:dd:49/00:00:17:00:00/40 tag 0 cdb 0x0 data 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5: soft resetting port
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata5.00: configured for UDMA/66
ata5: EH complete
SCSI device sde: 398297088 512-byte hdwr sectors (203928 MB)
sde: Write Protect is off
sde: Mode Sense: 00 3a 00 00
SCSI device sde: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata5: EH in ADMA mode, notifier 0x1 notifier_error 0x0 gen_ctl 0x1501000 status 0x1540
ata5: CPB 0: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 1: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 2: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 3: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 4: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 5: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 6: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 7: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 8: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 9: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 10: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 11: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 12: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 13: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 14: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 15: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 16: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 17: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 18: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 19: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 20: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 21: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 22: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 23: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 24: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 25: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 26: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 27: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 28: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 29: ctl_flags 0x1e, resp_flags 0x1
ata5: CPB 30: ctl_flags 0x1e, resp_flags 0x1
ata5: Resetting port
ata5.00: limiting speed to UDMA/44
ata5.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x2 frozen
ata5.00: cmd 61/08:00:77:dd:49/00:00:17:00:00/40 tag 0 cdb 0x0 data 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5: soft resetting port
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata5.00: configured for UDMA/44
sd 4:0:0:0: SCSI error: return code = 0x08000002
sde: Current [descriptor]: sense key=0xb
    ASC=0x0 ASCQ=0x0
Descriptor sense data with sense descriptors (in hex):
        72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
        00 00 00 00 
end_request: I/O error, dev sde, sector 390716791
ata5: EH complete
md: super_written gets error=-5, uptodate=0
raid5: Disk failure on sde1, disabling device. Operation continuing on 6 devices
md: md2: recovery done.
SCSI device sde: 398297088 512-byte hdwr sectors (203928 MB)
sde: Write Protect is off
sde: Mode Sense: 00 3a 00 00
SCSI device sde: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
RAID5 conf printout:
 --- rd:8 wd:6
 disk 0, o:1, dev:sdb1
 disk 1, o:1, dev:sdf1
 disk 2, o:1, dev:sdg1
 disk 3, o:1, dev:sdh1
 disk 4, o:1, dev:sdd1
 disk 5, o:1, dev:sdc1
 disk 6, o:0, dev:sde1
 disk 7, o:1, dev:sda1
RAID5 conf printout:
 --- rd:8 wd:6
 disk 0, o:1, dev:sdb1
 disk 2, o:1, dev:sdg1
 disk 3, o:1, dev:sdh1
 disk 4, o:1, dev:sdd1
 disk 5, o:1, dev:sdc1
 disk 6, o:0, dev:sde1
 disk 7, o:1, dev:sda1
RAID5 conf printout:
 --- rd:8 wd:6
 disk 0, o:1, dev:sdb1
 disk 2, o:1, dev:sdg1
 disk 3, o:1, dev:sdh1
 disk 4, o:1, dev:sdd1
 disk 5, o:1, dev:sdc1
 disk 6, o:0, dev:sde1
 disk 7, o:1, dev:sda1
RAID5 conf printout:
 --- rd:8 wd:6
 disk 0, o:1, dev:sdb1
 disk 2, o:1, dev:sdg1
 disk 3, o:1, dev:sdh1
 disk 4, o:1, dev:sdd1
 disk 5, o:1, dev:sdc1
 disk 7, o:1, dev:sda1
xenbr9: port 3(vif2.0) entering disabled state
device vif2.0 left promiscuous mode
xenbr9: port 3(vif2.0) entering disabled state
md: md_d2 stopped.
md: md2 stopped.
md: unbind<sdf1>
md: export_rdev(sdf1)
md: unbind<sdb1>
md: export_rdev(sdb1)
md: unbind<sda1>
md: export_rdev(sda1)
md: unbind<sde1>
md: export_rdev(sde1)
md: unbind<sdc1>
md: export_rdev(sdc1)
md: unbind<sdd1>
md: export_rdev(sdd1)
md: unbind<sdh1>
md: export_rdev(sdh1)
md: unbind<sdg1>
md: export_rdev(sdg1)
md: md_d2 stopped.
md: bind<sdg1>
md: bind<sdh1>
md: bind<sdd1>
md: bind<sdc1>
md: bind<sde1>
md: bind<sda1>
md: bind<sdb1>
md: md_d2 stopped.
md: unbind<sdb1>
md: export_rdev(sdb1)
md: unbind<sda1>
md: export_rdev(sda1)
md: unbind<sde1>
md: export_rdev(sde1)
md: unbind<sdc1>
md: export_rdev(sdc1)
md: unbind<sdd1>
md: export_rdev(sdd1)
md: unbind<sdh1>
md: export_rdev(sdh1)
md: unbind<sdg1>
md: export_rdev(sdg1)
md: bind<sdg1>
md: bind<sdh1>
md: bind<sdd1>
md: bind<sdc1>
md: bind<sde1>
md: bind<sda1>
md: bind<sdb1>
raid5: device sdb1 operational as raid disk 0
raid5: device sda1 operational as raid disk 7
raid5: device sde1 operational as raid disk 6
raid5: device sdc1 operational as raid disk 5
raid5: device sdd1 operational as raid disk 4
raid5: device sdh1 operational as raid disk 3
raid5: device sdg1 operational as raid disk 2
raid5: allocated 8462kB for md_d2
raid5: raid level 5 set md_d2 active with 7 out of 8 devices, algorithm 2
RAID5 conf printout:
 --- rd:8 wd:7
 disk 0, o:1, dev:sdb1
 disk 2, o:1, dev:sdg1
 disk 3, o:1, dev:sdh1
 disk 4, o:1, dev:sdd1
 disk 5, o:1, dev:sdc1
 disk 6, o:1, dev:sde1
 disk 7, o:1, dev:sda1
md_d2: bitmap initialized from disk: read 12/12 pages, set 8376 bits, status: 0
created bitmap (187 pages) for device md_d2
 md_d2: p1
md: bind<sdf1>
RAID5 conf printout:
 --- rd:8 wd:7
 disk 0, o:1, dev:sdb1
 disk 1, o:1, dev:sdf1
 disk 2, o:1, dev:sdg1
 disk 3, o:1, dev:sdh1
 disk 4, o:1, dev:sdd1
 disk 5, o:1, dev:sdc1
 disk 6, o:1, dev:sde1
 disk 7, o:1, dev:sda1
md: recovery of RAID array md_d2
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
md: using 128k window, over a total of 195358208 blocks.

--Apple-Mail-11-305940322
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	delsp=yes;
	format=flowed



BTW, you can see around "md2: recovery done" a second disk failed  
before the first was completely rebuilt.

- Test #2
I swapped all the drives with this scheme: sda->sdh, sdb->sdg, sdc- 
 >sdf,..., sdg->sdb, sdh->sda. So now all the newer drives are  
attached through sata_nv (ata5:8), the oldest through sata_sil (ata1:4)
I kept the scheduler to anticipatory and ran xfs_frs. 60 seconds  
later it hanged. Still on ata5/ata6, i.e. sata_nv. Drive  
reconstruction...
Then I switched the scheduler to CFQ. xfs_fsr + 10 seconds: another  
freeze. No drive loss from the array though. See the dmesg below.



--Apple-Mail-11-305940322
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	x-unix-mode=0644;
	name=dmesg-08-01.txt
Content-Disposition: attachment;
	filename=dmesg-08-01.txt

00 3a 00 00
SCSI device sdf: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sdf: 398297088 512-byte hdwr sectors (203928 MB)
sdf: Write Protect is off
sdf: Mode Sense: 00 3a 00 00
SCSI device sdf: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdf: sdf1 sdf2 sdf3
sd 5:0:0:0: Attached scsi disk sdf
ACPI: PCI Interrupt Link [APSJ] enabled at IRQ 20
ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [APSJ] -> GSI 20 (level, low) -> IRQ 20
sata_nv 0000:00:08.0: Using ADMA mode
PCI: Setting latency timer of device 0000:00:08.0 to 64
ata7: SATA max UDMA/133 cmd 0xFFFFC20000028480 ctl 0xFFFFC200000284A0 bmdma 0xB800 irq 20
ata8: SATA max UDMA/133 cmd 0xFFFFC20000028580 ctl 0xFFFFC200000285A0 bmdma 0xB808 irq 20
scsi6 : sata_nv
ata7: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata7.00: ATA-7, max UDMA/133, 398297088 sectors: LBA48 NCQ (depth 31/32)
ata7.00: ata7: dev 0 multi count 16
ata7.00: configured for UDMA/133
scsi7 : sata_nv
ata8: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata8.00: ATA-7, max UDMA/133, 490234752 sectors: LBA48 NCQ (depth 31/32)
ata8.00: ata8: dev 0 multi count 16
ata8.00: configured for UDMA/133
scsi 6:0:0:0: Direct-Access     ATA      Maxtor 6L200S0   BACE PQ: 0 ANSI: 5
ata7: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw segs 61
SCSI device sdg: 398297088 512-byte hdwr sectors (203928 MB)
sdg: Write Protect is off
sdg: Mode Sense: 00 3a 00 00
SCSI device sdg: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sdg: 398297088 512-byte hdwr sectors (203928 MB)
sdg: Write Protect is off
sdg: Mode Sense: 00 3a 00 00
SCSI device sdg: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdg: sdg1 sdg2 sdg3
sd 6:0:0:0: Attached scsi disk sdg
scsi 7:0:0:0: Direct-Access     ATA      Maxtor 6L250S0   BACE PQ: 0 ANSI: 5
ata8: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw segs 61
SCSI device sdh: 490234752 512-byte hdwr sectors (251000 MB)
sdh: Write Protect is off
sdh: Mode Sense: 00 3a 00 00
SCSI device sdh: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sdh: 490234752 512-byte hdwr sectors (251000 MB)
sdh: Write Protect is off
sdh: Mode Sense: 00 3a 00 00
SCSI device sdh: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdh: sdh1 sdh2 sdh3 sdh4
sd 7:0:0:0: Attached scsi disk sdh
pata_amd 0000:00:06.0: version 0.2.7
ata: 0x170 IDE port busy
ata: conflict with ide1
PCI: Setting latency timer of device 0000:00:06.0 to 64
ata9: PATA max UDMA/133 cmd 0x1F0 ctl 0x3F6 bmdma 0xE000 irq 14
ata10: DUMMY
scsi8 : pata_amd
ATA: abnormal status 0x8 on port 0x1F7
scsi9 : pata_amd
usbmon: debugfs is not available
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver (PCI)
ACPI: PCI Interrupt Link [APCF] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [APCF] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:02.0 to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:02.0: irq 23, io mem 0xfe02f000
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 10 ports detected
usb 1-5: new low speed USB device using ohci_hcd and address 2
usb 1-5: configuration #1 chosen from 1 choice
usb 1-6: new full speed USB device using ohci_hcd and address 3
usb 1-6: configuration #1 chosen from 1 choice
usbcore: registered new interface driver hiddev
input: Logitech USB Receiver as /class/input/input0
input: USB HID v1.10 Keyboard [Logitech USB Receiver] on usb-0000:00:02.0-5
input: Logitech USB Receiver as /class/input/input1
input: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:02.0-5
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
md: raid10 personality registered for level 10
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 15
md: Skipping autodetection of RAID arrays. (raid=noautodetect)
md: Loading md_d1: /dev/sdh3
md: bind<sdh3>
md: bind<sdg3>
md: bind<sdf3>
md: bind<sde3>
md: bind<sdd3>
raid10: raid set md_d1 active with 5 out of 6 devices
md_d1: bitmap initialized from disk: read 11/11 pages, set 228551 bits, status: 0
created bitmap (167 pages) for device md_d1
 md_d1: p1 p2 p3
 md_d1: p1 p2 p3
ReiserFS: md_d1p2: found reiserfs format "3.6" with standard journal
ReiserFS: md_d1p2: using ordered data mode
ReiserFS: md_d1p2: journal params: device md_d1p2, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: md_d1p2: checking transaction log (md_d1p2)
ReiserFS: md_d1p2: Using r5 hash to sort names
VFS: Mounted root (reiserfs filesystem).
Freeing unused kernel memory: 228k freed
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 1:0:0:0: Attached scsi generic sg1 type 0
sd 2:0:0:0: Attached scsi generic sg2 type 0
sd 3:0:0:0: Attached scsi generic sg3 type 0
sd 4:0:0:0: Attached scsi generic sg4 type 0
sd 5:0:0:0: Attached scsi generic sg5 type 0
sd 6:0:0:0: Attached scsi generic sg6 type 0
sd 7:0:0:0: Attached scsi generic sg7 type 0
i2c_adapter i2c-0: nForce2 SMBus adapter at 0x4c00
i2c_adapter i2c-1: nForce2 SMBus adapter at 0x4c40
forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.59.
ACPI: PCI Interrupt Link [APCH] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [APCH] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:0a.0 to 64
forcedeth: using HIGHDMA
ieee1394: Initialized config rom entry `ip1394'
Initializing USB Mass Storage driver...
scsi10 : SCSI emulation for USB Mass Storage devices
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usb-storage: device found at 3
usb-storage: waiting for device to settle before scanning
eth0: forcedeth.c: subsystem: 01462:7125 bound to 0000:00:0a.0
ACPI: PCI Interrupt 0000:01:0c.0[A] -> Link [APC4] -> GSI 19 (level, low) -> IRQ 19
udev: renamed network interface eth0 to eth1
ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[19]  MMIO=[fdeff000-fdeff7ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0010dc0000cbb4fa]
input: Power Button (FF) as /class/input/input2
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input3
ACPI: Power Button (CM) [PWRB]
ACPI: Fan [FAN] (on)
ACPI: Thermal Zone [THRM] (22 C)
Capability LSM initialized
Bridge firewalling registered
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
All bugs added by David S. Miller <davem@redhat.com>
md: md0 stopped.
md: bind<sdg2>
md: bind<sdf2>
md: bind<sde2>
md: bind<sdd2>
md: bind<sdh2>
md: raid1 personality registered for level 1
raid1: raid set md0 active with 5 out of 5 mirrors
md0: bitmap initialized from disk: read 2/2 pages, set 0 bits, status: 0
created bitmap (17 pages) for device md0
md: md_d2 stopped.
md: bind<sdc1>
md: bind<sdb1>
md: bind<sda1>
md: bind<sde1>
md: bind<sdf1>
md: bind<sdd1>
md: bind<sdh1>
md: bind<sdg1>
raid5: automatically using best checksumming function: generic_sse
   generic_sse:  5237.000 MB/sec
raid5: using function: generic_sse (5237.000 MB/sec)
raid6: int64x1   2064 MB/s
raid6: int64x2   2743 MB/s
raid6: int64x4   2927 MB/s
raid6: int64x8   1961 MB/s
raid6: sse2x1    1974 MB/s
raid6: sse2x2    2164 MB/s
raid6: sse2x4    2533 MB/s
raid6: using algorithm sse2x4 (2533 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
raid5: device sdg1 operational as raid disk 0
raid5: device sdh1 operational as raid disk 7
raid5: device sdd1 operational as raid disk 6
raid5: device sdf1 operational as raid disk 5
raid5: device sde1 operational as raid disk 4
raid5: device sda1 operational as raid disk 3
raid5: device sdb1 operational as raid disk 2
raid5: device sdc1 operational as raid disk 1
raid5: allocated 8462kB for md_d2
raid5: raid level 5 set md_d2 active with 8 out of 8 devices, algorithm 2
RAID5 conf printout:
 --- rd:8 wd:8
 disk 0, o:1, dev:sdg1
 disk 1, o:1, dev:sdc1
 disk 2, o:1, dev:sdb1
 disk 3, o:1, dev:sda1
 disk 4, o:1, dev:sde1
 disk 5, o:1, dev:sdf1
 disk 6, o:1, dev:sdd1
 disk 7, o:1, dev:sdh1
md_d2: bitmap initialized from disk: read 12/12 pages, set 0 bits, status: 0
created bitmap (187 pages) for device md_d2
 md_d2: p1
device-mapper: snapshots: Snapshot is marked invalid.
scsi 10:0:0:0: Direct-Access     Generic  USB SD Reader    1.00 PQ: 0 ANSI: 0
sd 10:0:0:0: Attached scsi removable disk sdi
sd 10:0:0:0: Attached scsi generic sg8 type 0
scsi 10:0:0:1: Direct-Access     Generic  USB CF Reader    1.01 PQ: 0 ANSI: 0
sd 10:0:0:1: Attached scsi removable disk sdj
sd 10:0:0:1: Attached scsi generic sg9 type 0
scsi 10:0:0:2: Direct-Access     Generic  USB SM Reader    1.02 PQ: 0 ANSI: 0
sd 10:0:0:2: Attached scsi removable disk sdk
sd 10:0:0:2: Attached scsi generic sg10 type 0
scsi 10:0:0:3: Direct-Access     Generic  USB MS Reader    1.03 PQ: 0 ANSI: 0
sd 10:0:0:3: Attached scsi removable disk sdl
sd 10:0:0:3: Attached scsi generic sg11 type 0
usb-storage: device scan complete
Buffer I/O error on device dm-8, logical block 78675952
Buffer I/O error on device dm-8, logical block 78675952
Buffer I/O error on device dm-8, logical block 78675966
Buffer I/O error on device dm-8, logical block 78675966
Buffer I/O error on device dm-8, logical block 0
Buffer I/O error on device dm-8, logical block 0
Buffer I/O error on device dm-8, logical block 0
Buffer I/O error on device dm-8, logical block 78675967
Buffer I/O error on device dm-8, logical block 78675967
Buffer I/O error on device dm-8, logical block 78675967
ReiserFS: md0: warning: read_super_block: found reiserfs format "3.6" with non-standard journal
ReiserFS: md0: using ordered data mode
ReiserFS: md0: journal params: device md0, size 512, journal first block 18, max trans len 256, max batch 225, max commit age 30, max trans age 30
ReiserFS: md0: checking transaction log (md0)
ReiserFS: md0: Using r5 hash to sort names
Adding 2097144k swap on /dev/md_d1p1.  Priority:-1 extents:1 across:2097144k
eth1.1: dev_set_promiscuity(master, 1)
device eth1 entered promiscuous mode
device eth1.1 entered promiscuous mode
eth1.6: dev_set_promiscuity(master, 1)
device eth1.6 entered promiscuous mode
eth1.8: dev_set_promiscuity(master, 1)
device eth1.8 entered promiscuous mode
eth1.9: dev_set_promiscuity(master, 1)
device eth1.9 entered promiscuous mode
xenbr1: port 1(eth1.1) entering learning state
xenbr1: topology change detected, propagating
xenbr1: port 1(eth1.1) entering forwarding state
xenbr6: port 1(eth1.6) entering learning state
xenbr6: topology change detected, propagating
xenbr6: port 1(eth1.6) entering forwarding state
xenbr8: port 1(eth1.8) entering learning state
xenbr8: topology change detected, propagating
xenbr8: port 1(eth1.8) entering forwarding state
xenbr9: port 1(eth1.9) entering learning state
xenbr9: topology change detected, propagating
xenbr9: port 1(eth1.9) entering forwarding state
NET: Registered protocol family 17
device vif1.0 entered promiscuous mode
xenbr9: port 2(vif1.0) entering learning state
xenbr9: topology change detected, propagating
xenbr9: port 2(vif1.0) entering forwarding state
device vif2.0 entered promiscuous mode
xenbr9: port 3(vif2.0) entering learning state
xenbr9: topology change detected, propagating
xenbr9: port 3(vif2.0) entering forwarding state
blkback: ring-ref 8, event-channel 6, protocol 2 (x86_32-abi)
xenbr9: port 3(vif2.0) entering disabled state
device vif2.0 left promiscuous mode
xenbr9: port 3(vif2.0) entering disabled state
md: md_d2 stopped.
md: unbind<sdg1>
md: export_rdev(sdg1)
md: unbind<sdh1>
md: export_rdev(sdh1)
md: unbind<sdd1>
md: export_rdev(sdd1)
md: unbind<sdf1>
md: export_rdev(sdf1)
md: unbind<sde1>
md: export_rdev(sde1)
md: unbind<sda1>
md: export_rdev(sda1)
md: unbind<sdb1>
md: export_rdev(sdb1)
md: unbind<sdc1>
md: export_rdev(sdc1)
md: md2 stopped.
md: bind<sdc1>
md: bind<sdb1>
md: bind<sda1>
md: bind<sde1>
md: bind<sdf1>
md: bind<sdd1>
md: bind<sdh1>
md: bind<sdg1>
raid5: device sdg1 operational as raid disk 0
raid5: device sdh1 operational as raid disk 7
raid5: device sdd1 operational as raid disk 6
raid5: device sdf1 operational as raid disk 5
raid5: device sde1 operational as raid disk 4
raid5: device sda1 operational as raid disk 3
raid5: device sdb1 operational as raid disk 2
raid5: device sdc1 operational as raid disk 1
raid5: allocated 8462kB for md2
raid5: raid level 5 set md2 active with 8 out of 8 devices, algorithm 2
RAID5 conf printout:
 --- rd:8 wd:8
 disk 0, o:1, dev:sdg1
 disk 1, o:1, dev:sdc1
 disk 2, o:1, dev:sdb1
 disk 3, o:1, dev:sda1
 disk 4, o:1, dev:sde1
 disk 5, o:1, dev:sdf1
 disk 6, o:1, dev:sdd1
 disk 7, o:1, dev:sdh1
md2: bitmap initialized from disk: read 12/12 pages, set 0 bits, status: 0
created bitmap (187 pages) for device md2
device vif3.0 entered promiscuous mode
xenbr9: port 3(vif3.0) entering learning state
xenbr9: topology change detected, propagating
xenbr9: port 3(vif3.0) entering forwarding state
blkback: ring-ref 8, event-channel 6, protocol 2 (x86_32-abi)
blkback: ring-ref 9, event-channel 7, protocol 2 (x86_32-abi)
ata5: EH in ADMA mode, notifier 0xFFFFFFF notifier_error 0x0 gen_ctl 0x1501000 status 0x1540
ata5: CPB 0: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 1: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 2: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 3: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 4: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 5: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 6: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 7: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 8: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 9: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 10: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 11: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 12: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 13: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 14: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 15: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 16: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 17: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 18: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 19: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 20: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 21: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 22: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 23: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 24: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 25: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 26: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 27: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 28: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 29: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 30: ctl_flags 0x1f, resp_flags 0x1
ata5: Resetting port
ata5.00: exception Emask 0x0 SAct 0xfffffff SErr 0x0 action 0x2 frozen
ata5.00: cmd 61/18:00:f7:c0:97/00:00:04:00:00/40 tag 0 cdb 0x0 data 12288 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 61/18:08:17:c1:97/00:00:04:00:00/40 tag 1 cdb 0x0 data 12288 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 61/18:10:37:c1:97/00:00:04:00:00/40 tag 2 cdb 0x0 data 12288 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 61/10:18:57:c1:97/00:00:04:00:00/40 tag 3 cdb 0x0 data 8192 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 61/18:20:6f:c1:97/00:00:04:00:00/40 tag 4 cdb 0x0 data 12288 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 61/08:28:b7:c1:97/00:00:04:00:00/40 tag 5 cdb 0x0 data 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 61/08:30:bf:c1:97/00:00:04:00:00/40 tag 6 cdb 0x0 data 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 61/28:38:e7:c1:97/00:00:04:00:00/40 tag 7 cdb 0x0 data 20480 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 61/08:40:17:c2:97/00:00:04:00:00/40 tag 8 cdb 0x0 data 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 60/18:48:d7:c0:97/00:00:04:00:00/40 tag 9 cdb 0x0 data 12288 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 60/30:50:47:c0:97/00:00:04:00:00/40 tag 10 cdb 0x0 data 24576 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 60/20:58:e7:c2:97/00:00:04:00:00/40 tag 11 cdb 0x0 data 16384 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 60/18:60:07:c3:97/00:00:04:00:00/40 tag 12 cdb 0x0 data 12288 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 60/08:68:27:c3:97/00:00:04:00:00/40 tag 13 cdb 0x0 data 4096 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 60/28:70:87:c0:97/00:00:04:00:00/40 tag 14 cdb 0x0 data 20480 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 60/08:78:77:c0:97/00:00:04:00:00/40 tag 15 cdb 0x0 data 4096 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 60/08:80:af:c0:97/00:00:04:00:00/40 tag 16 cdb 0x0 data 4096 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 60/10:88:bf:c0:97/00:00:04:00:00/40 tag 17 cdb 0x0 data 8192 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 60/08:90:cf:c0:97/00:00:04:00:00/40 tag 18 cdb 0x0 data 4096 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 60/18:98:2f:c3:97/00:00:04:00:00/40 tag 19 cdb 0x0 data 12288 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 61/08:a0:4f:c2:97/00:00:04:00:00/40 tag 20 cdb 0x0 data 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 61/08:a8:8f:c2:97/00:00:04:00:00/40 tag 21 cdb 0x0 data 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 61/08:b0:c7:c2:97/00:00:04:00:00/40 tag 22 cdb 0x0 data 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 60/10:b8:47:c3:97/00:00:04:00:00/40 tag 23 cdb 0x0 data 8192 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 60/30:c0:5f:c3:97/00:00:04:00:00/40 tag 24 cdb 0x0 data 24576 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 60/38:c8:97:c3:97/00:00:04:00:00/40 tag 25 cdb 0x0 data 28672 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 60/30:d0:d7:c3:97/00:00:04:00:00/40 tag 26 cdb 0x0 data 24576 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 60/30:d8:0f:c4:97/00:00:04:00:00/40 tag 27 cdb 0x0 data 24576 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata6: EH in ADMA mode, notifier 0x0 notifier_error 0x0 gen_ctl 0x1501000 status 0x500
ata6: CPB 0: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 1: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 2: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 3: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 4: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 5: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 6: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 7: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 8: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 9: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 10: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 11: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 12: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 13: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 14: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 15: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 16: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 17: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 18: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 19: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 20: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 21: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 22: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 23: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 24: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 25: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 26: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 27: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 28: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 29: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 30: ctl_flags 0x1f, resp_flags 0x1
ata6: Resetting port
sd 5:0:0:0: SCSI error: return code = 0x06000000
end_request: I/O error, dev sdf, sector 77054047
sd 5:0:0:0: SCSI error: return code = 0x06000000
end_request: I/O error, dev sdf, sector 77054111
sd 5:0:0:0: SCSI error: return code = 0x06000000
end_request: I/O error, dev sdf, sector 77054167
sd 5:0:0:0: SCSI error: return code = 0x06000000
end_request: I/O error, dev sdf, sector 77054223
sd 5:0:0:0: SCSI error: return code = 0x06000000
end_request: I/O error, dev sdf, sector 77054287
sd 5:0:0:0: SCSI error: return code = 0x06000000
end_request: I/O error, dev sdf, sector 77054343
sd 5:0:0:0: SCSI error: return code = 0x06000000
end_request: I/O error, dev sdf, sector 77054015
raid5: Disk failure on sdf1, disabling device. Operation continuing on 7 devices
sd 5:0:0:0: SCSI error: return code = 0x06000000
end_request: I/O error, dev sdf, sector 77054199
sd 5:0:0:0: SCSI error: return code = 0x06000000
end_request: I/O error, dev sdf, sector 77054231
sd 5:0:0:0: SCSI error: return code = 0x06000000
end_request: I/O error, dev sdf, sector 77054263
sd 5:0:0:0: SCSI error: return code = 0x06000000
end_request: I/O error, dev sdf, sector 77054295
ata5: soft resetting port
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata5.00: configured for UDMA/133
ata5: EH complete
SCSI device sde: 398297088 512-byte hdwr sectors (203928 MB)
sde: Write Protect is off
sde: Mode Sense: 00 3a 00 00
SCSI device sde: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
RAID5 conf printout:
 --- rd:8 wd:7
 disk 0, o:1, dev:sdg1
 disk 1, o:1, dev:sdc1
 disk 2, o:1, dev:sdb1
 disk 3, o:1, dev:sda1
 disk 4, o:1, dev:sde1
 disk 5, o:0, dev:sdf1
 disk 6, o:1, dev:sdd1
 disk 7, o:1, dev:sdh1
RAID5 conf printout:
 --- rd:8 wd:7
 disk 0, o:1, dev:sdg1
 disk 1, o:1, dev:sdc1
 disk 2, o:1, dev:sdb1
 disk 3, o:1, dev:sda1
 disk 4, o:1, dev:sde1
 disk 6, o:1, dev:sdd1
 disk 7, o:1, dev:sdh1
md: unbind<sdf1>
md: export_rdev(sdf1)
md: bind<sdf1>
RAID5 conf printout:
 --- rd:8 wd:7
 disk 0, o:1, dev:sdg1
 disk 1, o:1, dev:sdc1
 disk 2, o:1, dev:sdb1
 disk 3, o:1, dev:sda1
 disk 4, o:1, dev:sde1
 disk 5, o:1, dev:sdf1
 disk 6, o:1, dev:sdd1
 disk 7, o:1, dev:sdh1
md: recovery of RAID array md2
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
md: using 128k window, over a total of 195358208 blocks.
md: md2: recovery done.
RAID5 conf printout:
 --- rd:8 wd:8
 disk 0, o:1, dev:sdg1
 disk 1, o:1, dev:sdc1
 disk 2, o:1, dev:sdb1
 disk 3, o:1, dev:sda1
 disk 4, o:1, dev:sde1
 disk 5, o:1, dev:sdf1
 disk 6, o:1, dev:sdd1
 disk 7, o:1, dev:sdh1
ata5: EH in ADMA mode, notifier 0xFF notifier_error 0x0 gen_ctl 0x1501000 status 0x1540
ata5: CPB 0: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 1: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 2: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 3: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 4: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 5: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 6: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 7: ctl_flags 0x1f, resp_flags 0x1
ata6: EH in ADMA mode, notifier 0x1FFFF notifier_error 0x0 gen_ctl 0x1501000 status 0x1540
ata6: CPB 0: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 1: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 2: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 3: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 4: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 5: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 6: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 7: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 8: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 9: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 10: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 11: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 12: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 13: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 14: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 15: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 16: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 17: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 18: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 19: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 20: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 21: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 22: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 23: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 24: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 25: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 26: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 27: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 28: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 29: ctl_flags 0x1f, resp_flags 0x1
ata6: CPB 30: ctl_flags 0x1f, resp_flags 0x1
ata6: Resetting port
ata5: CPB 8: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 9: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 10: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 11: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 12: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 13: ctl_flags 0x1f, resp_flags 0x1
ata6.00: exception Emask 0x0 SAct 0x1ffff SErr 0x0 action 0x2 frozen
ata6.00: cmd 60/08:00:ef:74:97/00:00:04:00:00/40 tag 0 cdb 0x0 data 4096 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata6.00: cmd 60/08:08:7f:74:97/00:00:04:00:00/40 tag 1 cdb 0x0 data 4096 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata6.00: cmd 60/08:10:b7:74:97/00:00:04:00:00/40 tag 2 cdb 0x0 data 4096 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata6.00: cmd 60/08:18:2f:75:97/00:00:04:00:00/40 tag 3 cdb 0x0 data 4096 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata6.00: cmd 60/08:20:67:75:97/00:00:04:00:00/40 tag 4 cdb 0x0 data 4096 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata6.00: cmd 60/08:28:9f:75:97/00:00:04:00:00/40 tag 5 cdb 0x0 data 4096 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata6.00: cmd 60/08:30:df:75:97/00:00:04:00:00/40 tag 6 cdb 0x0 data 4096 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata6.00: cmd 60/08:38:17:76:97/00:00:04:00:00/40 tag 7 cdb 0x0 data 4096 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata6.00: cmd 60/08:40:4f:76:97/00:00:04:00:00/40 tag 8 cdb 0x0 data 4096 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata6.00: cmd 60/08:48:8f:76:97/00:00:04:00:00/40 tag 9 cdb 0x0 data 4096 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata6.00: cmd 60/08:50:c7:76:97/00:00:04:00:00/40 tag 10 cdb 0x0 data 4096 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata6.00: cmd 60/08:58:ff:76:97/00:00:04:00:00/40 tag 11 cdb 0x0 data 4096 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata6.00: cmd 60/10:60:27:77:97/00:00:04:00:00/40 tag 12 cdb 0x0 data 8192 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata6.00: cmd 60/18:68:3f:77:97/00:00:04:00:00/40 tag 13 cdb 0x0 data 12288 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata6.00: cmd 60/08:70:77:77:97/00:00:04:00:00/40 tag 14 cdb 0x0 data 4096 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata6.00: cmd 61/08:78:3f:74:97/00:00:04:00:00/40 tag 15 cdb 0x0 data 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata6.00: cmd 60/08:80:af:77:97/00:00:04:00:00/40 tag 16 cdb 0x0 data 4096 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5: CPB 14: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 15: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 16: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 17: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 18: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 19: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 20: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 21: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 22: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 23: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 24: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 25: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 26: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 27: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 28: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 29: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 30: ctl_flags 0x1f, resp_flags 0x1
ata5: Resetting port
ata5.00: exception Emask 0x0 SAct 0xff SErr 0x0 action 0x2 frozen
ata5.00: cmd 60/08:00:cf:77:97/00:00:04:00:00/40 tag 0 cdb 0x0 data 4096 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 60/08:08:07:78:97/00:00:04:00:00/40 tag 1 cdb 0x0 data 4096 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 60/08:10:37:78:97/00:00:04:00:00/40 tag 2 cdb 0x0 data 4096 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 61/08:18:1f:77:97/00:00:04:00:00/40 tag 3 cdb 0x0 data 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 60/10:20:27:77:97/00:00:04:00:00/40 tag 4 cdb 0x0 data 8192 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 60/18:28:3f:77:97/00:00:04:00:00/40 tag 5 cdb 0x0 data 12288 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 61/08:30:57:77:97/00:00:04:00:00/40 tag 6 cdb 0x0 data 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 61/08:38:8f:77:97/00:00:04:00:00/40 tag 7 cdb 0x0 data 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5: soft resetting port
ata6: soft resetting port
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata5.00: configured for UDMA/133
ata5: EH complete
ata6.00: configured for UDMA/133
ata6: EH complete
SCSI device sde: 398297088 512-byte hdwr sectors (203928 MB)
sde: Write Protect is off
sde: Mode Sense: 00 3a 00 00
SCSI device sde: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sdf: 398297088 512-byte hdwr sectors (203928 MB)
sdf: Write Protect is off
sdf: Mode Sense: 00 3a 00 00
SCSI device sdf: write cache: enabled, read cache: enabled, doesn't support DPO or FUA

--Apple-Mail-11-305940322
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	delsp=yes;
	format=flowed



So it seems to be either a cabling problem or a bug with sata_nv ?  
I'm running gentoo's 2.6.20-xen, and maybe my problem looks like the  
sata_nv/adma/samsung problems reports I can see on the net ?

Thanks !
GoM
--Apple-Mail-11-305940322--
