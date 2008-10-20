Return-Path: <linux-kernel-owner+w=401wt.eu-S1752511AbYJTKBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbYJTKBx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 06:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbYJTKBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 06:01:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47613 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbYJTKBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 06:01:44 -0400
Date: Mon, 20 Oct 2008 12:01:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Keith Packard <keithp@keithp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Dave Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dri-devel@lists.sf.net, Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [git pull] drm patches for 2.6.27-rc1
Message-ID: <20081020100122.GA12139@elte.hu>
References: <alpine.DEB.0.82.0810172227490.14817@skynet.skynet.ie> <200810181237.49784.nickpiggin@yahoo.com.au> <1224357062.4384.72.camel@koto.keithp.com> <alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org> <20081018203741.GA23396@elte.hu> <1224366690.4384.89.camel@koto.keithp.com> <20081018223214.GA5093@elte.hu> <1224376691.4384.105.camel@koto.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224376691.4384.105.camel@koto.keithp.com>
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


* Keith Packard <keithp@keithp.com> wrote:

> On Sun, 2008-10-19 at 00:32 +0200, Ingo Molnar wrote:
> 
> > the _real_ remapping in a graphics aperture happens on the GPU level 
> > anyway, you manage an in-RAM GPU pagetable that just works like an 
> > IOMMU, correct?
> 
> Yes, a one-level linear MMU which uses BIOS-reserved memory.
> 
> So, at least for a prototype, on 64-bit we can just use ioremap_wc and 
> hold the mapping while the driver is open? Is there any huge benefit 
> to using the kernel mapping?

correct. There's no benefit to using the kernel mapping - and we can add 
2MB pages support to ioremap just fine and then you'll benefit from it 
automatically.

	Ingo
