Return-Path: <linux-kernel-owner+w=401wt.eu-S1763437AbZAUK2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763437AbZAUK2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 05:28:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755382AbZAUK1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 05:27:43 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:11270 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbZAUK1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 05:27:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Z7LCCYjY7vvtBYDKna+o09X5By1ObP64jONke5yDzog5Jl652bDE1KY9KhO8wW2f3j
         x+yx8oDPd9A3PMBUzCtTHt1Xpo2HvnGZ9pVYRrxaKDJNtuy2d6W+shZXGq/kRyo3Wn0y
         +lPLXGQIYvSQ05wbErE5eMsbfdonxtd2C1dfc=
Message-ID: <4976F89A.1040405@gmail.com>
Date: Wed, 21 Jan 2009 02:27:38 -0800
From: Patrick Horn <patrick.horn@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Diego Calleja <diegocg@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Faulty seagate drives, are going to be blacklisted?
References: <20090120002923.065f24ca@diego-desktop>
In-Reply-To: <20090120002923.065f24ca@diego-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Diego Calleja wrote:
> Tech sites are reporting everywhere a massive flaw in seagate drives that
> can lock up the drive and make it unusable (the bios doesn't detect it, you
> can't read the data). Haven't read anything about it here on the lists.
> Seagate has ack'ed the problem:
> http://seagate.custkb.com/seagate/crm/selfservice/search.jsp?DocId=207931
> 
> So, apparently there're a lot of drives on the market (including mine)
> that can die any day. Are those drives going to be blacklisted? It's
> still not clear if the firmware update is safe (some affected but
> working drives are dying after the firmware update), so some people
> like me is still waiting (and hoping that the drive doesn't die) for
> more stable firmware updates...
> 
> Here is the list of drives+firmware affected, according to the support site
> as of now. Some models are still being diagnosed.
> 
> 
> Seagate Barracuda 7200.11 (http://seagate.custkb.com/seagate/crm/selfservice/search.jsp?DocId=207951)
> 
> Models Affected:
>  ST3500320AS
>  ST3640330AS
>  ST3750330AS
>  ST31000340AS
> Firmware Affected
>  SD15, SD16, SD17, SD18, SD19, AD14
> Recommended Firmware Update
>  SD1A
> 
> Seagate Barracuda 7200.11, page 2 (http://seagate.custkb.com/seagate/crm/selfservice/search.jsp?DocId=207957)
> Models Affected:
>  ST31500341AS
>  ST31000333AS
>  ST3640323AS
>  ST3640623AS
>  ST3320613AS
>  ST3320813AS
>  ST3160813AS
> Firmware Affected
>  Still Unknow
> Recommended Firmware Update
>  Still Unknow
> 
> 
> Seagate Barracuda ES.2 (http://seagate.custkb.com/seagate/crm/selfservice/search.jsp?DocId=207963)
> Models Affected:
>  ST3250310NS
>  ST3500320NS
>  ST3750330NS
>  ST31000340NS
> Firmware Affected
>  Still Unknow
> Recommended Firmware Update
>  Still Unknow
> 
> DiamondMax 22 (http://seagate.custkb.com/seagate/crm/selfservice/search.jsp?DocId=207969)
> Models Affected:
>  STM3500320AS
>  STM3750330AS
>  STM31000340AS
> Firmware Affected
>  MX15 (or higher)
> Recommended Firmware Update
>  MX1A
> 
> DiamondMax 22 (http://seagate.custkb.com/seagate/crm/selfservice/search.jsp?DocId=207975)
> Models Affected:
>  STM31000334AS
>  STM3320614AS
>  STM3160813AS
> Firmware Affected
>  Still Unknow
> Recommended Firmware Update
>  Still Unknow
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Hi,

I have another drive which doesn't seem to be on any list, and a google search 
comes up with very little information about this one.

I have two raided SATA 1TB "MAXTOR STM31000333AS" drives, firmware MX15, one of 
which "failed" last weekend.  I have since rebuilt the array and it has had no 
further problems, but I know it's only a matter of time before it happens again.

I checked SMART, and both drives are essentially identical with nothing anywhere 
near failure.
I am on Ubuntu kernel 2.6.28-4-generic #5-Ubuntu but I will be happy to build a 
kernel if this becomes at all reproducible.

At first I thought that this NCQ problem might apply to me, but my drive is 
(gasp) one letter different from two of those listed (both seagate and maxtor 
variants):
http://seagate.custkb.com/seagate/crm/selfservice/search.jsp?DocId=207931
And MX15 is listed as a faulty firmware for the STM31000340AS/334AS

I have been using these drives for just three weeks up to now, before having the 
one drive fail (and later it gave a bunch of errors at bootup, which was solved 
when it reset the SATA link). The other drive has luckily not had any issues.

Is this error just coincidence, or did Seagate forget to mention my drive?
(And what happened to the firmware updates--they seem to be "In Validation")
Is seagate the only site with information about this? Any public blacklist of 
every affected drive? What can I see in dmesg that indicates that NCQ is the cause?


Thanks,
-Patrick

(I'll paste my dmesg as I don't know enough to tell if this is the same issue as 
the other seagate drives--I trimmed the repetitive parts)

[ 7520.699730] ata2.00: exception Emask 0x10 SAct 0x7ff4f SErr 0x400100 action 
0x6 frozen
[ 7520.699734] ata2.00: irq_stat 0x08000000, interface fatal error
[ 7520.699738] ata2: SError: { UnrecovData Handshk }
[ 7520.699743] ata2.00: cmd 61/50:00:89:4b:c0/00:00:01:00:00/40 tag 0 ncq 40960 out
[ 7520.699745]          res 40/00:30:91:60:c0/00:00:01:00:00/40 Emask 0x10 (ATA 
bus error)
[ 7520.699748] ata2.00: status: { DRDY }
[ 7520.699752] ata2.00: cmd 61/40:08:b1:4f:c0/00:00:01:00:00/40 tag 1 ncq 32768 out
[ 7520.699753]          res 40/00:30:91:60:c0/00:00:01:00:00/40 Emask 0x10 (ATA 
bus error)
[ 7520.699756] ata2.00: status: { DRDY }
[ 7520.699875] ata2: hard resetting link
[ 7521.180020] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 7521.250673] ata2.00: configured for UDMA/133
[ 7521.250724] ata2: EH complete
[ 7521.250812] sd 1:0:0:0: [sdb] 1953525168 512-byte hardware sectors: (1.00 
TB/931 GiB)
[ 7521.250832] sd 1:0:0:0: [sdb] Write Protect is off
[ 7521.250835] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[ 7521.250865] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[ 7521.258968] ata2.00: exception Emask 0x10 SAct 0x7ffff SErr 0x400100 action 
0x6 frozen
[ 7521.258972] ata2.00: irq_stat 0x08000000, interface fatal error
[ 7521.258975] ata2: SError: { UnrecovData Handshk }
... it then goes down to 1.5 Gbps but continues to give errors until it is 
kicked from the raid array an hour later

[10477.764175] ata2.00: status: { DRDY }
[10477.764179] ata2: hard resetting link
[10478.248019] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[10478.318670] ata2.00: configured for UDMA/33
[10478.318679] end_request: I/O error, dev sdb, sector 989067690
[10478.318685] raid1: Disk failure on sdb3, disabling device.
[10478.318686] raid1: Operation continuing on 1 devices.


This drive also encountered a similar error on bootup the next day:
[    9.389771] ata2.00: exception Emask 0x10 SAct 0xf SErr 0xc00000 action 0x6 
frozen
[    9.389774] ata2.00: irq_stat 0x0c000000, interface fatal error
[    9.389776] ata2: SError: { Handshk LinkSeq }
[    9.389780] ata2.00: cmd 60/02:00:3f:af:4e/00:00:00:00:00/40 tag 0 ncq 1024 in
[    9.389781]          res 40/00:10:41:af:4e/00:00:00:00:00/40 Emask 0x10 (ATA 
bus error)
[    9.389783] ata2.00: status: { DRDY }


 From lspci -vvv:

0:1f.2 SATA controller: Intel Corporation 82801IR/IO/IH (ICH9R/DO/DH) 6 port 
SATA AHCI Controller (rev 02) (prog-if 01)
         Subsystem: ASUSTeK Computer Inc. Device 8277 

         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0 

         Interrupt: pin B routed to IRQ 2299 

         Region 0: I/O ports at 9c00 [size=8] 

         Region 1: I/O ports at 9880 [size=4] 

         Region 2: I/O ports at 9800 [size=8] 

         Region 3: I/O ports at 9480 [size=4] 

         Region 4: I/O ports at 9400 [size=32] 

         Region 5: Memory at f9ffe800 (32-bit, non-prefetchable) [size=2K] 

         Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/4 
Enable+
                 Address: fee0f00c  Data: 4181 

         Capabilities: [70] Power Management version 3 

                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot+,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME- 

         Capabilities: [a8] SATA HBA <?> 

         Capabilities: [b0] Vendor Specific Information <?> 

         Kernel driver in use: ahci 

         Kernel modules: ahci 


