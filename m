Return-Path: <linux-kernel-owner+w=401wt.eu-S1753033AbXBJImw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033AbXBJImw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 03:42:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbXBJImv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 03:42:51 -0500
Received: from moutng.kundenserver.de ([212.227.126.179]:54060 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbXBJImu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 03:42:50 -0500
From: Emmeran Seehuber <rototor@rototor.de>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: 2.6.18.2: sporadic SATA port resets (Broadcom BCM5785 (HT1000))
Date: Sat, 10 Feb 2007 09:42:45 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <200702071817.17006.rototor@rototor.de> <200702091809.19418.rototor@rototor.de> <45CD6AE2.4040409@gmail.com>
In-Reply-To: <45CD6AE2.4040409@gmail.com>
X-Face: r$Dk&6(PFBkz"O(d4nE<ZXvpygmFFB%`/+1FHeQCFD|K1tY#:C3t"=?utf-8?q?wW2zb=27QD=3FYWE=26liV=5E=0A=09h!=26-=7C=5DT=2E=5BRlcZ=7DN=7E4A0z?=
 =?utf-8?q?4syfMw=5E=26gH=24M?=,fWc+P@GWh1Ja)'J5]In}-=d<
 =?utf-8?q?tj=3A+oV-=23*D=27Bi=0A=094DR=5DF=7CEZH=5EjC/O?=)(Oe<Fc+`f}2^M14u<gK_mw4_wF$xn"~bF!BKsdTiaMs)"
 =?utf-8?q?=3D=5DxT8aC=5FS=3D=0A=09RA=3ATsO?="hfoHvOa%8'u0/6RLTL=-}>=S;uWHI5DiU)YUUnED+B784<x\2*,VR^E>
 =?utf-8?q?3=5Bz=7CIJ=7B=0A=09ftYrhFwU1=26?=<.=`'*vh@
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_FWYzFHzNwXotJeG"
Message-Id: <200702100942.45694.rototor@rototor.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:d84d732d8ddd2281dac05c143a411240
X-Provags-ID2: V01U2FsdGVkX1+zLanT7OxmPMXpOCDn60yWBkiJ2pIgf2w2DALjzexyGBkXAKzovYKfGpOK8uKVG2OdgDDAVN9KrcDZd1jAyF622RpC9e1Zan3MRAiAF5SM9w==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_FWYzFHzNwXotJeG
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Saturday 10 February 2007 schrieb Tejun Heo:
> Hmmm... Raptor not supporting SMART. =A0That's weird. =A0Please try
> 'smartctl -d ata -a /dev/sda'.

The output is attached.

cu,
  Emmy

--Boundary-00=_FWYzFHzNwXotJeG
Content-Type: text/plain;
  charset="iso-8859-1";
  name="smartctl.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="smartctl.txt"

smartctl version 5.36 [x86_64-unknown-linux-gnu] Copyright (C) 2002-6 Bruce=
 Allen
Home page is http://smartmontools.sourceforge.net/

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Device Model:     WDC WD1500ADFD-00NLR1
Serial Number:    WD-WMAP41246348
=46irmware Version: 20.07P20
User Capacity:    150.039.945.216 bytes
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   7
ATA Standard is:  Not recognized. Minor revision code: 0x1d
Local Time is:    Sat Feb 10 09:31:27 2007 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x84)	Offline data collection activity
					was suspended by an interrupting command from host.
					Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)	The previous self-test routine comp=
leted
					without error or no self-test has ever=20
					been run.
Total time to complete Offline=20
data collection: 		 (4783) seconds.
Offline data collection
capabilities: 			 (0x7b) SMART execute Offline immediate.
					Auto Offline data collection on/off support.
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
					General Purpose Logging supported.
Short self-test routine=20
recommended polling time: 	 (   2) minutes.
Extended self-test routine
recommended polling time: 	 (  72) minutes.
Conveyance self-test routine
recommended polling time: 	 (   5) minutes.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  =
WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000b   200   200   051    Pre-fail  Always   =
    -       0
  3 Spin_Up_Time            0x0007   170   170   021    Pre-fail  Always   =
    -       4533
  4 Start_Stop_Count        0x0032   100   100   040    Old_age   Always   =
    -       59
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always   =
    -       0
  7 Seek_Error_Rate         0x000a   200   200   051    Old_age   Always   =
    -       0
  9 Power_On_Hours          0x0032   097   097   000    Old_age   Always   =
    -       2232
 10 Spin_Retry_Count        0x0012   100   253   051    Old_age   Always   =
    -       0
 11 Calibration_Retry_Count 0x0012   100   253   051    Old_age   Always   =
    -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always   =
    -       59
194 Temperature_Celsius     0x0022   118   116   000    Old_age   Always   =
    -       29
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always   =
    -       0
197 Current_Pending_Sector  0x0012   200   200   000    Old_age   Always   =
    -       0
198 Offline_Uncorrectable   0x0012   200   200   000    Old_age   Always   =
    -       0
199 UDMA_CRC_Error_Count    0x000a   200   253   000    Old_age   Always   =
    -       5
200 Multi_Zone_Error_Rate   0x0008   200   200   051    Old_age   Offline  =
    -       0

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


--Boundary-00=_FWYzFHzNwXotJeG--
