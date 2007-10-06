Return-Path: <linux-kernel-owner+w=401wt.eu-S1764395AbXJFQEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764395AbXJFQEE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 12:04:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760302AbXJFQDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 12:03:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38283 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760238AbXJFQDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 12:03:53 -0400
Date: Sat, 6 Oct 2007 09:03:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Verych <olecom@flower.upol.cz>
cc: Roman Zippel <zippel@linux-m68k.org>,
       "Elyse M. Grasso" <emgrasso@data-raptors.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Eric Van Hensbergen <ericvh@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net,
       Andreas Herrmann <aherrman@arcor.de>
Subject: Re: A bit of kconfig rewrite (Re: [PATCH] 9p: fix compile error if
 !CONFIG_SYSCTL)
In-Reply-To: <20071006152614.GC22435@flower.upol.cz>
Message-ID: <alpine.LFD.0.999.0710060900040.23684@woody.linux-foundation.org>
References: <20070918080537.GA14882@devil> <alpine.LFD.0.999.0709280728170.3579@woody.linux-foundation.org>
 <200709281005.34001.nickpiggin@yahoo.com.au> <200709281112.52844.emgrasso@data-raptors.com>
 <E1IcFgK-0005oI-5p@flower> <Pine.LNX.4.64.0710050408550.1819@scrub.home>
 <20071006152614.GC22435@flower.upol.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 6 Oct 2007, Oleg Verych wrote:
> 
> Thanks. I will be specific, after i will finish, what i already have,
> to make air a bit less hot. Of course everything will be back
> compatible, so nothing to worry about (the rewrite).

Qutie frankly, this kind of "I'll tell you more when I'm done" is not 
generally a very working approach. 

If it's all backwards-compatible with the current Kconfig format, I guess 
it's not too bad, but historically speaking, the people who went off on 
their own and redesigned something from scratch have not been successful 
(and the CML2 thing is a good example of that).

Incremental improvements actually tend to do better than "redesign".  
That's largely true outside of computer science too..

		Linus
