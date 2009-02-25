Return-Path: <linux-kernel-owner+w=401wt.eu-S1758542AbZBYEfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758542AbZBYEfI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 23:35:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbZBYEe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 23:34:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55979 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751274AbZBYEe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 23:34:56 -0500
Date: Tue, 24 Feb 2009 20:33:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Martin Bligh <mbligh@google.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/4] tracing: add event trace infrastructure
Message-Id: <20090224203308.8d623e0b.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0902242252480.12697@gandalf.stny.rr.com>
References: <20090225025608.956691460@goodmis.org>
	<20090225025753.798204550@goodmis.org>
	<20090224194548.3effb746.akpm@linux-foundation.org>
	<alpine.DEB.2.00.0902242252480.12697@gandalf.stny.rr.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Feb 2009 23:08:56 -0500 (EST) Steven Rostedt <rostedt@goodmis.org> wrote:

> > Gad, what a lot of stuff.
> > 
> > Use strncpy_from_user()?
> > 
> > Use strstrip()?
> > 
> > Why do we care about leading and trailing whitespace - user error!
> 
> This is because i want:
> 
>  cat available_events > set_event
> 
> to work.

:(

Why on earth do we keep on putting all these pretty-printers and
pretty-parsers into the kernel?  I mean, how hard is it for userspace
to read a text file, do some basic substitutions and print it out again?

