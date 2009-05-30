Return-Path: <linux-kernel-owner+w=401wt.eu-S1754456AbZE3IiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456AbZE3IiH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 04:38:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbZE3Ih4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 04:37:56 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:56318 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbZE3Ih4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 04:37:56 -0400
Message-ID: <4A20EF5C.10702@cs.helsinki.fi>
Date: Sat, 30 May 2009 11:33:32 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: "Larry H." <research@subreption.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, pageexec@freemail.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page	allocator
References: <20090522113809.GB13971@oblivion.subreption.com> <20090523124944.GA23042@elte.hu> <4A187BDE.5070601@redhat.com> <20090527223421.GA9503@elte.hu> <20090528072702.796622b6@lxorguk.ukuu.org.uk> <20090528090836.GB6715@elte.hu> <20090528125042.28c2676f@lxorguk.ukuu.org.uk> <84144f020905300035g1d5461f9n9863d4dcdb6adac0@mail.gmail.com> <20090530075033.GL29711@oblivion.subreption.com> <4A20E601.9070405@cs.helsinki.fi> <20090530082048.GM29711@oblivion.subreption.com>
In-Reply-To: <20090530082048.GM29711@oblivion.subreption.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Larry,

On 10:53 Sat 30 May, Pekka Enberg wrote:
>>> That's hopeless, and kzfree is broken. Like I said in my earlier reply,
>>> please test that yourself to see the results. Whoever wrote that ignored
>>> how SLAB/SLUB work and if kzfree had been used somewhere in the kernel
>>> before, it should have been noticed long time ago.
>> An open-coded version of kzfree was being used in the kernel:
>>
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=00fcf2cb6f6bb421851c3ba062c0a36760ea6e53
>>
>> Can we now get to the part where you explain how it's broken because I 
>> obviously "ignored how SLAB/SLUB works"?

Larry H. wrote:
> You can find the answer in the code of sanitize_obj, within my kfree
> patch. Besides, it would have taken less time for you to write a simple
> module that kmallocs and kzfrees a buffer, than writing these two
> emails.
> 
> Consider the inuse, size, objsize and offset members of a kmem_cache
> structure, for further hints. Test the module on a system with SLUB,
> though the issue should replicate over SLAB too. And don't dare test it
> on SLOB and its wonderful ksize, or even look at the freelist pointer
> management within SLUB.

Thank you for the lesson in slab internals! That said, I did go over 
your patch and am still as confused as ever. I am afraid I have to 
consider this discussion done unless you're willing to share your 
knowledge on the subject.

			Pekka
