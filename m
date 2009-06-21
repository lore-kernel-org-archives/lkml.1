Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589AbZFUKy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbZFUKy3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 06:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbZFUKyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 06:54:20 -0400
Received: from web32607.mail.mud.yahoo.com ([68.142.207.234]:40840 "HELO
	web32607.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751831AbZFUKyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 06:54:19 -0400
Message-ID: <929888.79571.qm@web32607.mail.mud.yahoo.com>
X-YMail-OSG: wcDB1T8VM1mbZY1KZ.DOatd6Y2UZE5Oy39sTdbqG0vIfuBU71ebkswcKz7VbB_Hw4ZWl4Cky13Be5t7ax3am2Q5fqE7WWmC0WEhpvqZDXFR6KgfzFP6cNCIsI2nnbbRRv1e.66jAW2NcJRHsu.RYpNYQ_g8U4pVpK2iPWxE5oB.VWVi9sIiyOFyGVInPMuiSqDtiGm6VNwMX3T3CQPDzCvEDqiD0vK0poRPdij0KiqHpqEns4y6DKSm74kWz6jURFTozpZRMJIuekxtHoy9DJlOE2_OPwhocbWHZsIYgnI0-
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1277.43 YahooMailWebService/0.7.289.15
References: <488605.71443.qm@web32605.mail.mud.yahoo.com> <20090527133125.c36381b5.akpm@linux-foundation.org> <ac3eb2510905271356n1b01f273jca1f7aa8fc65c78b@mail.gmail.com> <170150.72851.qm@web32604.mail.mud.yahoo.com> <20090616122547.1323d2d4@jbarnes-g45> <971371.70253.qm@web32604.mail.mud.yahoo.com> <4A3D104E.9060105@hp.com>
Date: Sun, 21 Jun 2009 03:54:21 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Subject: Re: Analyzed/Solved/Bisected: Booting 2.6.30-rc2-git7 very slow
To: jim owens <jowens@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>, efault@gmx.de,
       viro@zeniv.linux.org.uk, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       shemminger@vyatta.com, matthew@wil.cx, mike.miller@hp.com
In-Reply-To: <4A3D104E.9060105@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Original Message ----

> From: jim owens <jowens@hp.com>
> To: Martin Knoblauch <knobi@knobisoft.de>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>; Kay Sievers <kay.sievers@vrfy.org>; Andrew Morton <akpm@linux-foundation.org>; efault@gmx.de; viro@zeniv.linux.org.uk; rjw@sisk.pl; linux-kernel@vger.kernel.org; shemminger@vyatta.com; matthew@wil.cx; mike.miller@hp.com
> Sent: Saturday, June 20, 2009 6:37:34 PM
> Subject: Re: Analyzed/Solved/Bisected: Booting 2.6.30-rc2-git7 very slow
> 
> Martin Knoblauch wrote:
> > ----- Original Message ----
> > 
> >> From: Jesse Barnes 
> >> To: Martin Knoblauch 
> >> Cc: Kay Sievers ; Andrew Morton 
> ; efault@gmx.de; viro@zeniv.linux.org.uk; 
> rjw@sisk.pl; linux-kernel@vger.kernel.org; shemminger@vyatta.com; 
> matthew@wil.cx; mike.miller@hp.com
> >> Sent: Tuesday, June 16, 2009 9:25:47 PM
> >> Subject: Re: Analyzed/Solved/Bisected: Booting 2.6.30-rc2-git7 very slow
> >> 
> >> On Thu, 28 May 2009 02:14:46 -0700 (PDT)
> >> Martin Knoblauch wrote:
> >>>> I expect the duplicate comes from a left-over mount in initramfs
> >>>> which isn't a duplicate in the sense of a bug in vfs or mount or
> >>>> anything. I guess, it is just still mounted in the initial kernel
> >>>> rootfs, below the root from the disk. It could be that a umount
> >>>> from initramfs did go wrong because of a changed timing.
> >>>> 
> >>>  This is what I suspect as well. I know for sure that the first
> >>> sysfs-line in /proc/mounts
> >>> 
> >>> | none /sys sysfs rw 0 0
> >>> 
> >>> is already there (2.6.29-rc1 and up) when entering startup-skripts.
> >>> It is supposed to be unmounted before, but something seems to prevent
> >>> it. I have idea how to capture debug output from the initrd/init
> >>> script :-(
> >> What's the latest here Martin?  It sounded like this was a userspace
> >> issue, with something reading the VPD over and over?  Or was it just a
> >> longer timeout that caused a specific driver to slow everything down?
> >> 
> > 
> >  Not sure about the VPD thing. Anyway, no real news. Still happens in 2.6.30. 
> But it only happens on a certain HW platform (HP/DL380G4). The folks at HP try 
> to reproduce in their environment.
> > 
> > Cheers
> > Martin
> 
> I reproduced this and verified Martin's analysis.  Conclusions:
>

 Cool, so I am not seeing gremlins :-)

Cheers
Martin 
