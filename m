Return-Path: <linux-kernel-owner+w=401wt.eu-S1762309AbXIXSxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762309AbXIXSxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 14:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756692AbXIXSxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 14:53:15 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:58151 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755772AbXIXSxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 14:53:13 -0400
Date: Mon, 24 Sep 2007 14:53:11 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [patch 4/7] Linux Kernel Markers - Architecture Independent Code
Message-ID: <20070924185311.GD28347@Krystal>
References: <20070924164950.006047409@polymtl.ca> <20070924165427.717587684@polymtl.ca> <20070924174817.GB1608@infradead.org> <20070924184309.GB28347@Krystal> <20070924184522.GA5013@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070924184522.GA5013@infradead.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:52:52 up 56 days, 19:11,  6 users,  load average: 0.79, 1.13, 1.11
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Hellwig (hch@infradead.org) wrote:
> On Mon, Sep 24, 2007 at 02:43:09PM -0400, Mathieu Desnoyers wrote:
> > gcc doesn't like it if I put the attribute after the function in the
> > implementation. Should I leave it before or separate the prototype from
> > the implementation ?
> 
> Just keep it where it was.
> 
> > > There seem to be a lot of exports and some functions that don't seem
> > > to be used by the obvious marker use-cases like your example, blktrace
> > > or sputrace.  Care to explain why we'd really want them or better cut
> > > them out for this first submission?
> > 
> > If you are referring to the exports you just told about in this email,
> > I'll remove them, they are not needed. As for the "marker_get_iter" and
> > friends, they are used to list the markers (I provide a /proc interface
> > to list the markers in the subsequent modules and also use it to dump
> > the marker list in a trace channel at trace start so I can later
> > understand the event data by using the format strings as type
> > identifiers).
> 
> Sounds conceptually fine, but can we introduce this together with
> the actualy users?

Sure, I'll move that down in my patch queue.

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
