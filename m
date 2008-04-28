Return-Path: <linux-kernel-owner+w=401wt.eu-S934334AbYD1Nyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934334AbYD1Nyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 09:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933213AbYD1Nyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 09:54:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56517 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933167AbYD1Nya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 09:54:30 -0400
Date: Mon, 28 Apr 2008 15:53:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Mika Fischer <mika.fischer@zoopnet.de>, balajirrao@gmail.com,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86_32: trim memory by updating e820 v3
Message-ID: <20080428135351.GF3973@elte.hu>
References: <200801192045.17291.yinghai.lu@sun.com> <200801202256.48365.yinghai.lu@sun.com> <20080122165125.GA17992@elte.hu> <200801221623.20861.yinghai.lu@sun.com> <20080426035614.a30afb17.akpm@linux-foundation.org> <48132665.8050202@googlemail.com> <86802c440804272344yac6a9f0n40809169424247e6@mail.gmail.com> <48159668.5010808@googlemail.com> <86802c440804280234y5b38b4bds330fc1a6987202c5@mail.gmail.com> <48159ECF.9020004@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48159ECF.9020004@googlemail.com>
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


* Gabriel C <nix.or.die@googlemail.com> wrote:

> > please try v2 version
> > 
> > http://lkml.org/lkml/2008/4/28/115
> 
> Box still won't boot with mtrr_chunk_size=1g but without it is perfect 
> :)) Thx for your work. I've quick tested some games and 3d things , 
> all are working with this patch really nice.

excellent. So just to make sure: this box never had proper graphics 
under Linux (under no previous kernel), due to the way the BIOS has set 
up the MTRR's, right?

so fixing up the MTRRs during bootup, no matter how dangerous in theory, 
is pretty much the best option to get your system to work fine under 
Linux, with that specific Xorg version?

i think we should still try to make this a non-default option because 
modern Xorg should not have any need to touch MTRRs. Perhaps a .config 
dependent on CONFIG_DANGEROUS ;-)

	Ingo
