Return-Path: <linux-kernel-owner+w=401wt.eu-S1759424AbXEaBJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759424AbXEaBJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 21:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750746AbXEaBJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 21:09:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbXEaBJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 21:09:02 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: fix leakage of -ERESTARTSYS to userland
In-Reply-To: Satoru Takeuchi's message of  Thursday, 31 May 2007 09:48:16 +0900 <87wsypakdr.wl%takeuchi_satoru@jp.fujitsu.com>
X-Zippy-Says: I wonder if I should put myself in ESCROW!!
Message-Id: <20070531010855.DE2AC1F8512@magilla.localdomain>
Date: Wed, 30 May 2007 18:08:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Aside from typos, I think it should be more clearly and strongly worded.

"These should never be seen by user programs.  To return one of these
codes, signal_pending() MUST be set.  Note that ptrace can observe these at
syscall exit tracing, but they will never be left for the debugged user
process to see."


Thanks,
Roland
