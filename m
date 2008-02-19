Return-Path: <linux-kernel-owner+w=401wt.eu-S1763016AbYBSXof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763016AbYBSXof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 18:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbYBSXoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 18:44:25 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44230 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751760AbYBSXoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 18:44:24 -0500
Date: Wed, 20 Feb 2008 00:44:46 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Petazzoni <thomas.petazzoni@enix.org>, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: arch/x86/kernel/acpi/sleep_32.c not compiled ?
Message-ID: <20080219234446.GA23837@elf.ucw.cz>
References: <20080219165940.6e9348f6@crazy> <200802192202.53510.rjw@sisk.pl> <20080219222623.GA28786@elf.ucw.cz> <200802200041.47851.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802200041.47851.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-02-20 00:41:46, Rafael J. Wysocki wrote:
> On Tuesday, 19 of February 2008, Pavel Machek wrote:
> > On Tue 2008-02-19 22:02:52, Rafael J. Wysocki wrote:
> > > On Tuesday, 19 of February 2008, Thomas Petazzoni wrote:
> > > > Hi,
> > > 
> > > Hi,
> > > 
> > > > Maybe I'm missing something completely obvious, but I don't see where
> > > > the arch/x86/kernel/acpi/sleep_32.c file gets compiled. The Makefile in
> > > > that directory compiles sleep.o, but doesn't compile sleep_$(BITS).o:
> > > > 
> > > > obj-$(CONFIG_ACPI)              += boot.o
> > > > obj-$(CONFIG_ACPI_SLEEP)        += sleep.o wakeup_$(BITS).o
> > > > 
> > > > ifneq ($(CONFIG_ACPI_PROCESSOR),)
> > > > obj-y                           += cstate.o processor.o
> > > > endif
> > > 
> > > No, the file is not build now.
> > > 
> > > Pavel, is this file really necessary?
> > 
> > sleep_32.c is obsolete. It tried to do s2ram whitelist in kernel, with
> > just one entry ;-). Remove it. If Mirek Spousta (probably last
> > remaining owner of whitelisted toshiba, he got it from me ;-)
> > complains, I'll give him better machine or something.
> 
> Well, then perhaps we also should remove the S1 quirk for the same box from
> drivers/acpi/sleep/main.c ?

Yes we probably can do that.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
