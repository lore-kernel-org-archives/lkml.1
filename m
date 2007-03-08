Return-Path: <linux-kernel-owner+w=401wt.eu-S1751811AbXCHNf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811AbXCHNf5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 08:35:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbXCHNf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 08:35:57 -0500
Received: from vsmtp12.tin.it ([212.216.176.206]:53878 "EHLO vsmtp12.tin.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811AbXCHNf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 08:35:56 -0500
Subject: Re: Problem with libata-pata, ATAPI DVD reader and a
	"copy-protected" audio cd
From: GhePeU <ghepeu@virgilio.it>
To: linux-kernel@vger.kernel.org
In-Reply-To: <1172919624.23576.31.camel@KazeNoTani>
References: <1172919624.23576.31.camel@KazeNoTani>
Content-Type: text/plain
Date: Thu, 08 Mar 2007 14:35:55 +0100
Message-Id: <1173360956.24659.3.camel@KazeNoTani>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Il giorno sab, 03/03/2007 alle 12.00 +0100, GhePeU ha scritto:
> Hello,
> 
> when kernel 2.6.20 was released I switched to the new libata-pata
> infrastructure for my EIDE hard disk and ATAPI dvd-reader. 
> 
> Until yesterday I didn't have any problem, then I tried to play an audio
> CD and my media player hanged. Looking to the logs, I found that the DVD
> reader (a Toshiba SD-M1612) was having problems reading the disk and
> that the kernel dropped its speed from UDMA/33 to PIO3 before I could
> eject the CD. Attached to this mail are the relevant lines of the system
> log.
> 
> After a careful scrutiny of the box, I noticed that the disk was one of
> those "Copy protected" non-standard CD. With the old ide driver I could
> play and rip the CD without problems, so from a user point of view this
> is a regression.
> 
> Besides, with the reduced speed the DVD reader was almost unusable, and
> since the new libata layer doesn't support forcing the driver speed with
> hdparm, I had to reboot the machine.
> 
> So my questions are:
> 
> 1) it is possible to implement a command to force re-detection of the
> better transfer mode available? I suppose that by unloading and
> reloading the module, the transfer mode should become again the better
> available, but when the driver is compiled in-kernel, this is not
> possible.
> 
> 2) is there a way to access copy protected audio CD again? the only
> change here was ide -> libata, so there has to be some difference in the
> error handling of the two layer that caused this pseudo-regression.
> 
> Thank you in advance
> 
> Giacomo
> 
> PS. I'm not subscribed to the list. I'm going to regularly check the
> archives in the next days to see if there are responses, CC me if you
> can. Thank you.
> 
> 

Well, it happened again, with a different cd, and this time I never
started the player: hal/g-v-m tried to access the CD and now my driver
is in PIO2 mode and pretty much unusable. Is there a way to fix this
without rebooting?

Giacomo

