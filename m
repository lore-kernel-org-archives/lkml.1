Return-Path: <linux-kernel-owner+w=401wt.eu-S1756030AbYJ3UTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbYJ3UTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 16:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbYJ3UTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 16:19:00 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:33405 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbYJ3UTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 16:19:00 -0400
Date: Thu, 30 Oct 2008 21:20:06 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH][RFC] x86: add non x86 build configuration
Message-ID: <20081030202006.GA1255@uranus.ravnborg.org>
References: <200810281802.m9SI2fYX030138@hera.kernel.org> <20081029091857.GA4414@osiris.boeblingen.de.ibm.com> <alpine.DEB.1.10.0810292139170.6145@gandalf.stny.rr.com> <20081030195107.GK27407@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081030195107.GK27407@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> So please name it something like CONFIG_STANDARD_X86_FEATURES, and 
> also make it depend on CONFIG_EMBEDDED (only allow it to be turned off 
> when EMBEDDED is enabled).

Any chance to introduce a CONFIG_EXPERT option?

CONFIG_EMBEDDED is supposed to be those features that may decrease performance
or functionality but lower the footprint.
And not all the crap it covers today.

	Sam
