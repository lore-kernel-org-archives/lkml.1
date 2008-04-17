Return-Path: <linux-kernel-owner+w=401wt.eu-S1754862AbYDQUQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbYDQUQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 16:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbYDQUQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 16:16:49 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:61684 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753028AbYDQUQs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 16:16:48 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEABpNB0hMROPA/2dsb2JhbACBYKtv
Date: Thu, 17 Apr 2008 16:16:44 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, prasad@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 1/2] Marker probes in futex.c
Message-ID: <20080417201644.GC31616@Krystal>
References: <20080415115058.GA6788@in.ibm.com> <20080415115314.GA6975@in.ibm.com> <1208260942.6395.6.camel@twins> <20080415123233.GA19797@Krystal> <1208264190.6395.21.camel@twins> <20080415132512.GA22351@Krystal> <1208361084.6395.80.camel@twins> <20080417191910.GI28235@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20080417191910.GI28235@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:15:36 up 48 days, 16:26,  4 users,  load average: 0.47, 0.38,
	0.27
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frank Ch. Eigler (fche@redhat.com) wrote:
[..]
> > >﻿+       trace_mark(futex_wake_called, "uaddr:%p fshared:%p nr_wake:%d "
> > > +                       "bitset:%d",
> > > +                       uaddr, fshared, nr_wake, bitset);
> > 
> > > +       INIT_FUTEX_DEBUG_PROBE(futex_wake_called,
> > > +                       "uaddr:%p fshared:%p nr_wake:%d bitset:%d"),
> > 
> > Why the need to duplicate it; that's utter madness.
> 
> This second instance is optional and is used as a consistency check
> for the event consumer to hook up exactly to the intended producer.
> The string could be empty.
> 

empty -> NULL , yes :)

> 
> - FChE

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
