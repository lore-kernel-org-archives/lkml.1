Return-Path: <linux-kernel-owner+w=401wt.eu-S1761780AbYEXUoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761780AbYEXUoP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 16:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbYEXUn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 16:43:59 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:42804 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608AbYEXUn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 16:43:58 -0400
Date: Sat, 24 May 2008 22:44:38 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [RFC PATCH] kconfig: introduce KCONFIG_* symbols for .c files
Message-ID: <20080524204438.GA3136@uranus.ravnborg.org>
References: <20080524192540.GA28067@uranus.ravnborg.org> <20080524200523.GB2308@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080524200523.GB2308@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> If you really want to be able to transform all #if's in .c files to 
> if()'s you also have to offer a variant of our MODULE #define.
1) I have no pland to replace the current CONFIG_ use.
2) I do not follow whay you try to say about our "MODULE #define"

> >...
> 
> Also an error message if if the varible is not currently available on 
> this architecture (e.g. KCONFIG_ISA on ia64).
> 
> Not an unsolvable problem, but something that has to be taken care of.

My master plan is to have a single configuration for the kernel
and not as today where we have one configuration for each architecture.

How far away we are from that I dunno. It is a while I visited this.
And I will not have time to do so anytime soon I'm afraid.

	Sam
