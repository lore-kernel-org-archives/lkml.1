Return-Path: <linux-kernel-owner+w=401wt.eu-S1422804AbXBGXxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422804AbXBGXxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 18:53:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422776AbXBGXxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 18:53:07 -0500
Received: from smtp.osdl.org ([65.172.181.24]:46119 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422804AbXBGXxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 18:53:05 -0500
Date: Wed, 7 Feb 2007 15:52:54 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roman Zippel <zippel@linux-m68k.org>
cc: Oleg Verych <olecom@flower.upol.cz>, Alexey Dobriyan <adobriyan@gmail.com>,
       sam@ravnborg.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kai Germaschewski <kai@germaschewski.name>
Subject: Re: [patch, fix build regression] kbuild: Kbuild.include avoid using
 spaces in call arguments
In-Reply-To: <Pine.LNX.4.64.0702080029030.14457@scrub.home>
Message-ID: <Pine.LNX.4.64.0702071546420.8424@woody.linux-foundation.org>
References: <20070207165204.GA5537@martell.zuzino.mipt.ru>
 <Pine.LNX.4.64.0702071846180.14457@scrub.home> <20070207220435.GC22699@flower.upol.cz>
 <Pine.LNX.4.64.0702080029030.14457@scrub.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 Feb 2007, Roman Zippel wrote:
> 
> Sorry, it needs more changes, the patch simply wasn't ready.

One problem I find very problematic with all the Kbuild setup is that 
people tend to be very quiet about any build issues until they simply go 
in.

Things don't "get ready" on their own. In other areas, people comment on 
why they don't like patches. In Kbuild, for some reason, we often seem to 
have this situation where people don't react at all.

Sam is great about maintaining the kernel build stuff most of the time, 
but because it's clearly a "secondary" thing, there tends to be some 
periods when nothing happens. Which is problematic for me..

So I end up in a situation where I just basically will apply the patches 
just becauseif I don't, nothing ever happens. The good news is that _once_ 
I apply them, people will usually notice problems and send in fixes fairly 
quickly. But this particular email was NOT useful, for example.  "needs 
more changes" is the epitome of a "not useful" comment.

I notice that Kai should probably have been Cc'd, and quite possibly 
wasn't. So I added him now.

In the meantime, I've applied the fixup patch. And more specific problem 
reports or patches are welcome.

		Linus
