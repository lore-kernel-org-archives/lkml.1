Return-Path: <linux-kernel-owner+w=401wt.eu-S1752850Ab0A0NAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab0A0NAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 08:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752497Ab0A0NAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 08:00:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43865 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914Ab0A0NA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 08:00:29 -0500
Date: Wed, 27 Jan 2010 14:00:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [Bug #14657] perf subsystem breakage in 2.6.32-rc7
Message-ID: <20100127130013.GA16698@elte.hu>
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera>
 <q60Z28d_9yH.A._eB.HbMXLB@chimera>
 <84144f021001270441t75441bebpc605ac8c0cfedbd1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f021001270441t75441bebpc605ac8c0cfedbd1@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> (I am CC'ing some more perf folks.)
> 
> On Mon, Jan 25, 2010 at 12:22 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.31 and 2.6.32.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.31 and 2.6.32. ?Please verify if it still should
> > be listed and let me know (either way).
> >
> > Bug-Entry ? ? ? : http://bugzilla.kernel.org/show_bug.cgi?id=14657
> > Subject ? ? ? ? : perf subsystem breakage in 2.6.32-rc7
> > Submitter ? ? ? : Arjan van de Ven <arjan@infradead.org>
> > Date ? ? ? ? ? ?: 2009-11-19 19:50 (67 days old)
> > References ? ? ?: http://marc.info/?l=linux-kernel&m=125866013419738&w=4
> 
> Is this bug still valid?

Ought to be fixed by:

 8f06d7e: perf timechart: Use tid not pid for COMM change

But i'd like Arjan to confirm this before we can strike this from the list of 
regressions.

	Ingo
