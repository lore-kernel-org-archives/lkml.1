Return-Path: <linux-kernel-owner+w=401wt.eu-S965457AbXBFUxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965457AbXBFUxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 15:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965460AbXBFUxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 15:53:20 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:58253 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965458AbXBFUxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 15:53:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=TaUuO7nkdLL9GyjNkYOyRsLUB/xa/2vg9GBaQPgRdFiE3q/6E/5yFEznB/Nng5pEvluXuSJLTyFk3UCyRK3G80Iuzz919PShwPSfjepuropwk9Qu8pdyUhUdUpQbaHtzTwrX87iuEF/88TPx6ehEjFyebSbvvYF9kKYETItY1UE=
Message-ID: <45C8EAAD.5000905@googlemail.com>
Date: Tue, 06 Feb 2007 21:53:01 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [QUESTION] ATA: abnormal status 0x80 on port 0xCC07
References: <6bffcb0e0702031044v601e4fc3icf859544af292789@mail.gmail.com>
In-Reply-To: <6bffcb0e0702031044v601e4fc3icf859544af292789@mail.gmail.com>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski napisał(a):
> Hi Jeff,
> 
> What does this mean?
> 
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata1.00: cmd c8/00:08:67:40:68/00:00:00:00:00/e3 tag 0 cdb 0x0 data 4096 in
>         res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata1: soft resetting port
> ata1.00: configured for UDMA/133
> ata1: EH complete
> SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
> sda: Write Protect is off
> sda: Mode Sense: 00 3a 00 00
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata1.00: cmd c8/00:00:c3:52:43/00:00:00:00:00/ea tag 0 cdb 0x0 data
> 131072 in
>         res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata1: soft resetting port
> ata1.00: configured for UDMA/133
> ata1: EH complete
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata1.00: cmd c8/00:00:c3:52:43/00:00:00:00:00/ea tag 0 cdb 0x0 data
> 131072 in
>         res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata1: soft resetting port
> ata1.00: configured for UDMA/133
> ata1: EH complete
> SCSI device sda: write cache: enabled, read cache: enabled, doesn't
> support DPO
> or FUA
> SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
> sda: Write Protect is off
> sda: Mode Sense: 00 3a 00 00
> SCSI device sda: write cache: enabled, read cache: enabled, doesn't
> support DPO
> or FUA
> ATA: abnormal status 0x80 on port 0xCC07
> ATA: abnormal status 0x80 on port 0xCC07
> ATA: abnormal status 0x80 on port 0xCC07
> ata1.00: limiting speed to UDMA/100
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata1.00: cmd ca/00:38:8f:7a:01/00:00:00:00:00/e0 tag 0 cdb 0x0 data
> 28672 out
>         res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata1: soft resetting port
> ata1.00: configured for UDMA/100
> ata1: EH complete
> SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
> sda: Write Protect is off
> sda: Mode Sense: 00 3a 00 00
> SCSI device sda: write cache: enabled, read cache: enabled, doesn't
> support DPO                                             or FUA
> ATA: abnormal status 0x80 on port 0xCC07
> ATA: abnormal status 0x80 on port 0xCC07
> ATA: abnormal status 0x80 on port 0xCC07
> ata1.00: limiting speed to UDMA/66
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata1.00: cmd ca/00:40:ab:e2:4a/00:00:00:00:00/ea tag 0 cdb 0x0 data
> 32768 out
>         res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata1: soft resetting port
> ata1.00: configured for UDMA/66
> ata1: EH complete
> SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
> sda: Write Protect is off
> sda: Mode Sense: 00 3a 00 00
> SCSI device sda: write cache: enabled, read cache: enabled, doesn't
> support DPO                                             or FUA
> 
> Is this a hardware problem?
> 

CONFIG_ATA=y
CONFIG_ATA_PIIX=y
CONFIG_SATA_INTEL_COMBINED=y

This might be an ata driver problem, 2.6.19-1.2895.fc6 works fine, 2.6.20-rc6 was fine.

This was the latest working kernel
Feb  3 00:53:49 euridica kernel: Linux version 2.6.20-rc7 (michal@euridica.enternet.net.pl) (gcc version 4.1.1 20070105 (Red Hat 4.1.1-51)) #27 SMP PREEMPT Thu Feb 1 11:57:34 CET 2007

