Return-Path: <linux-kernel-owner+w=401wt.eu-S1757307AbYE0K3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbYE0K3u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 06:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756193AbYE0K3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 06:29:40 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:41430 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756136AbYE0K3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 06:29:39 -0400
Date: Tue, 27 May 2008 13:26:54 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC: 2.6 patch] let GROUP_SCHED depend on BROKEN
Message-ID: <20080527102654.GB20938@cs181133002.pp.htv.fi>
References: <20080527085830.GA20938@cs181133002.pp.htv.fi> <1211881658.6742.20.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1211881658.6742.20.camel@marge.simson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2008 at 11:47:38AM +0200, Mike Galbraith wrote:
>...
> <quote>
> config EXPERIMENTAL
> 	bool "Prompt for non-development and/or absolutely complete code/drivers"
 	---help---
> 	  Some of the various things that Linux supports (such as network
> 	  drivers, file systems, network protocols, etc.) can be in a state
> 	  of development where the functionality, stability, or the level of
> 	  testing is not yet high enough for general use. This is usually
> 	  known as the "alpha-test" phase among developers. If a feature is
> 	  currently in alpha-test, then the developers usually discourage
> 	  uninformed widespread use of this feature by the general public to
> 	  avoid "Why doesn't this work?" type mail messages. However, active
> 	  testing and use of these systems is welcomed. Just be aware that it
>...

If you take this text seriously then companies like Redhat advertise 
their enterprise distributions with alpha-test quality software...

Facts are:
- as long as we allow hardware drivers to depend on EXPERIMENTAL we
  force many users to enable EXPERIMENTAL
- the EXPERIMENTAL dependencies in many areas of the kernel are so
  out of sync with the actual code quality that the presence or absence
  of such a dependency isn't a clear indication of the current status

> 	-Mike

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

