Return-Path: <linux-kernel-owner+w=401wt.eu-S1755996AbZIKTPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbZIKTPN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 15:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754411AbZIKTPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 15:15:09 -0400
Received: from mail-ew0-f227.google.com ([209.85.219.227]:41440 "EHLO
	mail-ew0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbZIKTPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 15:15:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sZ7fk8OP7k82ZYOdzhCGgc5P4+j6FxauQc9tlqF0IOuaO0rdhGaVe4vW1tXiiJgmdr
         ES2IhNpFUG79InYNUliV9esBsSzpRU3z/zoyu2ECjBM95Utkzkr/nwbYhrqwGbTAbVG0
         ZDoDr6qRkOgvaQn5CFNfOIGmp+fRsG39KqBiQ=
Date: Fri, 11 Sep 2009 21:15:04 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH tracing/kprobes 0/7] tracing/kprobes: kprobe-based
	event tracer update and perf support
Message-ID: <20090911191502.GB4993@nowhere>
References: <20090910235258.22412.29317.stgit@dhcp-100-2-132.bos.redhat.com> <20090911013332.GB16396@nowhere> <y0mr5udjoc8.fsf@fche.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <y0mr5udjoc8.fsf@fche.csb>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11, 2009 at 03:03:35PM -0400, Frank Ch. Eigler wrote:
> Frederic Weisbecker <fweisbec@gmail.com> writes:
> 
> > [...]  I'm really looking forward seeing this C expression-like
> > kprobe creation tool.  It seems powerful enough to replace printk +
> > kernel rebuild.  No need anymore to write some printk to debug,
> > worrying, [...]
> 
> To a large extent, systemtap had delivered this already some years
> ago, including the cushy ponies dancing in the sunlight.  While such
> low-level machinery is fine, some of our experience indicates that it
> is dramatically easier to use if high-level, symbolic, debugging data
> is used to compute probe locations and variable names/types/locations.
> 
> It is also too easy to stress the low-level machinery beyond its
> humble origins, in this case meaning putting probes in all kinds of
> tender spots that go "ouch".  The kprobes robustness patches coming in
> are great and will benefit all of our efforts, but it will be awhile
> until the kernel can survive a fuzz/crashme type stress test on that
> subsystem.  So expect ongoing effort there.


Fully agreed! The more I see corner recursivity cases, the more I think
we'll never fix every potential cases. But yeah it's worth trying to
fix all of them that are reported/anticipated, the more such case
are covered, the more it's usable.

