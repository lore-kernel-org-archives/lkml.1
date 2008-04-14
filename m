Return-Path: <linux-kernel-owner+w=401wt.eu-S1759906AbYDNH7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759906AbYDNH7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 03:59:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756538AbYDNH64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 03:58:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52311 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756390AbYDNH6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 03:58:55 -0400
Date: Mon, 14 Apr 2008 09:58:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Andrew <nick@nick-andrew.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       joe@perches.com
Subject: Re: [PATCH 1/2] printk: Refactor processing of line severity tokens
Message-ID: <20080414075834.GK16163@elte.hu>
References: <20080413115152.29086.37845.stgit@marcab.local.tull.net> <20080413122342.31769.40091.stgit@marcab.local.tull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080413122342.31769.40091.stgit@marcab.local.tull.net>
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


* Nick Andrew <nick@nick-andrew.net> wrote:

> printk: Refactor processing of line severity tokens
> 
> Restructure the logic of vprintk() so the processing of the leading 3 
> characters of each input line is in one place, regardless whether 
> printk_time is enabled. This makes the code smaller and easier to 
> understand.

thanks, applied - nice cleanup!

i also added the size stats:

   text    data     bss     dec     hex filename
   6157     397 1049804 1056358  101e66 printk.o.before
   6117     397 1049804 1056318  101e3e printk.o.after

	Ingo
