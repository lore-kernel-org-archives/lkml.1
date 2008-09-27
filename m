Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbYI0R4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbYI0R4s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 13:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbYI0R4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 13:56:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:39460 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbYI0R4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 13:56:38 -0400
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Bligh <mbligh@google.com>, Martin Bligh <mbligh@mbligh.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <alpine.DEB.1.10.0809271335001.10534@gandalf.stny.rr.com>
References: <alpine.LFD.1.10.0809251002290.3265@nehalem.linux-foundation.org>
	 <20080925195522.GA22248@elte.hu> <20080925201211.GA1878@elte.hu>
	 <alpine.LFD.1.10.0809251318270.3265@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0809251325450.3265@nehalem.linux-foundation.org>
	 <20080925211017.GA12689@elte.hu> <20080925214134.GA23025@elte.hu>
	 <alpine.LFD.1.10.0809251458020.3265@nehalem.linux-foundation.org>
	 <20080925221441.GA29060@elte.hu>
	 <alpine.LFD.1.10.0809251631460.3265@nehalem.linux-foundation.org>
	 <20080927171640.GA1990@elte.hu>
	 <alpine.DEB.1.10.0809271335001.10534@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Sat, 27 Sep 2008 19:50:28 +0200
Message-Id: <1222537829.16700.304.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-09-27 at 13:38 -0400, Steven Rostedt wrote:

>  It does not even implement the merge sort. That's up to the 
> tracer to handle. 

You could though, as you have the timestamps..

> So yes, the tracer can implement anything it wants on top of the ring 
> buffer ;-)

Mathieu seems to disagree, it would be good if he can share some
specifics so we can work on resolving those.

