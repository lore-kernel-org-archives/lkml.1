Return-Path: <linux-kernel-owner+w=401wt.eu-S1764197AbXEUPLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764197AbXEUPLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 11:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763971AbXEUPKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 11:10:55 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:41039 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763975AbXEUPKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 11:10:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=FKWXsTemfjcz34RfiZ2WkZ+RMba5G70Kd1qi+xYgztFxVwKmHe5lpQhDdqqMLV58EuI5J9rjE8q1DwkidMZG5i+uivAWTFJdyZPYGyXk7IjX5edPVJZF6JiPLjm1SRrANxC1ueZBfCZvGYZzgjWyewGp68SzWkG8VrAA5GsXElA=
Message-ID: <4651B66E.6030505@gmail.com>
Date: Mon, 21 May 2007 17:10:38 +0200
From: Robert de Rooy <robert.de.rooy@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: linux-kernel@vger.kernel.org, alan@redhat.com, bzolnier@gmail.com,
       jgarzik@pobox.com
Subject: Re: libata and legacy ide pcmcia failure
References: <464A0321.3080201@gmail.com> <464C1575.8070005@gmail.com> <464CB7C9.2080807@gmail.com> <46503192.1040300@gmail.com> <4650B9E3.7070409@gmail.com> <46518798.2020808@gmail.com>
In-Reply-To: <46518798.2020808@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This gets a little bit further again, but now I get lots of new errors....

** 2.6.22rc1-git5 + timing-debug.patch + disable-dev_init_param-and-setxfermode-for-CFA.patch

