Return-Path: <linux-kernel-owner+w=401wt.eu-S1755526AbXFNVG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbXFNVG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 17:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756662AbXFNVGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 17:06:31 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35328 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756645AbXFNVGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 17:06:30 -0400
Date: Thu, 14 Jun 2007 23:06:43 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/9] Conditional Calls - Architecture Independent Code
Message-ID: <20070614210643.GW3588@stusta.de>
References: <20070530140025.917261793@polymtl.ca> <20070530140227.070136408@polymtl.ca> <20070604190102.GY5500@stusta.de> <20070613155724.GA8703@Krystal> <20070613215104.GK3588@stusta.de> <20070614160241.GA21119@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070614160241.GA21119@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 12:02:42PM -0400, Mathieu Desnoyers wrote:
>...
> Well, we must take into account where these markers are added and how
> often the marked code is run. Since I mark very highly used code paths
> (interrupt handlers, page faults, lockdep code) and also plan to mark
> other code paths like the VM subsystem, adding cycles to these code
> paths seems like a no-go solution for standard distribution kernels.
>...
> People can get really picky when they have to decide wether or not they
> compile-in a profiling or tracing infrastructure in a distribution
> kernel.  If the impact is detectable when they are not doing any tracing
> nor profiling, their reflex will be to compile it out so they can have
> the "maximum performance". This is why I am going through the trouble of
> making the markers impact as small as possible.

Now that we finally hear what this code is required for, can we discuss 
on this basis whether this is wanted and required?

Including the question which abuse possibilities such an infrastructure 
offers, and whether this is wanted in distribution kernels.

> Mathieu

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

