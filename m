Return-Path: <linux-kernel-owner+w=401wt.eu-S1757078AbYHKTkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078AbYHKTkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 15:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbYHKTk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 15:40:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54198 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056AbYHKTk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 15:40:28 -0400
Date: Mon, 11 Aug 2008 21:40:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/2] x86: fix memory leaks when doing CPU hotplug
Message-ID: <20080811194013.GI12788@elte.hu>
References: <20080806082400.GC5427@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080806082400.GC5427@alberich.amd.com>
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


* Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> Following patches fix two memory leaks with CPU hotplug. Some per CPU 
> data is allocated each time a CPU is set online. But this space is 
> never freed.
> 
> Usually this memory leak is not a big deal (for normal CPU hotplug 
> usage). But during stress tests with lots of CPU offline/online cycles 
> this really matters.
> 
> The entire leak is 40K (10 pages) for each offline/online cycle per 
> CPU.  I've verified both fixes performing more than 90000 CPU 
> offline/online cycles.

applied to tip/x86/core, thanks Andreas.

> This is not a regression but I think it's still 2.6.27 material. 
> Please apply.

it's tricky code so i guess it's best to let it cook in tip/master a 
bit. If it does not show up upstream by say -rc4 time could you please 
ping us about it?

	Ingo
