Return-Path: <linux-kernel-owner+w=401wt.eu-S1765473AbYD3UcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765473AbYD3UcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 16:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759465AbYD3Ubz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 16:31:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46103 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756441AbYD3Uby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 16:31:54 -0400
Date: Wed, 30 Apr 2008 13:31:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: Slow DOWN, please!!!
In-Reply-To: <20080430131537.1f7a0914.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org>
References: <20080429.190352.137408408.davem@davemloft.net> <200804302136.58005.rjw@sisk.pl> <20080430131537.1f7a0914.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 Apr 2008, Andrew Morton wrote:
> 
> <jumps up and down>
> 
> There should be nothing in 2.6.x-rc1 which wasn't in 2.6.x-mm1!

The problem I see with both -mm and linux-next is that they tend to be 
better at finding the "physical conflict" kind of issues (ie the merge 
itself fails) than the "code looks ok but doesn't actually work" kind of 
issue.

Why?

The tester base is simply too small.

Now, if *that* could be improved, that would be wonderful, but I'm not 
seeing it as very likely.

I think we have fairly good penetration these days with the regular -git 
tree, but I think that one is quite frankly a *lot* less scary than -mm or 
-next are, and there it has been an absolutely huge boon to get the kernel 
into the Fedora test-builds etc (and I _think_ Ubuntu and SuSE also 
started something like that).

So I'm very pessimistic about getting a lot of test coverage before -rc1.

Maybe too pessimistic, who knows?

		Linus
