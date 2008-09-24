Return-Path: <linux-kernel-owner+w=401wt.eu-S1753497AbYIXDua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbYIXDua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 23:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751855AbYIXDuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 23:50:21 -0400
Received: from qmta10.westchester.pa.mail.comcast.net ([76.96.62.17]:47907
	"EHLO QMTA10.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751645AbYIXDuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 23:50:20 -0400
X-Authority-Analysis: v=1.0 c=1 a=_CjcERenb9QvQhTn4TEA:9
 a=ZJkrfDNY93o6deFdua5cs8HCMz0A:4 a=WuK_CZDBSqoA:10
Subject: Re: Unified tracing buffer
From: Tom Zanussi <zanussi@comcast.net>
To: Martin Bligh <mbligh@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, prasad@linux.vnet.ibm.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>, od@suse.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>
In-Reply-To: <33307c790809230700o4bf0d22fg8ab2dcb904f7d66c@mail.gmail.com>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
	 <1221869279.8359.31.camel@lappy.programming.kicks-ass.net>
	 <20080922140740.GB5279@in.ibm.com>
	 <1222094724.16700.11.camel@lappy.programming.kicks-ass.net>
	 <1222147545.6875.135.camel@charm-linux>
	 <33307c790809230700o4bf0d22fg8ab2dcb904f7d66c@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 23 Sep 2008 22:50:15 -0500
Message-Id: <1222228215.7761.0.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-09-23 at 07:00 -0700, Martin Bligh wrote:
> > - get rid of anything having to do with padding, nobody needs it and its
> > only affect has been to horribly distort and complicate a lot of the
> > code
> > - get rid of sub-buffers, they just cause confusion
> > - get rid of mmap, nobody uses it
> > - no sub-buffers and no mmap support means we can get rid of most of the
> > callbacks, and a lot of API confusion along with them
> > - add relay flags - they probably should have been used from the
> > beginning and options made explicit instead of being shoehorned into the
> > callback functions.
> 
> Actually, I think if you did all that, it'd be pretty close to what we
> want anyway ...

OK, then, I'll continue with the cleanup patchset and see where it
goes...

Tom

