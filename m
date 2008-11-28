Return-Path: <linux-kernel-owner+w=401wt.eu-S1752365AbYK1M6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365AbYK1M6m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 07:58:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752502AbYK1M6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 07:58:14 -0500
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:42955 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752409AbYK1M6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 07:58:11 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAOx1L0lMROB9/2dsb2JhbACBbc82gn0
Date: Fri, 28 Nov 2008 07:58:09 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Sam@smtp.polymtl.ca,
       Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, ltt-dev@lists.casi.polymtl.ca,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [ltt-dev] LTTng kernel integration roadmap, update
Message-ID: <20081128125809.GB10401@Krystal>
References: <20081124112842.GA15615@Krystal> <20081124114124.GA32459@infradead.org> <20081124122055.GA18626@Krystal> <alpine.DEB.1.10.0811241156030.20122@gandalf.stny.rr.com> <20081125055744.c3377164.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081125055744.c3377164.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 07:56:35 up 11 days, 13:37,  2 users,  load average: 0.13, 0.44,
	0.66
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Mon, 24 Nov 2008 11:58:40 -0500 (EST) Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > > The question that prevails is therefore : should we ship userspace
> > > binary with the kernel tree at all ? And if yes, how should the resuting
> > > executables be packaged and deployed ? Should it be installed in the
> > > system along with kernel modules or should it be populated into a
> > > filesystem populated by kernelspace ?
> > > 
> > > Or is it better to do as we have always done and keep the userspace
> > > tools separated from the kernel tree ?
> > 
> > I say keep the user space tools separate as much as possible.
> 
> So...  we're now planning to build even more userspace tools into the
> kernel merely because we don't know how to deliver userspace tools in
> userspace?
> 
> Worse, those kernel-based userspace tools will simply be presenting a
> textual form of something which the kernel already makes available in a
> binary form?
> 
> This is so lame.
> 
> Any proposal to fix all this will result in vast amounts of
> inconclusive chin-scratching again.  Last time this came up, we ended
> up with the old impractical put-it-in-util-linux chestnut.  I think the
> time has come for us to admit that this isn't working out.
> 
> Mathieu, if you're feeling keen I'd suggest that you just type `mkdir
> -p userspace/lttng' and build your userspace tools in there.  One they
> are there and real, the issues around versioning, installation and
> delivery will still need tobe sorted out, but we need to start
> somewhere.
> 

Yes, I like the idea of having a kernel-developer oriented version of
the userspace tools, which may not have packaging requirements as strong
as standard userspace packages. Just keeping them around with the kernel
build tree would be a good start, and we could probably go as far as
installing them along with the kernel modules in /lib/modules/`uname
-r`.

Mathieu


> 
> _______________________________________________
> ltt-dev mailing list
> ltt-dev@lists.casi.polymtl.ca
> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
