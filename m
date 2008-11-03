Return-Path: <linux-kernel-owner+w=401wt.eu-S1755389AbYKCKsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbYKCKsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 05:48:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755087AbYKCKs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 05:48:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38743 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755083AbYKCKs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 05:48:27 -0500
Date: Mon, 3 Nov 2008 11:48:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dave Airlie <airlied@gmail.com>
Cc: Keith Packard <keithp@keithp.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Dave Airlie <airlied@linux.ie>,
       Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: io resources and cached mappings (was: [git pull] drm patches
	for 2.6.27-rc1)
Message-ID: <20081103104807.GN13671@elte.hu>
References: <20081022093615.GF12453@elte.hu> <1224746087-13991-1-git-send-email-keithp@keithp.com> <20081023080553.GB14714@elte.hu> <1224776350.6738.14.camel@koto.keithp.com> <21d7e9970811022300o2576b437kb35a55e2751889f6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9970811022300o2576b437kb35a55e2751889f6@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Airlie <airlied@gmail.com> wrote:

> On Fri, Oct 24, 2008 at 1:39 AM, Keith Packard <keithp@keithp.com> wrote:
> > On Thu, 2008-10-23 at 10:05 +0200, Ingo Molnar wrote:
> >
> >> Any ballpark-figure numbers you can share with us?
> >
> > For one quake-3 based game we use for performance regression checking,
> > 64-bit kernels run about 18 times faster now. That's the difference
> > between using a zero-cost dynamic mapping and using ioremap_wc for each
> > page.
> >
> > --
> > keith.packard@intel.com
> >
> 
> So I've put these patches into Fedora rawhide kernel to test, and 
> glxgears on my 945G hw went from 85fps to 380fps, clearly we would 
> want these patches upstream sooner rather than later.

yep, it's all lined up already in tip/core/resources, and got 
massively tested over the past few days. Will send a pull request to 
Linus tomorrow-ish - we need one final cleanup patch and then it's 
green to go.

	Ingo
