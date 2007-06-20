Return-Path: <linux-kernel-owner+w=401wt.eu-S1755465AbXFTWAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbXFTWAL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 18:00:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbXFTV7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 17:59:44 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:63126 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752502AbXFTV7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 17:59:42 -0400
Date: Wed, 20 Jun 2007 17:59:27 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Adrian Bunk <bunk@stusta.de>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/9] Conditional Calls - Architecture Independent Code
Message-ID: <20070620215927.GA25495@Krystal>
References: <20070530140025.917261793@polymtl.ca> <20070530140227.070136408@polymtl.ca> <20070604190102.GY5500@stusta.de> <20070613155724.GA8703@Krystal> <20070613215104.GK3588@stusta.de> <20070614160241.GA21119@Krystal> <20070614210643.GW3588@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070614210643.GW3588@stusta.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:46:52 up 23 days,  6:25,  4 users,  load average: 0.55, 0.39, 0.39
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Adrian Bunk (bunk@stusta.de) wrote:
> On Thu, Jun 14, 2007 at 12:02:42PM -0400, Mathieu Desnoyers wrote:
> >...
> > Well, we must take into account where these markers are added and how
> > often the marked code is run. Since I mark very highly used code paths
> > (interrupt handlers, page faults, lockdep code) and also plan to mark
> > other code paths like the VM subsystem, adding cycles to these code
> > paths seems like a no-go solution for standard distribution kernels.
> >...
> > People can get really picky when they have to decide wether or not they
> > compile-in a profiling or tracing infrastructure in a distribution
> > kernel.  If the impact is detectable when they are not doing any tracing
> > nor profiling, their reflex will be to compile it out so they can have
> > the "maximum performance". This is why I am going through the trouble of
> > making the markers impact as small as possible.
> 
> Now that we finally hear what this code is required for, can we discuss 
> on this basis whether this is wanted and required?
> 
> Including the question which abuse possibilities such an infrastructure 
> offers, and whether this is wanted in distribution kernels.
> 

Hi Adrian,

The purpose of this infrastructure has never been a secret; it is a
piece taken from the Linux Kernel Markers. I proposed the first
implementation of markers in December 2006.

Please use the following link as a starting point to the thorough
discussion that has already been held on this matter.

First, a huge discussion thread back in November 2006, where the need
for a marker infrastructure has been recognized:
http://lwn.net/Articles/200059/

A good summary of my recent previous post on kerneltrap:
http://kerneltrap.org/node/8186

If you have new specific concerns to bring forward, I will be glad to
discuss them with you.

Regards,

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
