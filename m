Return-Path: <linux-kernel-owner+w=401wt.eu-S933338AbXLNPur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933338AbXLNPur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 10:50:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764368AbXLNPuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 10:50:09 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:33349 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764310AbXLNPuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 10:50:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=RxGYtz6zgbeH1yLUE6FN9MWOJEWiN/sOCWIfo7NKDtw6mbLhRzPS+I6tFiz45QQjm2uT4NMHoIalSGRkCq6L3xdaXO1tgispeZj0sAayKuWnC3GJxlZ7Q3VblME/HXA04hDX7xQw1+vZpbGr0SxMTgbKQAdKmwT0QE+d89THbFc=
Message-ID: <4762A625.4050101@gmail.com>
Date: Sat, 15 Dec 2007 00:49:57 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Christoph Anton Mitterer <calestyo@scientia.net>
CC: linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Robert Hancock <hancockr@shaw.ca>
Subject: Re: Strange ATA problems
References: <1197591699.3453.38.camel@fermat.scientia.net>	 <47629E40.5020007@gmail.com> <1197647095.3454.3.camel@fermat.scientia.net>
In-Reply-To: <1197647095.3454.3.camel@fermat.scientia.net>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc'ing linux-ide and Robert Hancock and quoting whole body]

Christoph Anton Mitterer wrote:
> Hi Tejun.
> 
> 
> On Sat, 2007-12-15 at 00:16 +0900, Tejun Heo wrote:
>> Do you have log with timestamp?  It's difficult to tell what's going on
>> without knowing what happened when.
> Ah sorry,... I've completely missed that... perhaps those two problems
> were not related (at least there's so much time between).

Then those two events are unrelated.

> Dec 13 17:05:51 fermat kernel: NVRM: loading NVIDIA UNIX x86_64 Kernel
> Module  100.14.19  Wed Sep 12 14:08:38 PDT 2007
> Dec 13 17:12:36 fermat kernel: usb 1-1: new high speed USB device using
> ehci_hcd and address 5
> Dec 13 17:12:36 fermat kernel: usb 1-1: configuration #1 chosen from 1
> choice
> Dec 13 17:12:36 fermat kernel: scsi6 : SCSI emulation for USB Mass
> Storage devices
> Dec 13 17:12:36 fermat kernel: usb-storage: device found at 5
> Dec 13 17:12:36 fermat kernel: usb-storage: waiting for device to settle
> before scanning
> Dec 13 17:12:41 fermat kernel: scsi 6:0:0:0: CD-ROM            PLEXTOR
> DVD-ROM PX-130A  1.03 PQ: 0 ANSI: 0 CCS
> Dec 13 17:12:41 fermat kernel: sr0: scsi3-mmc drive: 0x/50x cd/rw
> xa/form2 cdda tray
> Dec 13 17:12:41 fermat kernel: sr 6:0:0:0: Attached scsi CD-ROM sr0
> Dec 13 17:12:41 fermat kernel: sr 6:0:0:0: Attached scsi generic sg3
> type 5
> Dec 13 17:12:41 fermat kernel: usb-storage: device scan complete
> Dec 13 17:13:33 fermat kernel: end_request: I/O error, dev sr0, sector
> 308688
> Dec 13 17:13:33 fermat kernel: Buffer I/O error on device sr0, logical
> block 77172
> Dec 13 17:13:33 fermat kernel: Buffer I/O error on device sr0, logical
> block 77173
> Dec 13 17:13:33 fermat kernel: end_request: I/O error, dev sr0, sector
> 308688
> Dec 13 17:13:33 fermat kernel: Buffer I/O error on device sr0, logical
> block 77172
> Dec 13 17:13:33 fermat kernel: Buffer I/O error on device sr0, logical
> block 77173
> Dec 13 17:13:33 fermat kernel: end_request: I/O error, dev sr0, sector
> 308816
> Dec 13 17:13:33 fermat kernel: Buffer I/O error on device sr0, logical
> block 77204
> Dec 13 17:13:33 fermat kernel: Buffer I/O error on device sr0, logical
> block 77205
> Dec 13 17:13:33 fermat kernel: end_request: I/O error, dev sr0, sector
> 308816
> Dec 13 17:13:33 fermat kernel: Buffer I/O error on device sr0, logical
> block 77204
> Dec 13 17:13:33 fermat kernel: Buffer I/O error on device sr0, logical
> block 77205
> Dec 13 17:18:32 fermat kernel: UDF-fs: No VRS found
> Dec 13 18:09:43 fermat kernel: tun0: Disabled Privacy Extensions
> Dec 14 01:06:33 fermat kernel: usb 1-1: USB disconnect, address 5
> Dec 14 01:06:33 fermat kernel: ata1: EH in ADMA mode, notifier 0x0
> notifier_error 0x0 gen_ctl 0x1501000 status 0x400 next cpb count 0x0
> next
>  cpb idx 0x0
> Dec 14 01:06:33 fermat kernel: ata1: CPB 0: ctl_flags 0x1f, resp_flags
> 0x2
> Dec 14 01:06:33 fermat kernel: ata1: CPB 1: ctl_flags 0x1f, resp_flags
> 0x2
> Dec 14 01:06:33 fermat kernel: ata1: CPB 2: ctl_flags 0x1f, resp_flags
> 0x2
> Dec 14 01:06:33 fermat kernel: ata1: CPB 3: ctl_flags 0x1f, resp_flags
> 0x2
> Dec 14 01:06:33 fermat kernel: ata1: CPB 4: ctl_flags 0x1f, resp_flags
> 0x2
> Dec 14 01:06:33 fermat kernel: ata1: CPB 5: ctl_flags 0x1f, resp_flags
> 0x2
> Dec 14 01:06:33 fermat kernel: ata1: CPB 6: ctl_flags 0x1f, resp_flags
> 0x2
> Dec 14 01:06:33 fermat kernel: ata1: CPB 7: ctl_flags 0x1f, resp_flags
> 0x2
> Dec 14 01:06:33 fermat kernel: ata1: CPB 8: ctl_flags 0x1f, resp_flags
> 0x2
> Dec 14 01:06:33 fermat kernel: ata1: CPB 9: ctl_flags 0x1f, resp_flags
> 0x2
> Dec 14 01:06:33 fermat kernel: ata1: CPB 10: ctl_flags 0x1f, resp_flags
> 0x2
> Dec 14 01:06:33 fermat kernel: ata1: timeout waiting for ADMA IDLE,
> stat=0x400
> Dec 14 01:06:33 fermat kernel: ata1.00: exception Emask 0x0 SAct 0x7ff
> SErr 0x0 action 0x2 frozen
> Dec 14 01:06:33 fermat kernel: ata1.00: cmd
> 61/10:00:2e:07:a8/01:00:0b:00:00/40 tag 0 cdb 0x0 data 139264 out
> Dec 14 01:06:33 fermat kernel:          res
> 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
> Dec 14 01:06:33 fermat kernel: ata1.00: cmd
> 61/18:08:07:3f:02/00:00:00:00:00/40 tag 1 cdb 0x0 data 12288 out
> Dec 14 01:06:33 fermat kernel:          res
> 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> Dec 14 01:06:33 fermat kernel: ata1.00: cmd
> 61/08:10:b6:a8:23/00:00:0d:00:00/40 tag 2 cdb 0x0 data 4096 out
> Dec 14 01:06:33 fermat kernel:          res
> 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> Dec 14 01:06:33 fermat kernel: ata1.00: cmd
> 61/08:18:f6:37:68/00:00:0d:00:00/40 tag 3 cdb 0x0 data 4096 out
> Dec 14 01:06:33 fermat kernel:          res
> 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> Dec 14 01:06:33 fermat kernel: ata1.00: cmd
> 61/08:20:9e:32:a1/00:00:0d:00:00/40 tag 4 cdb 0x0 data 4096 out
> Dec 14 01:06:33 fermat kernel:          res
> 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> Dec 14 01:06:33 fermat kernel: ata1.00: cmd
> 61/08:28:4f:00:dc/00:00:02:00:00/40 tag 5 cdb 0x0 data 4096 out
> Dec 14 01:06:33 fermat kernel:          res
> 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> Dec 14 01:06:33 fermat kernel: ata1.00: cmd
> 61/08:30:6f:00:dc/00:00:02:00:00/40 tag 6 cdb 0x0 data 4096 out
> Dec 14 01:06:33 fermat kernel:          res
> 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> Dec 14 01:06:33 fermat kernel: ata1.00: cmd
> 61/08:38:3f:03:2c/00:00:05:00:00/40 tag 7 cdb 0x0 data 4096 out
> Dec 14 01:06:33 fermat kernel:          res
> 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> Dec 14 01:06:33 fermat kernel: ata1.00: cmd
> 61/08:40:36:ea:72/00:00:0d:00:00/40 tag 8 cdb 0x0 data 4096 out
> Dec 14 01:06:33 fermat kernel:          res
> 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> Dec 14 01:06:33 fermat kernel: ata1.00: cmd
> 61/08:48:7f:00:c4/00:00:05:00:00/40 tag 9 cdb 0x0 data 4096 out
> Dec 14 01:06:33 fermat kernel:          res
> 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> Dec 14 01:06:33 fermat kernel: ata1.00: cmd
> 61/08:50:47:02:d8/00:00:05:00:00/40 tag 10 cdb 0x0 data 4096 out
> Dec 14 01:06:33 fermat kernel:          res
> 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> Dec 14 01:06:33 fermat kernel: ata1: soft resetting port
> Dec 14 01:06:33 fermat kernel: ata1: SATA link up 3.0 Gbps (SStatus 123
> SControl 300)
> Dec 14 01:06:33 fermat kernel: ata1.00: configured for UDMA/133
> Dec 14 01:06:33 fermat kernel: ata1: EH complete
> Dec 14 01:06:33 fermat kernel: sd 0:0:0:0: [sda] 488397168 512-byte
> hardware sectors (250059 MB)
> Dec 14 01:06:33 fermat kernel: sd 0:0:0:0: [sda] Write Protect is off
> Dec 14 01:06:33 fermat kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> Dec 14 01:06:33 fermat kernel: sd 0:0:0:0: [sda] Write cache: enabled,
> read cache: enabled, doesn't support DPO or FUA
> Dec 14 01:27:45 fermat kernel: Kernel logging (proc) stopped.
> 
> 
> 
>> Also, please post the result of
>> 'cat /proc/interrupts'.
>            CPU0       CPU1       CPU2       CPU3       
>   0:        393       1181      82962    4513047   IO-APIC-edge
> timer
>   1:          0          0          0          2   IO-APIC-edge
> i8042
>   6:          0          0          0          5   IO-APIC-edge
> floppy
>   8:          0          0          0          0   IO-APIC-edge      rtc
>   9:          0          0          0          0   IO-APIC-fasteoi
> acpi
>  12:          0         84       1376     210883   IO-APIC-edge
> i8042
>  14:          0          3         17       1220   IO-APIC-edge
> ide0
>  18:          0         64       4964     300769   IO-APIC-fasteoi
> nvidia
>  19:          0          0          0          3   IO-APIC-fasteoi
> ohci1394
>  20:          0          0          0          4   IO-APIC-fasteoi
> ehci_hcd:usb1
>  21:          0          0          1        165   IO-APIC-fasteoi
> sata_nv
>  22:          0         44       1856     165693   IO-APIC-fasteoi
> sata_nv, NVidia CK804
>  23:          0        117       8565     452639   IO-APIC-fasteoi
> ohci_hcd:usb3, eth1
>  24:          0         37       3710     185125   IO-APIC-fasteoi
> ICE1724
>  30:          3       1833      52841   18139903   IO-APIC-fasteoi
> ioc0, ehci_hcd:usb2
>  31:          0          0          0         45   IO-APIC-fasteoi
> ioc1
>  55:        129     530948          1         81   IO-APIC-fasteoi
> eth2
> NMI:          0          0          0          0 
> LOC:    4597004    4596930    4596860    4596786 
> ERR:          0
> 
> 
>> If your USB cdrom is bus powered and you yanked it, it could have caused
>> fluctuation in power which in turn can cause disruption on serial ATA
>> bus leading to transmission error and timeouts.  There are other
>> possibilities but this kind of thing does happen often with SATA.  Those
>> highspeed low-voltage serial links are very susceptible to interferences.
> Well,.. it actually "worked" again when I unplugged it, but the errors
> from the cdrom above are probably unrelated..
> 
> 
>> As long as EH recovered it properly, there's nothing to worry about.
> What does that mean?

That means unless the problem continues to occur repeatedly, you don't
have to worry about it.

-- 
tejun
