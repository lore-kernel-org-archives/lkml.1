Return-Path: <linux-kernel-owner+w=401wt.eu-S1756100AbXL2Cep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100AbXL2Cep (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 21:34:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbXL2Ceh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 21:34:37 -0500
Received: from mx2.suse.de ([195.135.220.15]:57870 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469AbXL2Ceg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 21:34:36 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH] AMD Thermal Interrupt Support
Date: Sat, 29 Dec 2007 03:34:34 +0100
User-Agent: KMail/1.9.6
Cc: Russell Leidich <rml@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
References: <20071217185453.C4597CC562@localhost> <200712290311.51176.ak@suse.de> <26145.1198895417@turing-police.cc.vt.edu>
In-Reply-To: <26145.1198895417@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712290334.34609.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 December 2007 03:30:17 Valdis.Kletnieks@vt.edu wrote:
> On Sat, 29 Dec 2007 03:11:51 +0100, Andi Kleen said:
> > On Friday 28 December 2007 21:40:28 Russell Leidich wrote:
> 
> > +		printk(KERN_CRIT "CPU 0x%x: Thermal monitoring not "
> > +			"functional.\n", cpu);
> > 
> > Why is that KERN_CRIT? Does not seem that critical to me.
> 
> If you think you're running on a chipset that *should* support thermal
> monitoring, and it isn't there in a usable state, that seems pretty critical
> to me.  If that didn't work, you probably can't trust the "oh, the chip will
> thermal-limit itself if it gets to 100C or whatever" either.

Thermal shutdown in emergency uses quite different mechanisms (e.g. it goes
directly through pins to the motherboard); i don't think that code checks for 
that.

-Andi
