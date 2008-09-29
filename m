Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbYI2Lsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbYI2Lsx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 07:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbYI2Lsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 07:48:45 -0400
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:36314 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbYI2Lso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 07:48:44 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Sep 2008 07:48:44 EDT
Date: Mon, 29 Sep 2008 07:41:59 -0400
Message-Id: <200809291141.m8TBfxiU004269@dsl092-065-009.bos1.dsl.speakeasy.net>
From: Robert Krawitz <rlk@alum.mit.edu>
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
In-reply-to: <48E0824B.4010408@kernel.org> (tj@kernel.org)
Subject: Re: Another one for fixup-storage
References: <4897809E.8070902@alum.mit.edu> <48E0824B.4010408@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   Date: Mon, 29 Sep 2008 16:22:51 +0900
   From: Tejun Heo <tj@kernel.org>

   Robert Krawitz wrote:
   > This is for a Dell Inspiron E1705/9400.  I'm using a non-OEM disk (a
   > Hitachi 320 GB drive).
   > 
   > Note that matching on "MP061" doesn't work -- it needs to be "MP061*"
   > due to the way dmidecode seems to return the data (with a bunch of
   > spaces after the tag).  Hence I've attached the data rather than merely
   > 
   > I've only had this thing a month or so and already had over 70,000
   > unload cycles.  Ick.

   Can you please attach the result of "smartctl -a" output?

# smartctl -a /dev/sda
smartctl 5.39 2008-05-08 21:56 [x86_64-unknown-linux-gnu] (local build)
Copyright (C) 2002-8 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Device Model:     Hitachi HTS543232L9A300
Serial Number:    080403FB0400LEG0YVBA
Firmware Version: FB4OC40C
User Capacity:    320,072,933,376 bytes
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 3f
Local Time is:    Mon Sep 29 07:41:26 2008 EDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00) Offline data collection activity
                                        was never started.
                                        Auto Offline Data Collection: Disabled.
Self-test execution status:      (   0) The previous self-test routine completed
                                        without error or no self-test has ever 
                                        been run.
Total time to complete Offline 
data collection:                 ( 645) seconds.
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
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        ( 127) minutes.
SCT capabilities:              (0x003d) SCT Status supported.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000b   100   100   062    Pre-fail  Always       -       0
  2 Throughput_Performance  0x0005   100   100   040    Pre-fail  Offline      -       0
  3 Spin_Up_Time            0x0007   253   253   033    Pre-fail  Always       -       0
  4 Start_Stop_Count        0x0012   100   100   000    Old_age   Always       -       159
  5 Reallocated_Sector_Ct   0x0033   100   100   005    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x000b   100   100   067    Pre-fail  Always       -       0
  8 Seek_Time_Performance   0x0005   100   100   040    Pre-fail  Offline      -       0
  9 Power_On_Hours          0x0012   096   096   000    Old_age   Always       -       2186
 10 Spin_Retry_Count        0x0013   100   100   060    Pre-fail  Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       159
191 G-Sense_Error_Rate      0x000a   096   096   000    Old_age   Always       -       131078
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Always       -       4
193 Load_Cycle_Count        0x0012   093   093   000    Old_age   Always       -       72090
194 Temperature_Celsius     0x0002   130   130   000    Old_age   Always       -       42 (Lifetime Min/Max 20/47)
196 Reallocated_Event_Count 0x0032   100   100   000    Old_age   Always       -       0
197 Current_Pending_Sector  0x0022   100   100   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0008   100   100   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x000a   200   200   000    Old_age   Always       -       0
223 Load_Retry_Count        0x000a   100   100   000    Old_age   Always       -       0

SMART Error Log Version: 1
No Errors Logged

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

-- 
Robert Krawitz                                     <rlk@alum.mit.edu>

Tall Clubs International  --  http://www.tall.org/ or 1-888-IM-TALL-2
Member of the League for Programming Freedom -- mail lpf@uunet.uu.net
Project lead for Gutenprint   --    http://gimp-print.sourceforge.net

"Linux doesn't dictate how I work, I dictate how Linux works."
--Eric Crampton