This was the first bad one
Feb  3 18:26:07 euridica kernel: Linux version 2.6.20-rc7 (michal@euridica.enternet.net.pl) (gcc version 4.1.1 20070105 (Red Hat 4.1.1-51)) #28 SMP PREEMPT Sat Feb 3 02:07:08 CET 2007

I'll revert this patch.

commit 7a0f1c8a4b1052da7efc7715e2e557255b632712
Author: Lennert Buytenhek <buytenh@wantstofly.org>
Date:   Mon Jan 29 13:28:47 2007 +0100

    ata_if_xfermask() word 51 fix

    If word 53 bit 1 isn't set, the maximum PIO mode is indicated by
    the upper 8 bits of word 51, not the lower 8 bits.  Fixes PIO mode
    detection on old Compact Flash cards.

    Signed-off-by: Lennert Buytenhek <buytenh@wantstofly.org>
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index a388a8d..cf70702 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1037,7 +1037,7 @@ static unsigned int ata_id_xfermask(cons
                 * the PIO timing number for the maximum. Turn it into
                 * a mask.
                 */
-               u8 mode = id[ATA_ID_OLD_PIO_MODES] & 0xFF;
+               u8 mode = (id[ATA_ID_OLD_PIO_MODES] >> 8) & 0xFF;
                if (mode < 5)   /* Valid PIO range */
                        pio_mask = (2 << mode) - 1;
                else

There are 55 per cent chances that this is a hardware problem and 45 % that this is a software bug.

uptime
 21:36:36 up  4:48,  0 users,  load average: 0.62, 0.71, 0.65

on 2.6.19-1.2895.fc6 without any hdd related problems.

http://www.stardust.webpages.pl/files/tbf/euridica/2.6.20-rc7/messages

sudo /usr/sbin/smartctl -a -d ata /dev/sda
smartctl version 5.36 [i386-redhat-linux-gnu] Copyright (C) 2002-6 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Device Model:     ST3160811AS
Serial Number:    5PT0KRNR
Firmware Version: 3.AAE
User Capacity:    160,041,885,696 bytes
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   7
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Tue Feb  6 21:50:32 2007 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82) Offline data collection activity
                                        was completed without error.
                                        Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0) The previous self-test routine completed
                                        without error or no self-test has ever
                                        been run.
Total time to complete Offline
data collection:                 ( 430) seconds.
Offline data collection
capabilities:                    (0x5b) SMART execute Offline immediate.
                                        Auto Offline data collection on/off support.
                                        Suspend Offline collection upon new
                                        command.
                                        Offline surface scan supported.
                                        Self-test supported.
                                        No Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging supported.
Short self-test routine
recommended polling time:        (   1) minutes.
Extended self-test routine
recommended polling time:        (  54) minutes.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   119   100   006    Pre-fail  Always       -       231824575
  3 Spin_Up_Time            0x0003   099   096   000    Pre-fail  Always       -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age   Always       -       309
  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x000f   075   060   030    Pre-fail  Always       -       29962423
  9 Power_On_Hours          0x0032   098   098   000    Old_age   Always       -       2207
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age   Always       -       520
187 Unknown_Attribute       0x0032   100   100   000    Old_age   Always       -       0
189 Unknown_Attribute       0x003a   100   100   000    Old_age   Always       -       0
190 Unknown_Attribute       0x0022   057   053   045    Old_age   Always       -       724107307
194 Temperature_Celsius     0x0022   043   047   000    Old_age   Always       -       43 (Lifetime Min/Max 0/17)
195 Hardware_ECC_Recovered  0x001a   061   043   000    Old_age   Always       -       190459272
197 Current_Pending_Sector  0x0012   001   001   000    Old_age   Always       -       4294967294
198 Offline_Uncorrectable   0x0010   001   001   000    Old_age   Offline      -       4294967294
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       0
200 Multi_Zone_Error_Rate   0x0000   100   253   000    Old_age   Offline      -       0
202 TA_Increase_Count       0x0032   100   253   000    Old_age   Always       -       0

