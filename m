Return-Path: <linux-kernel-owner+w=401wt.eu-S1754354AbYJCVxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354AbYJCVxr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 17:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397AbYJCVxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 17:53:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34155 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353AbYJCVxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 17:53:37 -0400
Date: Fri, 3 Oct 2008 17:52:54 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Jason Baron <jbaron@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Martin Bligh <mbligh@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, od@novell.com
Subject: Re: Unified tracing buffer
Message-ID: <20081003215254.GA1504@redhat.com>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com> <alpine.DEB.1.10.0809200451420.9362@gandalf.stny.rr.com> <20080920135548.GB23215@Krystal> <20080920071232.46908040@infradead.org> <20080922185209.GC6349@Krystal> <20081002152851.GC3220@redhat.com> <20081003161154.GA4139@Krystal> <20081003183737.GD3167@redhat.com> <20081003191026.GC9626@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081003191026.GC9626@Krystal>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Fri, Oct 03, 2008 at 03:10:26PM -0400, Mathieu Desnoyers wrote:
> [...]
> I don't want the tracepoints to be coupled with markers (which are a
> userspace API). [...]

I'm glad the discussion seems to be slowly turning toward the event
layering issues, but ... "markers being a userspace API"?  That seems
to be grossly misleading terminology.  It's a kernel API like anything
else being discussed here.  What's different about it
(vs. tracepoints) is that it could be one of the first clients of the
unified ring buffer widget that concretely addresses the issue of
encoding abstract traceworthy events into serialized data.

(Of course, merging the lower level aspects of the marker/tracepoint
implementations is all well and good.)

- FChE
