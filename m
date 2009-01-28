Return-Path: <linux-kernel-owner+w=401wt.eu-S1754065AbZA1SWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbZA1SWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 13:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbZA1SWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 13:22:12 -0500
Received: from casper.infradead.org ([85.118.1.10]:47282 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbZA1SWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 13:22:11 -0500
Date: Wed, 28 Jan 2009 10:22:08 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, jens.axboe@oracle.com
Subject: Re: Buggy IPI and MTRR code on low memory
Message-ID: <20090128102208.68a900cc@infradead.org>
In-Reply-To: <alpine.DEB.1.10.0901281221450.25359@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0901281029150.25359@gandalf.stny.rr.com>
	<1233161182.10992.52.camel@laptop>
	<alpine.DEB.1.10.0901281221450.25359@gandalf.stny.rr.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2009 12:24:48 -0500 (EST)
Steven Rostedt <rostedt@goodmis.org> wrote:


> > ---
> I'll have skip the NMI test and see if it locks up any place else.

if you get an NMI during MTRR changing you are more or less screwed.
Really. (the cpu is uncachable etc)

the MTRR code should disable NMIs as much as possible.

and for sure in -RT, the MTRR change section should not be preemptable
at all.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
