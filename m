Return-Path: <linux-kernel-owner+w=401wt.eu-S1753659AbZGMDcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbZGMDcp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 23:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbZGMDcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 23:32:42 -0400
Received: from foo.birdnet.se ([213.88.146.6]:48409 "HELO foo.birdnet.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752103AbZGMDcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 23:32:42 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Jul 2009 23:32:41 EDT
Message-ID: <20090713032559.23220.qmail@stuge.se>
Date: Mon, 13 Jul 2009 05:25:59 +0200
From: Peter Stuge <peter@stuge.se>
To: Pavel Machek <pavel@ucw.cz>
Cc: Len Brown <lenb@kernel.org>, sfi-devel@simplefirmware.org,
       linux-kernel@vger.kernel.org, coreboot@coreboot.org
Subject: Re: [SFI-devel] [RFC/PATCH 2.6.32] Simple Firmware Interface
	(SFI): initial support
Mail-Followup-To: Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
	sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org,
	coreboot@coreboot.org
References: <1245741246-6503-1-git-send-email-lenb@kernel.org> <20090623183153.GB12814@srcf.ucam.org> <alpine.LFD.2.00.0906231438190.23079@localhost.localdomain> <20090622194303.GC2284@ucw.cz> <alpine.LFD.2.00.0906241645250.20716@localhost.localdomain> <20090711220211.GA1670@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090711220211.GA1670@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

Pavel Machek wrote:
> > > ACPI can already do the job, right?

As Len explains, it can't.


> > > and operating systems already have to support ACPI.

I disagree here. How so? There are certainly other ways to accomplish
what ACPI does.


> > > So what are the reasons to reinvent the wheel?

Hardware developments push firmware and operating systems to new
places. I believe that's both neccessary and normal.


> > The Moorestown platform doesn't use ACPI because its chip-set
> > fundamentally does not support it.  Not only is the required
> > register set missing, *all* IO accesses are missing, and there is
> > no SMM support present to emuate it.
..
> Well, you should have just selected subset of ACPI, documenting that
> and implementing that. You would not have 'acpi compliant' logo, and
> windows XP would not boot on that, but at least you would not have
> created one more bios standard for people to support.

I don't think that's a practical option though.


I've been involved in the coreboot (formerly LinuxBIOS) project for a
good number of years, in part because I realized that the PC firmware
environment had lacked any serious developments for a very long time
and anything new, especially open source, was a good idea.

There's a certain stigma to coreboot in parts of the Linux kernel
community, because it's something very new and different in the x86
firmware landscape. Let me just say that I completely understand the
desire to resist changes in what is a somewhat functioning and at any
rate very wide spread technology. It seems that SFI is now facing
some of the same resistance, for much the same reason.

x86 architecture is changing, and firmware must change with it. It
will do operating systems good to join in, early on. Ideally there
will be much more cooperation across disciplines than in the past,
especially since hardware and software are already converging to a
point where good engineers on either side really must know also how
the other camp works. The only thing that remains with x86 is the
instruction set, every other part of the architecture has changed, is
changing, and will continue to change. That affects both firmware and
operating system of course.

ACPI is not always ideal, some may argue never. SFI strikes me as a
good complement. I think we will come to see further alternatives,
and finally I think that's a good thing, as software and hardware
continues to develop.

Of course it's not simple for operating systems. Nor for firmware.
But I don't believe the optimal and practical solution is to resist
rounder and lighter wheels.


//Peter
