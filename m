Return-Path: <linux-kernel-owner+w=401wt.eu-S1754982AbZCHW2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbZCHW2c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 18:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754659AbZCHW2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 18:28:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59664 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754224AbZCHW2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 18:28:23 -0400
Date: Sun, 8 Mar 2009 23:28:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Yinghai Lu <yinghai@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] x86/pci: try to detect host_bridge pci_cfg_space
Message-ID: <20090308222804.GA25376@elte.hu>
References: <49B1C81B.5010904@zytor.com> <49B1C8C1.4090304@kernel.org> <20090308110437.GA27811@elte.hu> <20090308145803.GL25995@parisc-linux.org> <49B4330C.1060700@zytor.com> <49B4343B.9050807@kernel.org> <49B43585.2050606@zytor.com> <49B436E4.1050103@kernel.org> <20090308220100.GO25995@parisc-linux.org> <49B44182.1030707@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B44182.1030707@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> Matthew Wilcox wrote:
> > On Sun, Mar 08, 2009 at 02:21:40PM -0700, Yinghai Lu wrote:
> >> Jesse or Matthew, can you pick this patch?
> > 
> > Having reviewed it in light of HPA's comment, I don't have a problem
> > with it:
> > 
> > Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
> > 
> > However, I don't think it's my place to take this patch while Jesse is
> > away; it doesn't feel like it's needed to be submitted between -rc7 and
> > 2.6.29.  Do you have a reason that it needs to be merged more urgently
> > than 2.6.30-rc1?
> > 
> 
> I didn't see one... I was assuming it was a submission to be 
> pushed upstream during the merge window.
> 
> It doesn't fix a regression, so it doesn't seem to me to be a 
> case for a late -rc merge.  It's hardware enablement, so it 
> *might* qualify for 2.6.29-stable, as far as I understand Greg 
> and Chris' policies.

Yeah. The patch is replacing a slowly-but-surely-bitrotting and 
always-behind quirk table with a more generic 
approach/workaround.

So there's no regression technically - but non-fully-working 
cards are obviously quite annoying on new systems. So i'd 
suggest a .30 merge with a Cc: <stable@kernel.org> tag.

	Ingo
