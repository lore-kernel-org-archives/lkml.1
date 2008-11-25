Return-Path: <linux-kernel-owner+w=401wt.eu-S1753099AbYKYN6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099AbYKYN6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 08:58:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751007AbYKYN6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 08:58:39 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44145 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750745AbYKYN6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 08:58:39 -0500
Date: Tue, 25 Nov 2008 05:57:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Christoph Hellwig <hch@infradead.org>, ltt-dev@lists.casi.polymtl.ca,
       Zhaolei <zhaolei@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: LTTng kernel integration roadmap, update
Message-Id: <20081125055744.c3377164.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0811241156030.20122@gandalf.stny.rr.com>
References: <20081124112842.GA15615@Krystal>
	<20081124114124.GA32459@infradead.org>
	<20081124122055.GA18626@Krystal>
	<alpine.DEB.1.10.0811241156030.20122@gandalf.stny.rr.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2008 11:58:40 -0500 (EST) Steven Rostedt <rostedt@goodmis.org> wrote:

> > The question that prevails is therefore : should we ship userspace
> > binary with the kernel tree at all ? And if yes, how should the resuting
> > executables be packaged and deployed ? Should it be installed in the
> > system along with kernel modules or should it be populated into a
> > filesystem populated by kernelspace ?
> > 
> > Or is it better to do as we have always done and keep the userspace
> > tools separated from the kernel tree ?
> 
> I say keep the user space tools separate as much as possible.

So...  we're now planning to build even more userspace tools into the
kernel merely because we don't know how to deliver userspace tools in
userspace?

Worse, those kernel-based userspace tools will simply be presenting a
textual form of something which the kernel already makes available in a
binary form?

This is so lame.

Any proposal to fix all this will result in vast amounts of
inconclusive chin-scratching again.  Last time this came up, we ended
up with the old impractical put-it-in-util-linux chestnut.  I think the
time has come for us to admit that this isn't working out.

Mathieu, if you're feeling keen I'd suggest that you just type `mkdir
-p userspace/lttng' and build your userspace tools in there.  One they
are there and real, the issues around versioning, installation and
delivery will still need tobe sorted out, but we need to start
somewhere.

