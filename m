Return-Path: <linux-kernel-owner+w=401wt.eu-S1751223AbXBMJZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751223AbXBMJZU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 04:25:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751218AbXBMJZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 04:25:20 -0500
Received: from mpemail.mpe.mpg.de ([130.183.137.110]:42727 "EHLO
	mpemail.mpe.mpg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbXBMJZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 04:25:18 -0500
From: "Martin A. Fink" <fink@mpe.mpg.de>
Organization: MPE
To: Matthias Schniedermeyer <ms@citd.de>, linux-kernel@vger.kernel.org
Subject: Re: SATA-performance: Linux vs. FreeBSD
Date: Tue, 13 Feb 2007 10:25:15 +0100
User-Agent: KMail/1.8
References: <200702121502.17130.fink@mpe.mpg.de> <200702121856.29729.fink@mpe.mpg.de> <45D0F8EE.7020604@citd.de>
In-Reply-To: <45D0F8EE.7020604@citd.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702131025.15964.fink@mpe.mpg.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 13. Februar 2007 00:31 schrieben Sie:
> Martin A. Fink wrote:
> > I have to store big amounts of data coming from 2 digital cameras to disk. 
> > Thus I have to write blocks of around 1 MB at 30 to 50 frames per second 
for 
> > a long period of time. So it is important for me that the harddisk drive 
is 
> > reliable in the sense of "if it is capable of 50 MB/s then it should 
operate 
> > at this speed. Constantly."
> 
> The good old handful of suggestions:
> 
> - Use a dedicated disc for the task.

I used a dedicated disk for this task. No one else besides the task is writing 
to it!

> - Use an empty disc so there is no fragmentation.

All tests were performed on empty disk!

> - Buy a bigger disk, they have high bandwidths.

I have a flash disk from a manufacturer who grants me 48 MB/s. And FreeBSD as 
well as Windows reach this value. Only Linux 2.6.18 is far away from it (42 
MB/s)

> - Buy a more "specialized" disc.

see above

>   for e.x.: Western Digital Raptor X(*) a 150GB, 10-KRPM S-ATA disc.
> - Buy several discs and use RAID 0
>   or alternate between discs when writing.

What I have to build is an application for the International Space Station 
ISS. I am limited with power and space. So If the disk is able to write 
constantly 48 MB/s then the Operating System should do this!

> - use XFS. AFAIK XFS has about the best "large file" and "high
> bandwidth" characteristics.
> - that with XFS you can preallocate the files doesn't seem relevant in
> this case. It's more for the case that you write several files
> simultaneously over a longer period of time.
> - Write to one large file and separate the individual files later.
> 
> if you are sure that you don't get a power-failure:
> - Disable Write-Barriers, especially on a logging-filesystem.
> - Enable write-caching.
> (hdparm doesn't appear to be able to do that with a SATA-disc, but
> blktool appears to be able to)
> The later has a good chance of corrupting your filesystem when you do
> get a power-failure!!!
> 
> 
> 
> *:
> I don't think you want something from the server-line,
> SCSI/FibreChannel/...?
> IIRC i read a something about the first 100MB/s disc with in the 15-KRPM
> league.

Power consumption! See above.
> 
> Bis denn
> 
The problem is: FreeBSD is fast, but lacks of some special drivers. Linux has 
all drivers but access to harddisk is unpredictable and thus unreliable!
What can I do??
> -- 
> Real Programmers consider "what you see is what you get" to be just as
> bad a concept in Text Editors as it is in women. No, the Real Programmer
> wants a "you asked for it, you got it" text editor -- complicated,
> cryptic, powerful, unforgiving, dangerous.
> 
> 

-- 
Dipl. Physiker
Martin Anton Fink
Max Planck Institute for extraterrestrial Physics
Giessenbachstrasse
85741 Garching
Germany
Tel. +49-(0)89-30000-3645
Fax. +49-(0)89-30000-3569
