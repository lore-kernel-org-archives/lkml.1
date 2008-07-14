Return-Path: <linux-kernel-owner+w=401wt.eu-S1757695AbYGNROe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757695AbYGNROe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 13:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754404AbYGNROJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 13:14:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56153 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754175AbYGNROF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 13:14:05 -0400
Date: Mon, 14 Jul 2008 10:13:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] core/softirq for v2.6.27
In-Reply-To: <20080714164838.GA28765@elte.hu>
Message-ID: <alpine.LFD.1.10.0807141011260.3305@woody.linux-foundation.org>
References: <20080714144243.GA21079@elte.hu> <20080714092215.0efd7fa3.akpm@linux-foundation.org> <20080714163141.GA21068@elte.hu> <20080714094422.e7ae255a.akpm@linux-foundation.org> <20080714164838.GA28765@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Jul 2008, Ingo Molnar wrote:
> 
> /me suggests git-log-addendum feature to amend commit logs after the
>     fact, without changing any of the code :-)

It's called "git commit --amend".

But it obviously also changes the SHA1 of the commit - it generates a 
totally new one. You cannot do it after-the-fact or deep in history (well, 
you can, with the normal "rebase" op, but it literally is no different 
from changing the patch itself too).

BK used to be able to change the logs after-the-fact, but that meant that 
the logs were not trustworthy, and any changes also didn't distribute 
right (they'd only be changed locally and in any subsequent distributions)

		Linus
