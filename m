Return-Path: <linux-kernel-owner+w=401wt.eu-S932499AbYF2URl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932499AbYF2URl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 16:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757549AbYF2URc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 16:17:32 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62513 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756565AbYF2URb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 16:17:31 -0400
Date: Sun, 29 Jun 2008 21:16:38 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
In-Reply-To: <20080629200732.GA10295@srcf.ucam.org>
Message-ID: <Pine.LNX.4.55.0806292115200.22548@cliff.in.clinika.pl>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <200806262152.02099.rjw@sisk.pl>
 <Pine.LNX.4.55.0806270102051.31618@cliff.in.clinika.pl> <200806291600.29059.rjw@sisk.pl>
 <Pine.LNX.4.55.0806291952590.22548@cliff.in.clinika.pl>
 <20080629192353.GA9132@srcf.ucam.org> <Pine.LNX.4.55.0806292057270.22548@cliff.in.clinika.pl>
 <20080629200732.GA10295@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jun 2008, Matthew Garrett wrote:

> >  Is the DMI ID *guaranteed* to be changed with an update to the DSDT?  
> 
> The BIOS version is, yes.

 Good to know, thanks.

> > Anyway, you cannot imply from a given DMI ID a broken DSDT is present, so
> > you will have to repeat the experience of adding another DMI ID whenever a
> > user hits this broken DSDT with another piece of hardware.  As long as you
> > are able to pull this piece of information from that user, that is...
> 
> These are the only two pieces of hardware ever reported to have this 
> problem. Nobody appears to have demonstrated it on any other HP systems, 
> and any non-HP systems would have a different identifier string. With 
> the SB400 being superceded, I don't expect us to see any more machines 
> with the same ID.

 Fair enough.  As I wrote, I'll send an update shortly.

  Maciej
