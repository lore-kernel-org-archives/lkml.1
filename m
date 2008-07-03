Return-Path: <linux-kernel-owner+w=401wt.eu-S936390AbYGCHO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936390AbYGCHO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755047AbYGCG6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:58:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33326 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755337AbYGCG3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 02:29:11 -0400
Date: Thu, 3 Jul 2008 08:28:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hugh Dickins <hugh@veritas.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Jones <pjones@redhat.com>, Glauber Costa <gcosta@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Yinghai Lu <yhlu.kernel@gmail.com>, Huang@elte.hu,
       Ying <ying.huang@intel.com>
Subject: Re: [PATCH] x86: fix Intel Mac booting with EFI
Message-ID: <20080703062829.GA3097@elte.hu>
References: <Pine.LNX.4.64.0807022239520.24137@blonde.site> <20080703061802.GC9884@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080703061802.GC9884@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> * Hugh Dickins <hugh@veritas.com> wrote:
> 
> > Fedora reports that mem_init()'s zap_low_mappings(), extended to SMP 
> > in 61165d7a035f6571c7576e7f51e7230157724c8d x86: fix app crashes after 
> > SMP resume causes 32-bit Intel Mac machines to reboot very early when 
> > booting with EFI.
> > 
> > The EFI code appears to manage low mappings for itself when needed; 
> > but like many before it, confuses PSE with PAE.  So it has only been 
> > mapping half the space it needed when PSE but not PAE.  This remained 
> > unnoticed until we moved the SMP zap_low_mappings() before 
> > efi_enter_virtual_mode().  Presumably could have been noticed years 
> > ago if anyone ran a UP kernel on such machines?
> 
> good spotting!
> 
> Acked-by: Ingo Molnar <mingo@elte.hu>

and also applied to x86/urgent.

	Ingo
