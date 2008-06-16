Return-Path: <linux-kernel-owner+w=401wt.eu-S1757202AbYFPNix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202AbYFPNix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 09:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755718AbYFPNiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 09:38:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58076 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755314AbYFPNiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 09:38:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
Date: Mon, 16 Jun 2008 15:39:04 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <200806160314.49489.rjw@sisk.pl> <Pine.LNX.4.55.0806160343220.11995@cliff.in.clinika.pl>
In-Reply-To: <Pine.LNX.4.55.0806160343220.11995@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806161539.05524.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 16 of June 2008, Maciej W. Rozycki wrote:
> On Mon, 16 Jun 2008, Rafael J. Wysocki wrote:
> 
> > On Sunday, 15 of June 2008, Rafael J. Wysocki wrote:
> > > On Friday, 13 of June 2008, Stephen Rothwell wrote:
> > > > Hi all,
> > > > 
> > > > Changes since next-20080612:
> > > > 
> > > > New tree: kgdb
> > > > Dropped trees (temporary): ldp (it is unfetchable - probably something to
> > > > do with the new Staging tree)
> > > > Restored trees: block
> > > > 
> > > > The x86 tree gained a conflict with Linus' tree.
> > > > 
> > > > The acpi tree gained a conflict with the pci tree.
> > > > 
> > > > The mtd tree gained a trivial conflict with the avr32 tree.
> > > > 
> > > > The rr tree lost its conflict with the net-current tree.
> > > > 
> > > > The block tree gained several conflict with various other trees.  It also
> > > > required a build fix patch.
> > > > 
> > > > The firmware tree lost its build fix patch.
> > > > 
> > > > The patches for known build problems are no longer needed.
> > > 
> > > 20080613 doesn't boot on my HP nx6325.  Bisecting ...
> > 
> > Okay, with the following commit reverted, the kernel boots normally on this
> > box:
> > 
> > commit 7e3530cd98a0c6ab38f5898e855a5beffab26561
> > Author: Maciej W. Rozycki <macro@linux-mips.org>
> > Date:   Tue May 27 21:19:51 2008 +0100
> > 
> >     x86: I/O APIC: timer through 8259A second-chance
> > 
> >     Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
> >     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
>  Can I have .config used and a full bootstrap log from that system with
> the patch still applied?

That may be difficult, because with the patch applied the box either doesn't
boot at all, or works unreliably when booted (depending on the set of patches
applied on top of it).

I'll try to get one later today.

Thanks,
Rafael
