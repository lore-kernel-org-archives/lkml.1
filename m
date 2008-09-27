Return-Path: <linux-kernel-owner+w=401wt.eu-S1753669AbYI0QKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbYI0QKt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 12:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbYI0QKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 12:10:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60081 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391AbYI0QKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 12:10:41 -0400
Date: Sat, 27 Sep 2008 18:10:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Huang Ying <ying.huang@intel.com>
Cc: Russ Anderson <rja@sgi.com>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [PATCH 2/4] x86: Add UV bios call infrastructure v2
Message-ID: <20080927161034.GB29661@elte.hu>
References: <20080926200242.GC138671@sgi.com> <1222478495.28661.19.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222478495.28661.19.camel@yhuang-dev.sh.intel.com>
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


* Huang Ying <ying.huang@intel.com> wrote:

> efi_call_virt<n> and efi_call_phys<n> is the API instead of efi_call<n>.
> And please put the implementation without CONFIG_EFI defined out of
> 
> #ifdef CONFIG_X86_32
> <...>
> #else
> <...>
> #endif

ok - i'll wait for v3 of this patchset.

	Ingo
