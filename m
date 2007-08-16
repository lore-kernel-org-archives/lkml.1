Return-Path: <linux-kernel-owner+w=401wt.eu-S1765532AbXHPQBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765532AbXHPQBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 12:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760943AbXHPQBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 12:01:33 -0400
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:49970 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760301AbXHPQBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 12:01:31 -0400
Date: Thu, 16 Aug 2007 18:01:19 +0200
From: Andreas Radke <a.radke@arcor.de>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Jeff Garzik <jgarzik@pobox.com>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: sata drive loosing connection/resetting port
Message-ID: <20070816180119.2bb60360@workstation64.home>
In-Reply-To: <46C42CAF.4040709@gmail.com>
References: <20070813220241.3f4b8df5@workstation64.home>
	<6bffcb0e0708131311k51238bb0l63eeb2fce53e3481@mail.gmail.com>
	<46C180D8.9060005@gmail.com>
	<20070814221928.243949b6@workstation64.home>
	<46C29AE8.5070903@gmail.com>
	<20070815154846.28b6b462@workstation64.home>
	<46C42CAF.4040709@gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Thu, 16 Aug 2007 19:53:35 +0900
schrieb Tejun Heo <htejun@gmail.com>:

> I don't think this is driver issue.  I have the same controller and
> I've never seen similar thing happening and I have plenty of drives
> and test them often.  Error reports also point to transmission
> problems.  Your drive just doesn't like what it's hearing.  Does
> 'smartctl -a /dev/sda' tell anything special?

 
[root@workstation64 andyrtr]# smartctl -a /dev/sda
smartctl version 5.37 [x86_64-unknown-linux-gnu] Copyright (C) 2002-6
Bruce Allen Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Raptor family
Device Model:     WDC WD740ADFD-00NLR1
Serial Number:    WD-WMANS1463684
Firmware Version: 20.07P20
User Capacity:    74.355.769.344 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   7
ATA Standard is:  ATA/ATAPI-7 published, ANSI INCITS 397-2005
Local Time is:    Thu Aug 16 17:53:18 2007 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x84) Offline data collection activity
                                        was suspended by an interrupting command from host.
                                        Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0) The previous self-test routine completed
                                        without error or no self-test has ever 
                                        been run.
Total time to complete Offline 
data collection:                 (2391) seconds.
Offline data collection
capabilities:                    (0x7b) SMART execute Offline immediate.
                                        Auto Offline data collection on/off support.
                                        Suspend Offline collection upon new
                                        command.
                                        Offline surface scan supported.
                                        Self-test supported.
                                        Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging supported.
Short self-test routine 
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        (  39) minutes.
Conveyance self-test routine
recommended polling time:        (   5) minutes.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000b   200   200   051    Pre-fail  Always       -       0
  3 Spin_Up_Time            0x0007   167   166   021    Pre-fail  Always       -       2650
  4 Start_Stop_Count        0x0032   100   100   040    Old_age   Always       -       149
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x000a   200   200   051    Old_age   Always       -       0
  9 Power_On_Hours          0x0032   092   092   000    Old_age   Always       -       5890
 10 Spin_Retry_Count        0x0012   100   100   051    Old_age   Always       -       0
 11 Calibration_Retry_Count 0x0012   100   100   051    Old_age   Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       149
194 Temperature_Celsius     0x0022   111   104   000    Old_age   Always       -       32
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always       -       0
197 Current_Pending_Sector  0x0012   200   200   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0012   200   200   000    Old_age   Always       -       0
199 UDMA_CRC_Error_Count    0x000a   200   253   000    Old_age   Always       -       2074
200 Multi_Zone_Error_Rate   0x0008   200   200   051    Old_age   Offline      -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Conveyance offline  Completed without error       00%      5855         -
# 2  Short offline       Completed without error       00%      5854         -
# 3  Short offline       Completed without error       00%      5826         -
# 4  Short offline       Completed without error       00%         0         -

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


i have already filed a support request to Western Digital. but i doubt they will know this certain issue
and won't have a fixed firmware for me.

in AHCI mode this error makes the system freeze completly after a few hours without further
log entries. in IDE mode it keeps working the bad way without making the system freeze.

anyway no more time to risk a broken filesystem. i'll change my setup. but if you have an
idea how to fix it or want me to test something just drop me a mail. thanks so far.

Andreas
