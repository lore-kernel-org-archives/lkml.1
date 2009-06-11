Return-Path: <linux-kernel-owner+w=401wt.eu-S1756398AbZFKMwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398AbZFKMwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 08:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751807AbZFKMwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 08:52:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44220 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbZFKMwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 08:52:36 -0400
Date: Thu, 11 Jun 2009 08:52:27 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>
Subject: Re: [PATCH][GIT PULL] tracing: do not translate event helper
	macros in print format
Message-ID: <20090611125227.GA14220@infradead.org>
References: <20090609014534.790466803@goodmis.org> <20090609014746.481457542@goodmis.org> <20090609192159.GD6057@nowhere> <20090610094819.GA25527@infradead.org> <20090610101124.GA25042@elte.hu> <alpine.DEB.2.00.0906100812370.30552@gandalf.stny.rr.com> <20090610171648.GD31096@elte.hu> <alpine.DEB.2.00.0906101353200.30552@gandalf.stny.rr.com> <alpine.DEB.2.00.0906101436340.30552@gandalf.stny.rr.com> <20090610204801.GB8147@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090610204801.GB8147@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 10:48:02PM +0200, Ingo Molnar wrote:
> > This looks like it changed more than it really did, I only moved 
> > the one macro above another and added a few lines:
> > 
> >  +#undef __print_symbolic
> >  +#undef __get_dynamic_array
> >  +#undef __get_str

> >     tracing: do not translate event helper macros in print format
> >     
> >     By moving the macro that creates the print format code above the
> >     defining of the event macro helpers (__get_str, __print_symbolic,
> >     and __get_dynamic_array), we get a little cleaner print format.

__print_flags should also be added, shouldn't it?

Maybe also le/be*_to_cpu/cpu_to_le/be*? and major/minor?

We should also document those helpers that need special treatment
somewhere?

