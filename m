Return-Path: <linux-kernel-owner+w=401wt.eu-S1756606AbZCDTr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbZCDTr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 14:47:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755761AbZCDTrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 14:47:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38618 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755022AbZCDTrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 14:47:17 -0500
Date: Wed, 4 Mar 2009 20:46:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3 v7] SGI RTC: add UV RTC clocksource/clockevents and
	generic system vector
Message-ID: <20090304194658.GA18096@elte.hu>
References: <20090304185413.GA24385@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090304185413.GA24385@sgi.com>
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


* Dimitri Sivanich <sivanich@sgi.com> wrote:

> The following patches provide UV RTC driven clocksource and 
> clockevents for SGI systems, as well as introducing a generic 
> system interrupt vector.
> 
> With these patches, the UV system-wide synchronized RTC clock 
> and timers are used as clocksource and clockevents running in 
> high resolution mode.
> 
> 
> Subject: [PATCH 1/3 v7] SGI RTC: add generic system vector
> Subject: [PATCH 2/3 v7] SGI RTC: loop through installed UV blades
> Subject: [PATCH 3/3 v7] SGI RTC: add UV RTC clocksource/clockevents

applied to tip:x86/uv, thanks Dimitri!

Note, the new code does not build on !SMP:

arch/x86/kernel/uv_time.c:87: error: (Each undeclared identifier is reported only once
arch/x86/kernel/uv_time.c:87: error: for each function it appears in.)
arch/x86/kernel/uv_time.c: In function 'uv_setup_intr':
arch/x86/kernel/uv_time.c:117: error: implicit declaration of function 'cpu_physical_id'

So it's not merged into tip:master yet and not en route to 
2.6.30 yet either.

Please send a delta fix against tip:x86/uv. Thanks,

	Ingo
