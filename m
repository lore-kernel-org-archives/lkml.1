Return-Path: <linux-kernel-owner+w=401wt.eu-S1755205Ab0A0Pau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab0A0Pau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 10:30:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754747Ab0A0Pat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 10:30:49 -0500
Received: from casper.infradead.org ([85.118.1.10]:44749 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab0A0Pas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 10:30:48 -0500
Date: Wed, 27 Jan 2010 07:31:01 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [Bug #14657] perf subsystem breakage in 2.6.32-rc7
Message-ID: <20100127073101.04518085@infradead.org>
In-Reply-To: <20100127130013.GA16698@elte.hu>
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera>
	<q60Z28d_9yH.A._eB.HbMXLB@chimera>
	<84144f021001270441t75441bebpc605ac8c0cfedbd1@mail.gmail.com>
	<20100127130013.GA16698@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jan 2010 14:00:13 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> 
> > (I am CC'ing some more perf folks.)
> > 
> > On Mon, Jan 25, 2010 at 12:22 AM, Rafael J. Wysocki <rjw@sisk.pl>
> > wrote:
> > > This message has been generated automatically as a part of a
> > > report of regressions introduced between 2.6.31 and 2.6.32.
> > >
> > > The following bug entry is on the current list of known
> > > regressions introduced between 2.6.31 and 2.6.32. ?Please verify
> > > if it still should be listed and let me know (either way).
> > >
> > > Bug-Entry ? ? ? : http://bugzilla.kernel.org/show_bug.cgi?id=14657
> > > Subject ? ? ? ? : perf subsystem breakage in 2.6.32-rc7
> > > Submitter ? ? ? : Arjan van de Ven <arjan@infradead.org>
> > > Date ? ? ? ? ? ?: 2009-11-19 19:50 (67 days old)
> > > References ? ? ?:
> > > http://marc.info/?l=linux-kernel&m=125866013419738&w=4
> > 
> > Is this bug still valid?
> 
> Ought to be fixed by:
> 
>  8f06d7e: perf timechart: Use tid not pid for COMM change


nope independent from this bug.

this bug is about powertop not getting all events it expects


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
