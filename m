Return-Path: <linux-kernel-owner+w=401wt.eu-S1753289AbZBBFTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbZBBFTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 00:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbZBBFTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 00:19:10 -0500
Received: from casper.infradead.org ([85.118.1.10]:50566 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbZBBFTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 00:19:09 -0500
Date: Sun, 1 Feb 2009 21:19:09 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC][PATCH] create workqueue threads only when needed
Message-ID: <20090201211909.37c0780b@infradead.org>
In-Reply-To: <1233524261.18767.60.camel@pasglop>
References: <20090127001708.GA4815@nowhere>
	<20090126163015.7f879b18@infradead.org>
	<20090131180347.GC5884@nowhere>
	<20090131101502.7ce8e7af@infradead.org>
	<20090131182843.GD5884@nowhere>
	<1233524261.18767.60.camel@pasglop>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Feb 2009 08:37:41 +1100
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> 
> > I don't know, most of those I've looked on are not documented about
> > the reason for a private workqueue. I guess most of them can use
> > the usual kevent.
> 
> The main problem with kevent is that it gets clogged up.
> 
> That's were thread pools kick in ... tried using Dave Howells slow
> work ?

async function calls are pretty much the same and actually in mainlinme.
Dave Howells stuff in addition plays some extremely weird refcounting
games that I cannot imagine anyone but him needing...
