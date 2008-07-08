Return-Path: <linux-kernel-owner+w=401wt.eu-S1758084AbYGHUc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084AbYGHUc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 16:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757606AbYGHUbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 16:31:53 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33477 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692AbYGHUbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 16:31:52 -0400
Date: Tue, 8 Jul 2008 14:48:20 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
Message-ID: <20080708124820.GB16313@elf.ucw.cz>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <200806201353.59083.rjw@sisk.pl> <20080620115714.GC8637@srcf.ucam.org> <200806201422.12659.rjw@sisk.pl> <20080624091516.GA5642@ucw.cz> <Pine.LNX.4.55.0806270249490.31618@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0806270249490.31618@cliff.in.clinika.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-06-27 02:53:09, Maciej W. Rozycki wrote:
> On Tue, 24 Jun 2008, Pavel Machek wrote:
> 
> > > $ cat /proc/acpi/thermal_zone/TZ*/trip_points
> > > 
> > > in the failing case:
> > > 
> > > critical (S5):           105 C
> > > passive:                 16 C: tc1=1 tc2=2 tsp=100 devices=C000 C001 
> > > active[0]:               16 C: devices=C34F 
> > > active[1]:               16 C: devices=C350 
> > > active[2]:               16 C: devices=C351 
> > > active[3]:               16 C: devices=C352 
> > > critical (S5):           100 C
> > > passive:                 16 C: tc1=1 tc2=2 tsp=300 devices=C000 C001 
> > > critical (S5):           100 C
> > > passive:                 16 C: tc1=1 tc2=2 tsp=300 devices=C000 C001 
> > 
> > Can we call the ACPI BIOS to be terminally broken at this point?
> 
>  Do we have any point of contact at HP and/or ATI/AMD?  I suppose getting 
> hands on a SB400 datasheet could be tricky, but someone may be able to 
> answer questions about the interrupt routing between the 8254, the 8259A 
> and the I/O APIC for this chip and/or fix the DSDT.

Yes, we do have AMD contacts. Contact me privately if that's still
relevant.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
