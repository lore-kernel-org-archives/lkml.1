Return-Path: <linux-kernel-owner+w=401wt.eu-S1754503AbYF0Byu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbYF0Byu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 21:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465AbYF0Bym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 21:54:42 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63547 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751409AbYF0Byk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 21:54:40 -0400
Date: Fri, 27 Jun 2008 02:53:09 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Pavel Machek <pavel@suse.cz>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
In-Reply-To: <20080624091516.GA5642@ucw.cz>
Message-ID: <Pine.LNX.4.55.0806270249490.31618@cliff.in.clinika.pl>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <200806201353.59083.rjw@sisk.pl>
 <20080620115714.GC8637@srcf.ucam.org> <200806201422.12659.rjw@sisk.pl>
 <20080624091516.GA5642@ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2008, Pavel Machek wrote:

> > $ cat /proc/acpi/thermal_zone/TZ*/trip_points
> > 
> > in the failing case:
> > 
> > critical (S5):           105 C
> > passive:                 16 C: tc1=1 tc2=2 tsp=100 devices=C000 C001 
> > active[0]:               16 C: devices=C34F 
> > active[1]:               16 C: devices=C350 
> > active[2]:               16 C: devices=C351 
> > active[3]:               16 C: devices=C352 
> > critical (S5):           100 C
> > passive:                 16 C: tc1=1 tc2=2 tsp=300 devices=C000 C001 
> > critical (S5):           100 C
> > passive:                 16 C: tc1=1 tc2=2 tsp=300 devices=C000 C001 
> 
> Can we call the ACPI BIOS to be terminally broken at this point?

 Do we have any point of contact at HP and/or ATI/AMD?  I suppose getting 
hands on a SB400 datasheet could be tricky, but someone may be able to 
answer questions about the interrupt routing between the 8254, the 8259A 
and the I/O APIC for this chip and/or fix the DSDT.

  Maciej
