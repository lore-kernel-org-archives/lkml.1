Return-Path: <linux-kernel-owner+w=401wt.eu-S1756309AbZCEUDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309AbZCEUDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 15:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755205AbZCEUDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 15:03:25 -0500
Received: from charybdis-ext.suse.de ([195.135.221.2]:42240 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755055AbZCEUDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 15:03:25 -0500
Subject: Re: [patch 0/4] genirq: add infrastructure for threaded interrupt
 handlers V2
From: Sven-Thorsten Dietrich <sdietrich@novell.com>
To: Jon Masters <jonathan@jonmasters.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <1235661964.7055.51.camel@perihelion.bos.jonmasters.org>
References: <20090226131336.423054348@linutronix.de>
	 <1235661964.7055.51.camel@perihelion.bos.jonmasters.org>
Content-Type: text/plain
Organization: Novell
Date: Thu, 05 Mar 2009 12:03:17 -0800
Message-Id: <1236283397.20484.35.camel@sven.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-26 at 10:26 -0500, Jon Masters wrote:
> On Thu, 2009-02-26 at 13:28 +0000, Thomas Gleixner wrote:
> > This patch series implements support for threaded irq handlers for the
> > generic IRQ layer.
> 
> > The code was tested with a converted USB EHCI driver. The EHCI shares
> > an interrupt line with another device and both the threaded and the
> > non threaded handlers coexist nicely.
> 
> Cool. Thanks Thomas. The previous patchset works here aside from some
> issues with Sven's USB patch - I'll pull this new set in and see which
> drivers I can help convert over. Are you pulling this into the RT tree
> already?

Hi Jon,


Were you still using the USB threading version from October? 

There was at least a missing spin_unlock there at one point. We fixed
that at LCA.

I do take bug reports directly, btw. and might even see them if you can
just mail them to LKML.

But "some issues" is rather vague.

Thanks

Sven

> 
> Jon.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

