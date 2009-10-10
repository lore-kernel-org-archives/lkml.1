Return-Path: <linux-kernel-owner+w=401wt.eu-S1755596AbZJJXNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbZJJXNu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 19:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755337AbZJJXNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 19:13:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54615 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754316AbZJJXNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 19:13:49 -0400
Date: Sun, 11 Oct 2009 00:13:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: John Kacur <jkacur@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, Jonathan Corbet <corbet@lwn.net>,
       Christoph Hellwig <hch@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: [patch 22/28] macintosh: Remove BKL from ans-lcd
Message-ID: <20091011001324.49e9733d@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.0910102309570.3669@localhost.localdomain>
References: <20091010153314.827301943@linutronix.de>
	<20091010153349.966159859@linutronix.de>
	<alpine.LFD.2.00.0910102309570.3669@localhost.localdomain>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There were 4 checkpatch errors on this patch, all of the type
> ERROR: spaces required around that '=' (ctx:WxO)
> #1466: FILE: drivers/macintosh/ans-lcd.c:112:
> +			ret =-EACCES;

Here's a suggestion. If a few spaces bug you that much then instead of
complaining about it and posting checkpatch results deal with the file
itself. 

Wait until the patch goes in and send a follow up patch that fixes up the
file to fit codingstyle. There's no point whining about the bits a patch
touches when the file wasn't in that format before, but if you've got
nothing better to do then doing a pass over the whole file *is* useful.

(Plus it gets a patch to your name ;))

Checkpatch whines on files that simple don't follow style are usually
best ignored because they make the file formatting less internally
consistent.

Alan
