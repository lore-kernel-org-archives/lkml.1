Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426Ab0BWRbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 12:31:32 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:41033 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab0BWRb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 12:31:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GMET0hwynBpqrhMZDeT3M4oDWZ+nNjfg3UGaR/B1Zgi7HURugOwONDka7CoUdBSx8M
         q/Kjh34ZuEX0s0K23HSsLNoheclNAdv0z7lEnjwyFumtBC/SYkgyIweAYZNm3HzcZdFB
         lqiEC8SKxDwey7RlUbKgbIQ92KDtDfy5E5nb4=
Date: Tue, 23 Feb 2010 18:31:26 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com, Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH 00/12] perf trace: Python scripting support
Message-ID: <20100223173121.GD5357@nowhere>
References: <1264580883-15324-1-git-send-email-tzanussi@gmail.com> <20100219213707.GA6991@nowhere> <1266702715.6977.13.camel@tropicana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266702715.6977.13.camel@tropicana>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 20, 2010 at 03:51:55PM -0600, Tom Zanussi wrote:
> On Fri, 2010-02-19 at 22:37 +0100, Frederic Weisbecker wrote:
> > On Wed, Jan 27, 2010 at 02:27:51AM -0600, Tom Zanussi wrote:
> > > This patchset adds a Python scripting engine to perf trace.  In the
> > > process, it also creates a scripting-engines directory under perf/util
> > > and moves the existing Perl support there, to avoid cluttering the
> > > main perf/util directory with scripting support files.
> > > 
> > > It also includes some minor bugfixes and adds Documentation for the
> > > Python support, which includes a step-by-step example detailing how to
> > > write a new trace stream processing script using Python.
> > > 
> > > Finally, it adds several new scripts, all dealing with aggregation of
> > > system call trace data.  To make those scripts more user-friendly, it
> > > adds a couple patches that export some of the syscall metadata, enough
> > > to allow syscall names rather than raw numbers to be printed in the
> > > output.
> > 
> > 
> > Sorry to answer that late.
> > 
> > This looks very nice! And seeing how you made it easy to plug
> > new languages, and how easy it is to write trace report scripts,
> > this looks like a cool new step for the tracing over perf tools.
> > 
> > Focusing on scripts to post-process the tracing will certainly
> > accelerate the movement in this area.
> > 
> > I've looked at some patches in the set, this looks good at
> > a first glance. I'll review it in detail and test it, and
> > then apply/push it if I don't encounter problems.
> > 
> 
> No problem, thanks for reviewing them!
> 
> They've been working fine for me - playing with the Python support over
> the past few weeks, I haven't seen any problems, but there's one other
> patch that came up later that you might also want to take a look, with
> the title [PATCH] perf record: filter out perf process tracepoint
> events.  Here's a link to that patch, in case you've lost track of it:
> 
> http://patchwork.kernel.org/patch/76042/
> 
> Thanks,
> 
> Tom


Ah right. Hmm it's a more sensible patch, and not mandatory for
the python scripting support I guess. I'll comment in on its thread.

Thanks (BTW, I've included your change on the Pytuple size).

