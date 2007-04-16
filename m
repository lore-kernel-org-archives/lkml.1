Return-Path: <linux-kernel-owner+w=401wt.eu-S1754385AbXDPDQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385AbXDPDQv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 23:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754386AbXDPDQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 23:16:51 -0400
Received: from mail24.syd.optusnet.com.au ([211.29.133.165]:35861 "EHLO
	mail24.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754385AbXDPDQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 23:16:50 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Nick Piggin <npiggin@suse.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Date: Mon, 16 Apr 2007 13:15:27 +1000
User-Agent: KMail/1.9.5
Cc: Jonathan Lundell <linux@lundell-bros.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Pekka J Enberg <penberg@cs.helsinki.fi>,
       Willy Tarreau <w@1wt.eu>, hui Bill Huey <billh@gnuppy.monkey.org>,
       Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Peter Williams <pwil3058@bigpond.net.au>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20070413202100.GA9957@elte.hu> <200704160852.34241.kernel@kolivas.org> <20070416022838.GA13626@wotan.suse.de>
In-Reply-To: <20070416022838.GA13626@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704161315.28440.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 April 2007 12:28, Nick Piggin wrote:
> So, on to something productive, we have 3 candidates for a new scheduler so
> far. How do we decide which way to go? (and yes, I still think switchable
> schedulers is wrong and a copout) This is one area where it is virtually
> impossible to discount any decent design on correctness/performance/etc.
> and even testing in -mm isn't really enough.

We're in agreement! YAY!

Actually this is simpler than that. I'm taking SD out of the picture. It has 
served it's purpose of proving that we need to seriously address all the 
scheduling issues and did more than a half decent job at it. Unfortunately I 
also cannot sit around supporting it forever by myself. My own life is more 
important, so consider SD not even running the race any more.

I'm off to continue maintaining permanent-out-of-tree leisurely code at my own 
pace. What's more is, I think I'll just stick to staircase Gen I version blah 
and shelve SD and try to have fond memories of SD as an intellectual 
prompting exercise only.

-- 
-ck
