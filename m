Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbYGGNnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbYGGNnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 09:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbYGGNnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 09:43:07 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:35637 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751857AbYGGNnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 09:43:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAAy2cUhMQWVt/2dsb2JhbACBXKx3
Date: Mon, 7 Jul 2008 09:43:02 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC patch 00/12] Tracepoints v2
Message-ID: <20080707134302.GB14704@Krystal>
References: <20080704235207.147809973@polymtl.ca> <20080706022711.199401fe@linux360.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080706022711.199401fe@linux360.ro>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:34:04 up 32 days, 18:15,  6 users,  load average: 0.82, 0.91,
	0.87
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eduard - Gabriel Munteanu (eduard.munteanu@linux360.ro) wrote:
> On Fri, 04 Jul 2008 19:52:07 -0400
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Hi,
> > 
> > Here is the second release of kernel tracepoints, including the
> > architecture independent instrumentation taken from LTTng. I submit
> > this for another round of comments.
> 
> Hi,
> 
> Not using format specifiers sounds pretty nice. Are there any other
> advantages over markers? What about self-modifying code, does it employ
> this technique to eliminate conditional branching (markers did this on
> some arches, IIRC)?
> 

The main advantage is to remove the format strings. It also permits to
declare the tracepoints in a header file instead of only spreading them
all over the kernel code. It aims at providing an internal kernel
interface to kernel tracers, compared to markers which are eventually
meant to export the trace information, along with the format specifiers,
to userspace. The version I sent here does not use immediate values
(self-modifying code), but the one I have in my patchset does.

> I'm considering using this for kmemtrace, so please keep me Cc-ed if
> possible.
> 

Sure, I will,

Mathieu

> 
> 	Cheers,
> 	Eduard
> 
> P.S.: BTW, the To header is either broken or I screwed it (I'm reading
> this via Gmane's NNTP):
> "Steven Rostedt <ros"

Ok, will fix in the next post. Thanks.

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
