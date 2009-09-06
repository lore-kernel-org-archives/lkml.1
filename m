Return-Path: <linux-kernel-owner+w=401wt.eu-S1758104AbZIFSBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104AbZIFSBb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 14:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758069AbZIFSBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 14:01:31 -0400
Received: from ns.penguin.cz ([84.21.108.25]:58895 "EHLO ns.penguin.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757970AbZIFSBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 14:01:30 -0400
Subject: Re: Zaurus suspend saga
From: Stanislav Brabec <utx@penguin.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.miao@marvell.com
In-Reply-To: <200909061903.10542.rjw@sisk.pl>
References: <20090906052653.GB1324@ucw.cz>  <200909061903.10542.rjw@sisk.pl>
Content-Type: text/plain
Date: Sun, 06 Sep 2009 20:01:30 +0200
Message-Id: <1252260090.4021.21.camel@utx.utx.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Sunday 06 September 2009, Pavel Machek wrote:
> > Hi!
> > 
> > Even with mtd regression fixed, spitz will still not suspend/resume
> > correctly.
> 
> Is the regression fixed in the Linus' tree, or do you still need to apply the
> revert patch?

I just tested kernel without this revert, and it seems to work. I did it
because Pavel mentioned it and some time ago it did not work (see thread
"2.6.31-rc1: zaurus suspend regressing" from August 2009).

Please ignore the crash I reported it the last mail. It was caused by
the eject on the PCMCIA slot from my 2.6.26 system (in 2.6.27 order of
PCMCIA slots swapped).

And here is my new console output with just plain vanilla (e07cccf4...)
with Pavel's patch.

apm-power: Requesting system suspend...
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.06 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
hostap_cs: CS_EVENT_PM_SUSPEND
max1111 spi2.2: spi_sync failed with -108
max1111 spi2.2: spi_sync failed with -108
max1111 spi2.2: spi_sync failed with -108
max1111 spi2.2: spi_sync failed with -108
max1111 spi2.2: spi_sync failed with -108
sharpsl-pm sharpsl-pm: Error: AC check failed.
sharpsl-pm sharpsl-pm: Offline Charger: Error occurred.
sharpsl-pm sharpsl-pm: Charging Error!


________________________________________________________________________
Stanislav Brabec
http://www.penguin.cz/~utx

