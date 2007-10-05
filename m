Return-Path: <linux-kernel-owner+w=401wt.eu-S1758024AbXJECjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024AbXJECjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 22:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751484AbXJECjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 22:39:07 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:2601 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421AbXJECjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 22:39:06 -0400
Date: Fri, 5 Oct 2007 04:35:41 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Oleg Verych <olecom@flower.upol.cz>
cc: "Elyse M. Grasso" <emgrasso@data-raptors.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Eric Van Hensbergen <ericvh@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net,
       Andreas Herrmann <aherrman@arcor.de>
Subject: Re: [kbuild-devel] A bit of kconfig rewrite (Re: [PATCH] 9p: fix
 compile error if !CONFIG_SYSCTL)
In-Reply-To: <E1IcFgK-0005oI-5p@flower>
Message-ID: <Pine.LNX.4.64.0710050408550.1819@scrub.home>
References: <20070918080537.GA14882@devil> <alpine.LFD.0.999.0709280728170.3579@woody.linux-foundation.org>
 <200709281005.34001.nickpiggin@yahoo.com.au> <200709281112.52844.emgrasso@data-raptors.com>
 <E1IcFgK-0005oI-5p@flower>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 1 Oct 2007, Oleg Verych wrote:

> Today's kconfig was proposed and accepted in a very unpleasant
> circumstances, has very poor design, development and no working
> alternative (for 5+ years now).

If you want to make such statements, you have to offer a little more than 
the hot air you're producing right now...
If you want to improve the design, you're more than welcome. I'm the first 
one to admit that there's still lots of room for improvement, but if you 
want to claim this can only be done via a rewrite, then you have to be 
a lot more specific what's wrong the current design and why it's 
unfixable.
Quite some thought has been put into this design and if you were a little 
more specific, I could actually tell you why it is this way and maybe how 
to improve it incrementally instead of trying to reinvent everything.

>   + shell-like[0] (not like CML1, which is just shell) scripting, allowing
>     to extend easily (if there is no one available) capabilities,
>     config values or actions for particular sub-system or compilation
>     unit,

Just to pick this one point as example: I like scripting and maybe I 
should just update the swig wrapper script I already have and merge it, 
which would make it easier to play with the kconfig database in whatever 
language you like.
OTOH due to the necessary build dependencies I don't see this become a 
mandatory feature, so unless there is a compelling reason a certain set of 
base function will remain in C.

bye, Roman
