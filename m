Return-Path: <linux-kernel-owner+w=401wt.eu-S1751513AbZIOEwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbZIOEwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 00:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbZIOEwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 00:52:33 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:58747 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbZIOEwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 00:52:32 -0400
Date: Tue, 15 Sep 2009 10:22:27 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>, Andi Kleen <ak@linux.intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH tracing/kprobes 4/7] tracing/kprobes: Add event
	profiling support
Message-ID: <20090915045227.GA26458@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20090910235258.22412.29317.stgit@dhcp-100-2-132.bos.redhat.com> <20090910235329.22412.94731.stgit@dhcp-100-2-132.bos.redhat.com> <20090911031253.GD16396@nowhere> <4AAA7938.7070200@redhat.com> <20090914030244.GC14306@nowhere> <4AAE7540.9090009@redhat.com> <20090914185540.GD6045@nowhere> <4AAE9B41.3020905@redhat.com> <20090914210712.GH6045@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090914210712.GH6045@nowhere>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 11:07:13PM +0200, Frederic Weisbecker wrote:
> On Mon, Sep 14, 2009 at 03:36:33PM -0400, Masami Hiramatsu wrote:
> > Frederic Weisbecker wrote:
> >> On Mon, Sep 14, 2009 at 12:54:24PM -0400, Masami Hiramatsu wrote:
> 
> 
> >> There might be some of such factors that would force you to handle a
> >> lot of corner cases, things that you wouldn't need to worry about
> >> if you just had to maintain a simple rcu list of probes to call.
> >
> >
> > Anyway, I never see who are using post_handler:). I'm not sure why
> > it is needed...
> 
> 
> May be it's a legacy of code that was used by the past, in which case
> that could perhaps be cleaned up?

No, kprobe post_handlers are used in various places, especially for
debug purposes. It is part of the ABI and should be retained.

Ananth
