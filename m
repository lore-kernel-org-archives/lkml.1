Return-Path: <linux-kernel-owner+w=401wt.eu-S1756129AbZFJVLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbZFJVLl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 17:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756793AbZFJVLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 17:11:30 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:53707 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbZFJVL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 17:11:29 -0400
Message-ID: <4A302075.7060501@cs.helsinki.fi>
Date: Thu, 11 Jun 2009 00:07:01 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, hannes@cmpxchg.org, mpm@selenic.com,
       npiggin@suse.de, yinghai@kernel.org
Subject: Re: [GIT PULL] Early boot SLAB for 2.6.31
References: <Pine.LNX.4.64.0906102311230.30444@melkki.cs.Helsinki.FI> <alpine.LFD.2.01.0906101331250.6847@localhost.localdomain> <4A3017D1.5010708@cs.helsinki.fi> <20090610204318.GA8147@elte.hu> <84144f020906101347y3e250f4bme2d1c60dd5993ffc@mail.gmail.com> <20090610205026.GC8147@elte.hu> <20090610205749.GA9321@elte.hu>
In-Reply-To: <20090610205749.GA9321@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Ingo Molnar wrote:
>>>> What kind of conflicts are there against -tip? The diffstat 
>>>> suggests it's mostly in-SLAB code, right? There shouldnt be 
>>>> much to conflict, except kmemcheck - which has more or less 
>>>> trivial callbacks there.
>>> The conflicting bits are the patches that remove bootmem 
>>> allocator uses in arch/x86 and kernel/sched.c.
>> Give me an hour and i'll get some minimal testing done.
> 
> This tree doesnt conflict (not even with kmecheck) - and the older 
> bits you sent against the scheduler and against x86 doesnt apply 
> anymore - but they do look scary.

Btw, yeah, it doesn't conflict because I dropped the problematic patches 
and did the bootmem fallback instead.

But now you know why I tried to push all this to -tip. Your tree is 
moving so fast that it's difficult to generate patches that apply to 
both, -tip and mainline, in this particular area :-).

			Pekka
