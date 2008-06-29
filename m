Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbYF2W5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbYF2W5U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 18:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbYF2W5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 18:57:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46473 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbYF2W5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 18:57:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
Date: Mon, 30 Jun 2008 00:59:01 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Andi Kleen <andi-suse@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <Pine.LNX.4.55.0806292023320.22548@cliff.in.clinika.pl> <20080629200210.GB31633@elte.hu>
In-Reply-To: <20080629200210.GB31633@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806300059.03288.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 29 of June 2008, Ingo Molnar wrote:
> 
> * Maciej W. Rozycki <macro@linux-mips.org> wrote:
> 
> >  You may argue this is a regression, but this is simply the cost paid 
> > for progress -- the kernel stays within the spec as defined both by 
> > ACPI and MPS, we have just started using a different configuration now 
> > and an interrupt source override provided by the manufacturer 
> > explicitly states INTIN2 is good to use.  In a sense you were simply 
> > lucky previously the kernel was bad enough with the way it configured 
> > the timer through the I/O APIC it failed completely avoiding the bug 
> > in your firmware.  Now the bug has got uncovered.
> 
> well as long as we eliminate the bad effects around via DMI exceptions 
> nobody will feel the need to argue whether it's a regression ;-)

If all boxes affected by this particulare breakage are covered by DMI-based
workarounds, they will continue to work and that won't be any regression.
The point is that the patch should go along with such workarounds.

> [this problem could be argued to be a regression, even if it's caused by
> prior luck/stupidity of Linux. We have to live with the effects of our
> mistakes.] 

That's exactly right.

Thanks,
Rafael
