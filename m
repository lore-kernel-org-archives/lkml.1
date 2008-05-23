Return-Path: <linux-kernel-owner+w=401wt.eu-S1757901AbYEWPbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901AbYEWPbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 11:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756174AbYEWPa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 11:30:59 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:25315 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755874AbYEWPa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 11:30:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cbGGATSnYoh948YcnTsEpqP+sUZNxvtpQN7LGRE8bahQb8paP3pAcE9TVZ56Ye0YNU9WlkA9p1XwTLoZ2GEoiDi1igMvtwBbBnP0YzNe+3KSqwK0TNVpATr+J3USgX16k4c+/soXuoy6fzeBSpZXTW9SnGPxbTUlMSY9U/RQBSI=
Message-ID: <19f34abd0805230830o3af93956h8152de3f6e350a09@mail.gmail.com>
Date: Fri, 23 May 2008 17:30:55 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] kmemcheck: SMP support
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       "Pekka Paalanen" <pq@iki.fi>
In-Reply-To: <20080523150622.GA9782@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080523141759.GA1833@damson.getinternet.no>
	 <20080523150622.GA9782@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2008 at 5:06 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> Vegard, wanna have a look at introducing per CPU kernel pagetables? I
> tried that once in the past and it wasnt too horrible. (the patches are
> gone though) We could do it before bringing other CPUs online, i.e. much
> of the really yucky boot time pagetable juggling phase would be over
> already. Hm?

Ingo.

It really doesn't matter how easy it was for you.

You're one of the x86 maintainers.

And I think you're forgetting how hard these things are for a newbie.
I don't even know which one comes first of pmds and puds.

Per-cpu page tables sounds about on the same scale of as, say,
rewriting the VM or some other major subsystem. Epic!


I'm glad to hear from you, though.

Pekka suggested that per-cpu page tables might help NUMA systems too.
Does that sound right to you? Would anybody else benefit from having
per-CPU page tables? If not, I have a hard time believing it will ever
get merged.

(Oh. mmio-trace might. But that's also a hacking tool and doesn't really count.)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
