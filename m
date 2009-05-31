Return-Path: <linux-kernel-owner+w=401wt.eu-S1757358AbZEaLrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358AbZEaLrf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 07:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbZEaLr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 07:47:26 -0400
Received: from oblivion.subreption.com ([66.240.236.22]:49904 "EHLO
	mail.subreption.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbZEaLr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 07:47:26 -0400
Date: Sun, 31 May 2009 04:49:01 -0700
From: "Larry H." <research@subreption.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, pageexec@freemail.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page
	allocator
Message-ID: <20090531114901.GA10598@oblivion.subreption.com>
References: <20090530180333.GH6535@oblivion.subreption.com> <20090530182113.GA25237@elte.hu> <20090530184534.GJ6535@oblivion.subreption.com> <20090530190828.GA31199@elte.hu> <4A21999E.5050606@redhat.com> <84144f020905301353y2f8c232na4c5f9dfb740eec4@mail.gmail.com> <20090530213311.GM6535@oblivion.subreption.com> <20090531001318.093e3665@lxorguk.ukuu.org.uk> <20090530231813.GP6535@oblivion.subreption.com> <4A2223FE.3000309@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A2223FE.3000309@cs.helsinki.fi>
Organization: Subreption LLC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09:30 Sun 31 May     , Pekka Enberg wrote:
> Larry H. wrote:
>> OK, I'm going to squeeze some time and provide patches that perform the
>> same my original page bit ones did, but using kzfree. Behold code like
>> in the tty buffer management, which uses the page allocator directly for
>> allocations greater than PAGE_SIZE in length. That needs special
>> treatment, and is exactly the reason I've proposed unconditional
>> sanitization since the original patches were rejected.
>
> You might want to also do the patch Alan suggested for the security 
> conscious people. That is, do a memset() in every page free and wrap that 
> under CONFIG_SECURITY_PARANOIA or something. There's no reason the kzfree() 
> patches and that can't co-exist.

I know you came late into the discussion, but if you had invested a
minute checking the thread, you would have spotted a patch in which a
Kconfig option was used to disable the sensitive page flag effects as whole.
The very first one.

I'm not wasting my time re-workign a patch which has been already
rejected. Go ahead and do it in your own time if you wish, it's GPL
anyway.

	Larry

