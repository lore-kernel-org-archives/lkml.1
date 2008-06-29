Return-Path: <linux-kernel-owner+w=401wt.eu-S1756600AbYF2TWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbYF2TWR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 15:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbYF2TWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 15:22:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45579 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751AbYF2TWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 15:22:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
Date: Sun, 29 Jun 2008 21:23:15 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Andi Kleen <andi-suse@firstfloor.org>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <200806291600.29059.rjw@sisk.pl> <Pine.LNX.4.55.0806291952590.22548@cliff.in.clinika.pl>
In-Reply-To: <Pine.LNX.4.55.0806291952590.22548@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806292123.16237.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 29 of June 2008, Maciej W. Rozycki wrote:
> On Sun, 29 Jun 2008, Rafael J. Wysocki wrote:
> 
> > >  I believe I removed all the occurences.  I am waiting for a proposal of a
> > > quirk based on the DSDT ID -- my time is a bit too limited to study the
> > > internals of our ACPI code at the moment; sorry about that.  I will
> > > complement it with a change to remove IRQ0 from I/O APIC tables as
> > > promised then; this piece of code I am quite familiar with.
> > 
> > Well, why don't we use the DMI identification as suggested by Matthew?
> 
>  Because it checks the wrong property.
> 
> > I think we can safely assume that all of these boxes are broken for now and we
> > can use a more fine grained identification in the future, if necessary.
> 
>  It is the reverse -- checking the DSDT ID is coarser, matching all the
> systems that use the broken firmware.

How can you tell which DSDTs are broken until somebody reports them?

> With DMI we may face both false positives and false negatives which imply
> further maintenance actions.   

With DSDT matching you're likely to end up breaking systems the users of
which have not reported problems.

> Please note as proved over the years understanding of these issues seems
> to be problematic for people, so the result may be another round of
> discussions reinventing the wheel in a couple of years' time or so.
> 
>  That's my opinion only though -- if it was to hinder the progress, then I
> am not going to persist.

Good.

>  Have you tried to report the issue through the usual manufacturer's
> support channels, BTW?

My experience with HP indicates that it would have been a loss of time.

Apart from this, I've always been against forcing people to upgrade their
BIOSes just because we just had a briliant idea that made the kernel stop
working on their systems.  IMO it's extremely user-unfriendly and plain wrong.

Thanks,
Rafael
