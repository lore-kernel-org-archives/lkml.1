Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbYAON0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbYAON0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 08:26:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750914AbYAON0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 08:26:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35450 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbYAON0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 08:26:22 -0500
Date: Tue, 15 Jan 2008 14:26:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: move warning message of polling idle and HT
	enabled
Message-ID: <20080115132607.GE7025@elte.hu>
References: <478BB226.6090105@ct.jp.nec.com> <20080114190904.GA2288@elte.hu> <478C1475.7060706@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478C1475.7060706@ct.jp.nec.com>
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


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> Subject: [PATCH] x86: move warning message of polling idle and HT enabled
> 
> This warning at idle_setup() is never shown because smp_num_sibling hasn't
> been updated at this point yet.
> 
> Move this polling idle and HT enabled warning message to 
> select_idle_routine(). I also implement this warning on 64-bit kernel 
> and make select_idle_routine() call after detect_ht() call.

looks good to me, but could you please split this up into two patches 
instead - one that just moves/adds the printks, the other one that moves 
the select_idle_routine() call? (Moving init calls around is notoriously 
error-prone, so we want as small of a bisection target as possible.) 
Thanks,

	Ingo
