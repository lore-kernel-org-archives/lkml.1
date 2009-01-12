Return-Path: <linux-kernel-owner+w=401wt.eu-S1755387AbZALSnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbZALSnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 13:43:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbZALSnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 13:43:43 -0500
Received: from casper.infradead.org ([85.118.1.10]:51647 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbZALSnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 13:43:42 -0500
Subject: Re: [PATCH 22/24] i386: add TRACE_IRQS_OFF for the nmi
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: heukelum@fastmail.fm, linux-kernel@vger.kernel.org, ak@suse.de,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
In-Reply-To: <20090112183904.GC12249@elte.hu>
References: <1220990178-29773-15-git-send-email-heukelum@fastmail.fm>
	 <1220990178-29773-16-git-send-email-heukelum@fastmail.fm>
	 <1220990178-29773-17-git-send-email-heukelum@fastmail.fm>
	 <1220990178-29773-18-git-send-email-heukelum@fastmail.fm>
	 <1220990178-29773-19-git-send-email-heukelum@fastmail.fm>
	 <1220990178-29773-20-git-send-email-heukelum@fastmail.fm>
	 <1220990178-29773-21-git-send-email-heukelum@fastmail.fm>
	 <1220990178-29773-22-git-send-email-heukelum@fastmail.fm>
	 <1220990178-29773-23-git-send-email-heukelum@fastmail.fm>
	 <1231780911.4371.196.camel@laptop>  <20090112183904.GC12249@elte.hu>
Content-Type: text/plain
Date: Mon, 12 Jan 2009 19:43:35 +0100
Message-Id: <1231785815.4371.205.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-12 at 19:39 +0100, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Tue, 2008-09-09 at 21:56 +0200, heukelum@fastmail.fm wrote:
> > > From: Alexander van Heukelum <heukelum@fastmail.fm>
> > > 
> > > At this point interrupts are off, so let's inform the tracing
> > > code of that fact before calling into C.
> > 
> > Sorry but this is an obvious dud, lockdep (and thus the irq state
> > tracer) aren't nmi safe.
> > 
> > Ingo, please revert, as people are already seeing lockdep warnings due
> > to this.
> 
> done - reverted it in tip/x86/urgent, see the commit below. Is that all 
> that we need, wasnt there a 64-bit side done too?

I had a _very_ quick peek but couldn't fine one, Alexander, does your
memory go back that far? :-)


