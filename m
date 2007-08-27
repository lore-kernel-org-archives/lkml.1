Return-Path: <linux-kernel-owner+w=401wt.eu-S932195AbXH0RVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195AbXH0RVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 13:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755669AbXH0RVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 13:21:12 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42173 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757015AbXH0RVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 13:21:11 -0400
Date: Mon, 27 Aug 2007 10:20:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Len Brown <len.brown@intel.com>,
       Andi Kleen <ak@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix maxcpus=N parsing
In-Reply-To: <Pine.LNX.4.64.0708271554570.21853@blonde.wat.veritas.com>
Message-ID: <alpine.LFD.0.999.0708271009270.25853@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0708271554570.21853@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 27 Aug 2007, Hugh Dickins wrote:
>
> Fix 61ec7567db103d537329b0db9a887db570431ff4: maxcpus=N is now having no
> ...

On a totally unrelated issue:

While looking at the history in gitk and gitweb etc shows these commit 
ID's as nice hyperlinks, I really think it's nicer for everybody if the 
commit is also described with its "headline", so that non-git users (or 
even git users, when just using "git log" or similar) at least can grep or 
google for it.

So when writing descriptions, I would prefer it if people wrote them 
something like

   Commit 61ec7567db103d537329b0db9a887db570431ff4 ('ACPI: boot correctly 
   with "nosmp" or "maxcpus=0"') broke maxcpus parsing on x86[-64] ...

so that it gets both the exact commit naming and the nice hyperlinks where 
appropriate *and* it ends up being more useful even without the links.

Yes, it's redundant information, but since we have the useful one-line 
descriptions, it's generally a good idea. And I really do think that it 
tends to make the explanations read better too.

For example, in this example, I think it really made it more clear what 
kind of change had caused the breakage. Maybe that's not always true, but 
I suspect it's true most of the time.

I'll fix it up manually (I often do), but I thought I'd just mention this 
stylistic issue.

		Linus
