Return-Path: <linux-kernel-owner+w=401wt.eu-S1756526AbZKQWkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526AbZKQWkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 17:40:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756494AbZKQWko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 17:40:44 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38652 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756469AbZKQWkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 17:40:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #14483] Interrupts enabled after irqrouter_resume - iMac9,1
Date: Tue, 17 Nov 2009 23:42:13 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rc7-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Justin Mattock <justinmattock@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera> <xXQGFmujPl.A.-yG.OTdALB@chimera> <20091117060554.GC30852@elte.hu>
In-Reply-To: <20091117060554.GC30852@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911172342.13077.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 November 2009, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.31.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14483
> > Subject		: Interrupts enabled after irqrouter_resume - iMac9,1
> > Submitter	: Justin Mattock <justinmattock@gmail.com>
> > Date		: 2009-10-25 19:58 (23 days old)
> > References	: http://marc.info/?l=linux-kernel&m=125650070420168&w=4
> 
> Looks like a suspend bug, not an irq bug. The new warnings in the 
> suspend/resume code might have triggered an old bug in that particular 
> driver.

That's quite possible, although that's rather core code than a driver.

Anyway, I haven't been able to find the bug in there so far.

Thanks,
Rafael
