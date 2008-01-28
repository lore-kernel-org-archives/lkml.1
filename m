Return-Path: <linux-kernel-owner+w=401wt.eu-S1753170AbYA1R4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbYA1R4w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 12:56:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbYA1R4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 12:56:44 -0500
Received: from vms040pub.verizon.net ([206.46.252.40]:42137 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbYA1R4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 12:56:42 -0500
Date: Mon, 28 Jan 2008 12:44:10 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Problem with ata layer in 2.6.24
In-reply-to: <200801281230.32910.gene.heskett@gmail.com>
To: Zan Lynx <zlynx@acm.org>
Cc: Calvin Walton <calvin.walton@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux ide Mailing list <linux-ide@vger.kernel.org>
Message-id: <200801281244.10662.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: Multipart/Mixed; boundary="Boundary-00=_qRhnHJ7DNdHgYxp"
References: <200801272122.21823.gene.heskett@gmail.com>
 <1201540830.6526.19.camel@localhost>
 <200801281230.32910.gene.heskett@gmail.com>
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_qRhnHJ7DNdHgYxp
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 28 January 2008, Gene Heskett wrote:
>On Monday 28 January 2008, Zan Lynx wrote:
>>On Mon, 2008-01-28 at 11:50 -0500, Calvin Walton wrote:
>>> On Mon, 2008-01-28 at 11:35 -0500, Gene Heskett wrote:
>>> > On Monday 28 January 2008, Mikael Pettersson wrote:
>>> > >Unfortunately we also see:
>>> > > > [   48.285456] nvidia: module license 'NVIDIA' taints kernel.
>>> > > > [   48.549725] ACPI: PCI Interrupt 0000:02:00.0[A] -> Link [APC4]
>>> > > > -> GSI 19 (level, high) -> IRQ 20 [   48.550149] NVRM: loading
>>> > > > NVIDIA UNIX x86 Kernel Module  169.07  Thu Dec 13 18:42:56 PST 2007
>>> > >
>>> > >We have no way of debugging that module, so please try 2.6.24 without
>>> > > it.
>>> >
>>> > Sorry, I can't do this and have a working machine.  The nv driver has
>>> > suffered bit rot or something since the FC2 days when it COULD run a
>>> > 19" crt at 1600x1200, and will not drive this 20" wide screen lcd
>>> > 1680x1050 monitor at more than 800x600, which is absolutely butt ugly
>>> > fuzzy, looking like a jpg compressed to 10%.  The system is not usable
>>> > on a day to basis without the nvidia driver.
>>>
>>> You should probably give the nouveau[1] driver a try, if only for
>>> testing purposes; if you are running an NV4x (G6x or G7x) card in
>>> particular, it works a lot better than the nv driver for 2d support.
>>>
>>> 1. http://nouveau.freedesktop.org/wiki/InstallNouveau
>>
>>But nouveau is much less stable than nv.  For testing purposes, go with
>>stable.
>
>I believe at this point, its moot.  I captured quite a few instances of that
>error message while rebooting the last time, all of which occurred long
>before I logged in and did a startx (I boot to runlevel 3 here), so the
>kernel was NOT tainted at that point.  That dmesg has been posted and some
>questions asked.
>
>As this has gone on for a while, it seems to me that with 14,800 google hits
>on this problem, Linus should call a halt until this is found and fixed. 
> But I'm not Linus.  I'm also locking up for 30 at a time, & probably ready
> for reboot #7 today.
>
>>I'm not sure why it won't run his screen though.  I can use nv to run a
>>1920x1200 laptop LCD.  It *is* dog slow (although nouveau was not any
>>better with a NV17 / 440-Go -- render support for AA fonts seems to be
>>missing), but it does work.

I've been trying to run a long selftest on that drive, but the constant 
reboots are fscking that up.  I have attached the last smartctl -a output, 
indicating that the test was aborted probably from all the resets that are 
being issued, the last one froze me for around 5 minutes but I haven't 
rebooted yet.  Its attached.  Can anyone see if there is actually anything 
wrong with the drive?  If a boot will last long enough for the -t long to 
complete, then it passes with no errors, but this was interrupted now for the 
3rd time.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Well begun is half done.
		-- Aristotle

--Boundary-00=_qRhnHJ7DNdHgYxp
Content-Type: text/x-log;
  charset="utf-8";
  name="smart.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="smart.log"

smartctl version 5.37 [i386-redhat-linux-gnu] Copyright (C) 2002-6 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Caviar SE family
Device Model:     WDC WD2000JB-00EVA0
Serial Number:    WD-WMAEH2782398
Firmware Version: 15.05R15
User Capacity:    200,049,647,616 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   6
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Mon Jan 28 12:39:08 2008 EST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x85)	Offline data collection activity
					was aborted by an interrupting command from host.
					Auto Offline Data Collection: Enabled.
Self-test execution status:      ( 249)	Self-test routine in progress...
					90% of test remaining.
