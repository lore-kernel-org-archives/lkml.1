Return-Path: <linux-kernel-owner+w=401wt.eu-S1751572AbZIGTPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbZIGTPZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 15:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750869AbZIGTPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 15:15:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:50340 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbZIGTPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 15:15:24 -0400
Subject: Re: [PATCH 1/5] debugfs - Fix mount directory of debugfs by
 default in events.txt
From: Peter Zijlstra <peterz@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: leemgs1@gmail.com, linux-kernel <linux-kernel@vger.kernel.org>,
       mathieu.desnoyers@polymtl.ca, Steven Rostedt <srostedt@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20090907185513.GA27876@kroah.com>
References: <1252327037.2153.96.camel@centos51>
	 <1252327737.7959.22.camel@laptop>  <20090907185513.GA27876@kroah.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 07 Sep 2009 21:15:14 +0200
Message-Id: <1252350914.7503.24.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-07 at 11:55 -0700, Greg KH wrote:
> On Mon, Sep 07, 2009 at 02:48:57PM +0200, Peter Zijlstra wrote:
> > On Mon, 2009-09-07 at 21:37 +0900, GeunSik Lim wrote:
> > > 
> > > >From 99e8ab48d783e619329c31e8f91e4384729a2e8b Mon Sep 17 00:00:00 2001
> > > From: GeunSik,Lim <leemgs1@gmail.com>
> > > Date: Mon, 7 Sep 2009 20:34:19 +0900
> > > Subject: [PATCH 1/5] Fix mount directory of debugfs by default in events.txt
> > > 
> > > We need common default directory of denbugfs for consistency.
> > > (debugfs's default directory is /sys/kernel/debug/ by debugfs.)
> > 
> > I'd rather we fix that brain-dead default.
> 
> Um, why is that "brain-dead"?  It was discussed many times when debugfs
> first came out and this was what was decided on.

>From what people tell me it wasn't a clear consensus.

> So what is the problem?

Its not related to sysfs in any way I can discover, its not consistent
with most of the other virtual fs', and its way too much typing.

we don't mount /dev, /proc, /sys in weird places either, so why should
we mount /debug in a cumbersome location.


