Return-Path: <linux-kernel-owner+w=401wt.eu-S1758919AbXISLSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919AbXISLSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 07:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753720AbXISLSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 07:18:08 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:60681 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753081AbXISLSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 07:18:06 -0400
Date: Wed, 19 Sep 2007 07:18:02 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 3/4] Linux Kernel Markers - Documentation
Message-ID: <20070919111802.GE15500@Krystal>
References: <20070918211324.161373216@polymtl.ca> <20070918211459.816763211@polymtl.ca> <20070918162210.5da258ea.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070918162210.5da258ea.randy.dunlap@oracle.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 07:17:37 up 51 days, 11:36,  3 users,  load average: 1.24, 1.39, 1.29
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Randy Dunlap (randy.dunlap@oracle.com) wrote:
> On Tue, 18 Sep 2007 17:13:27 -0400 Mathieu Desnoyers wrote:
> 
> > Here is some documentation explaining what is/how to use the Linux
> > Kernel Markers.
> > 
> > ---
> > 
> >  Documentation/markers/markers.txt          |   93 +++++++++++++++++++++++++++
> >  Documentation/markers/src/Makefile         |    7 ++
> >  Documentation/markers/src/marker-example.c |   55 ++++++++++++++++
> >  Documentation/markers/src/probe-example.c  |   98 +++++++++++++++++++++++++++++
> >  4 files changed, 253 insertions(+)
> > 
> > Index: linux-2.6-lttng/Documentation/markers/markers.txt
> > ===================================================================
> > --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> > +++ linux-2.6-lttng/Documentation/markers/markers.txt	2007-09-07 09:17:45.000000000 -0400
> > @@ -0,0 +1,93 @@
> 
> > +The marker mechanism supports inserting multiple instances of the same marker.
> > +Markers can be put in inline functions, inlined static functions, and
> > +unrolled loops.
> 
> as well as regular functions ?
> 

Oh, yes, forgot the trivial case ;)

> > +* Probe / marker example
> > +
> > +See the example provided in Documentation/markers/markers/src
> 
>                                        drop one of ^^^ "markers/"
> 

Ok.

Will fix, thanks!

Mathieu

> > +Run, as root :
> > +
> > +make
> > +insmod marker-example.ko (insmod order is not important)
> > +insmod probe-example.ko
> > +cat /proc/marker-example (returns an expected error)
> > +rmmod marker-example probe-example
> > +dmesg
> 
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
