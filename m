Return-Path: <linux-kernel-owner+w=401wt.eu-S1756566AbYFOABo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbYFOABo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 20:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755803AbYFOABf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 20:01:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755797AbYFOABe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 20:01:34 -0400
Date: Sat, 14 Jun 2008 17:00:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: 2.6.26-rc6-git2: Reported regressions from 2.6.25
In-Reply-To: <Pine.LNX.4.55.0806142249090.3771@cliff.in.clinika.pl>
Message-ID: <alpine.LFD.1.10.0806141654280.2949@woody.linux-foundation.org>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik> <alpine.LFD.1.10.0806141423500.2949@woody.linux-foundation.org> <Pine.LNX.4.55.0806142249090.3771@cliff.in.clinika.pl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 14 Jun 2008, Maciej W. Rozycki wrote:
> 
>  From what you have written it looks the dependency should actually be:
> 
> 	depends on !M386 && !M486 && !M586 && !M586TSC && !M586MMX
> 
> as none of the pre-Pentium-Pro processors had the PAE feature (I am not
> sure about non-Intel implementations, so the case of M586 would have to be
> investigated).

Yes, it's the non-intel ones that would keep me from saying !M586.

For intel, PAE was a PPro feature (at least officially, as you point out), 
but I do not know about various other manufacturers. From personal 
experience, the line between Pentium and PPro features doesn't tend to be 
totally black-and-white (although I suspect that when it comes to PAE it 
_may_ be).

		Linus
