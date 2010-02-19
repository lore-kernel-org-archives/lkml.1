Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab0BSVhT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 16:37:19 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:23562 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab0BSVhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 16:37:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=U8+GgM7RhDUQcKG1wKEi/Di1qfzdOoXe+LB6TPFYNmXSvqU1caKWF5wMtjpQkfJHDJ
         gTh52T+mY4eWwmtsMIi9HtTKYoJG5yS1uoKRQcJ3SmUk4tnO1Rm24jfNPu4+CrQFOTyz
         m1/dGmkqGbjeWtT/zma1Y2tDtkX4ZCYzQEgPQ=
Date: Fri, 19 Feb 2010 22:37:12 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com, Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH 00/12] perf trace: Python scripting support
Message-ID: <20100219213707.GA6991@nowhere>
References: <1264580883-15324-1-git-send-email-tzanussi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264580883-15324-1-git-send-email-tzanussi@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 02:27:51AM -0600, Tom Zanussi wrote:
> This patchset adds a Python scripting engine to perf trace.  In the
> process, it also creates a scripting-engines directory under perf/util
> and moves the existing Perl support there, to avoid cluttering the
> main perf/util directory with scripting support files.
> 
> It also includes some minor bugfixes and adds Documentation for the
> Python support, which includes a step-by-step example detailing how to
> write a new trace stream processing script using Python.
> 
> Finally, it adds several new scripts, all dealing with aggregation of
> system call trace data.  To make those scripts more user-friendly, it
> adds a couple patches that export some of the syscall metadata, enough
> to allow syscall names rather than raw numbers to be printed in the
> output.


Sorry to answer that late.

This looks very nice! And seeing how you made it easy to plug
new languages, and how easy it is to write trace report scripts,
this looks like a cool new step for the tracing over perf tools.

Focusing on scripts to post-process the tracing will certainly
accelerate the movement in this area.

I've looked at some patches in the set, this looks good at
a first glance. I'll review it in detail and test it, and
then apply/push it if I don't encounter problems.

Thanks a lot!

