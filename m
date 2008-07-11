Return-Path: <linux-kernel-owner+w=401wt.eu-S1758861AbYGKB2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861AbYGKB2a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 21:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755055AbYGKB2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 21:28:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755569AbYGKB2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 21:28:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64: fix delayed signals
In-Reply-To: Linus Torvalds's message of  Thursday, 10 July 2008 18:18:37 -0700 <alpine.LFD.1.10.0807101806330.2936@woody.linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <20080710215039.2A143154218@magilla.localdomain>
	<alpine.LFD.1.10.0807101459000.2936@woody.linux-foundation.org>
	<20080710224256.AD038154218@magilla.localdomain>
	<alpine.LFD.1.10.0807101549590.2936@woody.linux-foundation.org>
	<20080711005243.ADE90154218@magilla.localdomain>
	<alpine.LFD.1.10.0807101806330.2936@woody.linux-foundation.org>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20080711012749.82305154218@magilla.localdomain>
Date: Thu, 10 Jul 2008 18:27:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In short, it doesn't smell like something I should apply under -rc9 rules.

Sorry, never said it was.  2.6.27 is just fine for this.
Since it has indeed been that way so long, I guess I figured
it was obvious this was not a last-minute-urgent sort of thing.

I figured Ingo would put it in one of his trees to be chewed on.

Aside from the test case, which I did indeed contrive after I
found the bug, and the general concern about races, I was only
bitten by this because it fouled up things for changes I'm
working on for .27 or later.


Thanks,
Roland
