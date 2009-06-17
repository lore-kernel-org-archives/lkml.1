Return-Path: <linux-kernel-owner+w=401wt.eu-S932738AbZFQIgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738AbZFQIgL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 04:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765149AbZFQIfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 04:35:40 -0400
Received: from web32604.mail.mud.yahoo.com ([68.142.207.231]:38894 "HELO
	web32604.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1765129AbZFQIfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 04:35:37 -0400
Message-ID: <971371.70253.qm@web32604.mail.mud.yahoo.com>
X-YMail-OSG: 7qrMRSEVM1nJGfcNZEKTxDdtb9EXxFp1k0OcrP.NwAMxaokaSUe.GF7EKgn9ayARcUGaBWCIVcbdDcYa6IGaP3FcvyZvOC79MwgFK6q1UPJVnedpBH1KzQYSYkD8_Za_B8RrWl0ewcO8tOlWp3aVq6WLOtc.Pw.nvk5Cc6mW6O7rhQWzOACCG4BSGhBU6fhY1UO94b78FIEZUFTwXWEh2sL0lLlf5KZOTCKWbdc3amUZ2Q8Kqdm5.8cPkU70.0Yzm42Q61g3I066tAoMxO_4wN6ouQo2e31llGVRHTYHjFh70Q--
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1277.43 YahooMailWebService/0.7.289.15
References: <488605.71443.qm@web32605.mail.mud.yahoo.com> <20090527133125.c36381b5.akpm@linux-foundation.org> <ac3eb2510905271356n1b01f273jca1f7aa8fc65c78b@mail.gmail.com> <170150.72851.qm@web32604.mail.mud.yahoo.com> <20090616122547.1323d2d4@jbarnes-g45>
Date: Wed, 17 Jun 2009 01:35:38 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Subject: Re: Analyzed/Solved/Bisected: Booting 2.6.30-rc2-git7 very slow
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>, efault@gmx.de,
       viro@zeniv.linux.org.uk, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       shemminger@vyatta.com, matthew@wil.cx, mike.miller@hp.com,
       James Owens <JOwens@hp.com>
In-Reply-To: <20090616122547.1323d2d4@jbarnes-g45>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Original Message ----

> From: Jesse Barnes <jbarnes@virtuousgeek.org>
> To: Martin Knoblauch <knobi@knobisoft.de>
> Cc: Kay Sievers <kay.sievers@vrfy.org>; Andrew Morton <akpm@linux-foundation.org>; efault@gmx.de; viro@zeniv.linux.org.uk; rjw@sisk.pl; linux-kernel@vger.kernel.org; shemminger@vyatta.com; matthew@wil.cx; mike.miller@hp.com
> Sent: Tuesday, June 16, 2009 9:25:47 PM
> Subject: Re: Analyzed/Solved/Bisected: Booting 2.6.30-rc2-git7 very slow
> 
> On Thu, 28 May 2009 02:14:46 -0700 (PDT)
> Martin Knoblauch wrote:
> > > I expect the duplicate comes from a left-over mount in initramfs
> > > which isn't a duplicate in the sense of a bug in vfs or mount or
> > > anything. I guess, it is just still mounted in the initial kernel
> > > rootfs, below the root from the disk. It could be that a umount
> > > from initramfs did go wrong because of a changed timing.
> > > 
> > 
> >  This is what I suspect as well. I know for sure that the first
> > sysfs-line in /proc/mounts
> > 
> > | none /sys sysfs rw 0 0
> > 
> > is already there (2.6.29-rc1 and up) when entering startup-skripts.
> > It is supposed to be unmounted before, but something seems to prevent
> > it. I have idea how to capture debug output from the initrd/init
> > script :-(
> 
> What's the latest here Martin?  It sounded like this was a userspace
> issue, with something reading the VPD over and over?  Or was it just a
> longer timeout that caused a specific driver to slow everything down?
> 

 Not sure about the VPD thing. Anyway, no real news. Still happens in 2.6.30. But it only happens on a certain HW platform (HP/DL380G4). The folks at HP try to reproduce in their environment.

Cheers
Martin

