Return-Path: <linux-kernel-owner+w=401wt.eu-S932102AbYEFAiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102AbYEFAiY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 20:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756803AbYEFAiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 20:38:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56692 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756531AbYEFAiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 20:38:16 -0400
Date: Tue, 6 May 2008 02:38:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Parag Warudkar <parag.warudkar@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "akpm@osdl.org" <akpm@osdl.org>, Peter Zijlstra <peterz@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] default to n for GROUP_SCHED and FAIR_GROUP_SCHED
Message-ID: <20080506003803.GA1512@elte.hu>
References: <82e4877d0805031742o464dd581wd93173d79705ce0d@mail.gmail.com> <20080504092417.GA3425@elte.hu> <82e4877d0805050814j721ae522k84384df48c9f4336@mail.gmail.com> <20080505172146.GB22332@elte.hu> <82e4877d0805051436u377bf943m3beef5e9be5cbe23@mail.gmail.com> <20080505214904.GA8204@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505214904.GA8204@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > Hmm - It's the IO_DELAY stuff - I will test more but it looks like 
> > with CONFIG_IO_DELAY_TYPE_NONE -git boots fine on my machine but 
> > with the same option sched-devel does not. Setting 
> > CONFIG_IO_DELAY_TYPE=0 (0x80) makes sched-devel boots again.
> 
> hm, that's really interesting. I've added a patch that makes 
> IO_DELAY_TYPE_NONE depend on CONFIG_BROKEN, because your machine is 
> reasonably new but apparently needs delays during bootup. But why 
> sched-devel triggered this is still weird.

note that i've added this to sched-devel/latest so if you try the latest 
bits you should get this fix automatically.

	Ingo
