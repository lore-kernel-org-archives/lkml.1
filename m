Return-Path: <linux-kernel-owner+w=401wt.eu-S1756701AbYGGVjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701AbYGGVjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 17:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932076AbYGGVjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 17:39:05 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62933 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932073AbYGGVjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 17:39:04 -0400
Date: Mon, 7 Jul 2008 22:38:07 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Len Brown <lenb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       linux-next@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/2] acpi: Disable IRQ 0 through I/O APIC for some HP
 systems
In-Reply-To: <200807072217.24590.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.55.0807072231090.20615@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0807010055070.30785@cliff.in.clinika.pl>
 <200807070319.29470.rjw@sisk.pl> <Pine.LNX.4.55.0807072054310.20615@cliff.in.clinika.pl>
 <200807072217.24590.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jul 2008, Rafael J. Wysocki wrote:

> >  Ingo, from the sequence above, I gather this code is currently in the 
> > tree:
> > 
> > -	replace_pin_at_irq(0, 0, 0, apic1, pin1);
> > -	apic1 = 0;
> > -	pin1 = 0;
> > 
> > Please revert the change which introduced it.  While I recall posting a
> > patch which added code like this, I clearly stated it was solely for
> > diagnostics of Rafael's system and not to apply to any tree.
> 
> Shouldn't the setup_timer_IRQ0_pin(apic1, pin1, cfg->vector) be removed as
> well?

 Yes.  The whole commit should be reverted as mentioned in the other
e-mail (it didn't even bear my sign-off mark).  This would include the
line you are referring to as well.  I have submitted a patch to add a
64-bit variation of replace_pin_at_irq() separately.

  Maciej