Total time to complete Offline 
data collection: 		 (6942) seconds.
Offline data collection
capabilities: 			 (0x79) SMART execute Offline immediate.
					No Auto Offline data collection support.
					Suspend Offline collection upon new
					command.
					Offline surface scan supported.
					Self-test supported.
					Conveyance Self-test supported.
					Selective Self-test supported.
SMART capabilities:            (0x0003)	Saves SMART data before entering
					power-saving mode.
					Supports SMART auto save timer.
Error logging capability:        (0x01)	Error logging supported.
					No General Purpose Logging support.
Short self-test routine 
recommended polling time: 	 (   2) minutes.
Extended self-test routine
recommended polling time: 	 (  88) minutes.
Conveyance self-test routine
recommended polling time: 	 (   5) minutes.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000b   194   194   051    Pre-fail  Always       -       12
  3 Spin_Up_Time            0x0007   180   124   021    Pre-fail  Always       -       1500
  4 Start_Stop_Count        0x0032   100   100   040    Old_age   Always       -       182
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x000b   200   200   051    Pre-fail  Always       -       0
  9 Power_On_Hours          0x0032   062   062   000    Old_age   Always       -       27779
 10 Spin_Retry_Count        0x0013   100   100   051    Pre-fail  Always       -       0
 11 Calibration_Retry_Count 0x0013   100   100   051    Pre-fail  Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       178
194 Temperature_Celsius     0x0022   120   253   000    Old_age   Always       -       30
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always       -       0
197 Current_Pending_Sector  0x0012   200   200   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0012   200   200   000    Old_age   Always       -       0
199 UDMA_CRC_Error_Count    0x000a   200   253   000    Old_age   Always       -       0
200 Multi_Zone_Error_Rate   0x0009   200   155   051    Pre-fail  Offline      -       0

SMART Error Log Version: 1
ATA Error Count: 12 (device log contains only the most recent five errors)
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

Error 12 occurred at disk power-on lifetime: 472 hours (19 days + 16 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 58 8b 3d 07 e0  Error: 

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  00 00 c8 00 00 58 00 00      00:03:35.550  NOP [Abort queued commands]
  00 00 00 00 00 00 00 00      00:03:35.550  NOP [Abort queued commands]
  00 00 ef 00 00 45 00 00      00:03:35.550  NOP [Abort queued commands]
  00 00 27 00 00 00 00 00      00:03:35.550  NOP [Abort queued commands]
  00 00 07 00 00 89 3d 00      00:03:35.550  NOP [Abort queued commands]

Error 11 occurred at disk power-on lifetime: 472 hours (19 days + 16 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 58 8b 3d 07 e0  Error: 

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  00 00 c8 00 00 58 00 00      00:03:33.500  NOP [Abort queued commands]
  00 00 00 00 00 00 00 00      00:03:33.500  NOP [Abort queued commands]
  00 00 ef 00 00 45 00 00      00:03:33.500  NOP [Abort queued commands]
  00 00 00 00 00 00 00 00      00:03:33.500  NOP [Abort queued commands]
  00 00 c8 00 00 58 00 00      00:03:33.500  NOP [Abort queued commands]

Error 10 occurred at disk power-on lifetime: 472 hours (19 days + 16 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 58 8b 3d 07 e0  Error: 

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  00 00 c8 00 00 58 00 00      00:03:31.400  NOP [Abort queued commands]
  00 00 ec 00 00 00 00 00      00:03:31.400  NOP [Abort queued commands]
  00 00 00 00 00 00 00 00      00:03:31.400  NOP [Abort queued commands]
  00 00 ec 00 00 00 00 00      00:03:31.400  NOP [Abort queued commands]
  00 00 00 00 00 00 00 00      00:03:31.400  NOP [Abort queued commands]

Error 9 occurred at disk power-on lifetime: 472 hours (19 days + 16 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 58 8b 3d 07 e0  Error: 

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  00 00 c8 00 00 58 00 00      00:03:29.350  NOP [Abort queued commands]
  00 00 00 00 00 00 00 00      00:03:29.350  NOP [Abort queued commands]
  00 00 ef 00 00 45 00 00      00:03:29.350  NOP [Abort queued commands]
  00 00 00 00 00 00 00 00      00:03:29.350  NOP [Abort queued commands]
  00 00 c8 00 00 58 00 00      00:03:29.350  NOP [Abort queued commands]

Error 8 occurred at disk power-on lifetime: 472 hours (19 days + 16 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 58 8b 3d 07 e0  Error: 

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  00 00 c8 00 00 58 00 00      00:03:27.150  NOP [Abort queued commands]
  00 00 00 00 00 00 00 00      00:03:27.150  NOP [Abort queued commands]
  00 00 ef 00 00 45 00 00      00:03:27.150  NOP [Abort queued commands]
  00 00 00 00 00 00 00 00      00:03:27.150  NOP [Abort queued commands]
  00 00 c8 00 00 58 00 00      00:03:27.150  NOP [Abort queued commands]

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%       460         -
# 2  Extended offline    Completed without error       00%       452         -

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


--Boundary-00=_qRhnHJ7DNdHgYxp--
