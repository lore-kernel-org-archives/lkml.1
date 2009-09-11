Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbZIKTHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbZIKTHH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 15:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754384AbZIKTHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 15:07:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47086 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbZIKTHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 15:07:03 -0400
Date: Fri, 11 Sep 2009 15:06:51 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
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
Message-ID: <20090911190651.GA22065@infradead.org>
References: <20090910235258.22412.29317.stgit@dhcp-100-2-132.bos.redhat.com> <20090911013332.GB16396@nowhere> <y0mr5udjoc8.fsf@fche.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <y0mr5udjoc8.fsf@fche.csb>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
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

No, systemtap has been for years failing to delivers this in a way that
it could be usefully integrated into the kernel.  Masami's patches are
exactly the kind of low-level functionality we absolutely need in the
kernel tree so that we can built more useful higherlevel tools ontop
of this. 

