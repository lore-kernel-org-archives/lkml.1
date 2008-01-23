Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbYAWRLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbYAWRLx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 12:11:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbYAWRLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 12:11:43 -0500
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:45756 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754631AbYAWRLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 12:11:41 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAC8El0dMQWYq/2dsb2JhbACBV6xm
Date: Wed, 23 Jan 2008 12:11:39 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jon Masters <jonathan@jonmasters.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: CONFIG_MARKERS
Message-ID: <20080123171139.GA22229@Krystal>
References: <1201029235.18144.62.camel@perihelion> <y0modbdnt4e.fsf@ton.toronto.redhat.com> <20080123031005.GA16766@Krystal> <1201061860.25284.28.camel@perihelion> <20080123131442.GA6562@redhat.com> <20080123144811.GA12296@Krystal> <20080123150140.GA14066@Krystal> <1201106023.25284.58.camel@perihelion>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1201106023.25284.58.camel@perihelion>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:08:57 up 80 days, 22:14,  6 users,  load average: 0.23, 0.24,
	0.41
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jon Masters (jonathan@jonmasters.org) wrote:
> On Wed, 2008-01-23 at 10:01 -0500, Mathieu Desnoyers wrote:
> 
> > if (!(mod->taints & (TAINT_FORCED_MODULE | TAINT_PROPRIETARY_MODULE)))
> > 
> > Which remembers me to never write code before my first coffee in the
> > morning ;)
> 
> I switched to decaf and joined a gym...for someone who used to have 23
> shots of espresso some days, it's a change.
> 

I only have two a day, in the morning and exercise regularly. But still,
coding with only one eye opened is not recommended. :)

> But more importantly, are you going to take care of patching this up, or
> shall I send something out? It's up to you.
> 

I would prefer to wait until we have some clear statement on this issue
before I submit a patch (allowing markers in proprietary modules or
not).

As soon as we have an answer, I'll cook the one-liner.

Mathieu

> Jon.
> 
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
