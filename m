Return-Path: <linux-kernel-owner+w=401wt.eu-S1755811AbZAFXjD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811AbZAFXjD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 18:39:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbZAFXix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 18:38:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751677AbZAFXiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 18:38:52 -0500
Date: Tue, 6 Jan 2009 15:38:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: hch@infradead.org, linux-kernel@vger.kernel.org,
       kobayashi.kk@ncos.nec.co.jp
Subject: Re: 2.6.29 -mm merge plans
Message-Id: <20090106153847.df96c8c0.akpm@linux-foundation.org>
In-Reply-To: <20090106232439.GC25103@infradead.org>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org>
	<20090106225744.GA10553@infradead.org>
	<20090106151344.0f146286.akpm@linux-foundation.org>
	<20090106232439.GC25103@infradead.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Jan 2009 18:24:39 -0500
Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, Jan 06, 2009 at 03:13:44PM -0800, Andrew Morton wrote:
> > (cc added)
> > 
> > On Tue, 6 Jan 2009 17:57:44 -0500
> > Christoph Hellwig <hch@infradead.org> wrote:
> > 
> > > On Mon, Jan 05, 2009 at 12:43:00AM -0800, Andrew Morton wrote:
> > > 
> > > > softirq-introduce-statistics-for-softirq.patch
> > > > proc-export-statistics-for-softirq-to-proc.patch
> > > > proc-update-document-for-proc-softirqs-and-proc-stat.patch
> > > 
> > > Why is this in procfs?
> > 
> > softirq stuff in /proc seems appropriate?  It's alongside
> > /proc/interrupts.  We could put it in /trendy-fs-of-the-day, but what
> > would it gain us?
> 
> debugfs seems to be the normal thing for these.

hm.  I'm not a huge fan of debugfs (for other reasons, nicely explained
by Matt Mackall a while back).

But I don't think we actually *gain* anything by putting softirq stats
into debugfs, whereas it makes sense that it lives in /proc?

otoh, the internal implementation might be nicer if it uses debugfs
helper infrastructure.  But the existing code is pretty
straightforward.


