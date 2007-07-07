Return-Path: <linux-kernel-owner+w=401wt.eu-S1755230AbXGGVgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbXGGVgW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 17:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbXGGVgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 17:36:13 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:48599 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752140AbXGGVgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 17:36:12 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: SATA exceptions
Date: Sun, 8 Jul 2007 00:35:02 +0300
User-Agent: KMail/1.9.7
Cc: Tejun Heo <htejun@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jgarzik@pobox.com>
References: <fa.hBFih6KVHDFsBf6Qfg6XispiIuY@ifi.uio.no> <fa.NhBdOmH9+RkW+QO72+TjPRwEKj0@ifi.uio.no> <468FD5ED.5060401@shaw.ca>
In-Reply-To: <468FD5ED.5060401@shaw.ca>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1299612.9USyLD0uuM";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707080035.05718.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1299612.9USyLD0uuM
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi;

07 Tem 2007 Cts tarihinde, Robert Hancock =C5=9Funlar=C4=B1 yazm=C4=B1=C5=
=9Ft=C4=B1:=20
> It's not the free space on the drive that matters, it's the number of
> free sectors in the spare sector pool on the drive, which is invisible
> to software.
>
> Your SMART log shows 309 reallocated sectors. That seems somewhat high..

Ah sorry to misinterpret the content:), its a quiet new piece of hardware (=
at=20
most ~1.5 month old) and  "Reallocated_Event_Count" constantly increases=20
(currently its increased to 313) and although i'm not 100 percent sure thes=
e=20
errors only occured with kernels > 2.6.18 (or 2.6.18 didn't report these=20
cause according to kern.log these only visible with 2.6.22+)=20

We bought 3 HP Pavillon dv2385ea and one of them only runs with 2.6.18 and =
its=20
smartctl output follows as a reference;

smartctl version 5.37 [i686-pc-linux-gnu] Copyright (C) 2002-6 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Device Model:     SAMSUNG HM160JI
Serial Number:    S0W6J10P331479
=46irmware Version: AD100-16
User Capacity:    160.041.885.696 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   7
ATA Standard is:  ATA/ATAPI-7 T13 1532D revision 0
Local Time is:    Sun Jul  8 00:22:21 2007 EEST

=3D=3D> WARNING: May need -F samsung or -F samsung2 enabled; see manual for=
=20
details.

SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED
See vendor-specific Attribute list for marginal Attributes.

General SMART Values:
Offline data collection status:  (0x00)	Offline data collection activity
					was never started.
					Auto Offline Data Collection: Disabled.
Self-test execution status:      (   0)	The previous self-test routine=20
completed
					without error or no self-test has ever=20
					been run.
Total time to complete Offline=20
data collection: 		 (5391) seconds.
Offline data collection
capabilities: 			 (0x51) SMART execute Offline immediate.
					No Auto Offline data collection support.
					Suspend Offline collection upon new
					command.
					No Offline surface scan supported.
					Self-test supported.
					No Conveyance Self-test supported.
					Selective Self-test supported.
SMART capabilities:            (0x0003)	Saves SMART data before entering
					power-saving mode.
					Supports SMART auto save timer.
Error logging capability:        (0x01)	Error logging supported.
					General Purpose Logging supported.
Short self-test routine=20
recommended polling time: 	 (   2) minutes.
Extended self-test routine
recommended polling time: 	 (  89) minutes.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED =
=20
WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   100   100   051    Pre-fail =20
Always       -       0
  3 Spin_Up_Time            0x0007   253   253   025    Pre-fail =20
Always       -       2880
  4 Start_Stop_Count        0x0032   098   098   000    Old_age  =20
Always       -       2648
  5 Reallocated_Sector_Ct   0x0033   253   253   010    Pre-fail =20
Always       -       0
  7 Seek_Error_Rate         0x000f   253   253   051    Pre-fail =20
Always       -       0
  8 Seek_Time_Performance   0x0025   253   253   015    Pre-fail =20
Offline      -       0
  9 Power_On_Hours          0x0032   253   253   000    Old_age  =20
Always       -       236
 10 Spin_Retry_Count        0x0033   100   100   051    Pre-fail =20
Always       -       1
 11 Calibration_Retry_Count 0x0012   100   100   000    Old_age  =20
Always       -       2
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age  =20
Always       -       57
187 Unknown_Attribute       0x0032   253   253   000    Old_age  =20
Always       -       0
188 Unknown_Attribute       0x0032   253   253   000    Old_age  =20
Always       -       0
190 Temperature_Celsius     0x0022   047   040   040    Old_age   Always  =
=20
In_the_past 1008009269
191 G-Sense_Error_Rate      0x0012   100   100   000    Old_age  =20
Always       -       5396
192 Power-Off_Retract_Count 0x0012   100   100   000    Old_age  =20
Always       -       40
193 Load_Cycle_Count        0x0012   100   100   000    Old_age  =20
Always       -       2575
194 Temperature_Celsius     0x0022   047   040   000    Old_age  =20
Always       -       53 (Lifetime Min/Max 0/15381)
195 Hardware_ECC_Recovered  0x001a   100   100   000    Old_age  =20
Always       -       98037
196 Reallocated_Event_Count 0x0032   253   253   000    Old_age  =20
Always       -       0
197 Current_Pending_Sector  0x0012   253   253   000    Old_age  =20
Always       -       0
198 Offline_Uncorrectable   0x0030   253   253   000    Old_age  =20
Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age  =20
Always       -       0
200 Multi_Zone_Error_Rate   0x000a   100   100   000    Old_age  =20
Always       -       0
201 Soft_Read_Error_Rate    0x0012   253   253   000    Old_age  =20
Always       -       0
223 Load_Retry_Count        0x0012   100   100   000    Old_age  =20
Always       -       2
225 Load_Cycle_Count        0x0012   100   100   000    Old_age  =20
Always       -       2575
255 Unknown_Attribute       0x000a   253   100   000    Old_age  =20
Always       -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
No self-tests have been logged.  [To run self-tests, use: smartctl -t]


SMART Selective Self-Test Log Data Structure Revision Number (0) should be 1
SMART Selective self-test log data structure revision number 0
Warning: ATA Specification requires selective self-test log data structure=
=20
revision number =3D 1
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.

What is your suggestion in that case will i try to change the hardware=20
assuming its harware's fault or that may be regression introduced by kernel=
s=20
newer than 2.6.18?

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart1299612.9USyLD0uuM
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQBGkAcJy7E6i0LKo6YRAiQTAKCwR9cv5VibQHFTaQ77lJpQ/sar8gCfe9of
MgZDWs/WI7rioqnL2NE8ePQ=
=YSmr
-----END PGP SIGNATURE-----

--nextPart1299612.9USyLD0uuM--
