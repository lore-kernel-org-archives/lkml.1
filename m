Return-Path: <linux-kernel-owner+w=401wt.eu-S1760319AbZAHOZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760319AbZAHOZJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 09:25:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756111AbZAHOY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 09:24:57 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:45705 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbZAHOY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 09:24:56 -0500
Date: Thu, 8 Jan 2009 09:24:55 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/2 v2] tracing/ftrace: handle more than one stat file
 per tracer
In-Reply-To: <20090108085817.GA6560@nowhere>
Message-ID: <alpine.DEB.1.10.0901080924460.22642@gandalf.stny.rr.com>
References: <4965214f.1f145e0a.6732.65b7@mx.google.com> <alpine.DEB.1.10.0901072249510.2429@gandalf.stny.rr.com> <20090108085817.GA6560@nowhere>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 8 Jan 2009, Frederic Weisbecker wrote:

> On Wed, Jan 07, 2009 at 10:50:35PM -0500, Steven Rostedt wrote:
> > 
> > On Wed, 7 Jan 2009, Frederic Weisbecker wrote:
> > 
> > > Impact: new API for tracers
> > > 
> > > Make the stat tracing API reentrant. And also provide the new directory
> > > /debugfs/tracing/trace_stat which will contain all the stat files for the
> > > current active tracer.
> > > 
> > > Now a tracer will, if desired, want to provide a zero terminated array of
> > > tracer_stat structures.
> > > Each one contains the callbacks necessary for one stat file.
> > > It have to provide at least a name for its stat file, an iterator with
> > > stat_start/start_next callback and an output callback for one stat entry.
> > > 
> > > Changes in v2:
> > > 
> > 
> > Hi Frederic,
> > 
> > This patch fails to compile the branch tracer by itself. No patch should 
> > break a build (for bisecting reasons).
> > 
> > -- Steve
> >
> 
> Hmm. Yes, so perhaps I can resend the two patches in one?

Sure.

-- Steve

