Return-Path: <linux-kernel-owner+w=401wt.eu-S1752022AbZL1Jrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbZL1Jrc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 04:47:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbZL1Jrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 04:47:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52553 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961AbZL1Jrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 04:47:31 -0500
Date: Mon, 28 Dec 2009 10:47:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: increase NR_IRQS and nr_irqs
Message-ID: <20091228094707.GH24690@elte.hu>
References: <4B347AEE.6030705@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B347AEE.6030705@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> have a system with lots of igb and ixgbe, when iov/vf are enabled for
> them, we hit the limit of 3064.
> 
> so try to increase NR_IRQS and nr_irqs to about 8000 and 6000.
> for that system.

could you please provide before/after .data size analysis, expected dynamic 
allocation overhead difference (if any), etc. - so that we can see whether 
there's any (and if yes, how much) cost due to the bumping of the limit.

Also, instead of just upping the limit to a new random limit that works on 
that testbox, could we put some more thought into how much we want to increase 
it, and stay at least 2-3 years ahead of the expected hardware curve?

	Ingo
