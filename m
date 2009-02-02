Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620AbZBBGC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbZBBGC6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 01:02:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755022AbZBBGCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 01:02:40 -0500
Received: from gate.crashing.org ([63.228.1.57]:43890 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754903AbZBBGCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 01:02:39 -0500
Subject: Re: [RFC][PATCH] create workqueue threads only when needed
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20090201211909.37c0780b@infradead.org>
References: <20090127001708.GA4815@nowhere>
	 <20090126163015.7f879b18@infradead.org> <20090131180347.GC5884@nowhere>
	 <20090131101502.7ce8e7af@infradead.org> <20090131182843.GD5884@nowhere>
	 <1233524261.18767.60.camel@pasglop> <20090201211909.37c0780b@infradead.org>
Content-Type: text/plain
Date: Mon, 02 Feb 2009 17:01:11 +1100
Message-Id: <1233554471.18767.72.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-02-01 at 21:19 -0800, Arjan van de Ven wrote:
> On Mon, 02 Feb 2009 08:37:41 +1100
> Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> 
> > 
> > > I don't know, most of those I've looked on are not documented about
> > > the reason for a private workqueue. I guess most of them can use
> > > the usual kevent.
> > 
> > The main problem with kevent is that it gets clogged up.
> > 
> > That's were thread pools kick in ... tried using Dave Howells slow
> > work ?
> 
> async function calls are pretty much the same and actually in mainlinme.
> Dave Howells stuff in addition plays some extremely weird refcounting
> games that I cannot imagine anyone but him needing...

I missed that new shinny stuff, I'll have a look.

Cheers,
Ben.

