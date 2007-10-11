Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbXJKKwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbXJKKwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 06:52:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbXJKKv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 06:51:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbXJKKv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 06:51:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] core dump: remain dumpable
In-Reply-To: Oleg Nesterov's message of  Thursday, 11 October 2007 14:49:42 +0400 <20071011104942.GA144@tv-sign.ru>
References: <20071011062730.19F774D026B@magilla.localdomain>
	<20071011102507.GA101@tv-sign.ru>
	<20071011103446.89BCC4D03F7@magilla.localdomain>
	<20071011104942.GA144@tv-sign.ru>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20071011105122.AB71B4D03F7@magilla.localdomain>
Date: Thu, 11 Oct 2007 03:51:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Ugh, sorry, I was wrong. coredump_wait() initializes mm->core_done and sets
> mm->core_startup_done before checking SIGNAL_GROUP_EXIT. This means we have
> to check ->core_waiters or SIGNAL_GROUP_EXIT before calling coredump_wait().

Ah.  Checking core_waiters seems like a fine thing to do.  


Thanks,
Roland
