Return-Path: <linux-kernel-owner+w=401wt.eu-S1753727AbYIHJik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbYIHJik (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 05:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbYIHJic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 05:38:32 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55480 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbYIHJib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 05:38:31 -0400
Date: Mon, 8 Sep 2008 11:42:05 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux@sandersweb.net, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <andi-suse@firstfloor.org>
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
Message-ID: <20080908094205.GD26079@one.firstfloor.org>
References: <200808311422.12525.linux@sandersweb.net> <200809071922.32974.linux@sandersweb.net> <48C48467.40703@zytor.com> <200809072249.17280.linux@sandersweb.net> <48C4A46B.90705@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C4A46B.90705@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Under that logic we shouldn't even have CPU configurables, since you 

Just for optimization.

> want it to "just work" whatever crap you're running on.  That is EXACTLY 
> what CONFIG_X86_GENERIC means, and the fact that any particular 

At least when I introduced X86_GENERIC it was just an optimization,
not a requirement.

That is the kernel pretty much always did "just work"
(with only a very few exceptions like PAE vs non PAE) on all 
CPUs. The CPU configs also just specified optimizations, not correctness.
The code for all CPUs used to be always there.
X86_GENERIC was mostly just to do things like always use 
the largest cache alignment.

I think someone changed that recently, but imho that wasn't
an improvement. As you can see it just causes endless support
problems.

> distribution is broken with respect to not enabling it is a bug in that 
> distribution, and not grounds for breaking the upstream kernel.

Well it's more like that you guys changed the semantics 
without warnings the distributions. I'm not sure you can blame
Debian for that.

-Andi
-- 
ak@linux.intel.com
