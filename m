Return-Path: <linux-kernel-owner+w=401wt.eu-S1758314AbYHZN2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758314AbYHZN2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 09:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754603AbYHZN2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 09:28:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55130 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754577AbYHZN2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 09:28:33 -0400
Date: Tue, 26 Aug 2008 15:28:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Witbrodt <dawitbro@sbcglobal.net>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>, stable@kernel.org
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user
	with the same regression
Message-ID: <20080826132815.GA2427@elte.hu>
References: <444229.17503.qm@web82104.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <444229.17503.qm@web82104.mail.mud.yahoo.com>
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


* David Witbrodt <dawitbro@sbcglobal.net> wrote:

> > Note that the hpet fix is now upstream  [...]
> 
> Any chance this can be applied to stable 2.6.26.x?
> 
> Half of my agenda was selfish (to be sure future kernels would not 
> hang on my 2 home servers), but the other half was to ensure that 
> Debian would not have hanging kernels in their next stable release.

it's a backport candidate, but i think we should wait a bit with that, 
until after .27-rc5 or -rc6, to make sure there are no side-effects.

The upstream commit is:

 commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
 Author: Yinghai Lu <yhlu.kernel@gmail.com>
 Date:   Mon Aug 25 00:56:08 2008 -0700

    x86: fix HPET regression in 2.6.26 versus 2.6.25, check hpet against BAR, v3

btw., are both of your systems that were hanging fixed by this commit?

> Thanks again for all the hard work,

you are welcome!

	Ingo
