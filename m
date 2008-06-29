Return-Path: <linux-kernel-owner+w=401wt.eu-S1757976AbYF2TH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976AbYF2TH7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 15:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755861AbYF2THt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 15:07:49 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61937 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754860AbYF2THs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 15:07:48 -0400
Date: Sun, 29 Jun 2008 20:05:42 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
In-Reply-To: <200806291600.29059.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.55.0806291952590.22548@cliff.in.clinika.pl>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <200806262152.02099.rjw@sisk.pl>
 <Pine.LNX.4.55.0806270102051.31618@cliff.in.clinika.pl> <200806291600.29059.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jun 2008, Rafael J. Wysocki wrote:

> >  I believe I removed all the occurences.  I am waiting for a proposal of a
> > quirk based on the DSDT ID -- my time is a bit too limited to study the
> > internals of our ACPI code at the moment; sorry about that.  I will
> > complement it with a change to remove IRQ0 from I/O APIC tables as
> > promised then; this piece of code I am quite familiar with.
> 
> Well, why don't we use the DMI identification as suggested by Matthew?

 Because it checks the wrong property.

> I think we can safely assume that all of these boxes are broken for now and we
> can use a more fine grained identification in the future, if necessary.

 It is the reverse -- checking the DSDT ID is coarser, matching all the
systems that use the broken firmware.  With DMI we may face both false
positives and false negatives which imply further maintenance actions.  
Please note as proved over the years understanding of these issues seems
to be problematic for people, so the result may be another round of
discussions reinventing the wheel in a couple of years' time or so.

 That's my opinion only though -- if it was to hinder the progress, then I
am not going to persist.

 Have you tried to report the issue through the usual manufacturer's
support channels, BTW?  They may not even be aware of the existence of the
bug.  Of course they may dismiss it anyway, but at least they will have a
record of it somewhere.

  Maciej