May 21 16:58:06 localhost kernel: pccard: PCMCIA card inserted into slot 0
May 21 16:58:06 localhost kernel: cs: memory probe 0xe8000000-0xefffffff: excluding 0xe8000000-0xefffffff
May 21 16:58:06 localhost kernel: cs: memory probe 0xc0200000-0xcfffffff: excluding 0xc0200000-0xc11fffff 0xc1a00000-0xc21fffff 0xc2a00000-0xc31fffff 0xc3a00000-0xcc1fffff 0xcca00000-0xcd1fffff 0xcda00000-0xce1fffff 0xcea00000-0xcf1fffff 0xcfa00000-0xd01fffff
May 21 16:58:06 localhost kernel: pcmcia: registering new device pcmcia0.0
May 21 16:58:06 localhost kernel: scsi3 : pata_pcmcia
May 21 16:58:06 localhost kernel: ata3: PATA max PIO0 cmd 0x00014100 ctl 0x0001410e bmdma 0x00000000 irq 0
May 21 16:58:06 localhost kernel: ata3: soft resetting port
May 21 16:58:16 localhost kernel: ata3: SRST failed (errno=-16)
May 21 16:58:16 localhost kernel: ata3: soft resetting port
May 21 16:58:17 localhost kernel: ata3: reset complete
May 21 16:58:17 localhost kernel: ata3.00: issuing IDENTIFY
May 21 16:58:17 localhost kernel: ata3.00: IDENTIFY complete
May 21 16:58:17 localhost kernel: ata3.00: CFA: Memory Card Adapter, 20011212, max PIO1
May 21 16:58:17 localhost kernel: ata3.00: 253696 sectors, multi 0: LBA 
May 21 16:58:17 localhost kernel: ata3.00: issuing IDENTIFY
May 21 16:58:17 localhost kernel: ata3.00: IDENTIFY complete
May 21 16:58:17 localhost kernel: ata3.00: configured for PIO0
May 21 16:58:17 localhost kernel: ata3: EH complete
May 21 16:58:17 localhost kernel: scsi 3:0:0:0: Direct-Access     ATA      Memory Card Adap 2001 PQ: 0 ANSI: 5
May 21 16:58:17 localhost kernel: sd 3:0:0:0: [sdd] 253696 512-byte hardware sectors (130 MB)
May 21 16:58:17 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
May 21 16:58:17 localhost kernel: sd 3:0:0:0: [sdd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
May 21 16:58:17 localhost kernel: sd 3:0:0:0: [sdd] 253696 512-byte hardware sectors (130 MB)
May 21 16:58:17 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
May 21 16:58:17 localhost kernel: sd 3:0:0:0: [sdd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
May 21 16:58:47 localhost kernel:  sdd:<3>ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
May 21 16:58:47 localhost kernel: ata3.00: cmd 20/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 in
May 21 16:58:47 localhost kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
May 21 16:58:47 localhost kernel: ata3: soft resetting port
May 21 16:58:57 localhost kernel: ata3: SRST failed (errno=-16)
May 21 16:58:57 localhost kernel: ata3: soft resetting port
May 21 16:58:57 localhost kernel: ata3: reset complete
May 21 16:58:57 localhost kernel: ATA: abnormal status 0x58 on port 0x00014107
May 21 16:58:57 localhost kernel: ata3.00: issuing IDENTIFY
May 21 16:58:57 localhost kernel: ATA: abnormal status 0x58 on port 0x00014107
May 21 16:58:57 localhost last message repeated 4 times
May 21 16:58:57 localhost kernel: ata3.00: IDENTIFY complete
May 21 16:58:57 localhost kernel: ata3.00: failed to IDENTIFY (I/O error, err_mask=0x2)
May 21 16:58:57 localhost kernel: ata3.00: revalidation failed (errno=-5)
May 21 16:58:57 localhost kernel: ata3: failed to recover some devices, retrying in 5 secs
May 21 16:59:02 localhost kernel: ata3: soft resetting port
May 21 16:59:12 localhost kernel: ata3: SRST failed (errno=-16)
May 21 16:59:12 localhost kernel: ata3: soft resetting port
May 21 16:59:22 localhost kernel: ata3: SRST failed (errno=-16)
May 21 16:59:22 localhost kernel: ata3: soft resetting port
May 21 16:59:23 localhost kernel: ata3: reset complete
May 21 16:59:23 localhost kernel: ATA: abnormal status 0x3B on port 0x00014107
May 21 16:59:23 localhost kernel: ATA: abnormal status 0x3B on port 0x00014107
May 21 16:59:23 localhost kernel: ATA: abnormal status 0x58 on port 0x00014107
May 21 16:59:23 localhost kernel: ata3.00: issuing IDENTIFY
May 21 16:59:23 localhost kernel: ATA: abnormal status 0x58 on port 0x00014107
May 21 16:59:23 localhost last message repeated 4 times
May 21 16:59:23 localhost kernel: ata3.00: IDENTIFY complete
May 21 16:59:23 localhost kernel: ata3.00: failed to IDENTIFY (I/O error, err_mask=0x2)
May 21 16:59:23 localhost kernel: ata3.00: revalidation failed (errno=-5)
May 21 16:59:23 localhost kernel: ata3: failed to recover some devices, retrying in 5 secs
May 21 16:59:28 localhost kernel: ata3: soft resetting port
May 21 16:59:28 localhost kernel: ata3: reset complete
May 21 16:59:28 localhost kernel: ATA: abnormal status 0x58 on port 0x00014107
May 21 16:59:28 localhost kernel: ata3.00: issuing IDENTIFY
May 21 16:59:28 localhost kernel: ATA: abnormal status 0x58 on port 0x00014107
May 21 16:59:28 localhost last message repeated 4 times
May 21 16:59:28 localhost kernel: ata3.00: IDENTIFY complete
May 21 16:59:28 localhost kernel: ata3.00: failed to IDENTIFY (I/O error, err_mask=0x2)
May 21 16:59:28 localhost kernel: ata3.00: revalidation failed (errno=-5)
May 21 16:59:28 localhost kernel: ata3.00: disabled
May 21 16:59:28 localhost kernel: ata3: EH complete
May 21 16:59:28 localhost kernel: sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
May 21 16:59:28 localhost kernel: end_request: I/O error, dev sdd, sector 0
May 21 16:59:28 localhost kernel: Buffer I/O error on device sdd, logical block 0
May 21 16:59:28 localhost kernel: sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
May 21 16:59:28 localhost kernel: end_request: I/O error, dev sdd, sector 0
May 21 16:59:28 localhost kernel: Buffer I/O error on device sdd, logical block 0
May 21 16:59:28 localhost kernel: sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
May 21 16:59:28 localhost kernel: end_request: I/O error, dev sdd, sector 0
May 21 16:59:28 localhost kernel: Buffer I/O error on device sdd, logical block 0
May 21 16:59:28 localhost kernel: sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
May 21 16:59:28 localhost kernel: end_request: I/O error, dev sdd, sector 0
May 21 16:59:28 localhost kernel: Buffer I/O error on device sdd, logical block 0
May 21 16:59:28 localhost kernel: sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
May 21 16:59:28 localhost kernel: end_request: I/O error, dev sdd, sector 0
May 21 16:59:28 localhost kernel: Buffer I/O error on device sdd, logical block 0
May 21 16:59:28 localhost kernel: sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
May 21 16:59:28 localhost kernel: end_request: I/O error, dev sdd, sector 0
May 21 16:59:28 localhost kernel: Buffer I/O error on device sdd, logical block 0
May 21 16:59:28 localhost kernel: sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
May 21 16:59:28 localhost kernel: end_request: I/O error, dev sdd, sector 0
May 21 16:59:28 localhost kernel: Buffer I/O error on device sdd, logical block 0
May 21 16:59:28 localhost kernel: Dev sdd: unable to read RDB block 0
May 21 16:59:28 localhost kernel: sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
May 21 16:59:28 localhost kernel: end_request: I/O error, dev sdd, sector 0
May 21 16:59:28 localhost kernel: Buffer I/O error on device sdd, logical block 0
May 21 16:59:28 localhost kernel: sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
May 21 16:59:28 localhost kernel: end_request: I/O error, dev sdd, sector 0
May 21 16:59:28 localhost kernel: Buffer I/O error on device sdd, logical block 0
May 21 16:59:28 localhost kernel:  unable to read partition table
May 21 16:59:28 localhost kernel: sd 3:0:0:0: [sdd] Attached SCSI removable disk
May 21 16:59:28 localhost kernel: sd 3:0:0:0: Attached scsi generic sg3 type 0
May 21 16:59:28 localhost udevd-event[2504]: udev_rules_apply_format: unknown format variable '$modalias'
May 21 16:59:29 localhost kernel: sd 3:0:0:0: [sdd] READ CAPACITY failed
May 21 16:59:29 localhost kernel: sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
May 21 16:59:29 localhost kernel: sd 3:0:0:0: [sdd] Sense not available.
May 21 16:59:29 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
May 21 16:59:29 localhost kernel: sd 3:0:0:0: [sdd] Asking for cache data failed
May 21 16:59:29 localhost kernel: sd 3:0:0:0: [sdd] Assuming drive cache: write through
May 21 16:59:29 localhost kernel: sd 3:0:0:0: [sdd] READ CAPACITY failed
May 21 16:59:29 localhost kernel: sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
May 21 16:59:29 localhost kernel: sd 3:0:0:0: [sdd] Sense not available.
May 21 16:59:29 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
May 21 16:59:29 localhost kernel: sd 3:0:0:0: [sdd] Asking for cache data failed
May 21 16:59:29 localhost kernel: sd 3:0:0:0: [sdd] Assuming drive cache: write through
May 21 16:59:29 localhost kernel: sd 3:0:0:0: [sdd] READ CAPACITY failed
May 21 16:59:29 localhost kernel: sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
May 21 16:59:29 localhost kernel: sd 3:0:0:0: [sdd] Sense not available.
May 21 16:59:29 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
May 21 16:59:29 localhost kernel: sd 3:0:0:0: [sdd] Asking for cache data failed
May 21 16:59:29 localhost kernel: sd 3:0:0:0: [sdd] Assuming drive cache: write through
May 21 16:59:29 localhost kernel: sd 3:0:0:0: [sdd] READ CAPACITY failed
May 21 16:59:29 localhost kernel: sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
May 21 16:59:29 localhost kernel: sd 3:0:0:0: [sdd] Sense not available.
May 21 16:59:29 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
May 21 16:59:29 localhost kernel: sd 3:0:0:0: [sdd] Asking for cache data failed
May 21 16:59:29 localhost kernel: sd 3:0:0:0: [sdd] Assuming drive cache: write through
May 21 16:59:29 localhost kernel: sd 3:0:0:0: [sdd] READ CAPACITY failed
May 21 16:59:29 localhost kernel: sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
May 21 16:59:29 localhost kernel: sd 3:0:0:0: [sdd] Sense not available.
May 21 16:59:29 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
May 21 16:59:29 localhost kernel: sd 3:0:0:0: [sdd] Asking for cache data failed
May 21 16:59:29 localhost kernel: sd 3:0:0:0: [sdd] Assuming drive cache: write through
May 21 16:59:29 localhost kernel: sd 3:0:0:0: [sdd] READ CAPACITY failed
May 21 16:59:29 localhost kernel: sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
May 21 16:59:29 localhost kernel: sd 3:0:0:0: [sdd] Sense not available.
May 21 16:59:29 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
May 21 16:59:29 localhost kernel: sd 3:0:0:0: [sdd] Asking for cache data failed
May 21 16:59:29 localhost kernel: sd 3:0:0:0: [sdd] Assuming drive cache: write through
May 21 16:59:31 localhost kernel: sd 3:0:0:0: [sdd] READ CAPACITY failed
May 21 16:59:31 localhost kernel: sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
May 21 16:59:31 localhost kernel: sd 3:0:0:0: [sdd] Sense not available.
May 21 16:59:31 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
May 21 16:59:31 localhost kernel: sd 3:0:0:0: [sdd] Asking for cache data failed
May 21 16:59:31 localhost kernel: sd 3:0:0:0: [sdd] Assuming drive cache: write through
May 21 16:59:31 localhost kernel: sd 3:0:0:0: [sdd] READ CAPACITY failed
May 21 16:59:31 localhost kernel: sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
May 21 16:59:31 localhost kernel: sd 3:0:0:0: [sdd] Sense not available.
May 21 16:59:31 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
May 21 16:59:31 localhost kernel: sd 3:0:0:0: [sdd] Asking for cache data failed
May 21 16:59:31 localhost kernel: sd 3:0:0:0: [sdd] Assuming drive cache: write through
May 21 16:59:33 localhost kernel: sd 3:0:0:0: [sdd] READ CAPACITY failed
May 21 16:59:33 localhost kernel: sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
May 21 16:59:33 localhost kernel: sd 3:0:0:0: [sdd] Sense not available.
May 21 16:59:33 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
May 21 16:59:33 localhost kernel: sd 3:0:0:0: [sdd] Asking for cache data failed
May 21 16:59:33 localhost kernel: sd 3:0:0:0: [sdd] Assuming drive cache: write through
May 21 16:59:33 localhost kernel: sd 3:0:0:0: [sdd] READ CAPACITY failed
May 21 16:59:33 localhost kernel: sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
May 21 16:59:33 localhost kernel: sd 3:0:0:0: [sdd] Sense not available.
May 21 16:59:33 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
May 21 16:59:33 localhost kernel: sd 3:0:0:0: [sdd] Asking for cache data failed
May 21 16:59:33 localhost kernel: sd 3:0:0:0: [sdd] Assuming drive cache: write through
May 21 16:59:35 localhost kernel: sd 3:0:0:0: [sdd] READ CAPACITY failed
May 21 16:59:35 localhost kernel: sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
May 21 16:59:35 localhost kernel: sd 3:0:0:0: [sdd] Sense not available.
May 21 16:59:35 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
May 21 16:59:35 localhost kernel: sd 3:0:0:0: [sdd] Asking for cache data failed
May 21 16:59:35 localhost kernel: sd 3:0:0:0: [sdd] Assuming drive cache: write through
May 21 16:59:35 localhost kernel: sd 3:0:0:0: [sdd] READ CAPACITY failed
May 21 16:59:35 localhost kernel: sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
May 21 16:59:35 localhost kernel: sd 3:0:0:0: [sdd] Sense not available.
May 21 16:59:35 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
May 21 16:59:35 localhost kernel: sd 3:0:0:0: [sdd] Asking for cache data failed
May 21 16:59:35 localhost kernel: sd 3:0:0:0: [sdd] Assuming drive cache: write through
May 21 16:59:37 localhost kernel: sd 3:0:0:0: [sdd] READ CAPACITY failed
May 21 16:59:37 localhost kernel: sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
May 21 16:59:37 localhost kernel: sd 3:0:0:0: [sdd] Sense not available.
May 21 16:59:37 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
May 21 16:59:37 localhost kernel: sd 3:0:0:0: [sdd] Asking for cache data failed
May 21 16:59:37 localhost kernel: sd 3:0:0:0: [sdd] Assuming drive cache: write through
May 21 16:59:37 localhost kernel: sd 3:0:0:0: [sdd] READ CAPACITY failed
May 21 16:59:37 localhost kernel: sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
May 21 16:59:37 localhost kernel: sd 3:0:0:0: [sdd] Sense not available.
May 21 16:59:37 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
May 21 16:59:37 localhost kernel: sd 3:0:0:0: [sdd] Asking for cache data failed
May 21 16:59:37 localhost kernel: sd 3:0:0:0: [sdd] Assuming drive cache: write through
May 21 16:59:39 localhost kernel: sd 3:0:0:0: [sdd] READ CAPACITY failed
May 21 16:59:39 localhost kernel: sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
May 21 16:59:39 localhost kernel: sd 3:0:0:0: [sdd] Sense not available.
May 21 16:59:39 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
May 21 16:59:39 localhost kernel: sd 3:0:0:0: [sdd] Asking for cache data failed
May 21 16:59:39 localhost kernel: sd 3:0:0:0: [sdd] Assuming drive cache: write through
May 21 16:59:39 localhost kernel: sd 3:0:0:0: [sdd] READ CAPACITY failed
May 21 16:59:39 localhost kernel: sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
May 21 16:59:39 localhost kernel: sd 3:0:0:0: [sdd] Sense not available.
May 21 16:59:39 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
May 21 16:59:39 localhost kernel: sd 3:0:0:0: [sdd] Asking for cache data failed
May 21 16:59:39 localhost kernel: sd 3:0:0:0: [sdd] Assuming drive cache: write through
May 21 16:59:41 localhost kernel: sd 3:0:0:0: [sdd] READ CAPACITY failed
May 21 16:59:41 localhost kernel: sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
May 21 16:59:41 localhost kernel: sd 3:0:0:0: [sdd] Sense not available.
May 21 16:59:41 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
May 21 16:59:41 localhost kernel: sd 3:0:0:0: [sdd] Asking for cache data failed
May 21 16:59:41 localhost kernel: sd 3:0:0:0: [sdd] Assuming drive cache: write through
May 21 16:59:41 localhost kernel: sd 3:0:0:0: [sdd] READ CAPACITY failed
May 21 16:59:41 localhost kernel: sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
May 21 16:59:41 localhost kernel: sd 3:0:0:0: [sdd] Sense not available.
May 21 16:59:41 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
May 21 16:59:41 localhost kernel: sd 3:0:0:0: [sdd] Asking for cache data failed
May 21 16:59:41 localhost kernel: sd 3:0:0:0: [sdd] Assuming drive cache: write through

and it continues like that until I pull the card.

Tejun Heo wrote:
> Robert de Rooy wrote:
>   
>> Thanks for looking into this!
>>
>> I tried the patches on 2.6.22rc1-git5. The second patch unfortunately
>> did not resolve the issue, although it seems to get a bit further. Here
>> are the logs.
>>
>> ** 2.6.22rc1-git5 + timing-debug.patch
>>     
>
> Oh I see.  The 2.6.22rc1-git5 has new reset sequencing which uses
> deadline table so it takes 10sec to fail to first reset try while 2.6.21
> needs 30secs.  That's where the 20sec difference per each try comes
> from, so newer version is better.  Great.
>
>   
>> ** 2.6.22rc1-git5 + timing-debug.patch + disable-dev_init_params.patch
>> May 20 23:02:26 localhost kernel: ata3.00: 253696 sectors, multi 0: LBA
>> May 20 23:02:56 localhost kernel: ata3.00: qc timeout (cmd 0xef)
>> May 20 23:02:56 localhost kernel: ata3.00: failed to set xfermode
>> (err_mask=0x4)
>>     
>
> Hmmm... It doesn't like SETXFERMASK either.  Please try the attached patch.
>
>   

