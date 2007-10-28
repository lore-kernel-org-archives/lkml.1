Return-Path: <linux-kernel-owner+w=401wt.eu-S1753505AbXJ1Vp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbXJ1Vp6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 17:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbXJ1Vps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 17:45:48 -0400
Received: from twin.jikos.cz ([213.151.79.26]:38397 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144AbXJ1Vpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 17:45:47 -0400
Date: Sun, 28 Oct 2007 22:45:17 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Matthew Wilcox <matthew@wil.cx>
cc: "J. Bruce Fields" <bfields@fieldses.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "George G. Davis" <gdavis@mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC, PATCH] locks: remove posix deadlock detection
In-Reply-To: <20071028213855.769741b6@the-village.bc.nu>
Message-ID: <Pine.LNX.4.64.0710282238580.18815@twin.jikos.cz>
References: <20071017185157.GC3785@mvista.com> <20071018185759.GU3785@mvista.com>
 <20071026170750.GC13033@fieldses.org> <20071026224707.GO13033@fieldses.org>
 <20071028173136.GA16905@fieldses.org> <20071028174321.GB16905@fieldses.org>
 <20071028182732.GK27248@parisc-linux.org> <20071028184052.49abd092@the-village.bc.nu>
 <20071028201101.GA32359@parisc-linux.org> <20071028213855.769741b6@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Oct 2007, Matthew Wilcox wrote:

> You can't fix the false EDEADLK detection without solving the halting
> problem.  Best of luck with that.

Could you please elaborate a little bit more on this? I don't see how 
detecting loops in graph relates to solving halting problem.

Of course the halting problem can be transformed to deadlock-detection 
problem, but this relates to static code analysis, right? Not anything we 
are interested in, i.e. tracking things in runtime and detecting loops in 
simple dependency graphs.

-- 
Jiri Kosina
