Return-Path: <linux-kernel-owner+w=401wt.eu-S1752613AbYIFM5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbYIFM5O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 08:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750962AbYIFM47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 08:56:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36135 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbYIFM46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 08:56:58 -0400
Date: Sat, 6 Sep 2008 14:56:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 0/5] x86: signal works for unification
Message-ID: <20080906125640.GH30964@elte.hu>
References: <48C1BF41.8040404@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C1BF41.8040404@ct.jp.nec.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0037]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> Hi,
> 
> this patch series is for future unification of signal.c.
> These patches make common functions similar in signal_32|64.c.
> 
> Could you please review them?

looks good to me - it's fairly safely structured and also in small, 
single-purpose steps. If there's a problem with them bisection should 
give a very good clue about exactly where.

So i've created a new tip/x86/signal topic for them and applied them - 
lets see how it goes. Thanks,

	Ingo
