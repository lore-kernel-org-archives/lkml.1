Return-Path: <linux-kernel-owner+w=401wt.eu-S1758524AbYF3I2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524AbYF3I2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 04:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbYF3I2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 04:28:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39220 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408AbYF3I2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 04:28:45 -0400
Date: Mon, 30 Jun 2008 10:28:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "Huang, Ying" <ying.huang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       andi@firstfloor.org, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86 boot: add E820_RESVD_KERN
Message-ID: <20080630082827.GA1092@elte.hu>
References: <1214461978.10809.6.camel@caritas-dev.intel.com> <86802c440806260025v3fc1970aq682b568cccba4b4e@mail.gmail.com> <1214466513.11346.30.camel@caritas-dev.intel.com> <86802c440806260247p19f5b850r8757c51280912ae9@mail.gmail.com> <86802c440806261922n3f13b454o5e543e28d9a34e8e@mail.gmail.com> <1214534894.10865.6.camel@caritas-dev.intel.com> <86802c440806271505n78275758re235ef6616d95b3d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86802c440806271505n78275758re235ef6616d95b3d@mail.gmail.com>
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

> > ﻿OK. Because some E820 entries are available after 
> > parse_setup_data(), it is better to call reserve_setup_data() after 
> > calling parse_setup_data() if update_e820_range() is used instead of 
> > reserve_early().
> 
> please modify it and test on your platforms then submit to Ingo..

btw, a small suggestion: it is a bit easier on the maintainer side if 
you also send Acked-by lines in such cases (which can be picked up for 
the next iteration of these patches) - that way we can see which patches 
have been reviewed and acked by you and which ones are still under 
discussion.

	Ingo
