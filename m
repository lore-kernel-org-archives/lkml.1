Return-Path: <linux-kernel-owner+w=401wt.eu-S1757157AbZBWQvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157AbZBWQvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 11:51:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754269AbZBWQve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 11:51:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50319 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbZBWQvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 11:51:33 -0500
Date: Mon, 23 Feb 2009 11:51:30 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] tracing/ftrace: add missing wake-up on some callsites
In-Reply-To: <20090223162630.GG5961@nowhere>
Message-ID: <alpine.DEB.2.00.0902231151020.18221@gandalf.stny.rr.com>
References: <49a1cc8f.2283420a.54d2.ffff8461@mx.google.com> <alpine.DEB.2.00.0902231034570.18221@gandalf.stny.rr.com> <alpine.DEB.2.00.0902231039290.18221@gandalf.stny.rr.com> <20090223162630.GG5961@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 23 Feb 2009, Frederic Weisbecker wrote:
> > 
> > Perhaps we could add these callsites back, but we would need to update 
> > trace_wake_up.
> > 
> > Have trace_wake_up set a flag instead, and add a tracepoint around the 
> > scheduler (outside the grabbing of runqueue locks), that will have a 
> > callback to the tracing code. That call back can perform the wakeups.
> > 
> > How does that sound?
> 
> 
> That sounds good but only for these particular tracers I guess.

OK, what about making a trace_delay_wake_up()?

-- Steve

