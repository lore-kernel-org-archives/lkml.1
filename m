Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbXH1RFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbXH1RFJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 13:05:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136AbXH1RE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 13:04:56 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:41316 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbXH1REz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 13:04:55 -0400
Date: Tue, 28 Aug 2007 19:06:04 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@kernel.org>,
       Gabriel C <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org,
       Olaf Hering <olh@suse.de>, netdev@vger.kernel.org
Subject: Re: [-mm patch] make types.h usable for non-gcc C parsers
Message-ID: <20070828170604.GA31284@uranus.ravnborg.org>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <46CC3B27.10604@googlemail.com> <20070827212743.GN4121@stusta.de> <20070828003704.deed71ae.akpm@linux-foundation.org> <20070828144248.GR26410@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070828144248.GR26410@stusta.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> It fixes a bug exposed by a -mm only patch, not by the net tree
> (and 2.6.23-rc3-mm1 doesn't contain the net tree at all).
> 
> > But I'd like a better description, please.  Which "non-gcc parser" are we
> > talking about here?  Something under ./scripts/.  Well, please identify it,
> > and describe what the problem is, and how the proposed patch will address
> > it.
> >...
> 
> It's about parsers like the Sun C compiler and the C parser shipped 
> with genksyms.

So it is about two bugs.
1) kbuild (genksyms) fails to generate CRC for some symbols
2) allow userspace to parse the header

As for 2 we already use sed to remove a lot of stuff in our headers
so why do we use another approach here?

As for 1 I will try to teach genksyms to accept __extension__ but
it seems leess trivial than I expected (most be fooling myself somehow).

	Sam
