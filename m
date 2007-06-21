Return-Path: <linux-kernel-owner+w=401wt.eu-S1756299AbXFUNAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299AbXFUNAe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 09:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbXFUNAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 09:00:25 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35369 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753106AbXFUNAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 09:00:20 -0400
Date: Thu, 21 Jun 2007 15:00:38 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/9] Conditional Calls - Architecture Independent Code
Message-ID: <20070621130037.GM12950@stusta.de>
References: <20070530140025.917261793@polymtl.ca> <20070530140227.070136408@polymtl.ca> <20070604190102.GY5500@stusta.de> <20070613155724.GA8703@Krystal> <20070613215104.GK3588@stusta.de> <20070614160241.GA21119@Krystal> <20070614210643.GW3588@stusta.de> <20070620215927.GA25495@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070620215927.GA25495@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 05:59:27PM -0400, Mathieu Desnoyers wrote:
> * Adrian Bunk (bunk@stusta.de) wrote:
> > On Thu, Jun 14, 2007 at 12:02:42PM -0400, Mathieu Desnoyers wrote:
> > >...
> > > Well, we must take into account where these markers are added and how
> > > often the marked code is run. Since I mark very highly used code paths
> > > (interrupt handlers, page faults, lockdep code) and also plan to mark
> > > other code paths like the VM subsystem, adding cycles to these code
> > > paths seems like a no-go solution for standard distribution kernels.
> > >...
> > > People can get really picky when they have to decide wether or not they
> > > compile-in a profiling or tracing infrastructure in a distribution
> > > kernel.  If the impact is detectable when they are not doing any tracing
> > > nor profiling, their reflex will be to compile it out so they can have
> > > the "maximum performance". This is why I am going through the trouble of
> > > making the markers impact as small as possible.
> > 
> > Now that we finally hear what this code is required for, can we discuss 
> > on this basis whether this is wanted and required?
> > 
> > Including the question which abuse possibilities such an infrastructure 
> > offers, and whether this is wanted in distribution kernels.
> 
> Hi Adrian,

Hi Mathieu,

> The purpose of this infrastructure has never been a secret; it is a
> piece taken from the Linux Kernel Markers. I proposed the first
> implementation of markers in December 2006.
> 
> Please use the following link as a starting point to the thorough
> discussion that has already been held on this matter.
> 
> First, a huge discussion thread back in November 2006, where the need
> for a marker infrastructure has been recognized:
> http://lwn.net/Articles/200059/
> 
> A good summary of my recent previous post on kerneltrap:
> http://kerneltrap.org/node/8186
> 
> If you have new specific concerns to bring forward, I will be glad to
> discuss them with you.

sorry if I was a bit harsh, but at least for me it wasn't clear that the 
main (and perhaps only) reasonable use case for your conditional calls 
was to get markers enabled in distribution kernels.

Please correct me, but my understanding is:
- conditional calls aim at getting markers enabled in distribution
  kernels
- markers are a valuable debugging tool
- you don't need markers during normal operation
- markers allow normal modules doing things they shouldn't be doing,
  implying that markers should _not_ be enabled in normal distribution
  kernels

> Regards,
> 
> Mathieu

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

