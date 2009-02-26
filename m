Return-Path: <linux-kernel-owner+w=401wt.eu-S1756792AbZBZP0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792AbZBZP0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 10:26:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754643AbZBZP0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 10:26:34 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:36530 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbZBZP0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 10:26:33 -0500
Subject: Re: [patch 0/4] genirq: add infrastructure for threaded interrupt
	handlers V2
From: Jon Masters <jonathan@jonmasters.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20090226131336.423054348@linutronix.de>
References: <20090226131336.423054348@linutronix.de>
Content-Type: text/plain
Organization: World Organi[sz]ation of Broken Dreams
Date: Thu, 26 Feb 2009 10:26:04 -0500
Message-Id: <1235661964.7055.51.camel@perihelion.bos.jonmasters.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-26 at 13:28 +0000, Thomas Gleixner wrote:
> This patch series implements support for threaded irq handlers for the
> generic IRQ layer.

> The code was tested with a converted USB EHCI driver. The EHCI shares
> an interrupt line with another device and both the threaded and the
> non threaded handlers coexist nicely.

Cool. Thanks Thomas. The previous patchset works here aside from some
issues with Sven's USB patch - I'll pull this new set in and see which
drivers I can help convert over. Are you pulling this into the RT tree
already?

Jon.


