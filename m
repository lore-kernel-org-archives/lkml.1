Return-Path: <linux-kernel-owner+w=401wt.eu-S1756193AbZDNWAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbZDNWAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 18:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbZDNWAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 18:00:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:48743 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbZDNWAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 18:00:31 -0400
Date: Tue, 14 Apr 2009 18:00:26 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Frank Ch. Eigler" <fche@elastic.org>
cc: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
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
In-Reply-To: <20090414212917.GA19933@elastic.org>
Message-ID: <alpine.DEB.2.00.0904141800010.31421@gandalf.stny.rr.com>
References: <20090414172337.280621613@goodmis.org> <20090414210445.GM955@mit.edu> <20090414212917.GA19933@elastic.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 14 Apr 2009, Frank Ch. Eigler wrote:

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

I think those headers are fine. This must also work when ext4 is a module.

-- Steve

