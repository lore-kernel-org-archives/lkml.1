Return-Path: <linux-kernel-owner+w=401wt.eu-S1758376AbZBZVKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758376AbZBZVKZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 16:10:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbZBZVKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 16:10:08 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45520 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754299AbZBZVKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 16:10:06 -0500
To: Theodore Tso <tytso@mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Martin Bligh <mbligh@google.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/4] tracing: add event trace infrastructure
References: <20090225025608.956691460@goodmis.org>
	<20090225025753.798204550@goodmis.org>
	<20090224194548.3effb746.akpm@linux-foundation.org>
	<alpine.DEB.2.00.0902242252480.12697@gandalf.stny.rr.com>
	<20090224203308.8d623e0b.akpm@linux-foundation.org>
	<20090225081118.GC15303@elte.hu>
	<20090225002852.5ef5b869.akpm@linux-foundation.org>
	<20090225135437.GG7064@mit.edu>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Thu, 26 Feb 2009 16:08:54 -0500
In-Reply-To: <20090225135437.GG7064@mit.edu> (Theodore Tso's message of "Wed, 25 Feb 2009 08:54:37 -0500")
Message-ID: <y0miqmwoqhl.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso <tytso@mit.edu> writes:

> [...]  I think it's because we've just been burned so many times
> with complex user space tools that are built in C++, have
> impossible-to-understand error handling ("try again with -vvvvvvv"),
> is hard to build because they have huge dependencies on external
> libraries, or is filled with distro dependencies and might not build
> on various distributions, or is dependent on the RPM macros, etc.
> [...]

How many of these concerns have a basis in recent reality / experience?

- FChE
