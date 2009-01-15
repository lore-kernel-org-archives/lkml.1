Return-Path: <linux-kernel-owner+w=401wt.eu-S1760091AbZAOLHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760091AbZAOLHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 06:07:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756660AbZAOLHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 06:07:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34659 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755943AbZAOLHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 06:07:33 -0500
Date: Thu, 15 Jan 2009 12:07:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] time-sched.c: tick_nohz_update_jiffies should be
	static
Message-ID: <20090115110718.GA22850@elte.hu>
References: <1231945697.3970.1.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231945697.3970.1.camel@jaswinder.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Jaswinder Singh Rajput <jaswinder@infradead.org> wrote:

> Impact: cleanup, reduce kernel size a bit, avoid sparse warning
> 
> Fixes sparse warning:
>  kernel/time/tick-sched.c:137:6: warning: symbol 'tick_nohz_update_jiffies' was not declared. Should it be static?
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  kernel/time/tick-sched.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

applied to tip/timers/urgent, thanks Jaswinder!

	Ingo
