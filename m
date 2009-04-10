Return-Path: <linux-kernel-owner+w=401wt.eu-S936389AbZDJNvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936389AbZDJNvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 09:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762512AbZDJNve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 09:51:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51554 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762124AbZDJNvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 09:51:33 -0400
Date: Fri, 10 Apr 2009 15:51:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Maly <bmaly@redhat.com>, h.peter.anvin@intel.com,
       linux-kernel@vger.kernel.org, dannf@hp.com, ying.huang@intel.com
Subject: Re: [PATCH] rtc: add x86 support for rtc-efi
Message-ID: <20090410135102.GB24809@elte.hu>
References: <49DA40B9.2060804@redhat.com> <49DA817E.8040705@intel.com> <49DA8875.5050009@redhat.com> <20090409161803.f79c0b64.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090409161803.f79c0b64.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 06 Apr 2009 18:55:49 -0400
> Brian Maly <bmaly@redhat.com> wrote:
> 
> > re-post of the patch, both as inline and as an attachment (which 
> > hopefully wont cause confusion).
> > 
> 
> Normally it does confuse me horridly because I get two copies of the
> same patch, which applies happily with `patch --dry-run', but dies
> horridly with `patch --for-real'.  But I was warned...
> 
> In future, please include a full copy of the (possibly modified)
> changelog with each iteration of a patch.
> 
> As this patch is mostly-x86 I tossed it onto my for-Ingo pile.
> 
> 
> From: Brian Maly <bmaly@redhat.com>
> 
> Add support for rtc-efi (RTC Class Driver for EFI-based systems) to x86.
> 
> This patch has been tested and works perfectly on every x86 EFI system I
> could find, though all have been EL64 systems.  I would appreciate any
> testing feedback from EL32 systems from anyone that has one and can test.
> 
> Signed-off-by: Brian Maly <bmaly@redhat.com>
> Acked-by: dann frazier <dannf@hp.com>
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Cc: David Brownell <david-b@pacbell.net>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  arch/x86/kernel/time_32.c |   19 +++++++++++++++++++
>  arch/x86/kernel/time_64.c |   18 ++++++++++++++++++
>  drivers/rtc/Kconfig       |    2 +-
>  3 files changed, 38 insertions(+), 1 deletion(-)

Hm, it would be nice to first unify the relevant bits of 
arch/x86/kernel/time_{32|64}.c into arch/x86/kernel/time.c, and then 
we can apply such patches without duplicative effects.

	Ingo
