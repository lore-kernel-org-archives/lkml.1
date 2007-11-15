Return-Path: <linux-kernel-owner+w=401wt.eu-S1762691AbXKOSDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762691AbXKOSDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 13:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbXKOSDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 13:03:07 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:58728 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755241AbXKOSDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 13:03:06 -0500
Date: Thu, 15 Nov 2007 19:04:36 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] x86: revert X86_HT semantics change
Message-ID: <20071115180436.GA23517@uranus.ravnborg.org>
References: <20071115161703.GR4250@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071115161703.GR4250@stusta.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2007 at 05:17:03PM +0100, Adrian Bunk wrote:
> The x86 unification resulted in CONFIG_X86_HT no longer being
> set if (X86_32 && MK8).
Yup - my bad. I wrongly assumed MK8 was an X86_64 thing.

Thanks for fixing this.
> 
> After grep'ing through the tree I think the problem is that different 
> places have different assumptions about the semantics of CONFIG_X86_HT,
> either:
> - hyperthreading or
> - multicore
> and the SCHED_SMT and SCHED_MC dependencies are just one of the 
> symptoms.
> 
> This should be sorted out properly, but until then we should keep the 
> 2.6.23 status quo.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Sam Ravnborg <sam@ravnborg.org>

I assume Thomas & Co will forward the patch.

	Sam
