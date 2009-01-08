Return-Path: <linux-kernel-owner+w=401wt.eu-S1756918AbZAHI6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918AbZAHI6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 03:58:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851AbZAHI6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 03:58:23 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:51748 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807AbZAHI6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 03:58:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ncid4lQ25Z4qNzdMufe7yMCt3mxcPWL9Ohui69fPNCRbreGhvEVgatq75rBrQYzhEO
         IXsjPPp11pejURlI7UvkonCKQU96IiAzmvIMYzBzTSnjkxi45xkGBb/c/Sb0Bx8Bv5C+
         RUMcQN9WBGhiL7qCi9KWagbFoei0qRVatmRZ4=
Date: Thu, 8 Jan 2009 09:58:18 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/2 v2] tracing/ftrace: handle more than one stat file
	per tracer
Message-ID: <20090108085817.GA6560@nowhere>
References: <4965214f.1f145e0a.6732.65b7@mx.google.com> <alpine.DEB.1.10.0901072249510.2429@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901072249510.2429@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 10:50:35PM -0500, Steven Rostedt wrote:
> 
> On Wed, 7 Jan 2009, Frederic Weisbecker wrote:
> 
> > Impact: new API for tracers
> > 
> > Make the stat tracing API reentrant. And also provide the new directory
> > /debugfs/tracing/trace_stat which will contain all the stat files for the
> > current active tracer.
> > 
> > Now a tracer will, if desired, want to provide a zero terminated array of
> > tracer_stat structures.
> > Each one contains the callbacks necessary for one stat file.
> > It have to provide at least a name for its stat file, an iterator with
> > stat_start/start_next callback and an output callback for one stat entry.
> > 
> > Changes in v2:
> > 
> 
> Hi Frederic,
> 
> This patch fails to compile the branch tracer by itself. No patch should 
> break a build (for bisecting reasons).
> 
> -- Steve
>

Hmm. Yes, so perhaps I can resend the two patches in one?

