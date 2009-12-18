Return-Path: <linux-kernel-owner+w=401wt.eu-S932522AbZLRTUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522AbZLRTUK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 14:20:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932367AbZLRTUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 14:20:08 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:36808 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932331AbZLRTUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 14:20:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=T5UpPROvlYgCVT2LreW28rV6n0/MDlARZ1CW7qUaBORInoay/A6AjNh1/Bm+4g6Bu6
         PbcAVtrherg/iT2urMebIARFOz9UUT/uGuCBwRRxCvPpbPF7Qeo6zKiWOWKDV3S7f7wL
         /d/Rt9+NmTs0PexArdOxgD7h+MbHLkbi+6FiQ=
MIME-Version: 1.0
In-Reply-To: <200912181838.20204.bzolnier@gmail.com>
References: <43e72e890912180926oad3b09fl6b7951864a836700@mail.gmail.com> 
	<200912181838.20204.bzolnier@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 18 Dec 2009 11:19:42 -0800
Message-ID: <43e72e890912181119t53e01ec2y5dc8687d23f7a668@mail.gmail.com>
Subject: Re: git pull on linux-next makes my system crawl to its knees and beg 
	for mercy
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Bob Copeland <me@bobcopeland.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 9:38 AM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
> On Friday 18 December 2009 06:26:29 pm Luis R. Rodriguez wrote:
>
>> on my kernel logs. Bewildered with this issue I set out to prove to
>> myself this issue was not a 2.6.32 issue and booted other kernels,
>> including Ubuntu's distro kernel on 2.6.31 and then later my own built
>> fresh 2.6.27.41 kernel. The issue was reproducible on all three
>> kernels!
>>
>> This lead me to believe this was a system / hard drive issue and
>> embraced myself for a system fix. I yet needed to prove this was
>
> Just some hints for ruling out the system / hard drive problem.
>
> smartctl -a /dev/sdx is your friend for checking your disk (keep an eye
> on anything suspicious like re-allocated sector count going up etc.)

Sweet thanks, here's my current output, I'll try later after I get
some day work done to pull linux-next and make it moan. Let me know if
you see anything fishy.

smartctl version 5.38 [x86_64-unknown-linux-gnu] Copyright (C) 2002-8
Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Device Model:     HITACHI HTS722010K9SA00
Serial Number:    080109DP0210DPG8DUEP
Firmware Version: DC2ZC75A
User Capacity:    100,030,242,816 bytes
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 3f
Local Time is:    Fri Dec 18 11:16:12 2009 PST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82)	Offline data collection activity
					was completed without error.
					Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)	The previous self-test routine completed
					without error or no self-test has ever
					been run.
Total time to complete Offline
data collection: 		 ( 645) seconds.
Offline data collection
capabilities: 			 (0x5b) SMART execute Offline immediate.
					Auto Offline data collection on/off support.
					Suspend Offline collection upon new
					command.
					Offline surface scan supported.
					Self-test supported.
					No Conveyance Self-test supported.
					Selective Self-test supported.
SMART capabilities:            (0x0003)	Saves SMART data before entering
					power-saving mode.
					Supports SMART auto save timer.
Error logging capability:        (0x01)	Error logging supported.
					General Purpose Logging supported.
Short self-test routine
recommended polling time: 	 (   2) minutes.
Extended self-test routine
recommended polling time: 	 (  39) minutes.
SCT capabilities: 	       (0x003d)	SCT Status supported.
					SCT Feature Control supported.
					SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000b   100   100   062    Pre-fail
Always       -       0
  2 Throughput_Performance  0x0005   116   116   040    Pre-fail
Offline      -       3380
  3 Spin_Up_Time            0x0007   253   253   033    Pre-fail
Always       -       0
  4 Start_Stop_Count        0x0012   098   098   000    Old_age
Always       -       3314
  5 Reallocated_Sector_Ct   0x0033   100   100   005    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x000b   100   100   067    Pre-fail
Always       -       0
  8 Seek_Time_Performance   0x0005   128   128   040    Pre-fail
Offline      -       29
  9 Power_On_Hours          0x0012   081   081   000    Old_age
Always       -       8401
 10 Spin_Retry_Count        0x0013   100   100   060    Pre-fail
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       1571
191 G-Sense_Error_Rate      0x000a   100   100   000    Old_age
Always       -       65536
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age
Always       -       3932351
193 Load_Cycle_Count        0x0012   045   045   000    Old_age
Always       -       559592
194 Temperature_Celsius     0x0002   134   134   000    Old_age
Always       -       41 (Lifetime Min/Max 13/48)
196 Reallocated_Event_Count 0x0032   100   100   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0022   100   100   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0008   100   100   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x000a   200   200   000    Old_age
Always       -       0
223 Load_Retry_Count        0x000a   100   100   000    Old_age
Always       -       0

