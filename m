Return-Path: <linux-kernel-owner+w=401wt.eu-S1761581AbXKMV4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761581AbXKMV4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 16:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759560AbXKMV4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 16:56:08 -0500
Received: from ns2.g-housing.de ([81.169.133.75]:41003 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759357AbXKMV4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 16:56:07 -0500
Date: Tue, 13 Nov 2007 22:56:01 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [BUG] New Kernel Bugs
In-Reply-To: <20071113130411.26ccae12.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.0.99999.0711132239350.3960@sheep.housecafe.de>
References: <20071113034916.2556edd7.akpm@linux-foundation.org> <20071113.035824.40509981.davem@davemloft.net> <20071113041259.79c9a8c5.akpm@linux-foundation.org> <20071113.043207.44732743.davem@davemloft.net> <20071113110259.44c56d42.akpm@linux-foundation.org>
 <alpine.DEB.0.9999.0711132055550.7865@sheep.housecafe.de> <20071113130411.26ccae12.akpm@linux-foundation.org>
User-Agent: Alpine 0.99999 (DEB 796 2007-11-08)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007, Andrew Morton wrote:
> There are a number of process things we _could_ do.  Like
> - have bugfix-only kernel releases

Adrian Bunk does (did?) this with 2.6.16.x, although it always seemed to 
me like an unrewarded one man show. AFAIK not even the big distros are 
begging for bugfix-only versions, as they too want to have (sell) new 
features. Mission critical systems might want to require such versions, 
but I guess they're using heavily customized trees anyway.

> - Just refuse to merge any non-bugfix patches for a subsystem when it is
>  determined that the subsystem has "too many" regressions.

Hm, that's what I had in mind. Has this been tried already?

> - Create an "if you added a regression, you should fix some other bug
>  too" rule.

Naah, I'm not really in favour of blaming someone. The kernel doesn't have 
SLA contracts (yet), so no need for giving out penalties :)

> But we can't/shouldn't do any of that until it is generally agreed that we
> have a problem and that the problem is of sufficient magnitude that process
> changes are needed to address it.  We aren't at that stage yet.

Keeping track of the (number of) regressions / bugs each release seems to 
be a good start, IMHO.

> process changes, they all would be aimed at a single thing: shifting some
> of the developers' time away from <otherstuff> and onto bugfixing.

True. Implementing "only bugfixes from now on" (i.e. a longer 
freeze-window) would perhaps speed up the shifting a bit: $developer can 
still do $otherstuff all day long, but it won't get merged anyway, because 
we're in "only bugfixes from now on"-mode.

> At this stage the only tool which is being deployed to attempt to bring
> about that reprioritisation is suasion.  aka "lkml flamewar".

True. But I just noticed that I have to distinguish between 
"flamewars" and "fierce discussions": if I'd imagine a room with ~50 
developers/bystanders brainstorming on a issue like this (at the same 
time, without the wonderful delay of writing/sending an email), it'd
feel much more uncomfortable.

Christian.
-- 
BOFH excuse #433:

error: one bad user found in front of screen
