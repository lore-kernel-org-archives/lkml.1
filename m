Return-Path: <linux-kernel-owner+w=401wt.eu-S1756150AbXLWR6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbXLWR6R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 12:58:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbXLWR6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 12:58:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49377 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287AbXLWR6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 12:58:05 -0500
Date: Sun, 23 Dec 2007 18:57:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: x86: Increase PCIBIOS_MIN_IO to 0x1500 to fix nForce 4
	suspend-to-RAM
Message-ID: <20071223175729.GA7152@elte.hu>
References: <200712231419.40207.carlos@strangeworlds.co.uk> <200712231730.34935.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712231730.34935.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> > 0x1500 has been picked here as a nice, round and more conservative 
> > value than 0x4000, and which covers 0x142E.
> 
> The patch is fine by me, so if anyone has objections, please speak up.

i'm quite nervous about that approach, partly due to the "black magic" 
interaction of commit 2ba84684e8c. Could we try to figure out what's 
really going on here, instead of playing with a general limit (which 
might break other boxes)?

	Ingo
