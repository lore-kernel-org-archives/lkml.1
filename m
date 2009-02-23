Return-Path: <linux-kernel-owner+w=401wt.eu-S1754772AbZBWRFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbZBWRFp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 12:05:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751069AbZBWRFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 12:05:35 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:55214 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbZBWRFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 12:05:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ahnvWGOrVXO7i5ZyflLZi7oXO5lc4sDbJPFMqXc9n8+kGlQTKtXDNjABLe83FCcXZ3
         sat5g38YyDtbsrqwYfo3Yh/Puw9GyCbBVFBT6Mcco4eD3PCOg4rdc9uOvaikZOjQPtIk
         FoX8tZK6F2StwCIFCxZza8W5k39T4Iu+KFtw4=
Date: Mon, 23 Feb 2009 18:05:29 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] tracing/ftrace: add missing wake-up on some callsites
Message-ID: <20090223170528.GH5961@nowhere>
References: <49a1cc8f.2283420a.54d2.ffff8461@mx.google.com> <alpine.DEB.2.00.0902231034570.18221@gandalf.stny.rr.com> <alpine.DEB.2.00.0902231039290.18221@gandalf.stny.rr.com> <20090223162630.GG5961@nowhere> <alpine.DEB.2.00.0902231151020.18221@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0902231151020.18221@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 11:51:30AM -0500, Steven Rostedt wrote:
> 
> On Mon, 23 Feb 2009, Frederic Weisbecker wrote:
> > > 
> > > Perhaps we could add these callsites back, but we would need to update 
> > > trace_wake_up.
> > > 
> > > Have trace_wake_up set a flag instead, and add a tracepoint around the 
> > > scheduler (outside the grabbing of runqueue locks), that will have a 
> > > callback to the tracing code. That call back can perform the wakeups.
> > > 
> > > How does that sound?
> > 
> > 
> > That sounds good but only for these particular tracers I guess.
> 
> OK, what about making a trace_delay_wake_up()?


Which would send a delayed work to wake up?

 
> -- Steve
> 

