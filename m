Return-Path: <linux-kernel-owner+w=401wt.eu-S1753199AbYIVKAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbYIVKAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 06:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbYIVKAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 06:00:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56995 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645AbYIVKAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 06:00:35 -0400
Date: Mon, 22 Sep 2008 12:00:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: do_boot_cpu - add check if we have ESR register
Message-ID: <20080922100024.GA24705@elte.hu>
References: <20080922093603.GC7663@localhost> <20080922095148.GD7663@localhost> <86802c440809220257q4e1b4c81o534c957d919a6b3c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440809220257q4e1b4c81o534c957d919a6b3c@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> > Actually it's resend of the patch. On previous attempt Yinghai was 
> > proposed to choose:
> >
> >> one apic_version or boot_cpu_apic_version could be enough
> >
> > but I think it should be different patch which does cleaning up 
> > variables usage. So for now I think _this_ patch is enough since 
> > idea is to prevent of touching nonexistant register rather code 
> > cleaning (whci could be done later).
> 
> do we have systems that have mixed cpu supported with different apic 
> version?

i dont think that ever happened in the past. Vendors have trouble 
keeping same-cpu type systems going ;-)

OTOH, if it's simple to have multi-version support then lets do that 
throughout. (although we certainly cannot test it. Perhaps we can 
provoke it artificially via a hack that artificially degrades one cpu's 
apic version or so.)

	Ingo
