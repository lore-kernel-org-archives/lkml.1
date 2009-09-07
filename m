Return-Path: <linux-kernel-owner+w=401wt.eu-S1752630AbZIGVd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbZIGVd7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 17:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbZIGVd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 17:33:59 -0400
Received: from kroah.org ([198.145.64.141]:51221 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162AbZIGVd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 17:33:58 -0400
Date: Mon, 7 Sep 2009 14:30:47 -0700
From: Greg KH <greg@kroah.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: leemgs1@gmail.com, linux-kernel <linux-kernel@vger.kernel.org>,
       mathieu.desnoyers@polymtl.ca, Steven Rostedt <srostedt@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] debugfs - Fix mount directory of debugfs by
 default in events.txt
Message-ID: <20090907213047.GA28651@kroah.com>
References: <1252327037.2153.96.camel@centos51>
 <1252327737.7959.22.camel@laptop>
 <20090907185513.GA27876@kroah.com>
 <1252350914.7503.24.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252350914.7503.24.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 07, 2009 at 09:15:14PM +0200, Peter Zijlstra wrote:
> On Mon, 2009-09-07 at 11:55 -0700, Greg KH wrote:
> > On Mon, Sep 07, 2009 at 02:48:57PM +0200, Peter Zijlstra wrote:
> > > On Mon, 2009-09-07 at 21:37 +0900, GeunSik Lim wrote:
> > > > 
> > > > >From 99e8ab48d783e619329c31e8f91e4384729a2e8b Mon Sep 17 00:00:00 2001
> > > > From: GeunSik,Lim <leemgs1@gmail.com>
> > > > Date: Mon, 7 Sep 2009 20:34:19 +0900
> > > > Subject: [PATCH 1/5] Fix mount directory of debugfs by default in events.txt
> > > > 
> > > > We need common default directory of denbugfs for consistency.
> > > > (debugfs's default directory is /sys/kernel/debug/ by debugfs.)
> > > 
> > > I'd rather we fix that brain-dead default.
> > 
> > Um, why is that "brain-dead"?  It was discussed many times when debugfs
> > first came out and this was what was decided on.
> 
> From what people tell me it wasn't a clear consensus.

Specifics please.

> > So what is the problem?
> 
> Its not related to sysfs in any way I can discover,

So, other filesystems are mounted in sysfs, and in /proc for many years.

> its not consistent with most of the other virtual fs',

What do you mean by this?

> and its way too much typing.

tab completion is your friend, as is environment variables.  Don't
choose stuff just because you are lazy :)

> we don't mount /dev, /proc, /sys in weird places either, so why should
> we mount /debug in a cumbersome location.

Because it is a _kernel_ debug thing, not a system-level debug thing.
What would userspace developers think about /debug ?  Why would they
care about such a thing?

As much as we tend to ignore it, kernel developers are not the primary,
or only, users of Linux :)

thanks,

greg k-h
