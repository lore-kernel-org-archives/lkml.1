Return-Path: <linux-kernel-owner+w=401wt.eu-S932097AbXDKT0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097AbXDKT0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 15:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932112AbXDKT0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 15:26:35 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:54136 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932097AbXDKT0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 15:26:34 -0400
Date: Wed, 11 Apr 2007 15:21:22 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>,
       "Frank Ch. Eigler" <fche@redhat.com>, systemtap@sources.redhat.com
Subject: Re: [PATCH] markers-linker-generic
Message-ID: <20070411192122.GA4668@Krystal>
References: <20070410223658.GC7092@Krystal> <20070411074414.GC3752@flint.arm.linux.org.uk> <20070411175110.GA30879@Krystal> <20070411110240.537ee25d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070411110240.537ee25d.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 15:07:40 up 68 days,  9:15,  5 users,  load average: 1.59, 1.62, 1.72
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Wed, 11 Apr 2007 13:51:11 -0400
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > > What's this marker stuff about?
> > > 
> > 
> > Hi Russel,
> > 
> > Here is an overview :
> 
> I am told that the systemtap developers plan to (or are) using this
> infrastructure.
> 

Quoting Frank Ch. Eigler, from the SystemTAP team :

"The LTTng user-space programs use it today.  Systemtap used to support
the earlier marker prototype and will be rapidly ported over to this
new API upon acceptance."


> If correct: what is their reason for preferring it over kprobes?
> 

I will let them answer on this one..

> 
> Secondly, the code in -mm has no actual backend for delivering anything to
> userspace or to anywhere else.  Why is this?

I wanted the community to come to an agreement regarding the
instrumentation mechanism before submitting a data transport backend.

> Which backends currently
> exist, and which ones are envisaged?  Is there a plan to merge any backend
> into the mainline kernel?
> 

Yes. The one I envisage to mainline is LTTng, available there :
http://ltt.polymtl.ca. It aims at providing the lowest system
disturbance and best performances possible, with reentrancy from almost
any kernel call site while keeping the task of adding new
instrumentation as easy as possible for the programmer. The current
patches are against 2.6.21-rc6-mm1. Is comes in small modules easy to
merge incrementally, which should make the whole process easier.

LKET, another tracer built on top of SystemTAP, can also be used to
extract the data to user space.

Mathieu


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
