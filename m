Return-Path: <linux-kernel-owner+w=401wt.eu-S1753086AbZGTVDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbZGTVDj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 17:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbZGTVDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 17:03:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36993 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbZGTVDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 17:03:37 -0400
Date: Mon, 20 Jul 2009 17:03:36 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: Re: [PATCH] sched: Provide iowait counters
In-Reply-To: <1248122316.23509.48.camel@laptop>
Message-ID: <alpine.DEB.2.00.0907201702560.14242@gandalf.stny.rr.com>
References: <4A64B813.1080506@linux.intel.com>  <1248117369.23509.33.camel@laptop>  <alpine.DEB.2.00.0907201540550.26208@gandalf.stny.rr.com>  <1248120676.23509.41.camel@laptop>  <alpine.DEB.2.00.0907201622140.26208@gandalf.stny.rr.com>
 <1248122316.23509.48.camel@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 20 Jul 2009, Peter Zijlstra wrote:
> 
> Hmm, should we maybe do something like:
> 
> 	TP_fast_assign(
> 		...
> 	)
> 	TP_perf_assign(
> 		addr = 0;
> 		count = time;
> 	),
> 
> So we can extend it over time?

Sure.

> 
> But otherwise, yes, looks nice. Lets make it happen ;-)

Want to send me a patch that I can play with ;-)

-- Steve

