Return-Path: <linux-kernel-owner+w=401wt.eu-S1758228AbZBTRCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228AbZBTRCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:02:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbZBTRCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:02:36 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:41709 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753983AbZBTRCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:02:35 -0500
Date: Fri, 20 Feb 2009 12:02:34 -0500
To: Richard Jonsson <richard_jonsson@hotmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Unable to write dvd+r on 3 systems
Message-ID: <20090220170234.GA7314@csclub.uwaterloo.ca>
References: <BAY108-W33A90CE987FE494CAA66779DB90@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAY108-W33A90CE987FE494CAA66779DB90@phx.gbl>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 14, 2009 at 08:14:37PM +0100, Richard Jonsson wrote:
> 
> Resend due to crappy formatting, sorry about that!
> 
> It seems I am the last person on earth burning dvd's. I have tried on
> three different systems, using a mix of growisofs, xfburn, brasero and
> k3b. They all give the same result for their respective system.
> 
> On system 1 it takes forever to complete the process. The system is
> completely useless while burning. IO wait is 50% and hardIRQ is
> 10-20%. If audio is playing at the same time it stutters in a way that
> it sounds as it's playing slow. Mouse cursor jerks and it takes eons
> to even open a new terminal.
> 
> On system 2 growisofs will try for half a minute and then fail with a
> message in dmesg. The disc isn't even touched. Tried homebuilt
> kernel.org kernels from 2.6.25 to current git with no difference. See
> attachment "growisofs_system2.txt". I have been able to burn exactly 1
> disc in total, which magically started recording immediately.
> 
> System 3 burns at decent speed and always reports success, but about
> half the time only part of the disc is actually burned. It is visible
> to the eye, and it will not work. Tried at 4x too.
> 
> I tried to compile older kernels, 2.6.24 wouldn't boot, and older
> kernels would not compile on these systems.
> 
>                 System 1         System 2         System 3
> System/mainb.   HP DV2140eu      Advent (noname)  Abit NF7-S
> Processor       Turion TL52-X2   Celeron M420     Athlon 2400+
> RAM             2GB              512MB            1GB
> DVD-burner      HL-DT-ST DVDRAM  Slimtype DVDRW   Plextor 8x
>                 GMA-4082N hq04   SOSW-833S vs04  
> OS              Ubuntu 8.10      U 8.10 server    U 8.10 server
>                 64bit            32bit            32bit
> software        all above        growisofs        growisofs, xfburn
> 
> I have at this time only tried one make of media (TDK 16x dvd+r):
> dvd+rw-mediainfo /dev/dvd
> INQUIRY:                [HL-DT-ST][DVDRAM GMA-4082N][HQ04]
> GET [CURRENT] CONFIGURATION:
>  Mounted Media:         1Bh, DVD+R
>  Current Write Speed:   8.0x1385=11080KB/s
>  Write Speed #0:        8.0x1385=11080KB/s
>  Write Speed #1:        4.0x1385=5540KB/s
> GET [CURRENT] PERFORMANCE:
>  Write Performance:     3.3x1385=4584KB/s@0 -> 8.0x1385=11092KB/s@2299967
>  Speed Descriptor#0:    02/2295103 R@3.3x1385=4584KB/s W@8.0x1385=11080KB/s
>  Speed Descriptor#1:    02/2295103 R@3.3x1385=4584KB/s W@4.0x1385=5540KB/s
> READ DVD STRUCTURE[#0h]:
>  Media Book Type:       00h, DVD-ROM book [revision 0]
>  Media ID:              TDK/003
>  Legacy lead-out at:    2295104*2KB=4700372992
> READ DISC INFORMATION:
>  Disc status:           blank
>  Number of Sessions:    1
>  State of Last Session: empty
>  "Next" Track:          1
>  Number of Tracks:      1
> READ TRACK INFORMATION[#1]:
>  Track State:           blank
>  Track Start Address:   0*2KB
>  Next Writable Address: 0*2KB
>  Free Blocks:           2295104*2KB
>  Track Size:            2295104*2KB
> READ CAPACITY:          0*2048=0
> 
> Please cc me as I'm not subscribed, and thanks in advance / Richard

Is anything stupid like gnome volume manager or hal or something regularly
poking at the drive to detect discs?

Are you using 80conductor IDE cables (for those drives that are IDE)?
I have had some DVD writers fail in odd ways when using 40conductor
cables.

-- 
Len Sorensen
