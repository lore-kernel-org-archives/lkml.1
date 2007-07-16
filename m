Return-Path: <linux-kernel-owner+w=401wt.eu-S1764351AbXGPW6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764351AbXGPW6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 18:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762640AbXGPW5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 18:57:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43241
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1762392AbXGPW5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 18:57:50 -0400
Date: Mon, 16 Jul 2007 15:57:53 -0700 (PDT)
Message-Id: <20070716.155753.34760312.davem@davemloft.net>
To: mingo@elte.hu
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       olaf.kirch@oracle.com
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070716223718.GA494@elte.hu>
References: <20070716215117.GA25097@elte.hu>
	<20070716.150902.55721400.davem@davemloft.net>
	<20070716223718.GA494@elte.hu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 17 Jul 2007 00:37:18 +0200

> I think if you leaned back and thought it through, and if you applied 
> this scenario to a bad scheduler commit from me that broke your box, 
> you'd readily agree with me =B-) (which scenario is purely hypothetical, 
> my scheduler commits are all 100% perfect of course ;-)

Actually I'd probably send you a patch for any bug I found that
triggered on sparc64, since that's faster than asking you to fix a bug
that you are unlikely to be able to trigger on your own systems.

But that's just how I operate.

Ask Thomas Gleixner.  Every single hrtimers/nohz bug I've found on
sparc64, I sent him either a full fix or a full analysis of the bug
and a description of exactly what is going on and what needs to be
changed so he can compose the bug fix patch with minimal effort.

I don't ask people to revert, ever.  It's never necessary when the
parties involved are extremely competent and responsive.
