Return-Path: <linux-kernel-owner+w=401wt.eu-S1758591AbYF2TaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758591AbYF2TaG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 15:30:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbYF2T3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 15:29:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45639 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716AbYF2T3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 15:29:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
Date: Sun, 29 Jun 2008 21:31:02 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <Pine.LNX.4.55.0806291952590.22548@cliff.in.clinika.pl> <20080629192353.GA9132@srcf.ucam.org>
In-Reply-To: <20080629192353.GA9132@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806292131.03859.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 29 of June 2008, Matthew Garrett wrote:
> On Sun, Jun 29, 2008 at 08:05:42PM +0100, Maciej W. Rozycki wrote:
> 
> >  It is the reverse -- checking the DSDT ID is coarser, matching all the
> > systems that use the broken firmware.  With DMI we may face both false
> > positives and false negatives which imply further maintenance actions.  
> > Please note as proved over the years understanding of these issues seems
> > to be problematic for people, so the result may be another round of
> > discussions reinventing the wheel in a couple of years' time or so.
> 
> The DSDT can't be updated without the BIOS being updated, and the DMI 
> information gives us a BIOS version string that can be matched against 
> if a fixed version is ever released. I'd be in favour of doing it with 
> DMI on the grounds that it's how we already handle machine-specific 
> quirks rather than adding new code to do it.

I violently agree.

Thanks,
Rafael