SMART Error Log Version: 1
ATA Error Count: 6 (device log contains only the most recent five errors)
        CR = Command Register [HEX]
        FR = Features Register [HEX]
        SC = Sector Count Register [HEX]
        SN = Sector Number Register [HEX]
        CL = Cylinder Low Register [HEX]
        CH = Cylinder High Register [HEX]
        DH = Device/Head Register [HEX]
        DC = Device Command Register [HEX]
        ER = Error register [HEX]
        ST = Status register [HEX]
Powered_Up_Time is measured from power on, and printed as
DDd+hh:mm:SS.sss where DD=days, hh=hours, mm=minutes,
SS=sec, and sss=millisec. It "wraps" after 49.710 days.

Error 6 occurred at disk power-on lifetime: 2202 hours (91 days + 18 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 bc 0c 02 e0  Error: UNC at LBA = 0x00020cbc = 134332

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  c8 00 00 2f 0c 02 e0 00      00:01:07.193  READ DMA
  ec 03 46 00 00 00 a0 02      00:01:07.192  IDENTIFY DEVICE
  ef 03 46 00 00 00 a0 00      00:01:07.180  SET FEATURES [Set transfer mode]
  ec 00 00 bc 0c 02 a0 02      00:01:05.100  IDENTIFY DEVICE
  c8 00 00 2f 0c 02 e0 00      00:01:05.096  READ DMA

Error 5 occurred at disk power-on lifetime: 2202 hours (91 days + 18 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 bc 0c 02 e0  Error: UNC at LBA = 0x00020cbc = 134332

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  c8 00 00 2f 0c 02 e0 00      00:01:07.193  READ DMA
  ec 03 46 00 00 00 a0 02      00:01:07.192  IDENTIFY DEVICE
  ef 03 46 00 00 00 a0 00      00:01:07.180  SET FEATURES [Set transfer mode]
  ec 00 00 bc 0c 02 a0 02      00:01:05.100  IDENTIFY DEVICE
  c8 00 00 2f 0c 02 e0 00      00:01:05.096  READ DMA

Error 4 occurred at disk power-on lifetime: 2202 hours (91 days + 18 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 bc 0c 02 e0  Error: UNC at LBA = 0x00020cbc = 134332

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  c8 00 00 2f 0c 02 e0 00      00:01:07.193  READ DMA
  ec 03 46 00 00 00 a0 02      00:01:07.192  IDENTIFY DEVICE
  ef 03 46 00 00 00 a0 00      00:01:07.180  SET FEATURES [Set transfer mode]
  ec 00 00 bc 0c 02 a0 02      00:01:05.100  IDENTIFY DEVICE
  c8 00 00 2f 0c 02 e0 00      00:01:05.096  READ DMA

Error 3 occurred at disk power-on lifetime: 2202 hours (91 days + 18 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 bc 0c 02 e0  Error: UNC at LBA = 0x00020cbc = 134332

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  c8 00 00 2f 0c 02 e0 00      00:01:00.301  READ DMA
  ec 03 46 00 00 00 a0 02      00:01:00.299  IDENTIFY DEVICE
  ef 03 46 00 00 00 a0 00      00:01:00.296  SET FEATURES [Set transfer mode]
  ec 00 00 bc 0c 02 a0 02      00:01:05.100  IDENTIFY DEVICE
  c8 00 00 2f 0c 02 e0 00      00:01:05.096  READ DMA

Error 2 occurred at disk power-on lifetime: 2202 hours (91 days + 18 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 bc 0c 02 e0  Error: UNC at LBA = 0x00020cbc = 134332

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  c8 00 00 2f 0c 02 e0 00      00:01:00.301  READ DMA
  ec 03 46 00 00 00 a0 02      00:01:00.299  IDENTIFY DEVICE
  ef 03 46 00 00 00 a0 00      00:01:00.296  SET FEATURES [Set transfer mode]
  ec 00 00 bc 0c 02 a0 02      00:01:00.294  IDENTIFY DEVICE
  c8 00 00 2f 0c 02 e0 00      00:01:00.293  READ DMA

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%      2180         -
# 2  Extended offline    Completed without error       00%       390         -

SMART Selective self-test log data structure revision number 1
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.


Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group
(http://www.stardust.webpages.pl/ltg/)
