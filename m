Return-Path: <linux-kernel-owner+w=401wt.eu-S1757179AbXFVNVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179AbXFVNVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 09:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbXFVNVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 09:21:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57627 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750718AbXFVNVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 09:21:12 -0400
Date: Fri, 22 Jun 2007 06:13:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mingo@elte.hu, hch@infradead.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, tglx@linutronix.de, johnstul@us.ibm.com,
       oleg@tv-sign.ru, paulmck@linux.vnet.ibm.com, dipankar@in.ibm.com,
       davem@davemloft.net, kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
Message-Id: <20070622061326.2e2d6d15.akpm@linux-foundation.org>
In-Reply-To: <1182517124.5493.38.camel@localhost.localdomain>
References: <20070622040014.234651401@goodmis.org>
	<20070622070948.GA21291@infradead.org>
	<1182515542.5493.20.camel@localhost.localdomain>
	<20070622123805.GA9770@elte.hu>
	<1182517124.5493.38.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 22 Jun 2007 08:58:44 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 2007-06-22 at 14:38 +0200, Ingo Molnar wrote:
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > > And this is something that might be fine for benchmarking, but not something
> > > > we should put in.  Keeping two wildly different implementation of core
> > > > functionality with very different behaviour around is quite bad.  Better
> > > > kill tasklets once for all.
> > > 
> > > Honestly, I highly doubted that this would make it up to Linus's tree.
> > 
> > that's where it belongs - but it first needs the cleanups suggested by 
> > Christoph.
> 
> I had the impression that he didn't want it in, but instead wanted each
> driver to be changed separately.

I do think that would be a better approach.  Apart from the cleanliness
issue, the driver-by-driver conversion would make it much easier to hunt
down any regresions or various funnineses.

