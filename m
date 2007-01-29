Return-Path: <linux-kernel-owner+w=401wt.eu-S1751977AbXA2Tyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbXA2Tyx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 14:54:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbXA2Tyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 14:54:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42357 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977AbXA2Tyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 14:54:52 -0500
Date: Mon, 29 Jan 2007 20:53:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@osdl.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: remove global locks from mm/highmem.c
Message-ID: <20070129195307.GA24434@elte.hu>
References: <1169993494.10987.23.camel@lappy> <20070128142925.df2f4dce.akpm@osdl.org> <20070129190806.GA14353@elte.hu> <Pine.LNX.4.64.0701291916420.10401@blonde.wat.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0701291916420.10401@blonde.wat.veritas.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.3 required=5.9 tests=ALL_TRUSTED,BAYES_40 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	1.0 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3559]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Hugh Dickins <hugh@veritas.com> wrote:

> > For every 64-bit Fedora box there's more than seven 32-bit boxes. I 
> > think 32-bit is going to live with us far longer than many thought, 
> > so we might as well make it work better. Both HIGHMEM and HIGHPTE is 
> > the default on many distro kernels, which pushes the kmap 
> > infrastructure quite a bit.
> 
> But HIGHPTE uses kmap_atomic (in mainline: does -rt use kmap there?)

The contention i saw was on mainline and in the pagecache uses of 
kmap(). With HIGHPTE i only meant that typically every available highmem 
option is enabled on 32-bit distro kernel rpms, to make it work on as 
wide selection of hardware as possible. Sometimes PAE is split into a 
separate rpm, but mostly there's just one 32-bit kernel.

	Ingo
