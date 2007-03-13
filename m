Return-Path: <linux-kernel-owner+w=401wt.eu-S933017AbXCMISX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017AbXCMISX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 04:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933058AbXCMISX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 04:18:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59970 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933017AbXCMISU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 04:18:20 -0400
Date: Tue, 13 Mar 2007 09:18:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Con Kolivas <kernel@kolivas.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
Message-ID: <20070313081805.GA22327@elte.hu>
References: <200703111457.17624.kernel@kolivas.org> <200703130549.47058.kernel@kolivas.org> <1173730314.6431.30.camel@Homer.simpson.net> <200703130738.19034.kernel@kolivas.org> <1173732344.6431.54.camel@Homer.simpson.net> <8cd998d50703121551u44ea3d85g2541503373f461f4@mail.gmail.com> <1173762639.7944.45.camel@Homer.simpson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173762639.7944.45.camel@Homer.simpson.net>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> [...] The situation as we speak is that you can run cpu intensive 
> tasks while watching eye-candy.  With RSDL, you can't, you feel the 
> non-interactive load instantly. [...]

i have to agree with Mike that this is a material regression that cannot 
be talked around.

Con, we want RSDL to /improve/ interactivity. Having new scheduler 
interactivity logic that behaves /worse/ in the presence of CPU hogs, 
which CPU hogs are even reniced to +5, than the current interactivity 
code, is i think a non-starter. Could you try to fix this, please? Good 
interactivity in the presence of CPU hogs (be them default nice level or 
nice +5) is _the_ most important scheduler interactivity metric. 
Anything else is really secondary.

	Ingo

ps. please be nice to each other - both of you are long-time
    scheduler contributors who did lots of cool stuff :-)
