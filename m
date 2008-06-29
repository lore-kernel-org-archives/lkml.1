Return-Path: <linux-kernel-owner+w=401wt.eu-S1760912AbYF2N6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760912AbYF2N6u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 09:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757033AbYF2N6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 09:58:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44679 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755689AbYF2N6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 09:58:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
Date: Sun, 29 Jun 2008 16:00:27 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <200806262152.02099.rjw@sisk.pl> <Pine.LNX.4.55.0806270102051.31618@cliff.in.clinika.pl>
In-Reply-To: <Pine.LNX.4.55.0806270102051.31618@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806291600.29059.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 27 of June 2008, Maciej W. Rozycki wrote:
> On Thu, 26 Jun 2008, Rafael J. Wysocki wrote:
> 
> > Well, actually, I'm not sure that will work.  I have only found
> > acpi_skip_timer_override being set to 1 in two places, but it doesn't seem to
> > be read anywhere.  What am I missing?
> 
>  I believe I removed all the occurences.  I am waiting for a proposal of a
> quirk based on the DSDT ID -- my time is a bit too limited to study the
> internals of our ACPI code at the moment; sorry about that.  I will
> complement it with a change to remove IRQ0 from I/O APIC tables as
> promised then; this piece of code I am quite familiar with.

Well, why don't we use the DMI identification as suggested by Matthew?

I think we can safely assume that all of these boxes are broken for now and we
can use a more fine grained identification in the future, if necessary.

Thanks,
Rafael
