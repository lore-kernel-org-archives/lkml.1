Return-Path: <linux-kernel-owner+w=401wt.eu-S1756510AbXJAT6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510AbXJAT6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 15:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755962AbXJAT6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 15:58:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51879 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755688AbXJAT6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 15:58:18 -0400
Date: Mon, 1 Oct 2007 12:56:26 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>, David Bahi <dbahi@novell.com>,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Gregory Haskins <GHaskins@novell.com>
Subject: Re: nmi_watchdog fix for x86_64 to be more like i386
Message-ID: <20071001125626.32eb6d0b@laptopd505.fenrus.org>
In-Reply-To: <alpine.LFD.0.9999.0710012124420.20478@localhost.localdomain>
References: <46FA4A800200006C000192FE@sinclair.provo.novell.com>
	<200710011936.01528.ak@suse.de>
	<alpine.LFD.0.9999.0710012052310.20478@localhost.localdomain>
	<200710012116.59356.ak@suse.de>
	<alpine.LFD.0.9999.0710012124420.20478@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2007 21:27:39 +0200 (CEST)

> > I already did this here by checking for cpu != 0. But it also needs
> > either tracking or forbidding migrations of irq 0. I can take care
> > of the patch.
> 
> I was thinking about the same fix. On i386 we already have the irq 
> migration / balancing of irq 0 disabled. That's why we setup IRQ0 with
> IRQ_NOBALANCING.

btw doing this is a problem if the user decides to hot(un)plug cpu 0...
he then can't move the irqs away to do that
