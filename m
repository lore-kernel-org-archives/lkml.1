Return-Path: <linux-kernel-owner+w=401wt.eu-S1759969AbXHBWlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759969AbXHBWlI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 18:41:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755559AbXHBWk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 18:40:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35247 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754849AbXHBWkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 18:40:55 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] do_sigaction: remove now unneeded recalc_sigpending()
In-Reply-To: Oleg Nesterov's message of  Friday, 3 August 2007 02:37:20 +0400 <20070802223720.GA623@tv-sign.ru>
X-Zippy-Says: BEEP-BEEP!!  I'm a '49 STUDEBAKER!!
Message-Id: <20070802224048.524644D04B5@magilla.localdomain>
Date: Thu,  2 Aug 2007 15:40:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> With the recent changes, do_sigaction()->recalc_sigpending_and_wake() can
> never clear TIF_SIGPENDING. Instead, it can set this flag and wake up the
> thread without any reason. Harmless, but unneeded and wastes CPU.
> 
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

ACK.  (We agreed months ago this was the thing to do.)


Thanks,
Roland
