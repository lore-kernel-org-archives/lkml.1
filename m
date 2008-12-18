Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752867AbYLRNb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbYLRNb5 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 08:31:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750853AbYLRNbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 08:31:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58763 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093AbYLRNbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 08:31:47 -0500
Date: Thu, 18 Dec 2008 14:31:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ken Chen <kenchen@google.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] x86: convert rdtscll() to use __native_read_tsc
Message-ID: <20081218133134.GH32135@elte.hu>
References: <b040c32a0812160032pf681f13s9e5e86c4b5448012@mail.gmail.com> <20081216091509.GA29872@elte.hu> <49477452.6030307@goop.org> <20081216101551.GA27481@elte.hu> <b040c32a0812170007s59600707h5a8597a1cbe9cc21@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b040c32a0812170007s59600707h5a8597a1cbe9cc21@mail.gmail.com>
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


* Ken Chen <kenchen@google.com> wrote:

> On Tue, Dec 16, 2008 at 2:15 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > agreed mostly, with this twist: vdso inlining dependencies should be
> > expressed explicitly, via:
> >
> >  native_vread_tsc()
> >
> > but we can also make native_read_tsc() __always_inline [it's a single
> > instruction with basically no preparatory halo around that instruction]
> > and document the vdso detail there.
> 
> Given that vdso already uses the inline version of __native_read_tsc, we 
> don't really have churn all that code around.  I also take your analysis 
> as there is no issue in converting rdtscll() to __native_read_tsc().  
> Would it be possible for you to merge the patch then?

yep, i already did that when i replied to your mail, it's in tip/x86/time.

	Ingo
