Return-Path: <linux-kernel-owner+w=401wt.eu-S1755026AbYJ2Qkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbYJ2Qkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 12:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017AbYJ2Qkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 12:40:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:32991 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbYJ2Qkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 12:40:36 -0400
Date: Wed, 29 Oct 2008 09:40:58 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Theodore Tso <tytso@mit.edu>,
       Mike Snitzer <snitzer@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH 1/2 v2][RFC] trace: profile likely and unlikely
 annotations
Message-ID: <20081029094058.50bdaa4b@infradead.org>
In-Reply-To: <alpine.DEB.1.10.0810291233580.13214@gandalf.stny.rr.com>
References: <170fa0d20810271529g3c64ae89me29ed8b65a9c3b5e@mail.gmail.com>
	<alpine.DEB.1.10.0810271918390.19731@gandalf.stny.rr.com>
	<20081028001340.GB9797@mit.edu>
	<alpine.DEB.1.10.0810272316270.802@gandalf.stny.rr.com>
	<20081028143720.GD8869@mit.edu>
	<20081028074816.04193e04@infradead.org>
	<alpine.DEB.1.10.0810281050440.29482@gandalf.stny.rr.com>
	<alpine.DEB.1.10.0810291233580.13214@gandalf.stny.rr.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2008 12:35:44 -0400 (EDT)
Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Andrew Morton recently suggested having an in-kernel way to profile
> likely and unlikely macros. This patch achieves that goal.
> 
> When configured, every(*) likely and unlikely macro gets a counter
> attached to it. When the condition is hit, the hit and misses of that
> condition are recorded. These numbers can later be retrieved by:
> 
>   /debugfs/tracing/profile_likely    - All likely markers
>   /debugfs/tracing/profile_unlikely  - All unlikely markers.
> 

I like the general approach
it'd be very convenient if the debugfs files also had a
percentage-incorrect (or percentage-correct, either way) listed,
so that we humans can focus straight on which ones are outliers rather
than having to do math in our heads first...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
