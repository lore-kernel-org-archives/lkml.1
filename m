Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbZE3IPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbZE3IPp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 04:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbZE3IPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 04:15:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44560 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbZE3IP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 04:15:29 -0400
Date: Sat, 30 May 2009 04:15:26 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH -tip v8 7/7] tracing: add kprobe-based event tracer
Message-ID: <20090530081526.GC15755@infradead.org>
References: <20090529000326.17532.70868.stgit@localhost.localdomain> <20090529000353.17532.71995.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090529000353.17532.71995.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 08:03:53PM -0400, Masami Hiramatsu wrote:
> Add kprobes-based event tracer on ftrace.

Wouldn't it make more sense to call this the dynamic event tracer?

The use of kprobes is more an implementation detail than something
the user cares about.

