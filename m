Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab0BTVwE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 16:52:04 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:43036 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756466Ab0BTVwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 16:52:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=dyusnaGekbNRdB9ZbKvYrDXtzUj0PAVPrM1j5uZGYx3daTG7kW3vX6io2VM94S0wan
         KtiiuGMbPSKBqOja5X4qtbiNEvjJrxJKWUd9/HdTOFvjaZ2QtpWSvp2vlxvymXFM+DlB
         8V2+1+2Fc/bQflPq5mCDbO/6bycf1zG58qlb8=
Subject: Re: [PATCH 00/12] perf trace: Python scripting support
From: Tom Zanussi <tzanussi@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com, Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
In-Reply-To: <20100219213707.GA6991@nowhere>
References: <1264580883-15324-1-git-send-email-tzanussi@gmail.com>
	 <20100219213707.GA6991@nowhere>
Content-Type: text/plain
Date: Sat, 20 Feb 2010 15:51:55 -0600
Message-Id: <1266702715.6977.13.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-19 at 22:37 +0100, Frederic Weisbecker wrote:
> On Wed, Jan 27, 2010 at 02:27:51AM -0600, Tom Zanussi wrote:
> > This patchset adds a Python scripting engine to perf trace.  In the
> > process, it also creates a scripting-engines directory under perf/util
> > and moves the existing Perl support there, to avoid cluttering the
> > main perf/util directory with scripting support files.
> > 
> > It also includes some minor bugfixes and adds Documentation for the
> > Python support, which includes a step-by-step example detailing how to
> > write a new trace stream processing script using Python.
> > 
> > Finally, it adds several new scripts, all dealing with aggregation of
> > system call trace data.  To make those scripts more user-friendly, it
> > adds a couple patches that export some of the syscall metadata, enough
> > to allow syscall names rather than raw numbers to be printed in the
> > output.
> 
> 
> Sorry to answer that late.
> 
> This looks very nice! And seeing how you made it easy to plug
> new languages, and how easy it is to write trace report scripts,
> this looks like a cool new step for the tracing over perf tools.
> 
> Focusing on scripts to post-process the tracing will certainly
> accelerate the movement in this area.
> 
> I've looked at some patches in the set, this looks good at
> a first glance. I'll review it in detail and test it, and
> then apply/push it if I don't encounter problems.
> 

No problem, thanks for reviewing them!

They've been working fine for me - playing with the Python support over
the past few weeks, I haven't seen any problems, but there's one other
patch that came up later that you might also want to take a look, with
the title [PATCH] perf record: filter out perf process tracepoint
events.  Here's a link to that patch, in case you've lost track of it:

http://patchwork.kernel.org/patch/76042/

Thanks,

Tom

> Thanks a lot!
> 

