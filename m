Return-Path: <linux-kernel-owner+w=401wt.eu-S1752843AbZBNTOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbZBNTOr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 14:14:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbZBNTOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 14:14:38 -0500
Received: from bay0-omc3-s29.bay0.hotmail.com ([65.54.246.229]:49168 "EHLO
	bay0-omc3-s29.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751628AbZBNTOh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 14:14:37 -0500
Message-ID: <BAY108-W33A90CE987FE494CAA66779DB90@phx.gbl>
X-Originating-IP: [83.226.134.188]
From: Richard Jonsson <richard_jonsson@hotmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: Unable to write dvd+r on 3 systems
Date: Sat, 14 Feb 2009 20:14:37 +0100
Importance: Normal
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 14 Feb 2009 19:14:37.0418 (UTC) FILETIME=[7A6354A0:01C98ED8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Resend due to crappy formatting, sorry about that!

It seems I am the last person on earth burning dvd's. I have tried on
three different systems, using a mix of growisofs, xfburn, brasero and
k3b. They all give the same result for their respective system.

On system 1 it takes forever to complete the process. The system is
completely useless while burning. IO wait is 50% and hardIRQ is
10-20%. If audio is playing at the same time it stutters in a way that
it sounds as it's playing slow. Mouse cursor jerks and it takes eons
to even open a new terminal.

On system 2 growisofs will try for half a minute and then fail with a
message in dmesg. The disc isn't even touched. Tried homebuilt
kernel.org kernels from 2.6.25 to current git with no difference. See
attachment "growisofs_system2.txt". I have been able to burn exactly 1
disc in total, which magically started recording immediately.

System 3 burns at decent speed and always reports success, but about
half the time only part of the disc is actually burned. It is visible
to the eye, and it will not work. Tried at 4x too.

I tried to compile older kernels, 2.6.24 wouldn't boot, and older
kernels would not compile on these systems.

                System 1         System 2         System 3
System/mainb.   HP DV2140eu      Advent (noname)  Abit NF7-S
Processor       Turion TL52-X2   Celeron M420     Athlon 2400+
RAM             2GB              512MB            1GB
DVD-burner      HL-DT-ST DVDRAM  Slimtype DVDRW   Plextor 8x
                GMA-4082N hq04   SOSW-833S vs04  
OS              Ubuntu 8.10      U 8.10 server    U 8.10 server
                64bit            32bit            32bit
software        all above        growisofs        growisofs, xfburn

I have at this time only tried one make of media (TDK 16x dvd+r):
dvd+rw-mediainfo /dev/dvd
INQUIRY:                [HL-DT-ST][DVDRAM GMA-4082N][HQ04]
GET [CURRENT] CONFIGURATION:
 Mounted Media:         1Bh, DVD+R
 Current Write Speed:   8.0x1385=11080KB/s
 Write Speed #0:        8.0x1385=11080KB/s
 Write Speed #1:        4.0x1385=5540KB/s
GET [CURRENT] PERFORMANCE:
 Write Performance:     3.3x1385=4584KB/s@0 -> 8.0x1385=11092KB/s@2299967
 Speed Descriptor#0:    02/2295103 R@3.3x1385=4584KB/s W@8.0x1385=11080KB/s
 Speed Descriptor#1:    02/2295103 R@3.3x1385=4584KB/s W@4.0x1385=5540KB/s
READ DVD STRUCTURE[#0h]:
 Media Book Type:       00h, DVD-ROM book [revision 0]
 Media ID:              TDK/003
 Legacy lead-out at:    2295104*2KB=4700372992
READ DISC INFORMATION:
 Disc status:           blank
 Number of Sessions:    1
 State of Last Session: empty
 "Next" Track:          1
 Number of Tracks:      1
READ TRACK INFORMATION[#1]:
 Track State:           blank
 Track Start Address:   0*2KB
 Next Writable Address: 0*2KB
 Free Blocks:           2295104*2KB
 Track Size:            2295104*2KB
READ CAPACITY:          0*2048=0

Please cc me as I'm not subscribed, and thanks in advance / Richard

_________________________________________________________________
25 GB gratis lagring på nätet - Skaffa SkyDrive nu! 
http://skydrive.live.com 