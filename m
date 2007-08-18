Return-Path: <linux-kernel-owner+w=401wt.eu-S1758942AbXHRXLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942AbXHRXLN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 19:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755814AbXHRXLB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 19:11:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754003AbXHRXLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 19:11:00 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] exec: simplify ->sighand switching
In-Reply-To: Oleg Nesterov's message of  Saturday, 18 August 2007 21:39:47 +0400 <20070818173947.GA209@tv-sign.ru>
Emacs: don't cry -- it won't help.
Message-Id: <20070818231053.6CE474D05C6@magilla.localdomain>
Date: Sat, 18 Aug 2007 16:10:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> There is no any reason to do recalc_sigpending() after changing ->sighand.
> To begin with, recalc_sigpending() does not take ->sighand into account.

I agree.  I think that call dates from before some other cleanups in that
code, when ->signal was changed there.  At the time, it was the most
conservative change to leave recalc_sigpending in case the side effects it
used to have were desireable (we've since decided to change those anyway).


Thanks,
Roland
