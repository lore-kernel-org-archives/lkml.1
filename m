Return-Path: <linux-kernel-owner+w=401wt.eu-S1752588AbYI1JAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbYI1JAb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 05:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbYI1JAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 05:00:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54761 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbYI1JAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 05:00:22 -0400
Subject: Re: [RFC PATCH] LTTng relay buffer allocation, read, write
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, Martin Bligh <mbligh@google.com>,
       prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, od@suse.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>
In-Reply-To: <1222535419.16700.300.camel@lappy.programming.kicks-ass.net>
References: <20080927134012.GA11930@Krystal>
	 <1222535419.16700.300.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain
Date: Sun, 28 Sep 2008 10:59:29 +0200
Message-Id: <1222592370.16700.311.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-09-27 at 19:10 +0200, Peter Zijlstra wrote:
> On Sat, 2008-09-27 at 09:40 -0400, Mathieu Desnoyers wrote:

> > It does not provide _any_ sort of locking on buffer data. Locking should be done
> > by the caller. Given that we might think of very lightweight locking schemes,

Which defeats the whole purpose of the exercise, we want to provide a
single mechanism - including locking - that is usable to all. Otherwise
everybody gets to do the hard part themselves, which will undoubtedly
result in many broken/suboptimal locking schemes. 