SMART Error Log Version: 1
ATA Error Count: 8 (device log contains only the most recent five errors)
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

Error 8 occurred at disk power-on lifetime: 0 hours (0 days + 0 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  10 51 01 9f 45 a5 e0  Error: IDNF at LBA = 0x00a5459f = 10831263

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  24 ff 01 9f 45 a5 e0 00      00:04:06.200  READ SECTOR(S) EXT
  25 ff 01 9f 45 a5 e0 00      00:04:06.100  READ DMA EXT
  34 ff 01 00 00 00 e0 00      00:04:04.100  WRITE SECTORS(S) EXT
  25 ff 01 00 00 00 e0 00      00:04:04.100  READ DMA EXT
  25 ff 01 c0 17 fa e0 00      00:04:04.100  READ DMA EXT

Error 7 occurred at disk power-on lifetime: 0 hours (0 days + 0 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  10 51 01 9f 45 a5 e0  Error: IDNF 1 sectors at LBA = 0x00a5459f = 10831263

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  25 ff 01 9f 45 a5 e0 00      00:04:06.100  READ DMA EXT
  34 ff 01 00 00 00 e0 00      00:04:04.100  WRITE SECTORS(S) EXT
  25 ff 01 00 00 00 e0 00      00:04:04.100  READ DMA EXT
  25 ff 01 c0 17 fa e0 00      00:04:04.100  READ DMA EXT
  25 ff 01 3f 00 00 e0 00      00:04:04.100  READ DMA EXT

Error 6 occurred at disk power-on lifetime: 0 hours (0 days + 0 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  10 51 01 9f 45 a5 e0  Error: IDNF at LBA = 0x00a5459f = 10831263

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  24 ff 01 9f 45 a5 e0 00      00:04:04.000  READ SECTOR(S) EXT
  25 ff 01 9f 45 a5 e0 00      00:04:04.000  READ DMA EXT
  34 ff 01 00 00 00 e0 00      00:04:02.000  WRITE SECTORS(S) EXT
  35 ff 01 cf 17 fa e0 00      00:04:02.000  WRITE DMA EXT
  35 ff 01 ce 17 fa e0 00      00:04:02.000  WRITE DMA EXT

Error 5 occurred at disk power-on lifetime: 0 hours (0 days + 0 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  10 51 01 9f 45 a5 e0  Error: IDNF 1 sectors at LBA = 0x00a5459f = 10831263

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  25 ff 01 9f 45 a5 e0 00      00:04:04.000  READ DMA EXT
  34 ff 01 00 00 00 e0 00      00:04:02.000  WRITE SECTORS(S) EXT
  35 ff 01 cf 17 fa e0 00      00:04:02.000  WRITE DMA EXT
  35 ff 01 ce 17 fa e0 00      00:04:02.000  WRITE DMA EXT
  35 ff 01 cd 17 fa e0 00      00:04:02.000  WRITE DMA EXT

Error 4 occurred at disk power-on lifetime: 0 hours (0 days + 0 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  10 51 01 9f 45 a5 e0  Error: IDNF at LBA = 0x00a5459f = 10831263

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  24 ff 01 9f 45 a5 e0 00      00:04:01.900  READ SECTOR(S) EXT
  25 ff 01 9f 45 a5 e0 00      00:04:01.800  READ DMA EXT
  34 ff 01 00 00 00 e0 00      00:03:59.900  WRITE SECTORS(S) EXT
  35 ff 01 4e 00 00 e0 00      00:03:59.900  WRITE DMA EXT
  35 ff 01 4d 00 00 e0 00      00:03:59.900  WRITE DMA EXT

SMART Self-test log structure revision number 1
No self-tests have been logged.  [To run self-tests, use: smartctl -t]


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

Also available at:

http://bombadil.infradead.org/~mcgrof/logs/2009/12/smart-ctl-sda2.txt

> It could be also fs related issue that shows up only under specific
> conditions

OK -- I see, I used a fresh new ext3, did not make the jump to ext4.

> (i.e. almost full partition -- some file-systems starts to
> crawl when the amount of available free space gets low).

Got it, thanks, so partition has a lot of room.

mcgrof@tux ~ $ df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda2              91G   43G   44G  50% /

Also ony have one partition.

  Luis
