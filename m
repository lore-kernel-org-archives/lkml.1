Return-Path: <linux-kernel-owner+w=401wt.eu-S1760530AbZFOJL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760530AbZFOJL2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 05:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbZFOJLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 05:11:19 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:53647 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751358AbZFOJLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 05:11:18 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: tty_ldisc_try_get(): BUG kmalloc-8: Poison overwritten
References: <20090614081052.GA9276@elte.hu>
	<20090614115428.1127ed2d@lxorguk.ukuu.org.uk>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Mon, 15 Jun 2009 10:10:05 +0100
In-Reply-To: <20090614115428.1127ed2d@lxorguk.ukuu.org.uk> (Alan Cox's message of "Sun\, 14 Jun 2009 11\:54\:28 +0100")
Message-ID: <tnxhbyhuaky.fsf@pc1117.cambridge.arm.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 15 Jun 2009 09:10:08.0080 (UTC) FILETIME=[14294D00:01C9ED99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Sun, 14 Jun 2009 10:10:52 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
>> Ok, this is one for those who like to look at weird crashes/bugs.
>> 
>> Here's a new regression that popped up in this merge window, there's 
>> some sort of slab corruption going on in tty data structures:
>
> I split the ldisc and tty apart and redid the ldisc locking so its a fair
> bet I know what changeset is to blame, will just need to hunt it down a
> bit. kmemcheck found one leak case on Friday which I've fixed but not yet
> scribbles.

That was kmemleak :-).

-- 
Catalin
