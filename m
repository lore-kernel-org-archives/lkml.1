Return-Path: <linux-kernel-owner+w=401wt.eu-S1761109AbYFTU5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761109AbYFTU5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754942AbYFTU5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:57:09 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64000 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753059AbYFTU5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:57:06 -0400
Date: Fri, 20 Jun 2008 21:56:18 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
In-Reply-To: <alpine.LFD.1.10.0806201507190.3395@apollo.tec.linutronix.de>
Message-ID: <Pine.LNX.4.55.0806202154380.19614@cliff.in.clinika.pl>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <200806180053.40044.rjw@sisk.pl>
 <Pine.LNX.4.55.0806180400070.28110@cliff.in.clinika.pl> <200806190011.38548.rjw@sisk.pl>
 <Pine.LNX.4.55.0806182345380.7802@cliff.in.clinika.pl> <20080619093541.GC15228@elte.hu>
 <Pine.LNX.4.55.0806191619560.12929@cliff.in.clinika.pl>
 <alpine.LFD.1.10.0806201507190.3395@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2008, Thomas Gleixner wrote:

> >  Is it now possible at the time check_timer() is called the 8254 has been
> > put in one of the single-shot modes?  If so, then additional code has to
> > be put in place either to switch the timer into the periodic mode for the
> > duration of check_timer() or to rearm the timer if in a single-shot mode
> > each time timer_irq_works() is called.
> 
> At this point the PIT is in periodic mode.

 I had a feeling this was the case -- thanks for your clarification.  
Nothing to change in check_timer() as far as this property is concerned
then.

  Maciej
