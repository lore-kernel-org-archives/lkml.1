Return-Path: <linux-kernel-owner+w=401wt.eu-S1756329AbZEDTp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329AbZEDTp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 15:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbZEDTpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 15:45:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753848AbZEDTpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 15:45:16 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Dike <jdike@addtoit.com>,
       utrace-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH 0/2] utrace/ptrace: simplify/cleanup ptrace attach
In-Reply-To: Oleg Nesterov's message of  Monday, 4 May 2009 21:30:16 +0200 <20090504193016.GA17076@redhat.com>
References: <20090503185537.GA17071@redhat.com>
	<20090504184951.623CEFC32F@magilla.sf.frob.com>
	<20090504193016.GA17076@redhat.com>
X-Shopping-List: (1) Circular gravy
   (2) Reddy-Mix Enema commendations
   (3) Ingenious carnation exhibitions
   (4) Enchained pompous televangelists
   (5) Antagonistic avaricious frivolity propositions
Message-Id: <20090504194348.BC0EBFC32F@magilla.sf.frob.com>
Date: Mon,  4 May 2009 12:43:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The second patch "ptrace: do not use task_lock() for attach" has nothing
> to do with utrace, and it is really pure ptrace cleanup.

Indeed.

> But it can't be applied to -mm tree, because it (textually) conficts with
> utrace changes in ptrace_attach().

Oh, -mm.  I had not thought about the -mm patch merge order.  I just look
at the whole ptrace-related series from you as an independent series on top
of Linus -current, preceding anything else related.

> > When those are on their way,
> > we'll update the utrace patches not to conflict.  I don't think it makes
> > sense to include utrace.patch's little ptrace.c change in the baseline tree
> > for your ptrace cleanup patches.
> 
> Yes, but in this case, how can we push it before utrace-core.patch ?
> 
> The first patch is only for -mm, to avoid the painful dependencies.

I guess we should take Andrew's advice on this.  To me, it makes most sense
just to order the -mm patches so utrace comes later, and replace the utrace
patch as necessary with a compatible version.  Perhaps things would be
simpler if we made a separate standalone series or git tree (tip/ptrace?)
for ptrace cleanups.


Thanks,
Roland
