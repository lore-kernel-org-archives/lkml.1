Return-Path: <linux-kernel-owner+w=401wt.eu-S1756022AbZIKTvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022AbZIKTvx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 15:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755968AbZIKTvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 15:51:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755952AbZIKTvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 15:51:50 -0400
Subject: Re: [PATCH tracing/kprobes 0/7] tracing/kprobes: kprobe-based 
 event tracer update and perf support
From: Mark Wielaard <mjw@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
In-Reply-To: <20090911190651.GA22065@infradead.org>
References: <20090910235258.22412.29317.stgit@dhcp-100-2-132.bos.redhat.com>
	 <20090911013332.GB16396@nowhere> <y0mr5udjoc8.fsf@fche.csb>
	 <20090911190651.GA22065@infradead.org>
Content-Type: text/plain
Date: Fri, 11 Sep 2009 21:50:13 +0200
Message-Id: <1252698613.2470.6.camel@hermans.wildebeest.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-11 at 15:06 -0400, Christoph Hellwig wrote:
> On Fri, Sep 11, 2009 at 03:03:35PM -0400, Frank Ch. Eigler wrote:
> > Frederic Weisbecker <fweisbec@gmail.com> writes:
> > 
> > > [...]  I'm really looking forward seeing this C expression-like
> > > kprobe creation tool.  It seems powerful enough to replace printk +
> > > kernel rebuild.  No need anymore to write some printk to debug,
> > > worrying, [...]
> > 
> > To a large extent, systemtap had delivered this already some years
> > ago, including the cushy ponies dancing in the sunlight.  While such
> > low-level machinery is fine, some of our experience indicates that it
> > is dramatically easier to use if high-level, symbolic, debugging data
> > is used to compute probe locations and variable names/types/locations.
> 
> No, systemtap has been for years failing to delivers this in a way that
> it could be usefully integrated into the kernel.

You are saying "No" to a claim Frank didn't even make.

>   Masami's patches are
> exactly the kind of low-level functionality we absolutely need in the
> kernel tree so that we can built more useful higherlevel tools ontop
> of this. 

And nobody is denying that either. I think everybody agrees that Masami
is doing some really wonderful work and improving the kprobes
foundations in a way that any higher level tracing tool will benefit
from it.

Cheers,

Mark

