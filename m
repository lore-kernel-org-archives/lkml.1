Return-Path: <linux-kernel-owner+w=401wt.eu-S1764601AbYEFJEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764601AbYEFJEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 05:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763440AbYEFI5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 04:57:21 -0400
Received: from saeurebad.de ([85.214.36.134]:43606 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763483AbYEFI5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 04:57:19 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [rfc][patch 0/3] bootmem2: a memory block-oriented boot time allocator
References: <20080505095938.326928514@symbol.fehenstaub.lan>
	<481F58DD.9000600@firstfloor.org>
Date: Tue, 06 May 2008 10:57:12 +0200
In-Reply-To: <481F58DD.9000600@firstfloor.org> (Andi Kleen's message of "Mon,
	05 May 2008 20:58:37 +0200")
Message-ID: <87r6cflsif.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Andi Kleen <andi@firstfloor.org> writes:

>> (because a PFN is not unique anymore)
>
> That doesn't make sense. If a PFN is not uniquely mapping to a single
> memory page anymore the VM and lots of other code in the kernel will
> just not work. And each memory page can be only in a single node.

I meant it is not unique to the bootmem allocator because two bitmaps
might partially represent the same page range.

	Hannes
