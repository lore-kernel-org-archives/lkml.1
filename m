Return-Path: <linux-kernel-owner+w=401wt.eu-S932750AbXGKUbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750AbXGKUbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 16:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545AbXGKUb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 16:31:26 -0400
Received: from rtr.ca ([64.26.128.89]:3602 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755435AbXGKUbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 16:31:25 -0400
Message-ID: <46953E1B.1090306@rtr.ca>
Date: Wed, 11 Jul 2007 16:31:23 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: caglar@pardus.org.tr
Cc: Robert Hancock <hancockr@shaw.ca>, Tejun Heo <htejun@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>
Subject: Re: SATA exceptions
References: <fa.hBFih6KVHDFsBf6Qfg6XispiIuY@ifi.uio.no> <fa.NhBdOmH9+RkW+QO72+TjPRwEKj0@ifi.uio.no> <468FD5ED.5060401@shaw.ca> <200707080035.05718.caglar@pardus.org.tr>
In-Reply-To: <200707080035.05718.caglar@pardus.org.tr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

S.�ag(lar Onur wrote:
> Hi;
> 
> 07 Tem 2007 Cts tarihinde, Robert Hancock şunları yazmıştı: 
>> It's not the free space on the drive that matters, it's the number of
>> free sectors in the spare sector pool on the drive, which is invisible
>> to software.
>>
>> Your SMART log shows 309 reallocated sectors. That seems somewhat high..
> 
> Ah sorry to misinterpret the content:), its a quiet new piece of hardware (at 
> most ~1.5 month old) and  "Reallocated_Event_Count" constantly increases 
> (currently its increased to 313) and although i'm not 100 percent sure these 
> errors only occured with kernels > 2.6.18 (or 2.6.18 didn't report these 
> cause according to kern.log these only visible with 2.6.22+) 
> 
> We bought 3 HP Pavillon dv2385ea and one of them only runs with 2.6.18 and its 
> smartctl output follows as a reference;
> 
> smartctl version 5.37 [i686-pc-linux-gnu] Copyright (C) 2002-6 Bruce Allen
> Home page is http://smartmontools.sourceforge.net/
> 
> === START OF INFORMATION SECTION ===
> Device Model:     SAMSUNG HM160JI
> Serial Number:    S0W6J10P331479
> Firmware Version: AD100-16
> User Capacity:    160.041.885.696 bytes
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   7
> ATA Standard is:  ATA/ATAPI-7 T13 1532D revision 0
> Local Time is:    Sun Jul  8 00:22:21 2007 EEST
> 
> ==> WARNING: May need -F samsung or -F samsung2 enabled; see manual for 
> details.
> 
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
> 
> === START OF READ SMART DATA SECTION ===
> SMART overall-health self-assessment test result: PASSED
> See vendor-specific Attribute list for marginal Attributes.
> 
> General SMART Values:
> Offline data collection status:  (0x00)	Offline data collection activity
> 					was never started.
> 					Auto Offline Data Collection: Disabled.
> Self-test execution status:      (   0)	The previous self-test routine 
> completed
> 					without error or no self-test has ever 
> 					been run.
> Total time to complete Offline 
> data collection: 		 (5391) seconds.
> Offline data collection
> capabilities: 			 (0x51) SMART execute Offline immediate.
> 					No Auto Offline data collection support.
> 					Suspend Offline collection upon new
> 					command.
> 					No Offline surface scan supported.
> 					Self-test supported.
> 					No Conveyance Self-test supported.
> 					Selective Self-test supported.
> SMART capabilities:            (0x0003)	Saves SMART data before entering
> 					power-saving mode.
> 					Supports SMART auto save timer.
> Error logging capability:        (0x01)	Error logging supported.
> 					General Purpose Logging supported.
> Short self-test routine 
> recommended polling time: 	 (   2) minutes.
> Extended self-test routine
> recommended polling time: 	 (  89) minutes.
> 
> SMART Attributes Data Structure revision number: 16
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  
> WHEN_FAILED RAW_VALUE
>   1 Raw_Read_Error_Rate     0x000f   100   100   051    Pre-fail  
> Always       -       0
>   3 Spin_Up_Time            0x0007   253   253   025    Pre-fail  
> Always       -       2880
>   4 Start_Stop_Count        0x0032   098   098   000    Old_age   
> Always       -       2648
>   5 Reallocated_Sector_Ct   0x0033   253   253   010    Pre-fail  
> Always       -       0
>   7 Seek_Error_Rate         0x000f   253   253   051    Pre-fail  
> Always       -       0
>   8 Seek_Time_Performance   0x0025   253   253   015    Pre-fail  
> Offline      -       0
>   9 Power_On_Hours          0x0032   253   253   000    Old_age   
> Always       -       236
>  10 Spin_Retry_Count        0x0033   100   100   051    Pre-fail  
> Always       -       1
>  11 Calibration_Retry_Count 0x0012   100   100   000    Old_age   
> Always       -       2
>  12 Power_Cycle_Count       0x0032   100   100   000    Old_age   
> Always       -       57
> 187 Unknown_Attribute       0x0032   253   253   000    Old_age   
> Always       -       0
> 188 Unknown_Attribute       0x0032   253   253   000    Old_age   
> Always       -       0
> 190 Temperature_Celsius     0x0022   047   040   040    Old_age   Always   
> In_the_past 1008009269
> 191 G-Sense_Error_Rate      0x0012   100   100   000    Old_age   
> Always       -       5396
> 192 Power-Off_Retract_Count 0x0012   100   100   000    Old_age   
> Always       -       40
> 193 Load_Cycle_Count        0x0012   100   100   000    Old_age   
> Always       -       2575
> 194 Temperature_Celsius     0x0022   047   040   000    Old_age   
> Always       -       53 (Lifetime Min/Max 0/15381)
> 195 Hardware_ECC_Recovered  0x001a   100   100   000    Old_age   
> Always       -       98037
> 196 Reallocated_Event_Count 0x0032   253   253   000    Old_age   
> Always       -       0
> 197 Current_Pending_Sector  0x0012   253   253   000    Old_age   
> Always       -       0
> 198 Offline_Uncorrectable   0x0030   253   253   000    Old_age   
> Offline      -       0
> 199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   
> Always       -       0
> 200 Multi_Zone_Error_Rate   0x000a   100   100   000    Old_age   
> Always       -       0
> 201 Soft_Read_Error_Rate    0x0012   253   253   000    Old_age   
> Always       -       0
> 223 Load_Retry_Count        0x0012   100   100   000    Old_age   
> Always       -       2
> 225 Load_Cycle_Count        0x0012   100   100   000    Old_age   
> Always       -       2575
> 255 Unknown_Attribute       0x000a   253   100   000    Old_age   
> Always       -       0
..

I'm not even sure how to interpret those numbers.
It seems rather odd that nearly all fields are either "100" or "253",
so those are probably pre-programmed numbers rather than actual counts.
The raw value at the end of the line (for the various "Reallocated*" fields)
is probably the real value here.

Tejun ??
