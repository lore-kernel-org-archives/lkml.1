Return-Path: <linux-kernel-owner+w=401wt.eu-S1756560AbXJAUMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbXJAUMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 16:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbXJAUMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 16:12:13 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:58122 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbXJAUMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 16:12:12 -0400
Date: Mon, 1 Oct 2007 13:11:47 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       David Bahi <dbahi@novell.com>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, Gregory Haskins <GHaskins@novell.com>
Subject: Re: nmi_watchdog fix for x86_64 to be more like i386
Message-ID: <20071001201147.GF29100@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <46FA4A800200006C000192FE@sinclair.provo.novell.com> <200710011936.01528.ak@suse.de> <alpine.LFD.0.9999.0710012052310.20478@localhost.localdomain> <200710012116.59356.ak@suse.de> <alpine.LFD.0.9999.0710012124420.20478@localhost.localdomain> <20071001125626.32eb6d0b@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071001125626.32eb6d0b@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2007 at 12:56:26PM -0700, Arjan van de Ven wrote:
> On Mon, 1 Oct 2007 21:27:39 +0200 (CEST)
> 
> > > I already did this here by checking for cpu != 0. But it also needs
> > > either tracking or forbidding migrations of irq 0. I can take care
> > > of the patch.
> > 
> > I was thinking about the same fix. On i386 we already have the irq 
> > migration / balancing of irq 0 disabled. That's why we setup IRQ0 with
> > IRQ_NOBALANCING.
> 
> btw doing this is a problem if the user decides to hot(un)plug cpu 0...
> he then can't move the irqs away to do that

Last I tried it, x86_64 and i386 in fact prohibit hotunplugging CPU 0.

						Thanx, Paul
