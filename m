Return-Path: <linux-kernel-owner+w=401wt.eu-S1758378AbZDPQzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758378AbZDPQzw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 12:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753686AbZDPQzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 12:55:39 -0400
Received: from verein.lst.de ([213.95.11.210]:37823 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537AbZDPQzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 12:55:38 -0400
Date: Thu, 16 Apr 2009 18:53:43 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Frank Ch. Eigler" <fche@elastic.org>
Cc: Theodore Tso <tytso@mit.edu>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>, Jiaying Zhang <jiayingz@google.com>,
       Michael Rubin <mrubin@google.com>, Martin Bligh <mbligh@google.com>
Subject: Re: [PATCH 0/8] [GIT PULL] TRACE_EVENT for modules
Message-ID: <20090416165343.GE5933@lst.de>
References: <20090414172337.280621613@goodmis.org> <20090414210445.GM955@mit.edu> <20090414212917.GA19933@elastic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414212917.GA19933@elastic.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 05:29:17PM -0400, Frank Ch. Eigler wrote:
> Hi -
> 
> On Tue, Apr 14, 2009 at 05:04:45PM -0400, Theodore Tso wrote:
> > [...]
> > One thing which I would really like is to avoid needing to drop the
> > header file in include/trace/<subsystem.h>.
> > 
> > The problem that I have with this is that for ext4, we need to access
> > private data structures which are defined in header files in
> > fs/ext4/*.h --- which we moved into fs/ext4 a long time ago [...]
> 
> If the tracepoints/events expand to code that exposes those private
> structures, then those structures are perhaps not quite so private any
> more.  That argues for moving those headers back under include/..., or
> at least those type decls made reachable from the tracepoints.

They expose them to the TRACE_EVENT output format, which then
pretty-prints them.  They are still as private to the module as it gets.

