Return-Path: <linux-kernel-owner+w=401wt.eu-S1752983AbYKYT3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbYKYT3I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 14:29:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751083AbYKYT24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 14:28:56 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:48104 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbYKYT2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 14:28:55 -0500
Date: Tue, 25 Nov 2008 20:30:17 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Christoph Hellwig <hch@infradead.org>, ltt-dev@lists.casi.polymtl.ca,
       Zhaolei <zhaolei@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: LTTng kernel integration roadmap, update
Message-ID: <20081125193017.GA6550@uranus.ravnborg.org>
References: <20081124112842.GA15615@Krystal> <20081124114124.GA32459@infradead.org> <20081124122055.GA18626@Krystal> <alpine.DEB.1.10.0811241156030.20122@gandalf.stny.rr.com> <20081125055744.c3377164.akpm@linux-foundation.org> <20081125154011.GA4883@uranus.ravnborg.org> <20081125175937.GA525@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081125175937.GA525@mit.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 12:59:37PM -0500, Theodore Tso wrote:
> On Tue, Nov 25, 2008 at 04:40:11PM +0100, Sam Ravnborg wrote:
> > > 
> > > Mathieu, if you're feeling keen I'd suggest that you just type `mkdir
> > > -p userspace/lttng' and build your userspace tools in there.
> > 
> > Maybe this can help...
> > 
> > 	Sam
> > 
> > diff --git a/usr/lttng/Makefile b/usr/lttng/Makefile
> > new file mode 100644
> > index 0000000..8667998
> > --- /dev/null
> > +++ b/usr/lttng/Makefile
> > @@ -0,0 +1,4 @@
> > +
> > +always := ltt
> > +
> > +hostprogs-y := ltt
> 
> hostprogs are intended to be run on the host during the compilation
> process, right?  What we really want is something that allows us to
> build userspace programs intended for use on the target, not the host,
> since they aren't going to be used when the system is compiled, but
> when the system is run.

Yes. And if this fly I will add support for that.
The majority build their kernel on the same host where they run it,
or at least a binary compatible host.

> 
> This also brings up some interesting questions such as where would we
> install these userspace programs (which could be kernel version
> specific), and how they would be packaged.
We already have similar userspace tools which we have no problem distributing.
Think of checkpatch, bloat-o-meter, cleanfile etc.

They happens to be scripts and not binaries. But otherwise I 
see no big difference.

	Sam
