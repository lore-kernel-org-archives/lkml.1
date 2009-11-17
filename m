Return-Path: <linux-kernel-owner+w=401wt.eu-S1756826AbZKQXIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826AbZKQXIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 18:08:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756426AbZKQXIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 18:08:13 -0500
Received: from www.tglx.de ([62.245.132.106]:51129 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756197AbZKQXIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 18:08:12 -0500
Date: Wed, 18 Nov 2009 00:07:09 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Justin Mattock <justinmattock@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Len Brown <lenb@kernel.org>,
       Venkatesch Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [Bug #14483] Interrupts enabled after irqrouter_resume -
 iMac9,1
In-Reply-To: <200911172342.13077.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0911180003070.24119@localhost.localdomain>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera> <xXQGFmujPl.A.-yG.OTdALB@chimera> <20091117060554.GC30852@elte.hu> <200911172342.13077.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Nov 2009, Rafael J. Wysocki wrote:

ACPI folks Cc'ed

> On Tuesday 17 November 2009, Ingo Molnar wrote:
> > 
> > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > 
> > > This message has been generated automatically as a part of a report
> > > of recent regressions.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.31.  Please verify if it still should be listed and let me know
> > > (either way).
> > > 
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14483
> > > Subject		: Interrupts enabled after irqrouter_resume - iMac9,1
> > > Submitter	: Justin Mattock <justinmattock@gmail.com>
> > > Date		: 2009-10-25 19:58 (23 days old)
> > > References	: http://marc.info/?l=linux-kernel&m=125650070420168&w=4
> > 
> > Looks like a suspend bug, not an irq bug. The new warnings in the 
> > suspend/resume code might have triggered an old bug in that particular 
> > driver.
> 
> That's quite possible, although that's rather core code than a driver.
> 
> Anyway, I haven't been able to find the bug in there so far.

irqrouter_resume() seems to be solely ACPI code. I have not seen where
it might reenable interrupts, but ACPI folks might shed some light on
that.

Thanks,

	tglx
