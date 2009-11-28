Return-Path: <linux-kernel-owner+w=401wt.eu-S1753512AbZK2AEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbZK2AEJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 19:04:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753406AbZK2AEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 19:04:08 -0500
Received: from ara.aytolacoruna.es ([91.117.124.165]:53661 "EHLO
	mx.aytolacoruna.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbZK2AEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 19:04:08 -0500
X-Greylist: delayed 611 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Nov 2009 19:04:07 EST
Date: Sun, 29 Nov 2009 00:54:00 +0100
From: Santiago Garcia Mantinan <manty@manty.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       David Miller <davem@davemloft.net>
Subject: Re: [Bug #14294] kernel BUG at drivers/ide/ide-disk.c:187
Message-ID: <20091128235359.GA6877@dis.manty.net>
References: <7qTjLRFNcGF.A.eSE.kCACLB@chimera>
 <mYW9sxtWd2G.A.EcF.bDACLB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mYW9sxtWd2G.A.EcF.bDACLB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14294

Hi!

Sorry for not answering before, I've been running 2.6.31 patched for all
this time and the results are a bit dissapointing...

The first run was for almost a month and ended up with half a hang, I could
read on the console that there had been an error on one of the disks, dma
error, the keyboard was working, getty seemed to work but then login didn't
show up when entering the username even though the disks led was flashing
when I operated the console entering usernames and all that. This hang was
not like the hangs I had before, don't know if it was due to the patch and
the unknown operation arriving to the IDE disk, but the message that the
patch was supposed to display was not displayed at all.

The second run is current run I believe, currently it has an uptime of 18
days and not problem was showed over this time.

So... I'm afraid I'm not able to reproduce this and maybe the whole problem
is hardware related, even though the machine had been running with 2.6.30 in
a stable way, it is an old machine, so maybe it is not as healthy as I
believed, and even though memtest doesn't show any errors there could be
some dma problems or other weird things happening around :-(

So... I'd say you can close the bug and if I happen to find it again... I'll
report it again.

Sorry for all the noise.

Regards...
-- 
Manty/BestiaTester -> http://manty.net
