Return-Path: <linux-kernel-owner+w=401wt.eu-S1754609AbZCHVcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbZCHVcX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 17:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754246AbZCHVcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 17:32:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58194 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754209AbZCHVcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 17:32:13 -0400
Date: Sun, 8 Mar 2009 22:31:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <matthew@wil.cx>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] x86/pci: try to detect host_bridge pci_cfg_space
Message-ID: <20090308213156.GA20272@elte.hu>
References: <49B1C50E.5010209@kernel.org> <49B1C69F.70904@zytor.com> <49B1C81B.5010904@zytor.com> <49B1C8C1.4090304@kernel.org> <20090308110437.GA27811@elte.hu> <20090308145803.GL25995@parisc-linux.org> <49B4330C.1060700@zytor.com> <49B4343B.9050807@kernel.org> <49B43585.2050606@zytor.com> <49B436E4.1050103@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B436E4.1050103@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> H. Peter Anvin wrote:
> > Yinghai Lu wrote:
> >>> It's still generic PCI code, however.  If there is no host bridge
> >>> exposed in PCI space, the patch is a noop.
> >> ok, will split that patch to two
> >> 1. one touch pci.c
> >> 2. and one touch x86/pci.
> >>
> > 
> > Speaking for myself, I don't see a reason to do that.  Just push the
> > combined patch to Jesse.
> > 
> > Acked-by: H. Peter Anvin <hpa@zytor.com>
> > 
> > ... if you need it.
> 
> thanks. 
> 
> Jesse or Matthew, can you pick this patch?

You might want to resubmit it with the added changelog items 
pointed out in the discussion.

	Ingo
