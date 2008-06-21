Return-Path: <linux-kernel-owner+w=401wt.eu-S1752387AbYFUWqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387AbYFUWqF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 18:46:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbYFUWpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 18:45:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33008 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbYFUWpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 18:45:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
Date: Sun, 22 Jun 2008 00:47:00 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <200806181640.45595.rjw@sisk.pl> <alpine.LFD.1.10.0806181726400.3395@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0806181726400.3395@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806220047.01497.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 18 of June 2008, Thomas Gleixner wrote:
> On Wed, 18 Jun 2008, Rafael J. Wysocki wrote:
> > > I just checked that the original c1e series and the affected code in
> > > tip are not different. IIRC you confirmed that the C1E patches would
> > > work on your box. So I wonder what else got changed which causes these
> > > problems.
> > 
> > Well, to eliminate any possible correlations, do you have a version of the
> > series or a single patch against the current mainline?
> 
> http://userweb.kernel.org/~tglx/952f4a-c1e-apic.patch
> http://userweb.kernel.org/~tglx/952f4a-c1e.patch
> 
> c1e-apic is the forward port of the apic changes and c1e is the pure
> c1e stuff. On my box it does not work w/o the c1e-apic one, but ....

Unfortunately, with the c1e.patch on top of the apic.patch on top of the
current mainline I get the same symptoms as with -next:
- processes freeze
- CPU loads are unreasonably high
- things generally get stucked if I don't move the mouse or press keys

Removing the the c1e.patch makes things work again.

Thanks,
Rafael
