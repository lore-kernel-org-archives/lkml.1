Return-Path: <linux-kernel-owner+w=401wt.eu-S1752744AbZIZO4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbZIZO4u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 10:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbZIZO4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 10:56:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47263 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952AbZIZO4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 10:56:48 -0400
Date: Sat, 26 Sep 2009 16:56:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dan Smith <danms@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oren Laadan <orenl@librato.com>,
       linux-api@vger.kernel.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       torvalds@linux-foundation.org, xemul@openvz.org
Subject: Re: [PATCH 00/80] Kernel based checkpoint/restart [v18]
Message-ID: <20090926145606.GA30071@elte.hu>
References: <1253749920-18673-1-git-send-email-orenl@librato.com> <20090924154139.2a7dd5ec.akpm@linux-foundation.org> <87ljk39lcl.fsf@caffeine.danplanet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ljk39lcl.fsf@caffeine.danplanet.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dan Smith <danms@us.ibm.com> wrote:

> >> Q: What additional work needs to be done to it?  A: Fill in the
> >> gory details following the examples so far. Current WIP includes
> >> inet sockets, event-poll, and early work on inotify, mount
> >> namespace and mount-points, pseudo file systems
> 
> AM> Will this new code muck up the kernel, or will it be clean?
> 
> I have (and have previously posted) prototype code to do c/r of open 
> sockets, ignoring some things like updating timers and such.  It looks 
> rather similar to the existing UNIX bits, and is even easier in some 
> ways.
> 
> One particular use case is only migrating listening sockets and 
> allowing the connected ones to be reset upon restart.  That enables a 
> bunch of things like apache, postfix, vncserver, and even sshd.  I 
> will pull the listen-only bits out of my current patch, scrape off a 
> little bitrot, and post them in a few days.

That looks useful. (Btw., the other four questions Andrew asked look 
relevant too.)

	Ingo
