Return-Path: <linux-kernel-owner+w=401wt.eu-S1755750AbYAJVgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750AbYAJVgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 16:36:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbYAJVgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 16:36:38 -0500
Received: from mga11.intel.com ([192.55.52.93]:62630 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421AbYAJVgh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 16:36:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,268,1196668800"; 
   d="scan'208";a="283538780"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [RFC PATCH 13/22 -v2] handle accurate time keeping over longdelays
Date: Thu, 10 Jan 2008 13:33:09 -0800
Message-ID: <1FE6DD409037234FAB833C420AA843EC48842F@orsmsx424.amr.corp.intel.com>
In-Reply-To: <1199996959.6108.18.camel@localhost.localdomain>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC PATCH 13/22 -v2] handle accurate time keeping over longdelays
Thread-Index: AchTx499B/YJDmGUTsq8vtqFAfqDGwAB+3Rg
References: <20080109232914.676624725@goodmis.org> <20080109233044.288563621@goodmis.org> <1199923219.6350.16.camel@localhost.localdomain> <12c511ca0801101154q224c7a43sa016190cf209d304@mail.gmail.com> <1199996959.6108.18.camel@localhost.localdomain>
From: "Luck, Tony" <tony.luck@intel.com>
To: "john stultz" <johnstul@us.ibm.com>, <bob.picco@hp.com>
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "LKML" <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
       "Gregory Haskins" <ghaskins@novell.com>,
       "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Tim Bird" <tim.bird@am.sony.com>, "Sam Ravnborg" <sam@ravnborg.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       "Steven Rostedt" <srostedt@redhat.com>
X-OriginalArrivalTime: 10 Jan 2008 21:33:10.0239 (UTC) FILETIME=[659166F0:01C853D0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If you noticed in my email, the fix for ppc was a bit easier, as it has
> only a 64bit counter that is quite unlikely to wrap twice between calls
> to update_wall_time().

"quite unlikely" ...

Hmmm just how fast are you driving the clocks on your ppc?  Even at 100GHz
It is almost SIX YEARS between wrap-arounds of a 64-bit counter.
Perhaps you could just have a cron job that forces a call to update_wall_time()
every January 1st, rather than add extra code overhead to a hot path :-) ?

But I agree that narrower counters are a problem.

-Tony
