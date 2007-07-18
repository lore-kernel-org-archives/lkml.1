Return-Path: <linux-kernel-owner+w=401wt.eu-S1764527AbXGRTJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764527AbXGRTJP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 15:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756443AbXGRTJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 15:09:00 -0400
Received: from mail.windriver.com ([147.11.1.11]:45431 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808AbXGRTI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 15:08:59 -0400
Date: Wed, 18 Jul 2007 12:08:06 -0700 (PDT)
From: Jeremy Katz <jeremy.katz@windriver.com>
X-X-Sender: jkatz@localhost.localdomain
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Stable Team <stable@kernel.org>
Subject: Re: [PATCH] posix-timer: fix deletion race
In-Reply-To: <20070718161156.GA761@tv-sign.ru>
Message-ID: <Pine.LNX.4.63.0707181203110.3157@localhost.localdomain>
References: <Pine.LNX.4.63.0707131058390.10358@localhost.localdomain>
 <1184662429.12353.426.camel@chaos> <Pine.LNX.4.63.0707171131580.10358@localhost.localdomain>
 <1184703427.12353.476.camel@chaos> <Pine.LNX.4.63.0707171558570.10358@localhost.localdomain>
 <Pine.LNX.4.63.0707171654020.10358@localhost.localdomain>
 <20070718161156.GA761@tv-sign.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-OriginalArrivalTime: 18 Jul 2007 19:08:06.0564 (UTC) FILETIME=[F911FE40:01C7C96E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2007, Oleg Nesterov wrote:

> Jeremy, I agree with Thomas that your patch should not be right, but it
> does make a difference. Perhaps this is just the timing, but who knows.
> Could you add some printk's to be sure that lock_timer() actually fails
> while it never should?

Agreed.

Unfortunately, adding any significant output appears to alter the 
situation to the point where the issue either does not occur, or takes 
significantly longer to surface.

Jeremy
