Return-Path: <linux-kernel-owner+w=401wt.eu-S1756282AbZE3IBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282AbZE3IBd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 04:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751409AbZE3IB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 04:01:26 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:46790 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbZE3IBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 04:01:25 -0400
Message-ID: <4A20E6CF.8070003@cs.helsinki.fi>
Date: Sat, 30 May 2009 10:57:03 +0300
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
References: <4A15A8C7.2030505@redhat.com> <20090522073436.GA3612@elte.hu> <20090522113809.GB13971@oblivion.subreption.com> <20090523124944.GA23042@elte.hu> <4A187BDE.5070601@redhat.com> <20090527223421.GA9503@elte.hu> <20090528072702.796622b6@lxorguk.ukuu.org.uk> <20090528090836.GB6715@elte.hu> <20090528125042.28c2676f@lxorguk.ukuu.org.uk> <84144f020905300035g1d5461f9n9863d4dcdb6adac0@mail.gmail.com> <20090530075033.GL29711@oblivion.subreption.com>
In-Reply-To: <20090530075033.GL29711@oblivion.subreption.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry H. wrote:
> Furthermore, selective clearing doesn't solve the roots of the problem.
> It's just adding bandages to a wound which never stops bleeding. I
> proposed an initial page flag because we could use it later for
> unconditional page clearing doing a one line change in a header file.
> 
> I see a lot of speculation on what works and what doesn't, but
> there isn't much on the practical side of things, yet. I provided test
> results that proved some of the comments wrong, and I've referenced
> literature which shows the reasoning behind all this. What else can I do
> to make you understand you are missing the point here?

Hey, if you want to add a CONFIG_ZERO_ALL_MEMORY_PARANOIA thing that can 
be disabled, go for it! But you have to find someone else to take the 
merge the SLAB bits because, quite frankly, I am not convinced it's 
worth it. And the hand waving you're doing here isn't really helping 
your case, sorry.

			Pekka
