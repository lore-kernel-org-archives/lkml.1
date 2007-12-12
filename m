Return-Path: <linux-kernel-owner+w=401wt.eu-S1759401AbXLLKfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759401AbXLLKfp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 05:35:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758435AbXLLKfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 05:35:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52069 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755103AbXLLKfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 05:35:36 -0500
Date: Wed, 12 Dec 2007 11:35:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [crash] kernel BUG at drivers/cpufreq/cpufreq.c:1060!
Message-ID: <20071212103524.GB1611@elte.hu>
References: <20071212091144.GA11986@elte.hu> <b6fcc0a0712120221h51a27cc5s1e17d3607412eadc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6fcc0a0712120221h51a27cc5s1e17d3607412eadc@mail.gmail.com>
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


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On 12/12/07, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > 2.6.24-rc4-git5, got this cpufreq crash on x86 64-bit, during 'make
> > randconfig' random bootup testing:
> 
> Ingo, since you already scripted this, maybe you can add "modprobe 
> everything/rmmod everything" test after successful bootup. It will 
> catch amazing amount of stuff, I promise.

something close to that is one of my standard tests: booting up an 
allyesconfig kernel.

	Ingo
