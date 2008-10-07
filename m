Return-Path: <linux-kernel-owner+w=401wt.eu-S1754685AbYJGFWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbYJGFWh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 01:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750908AbYJGFW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 01:22:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55213 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbYJGFW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 01:22:28 -0400
Date: Tue, 7 Oct 2008 07:22:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Huang Ying <ying.huang@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH -mm -v4] Separate atomic_t declaration from
	asm/atomic.h into asm/atomic_def.h
Message-ID: <20081007052214.GA27248@elte.hu>
References: <1223342608.5872.28.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223342608.5872.28.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Huang Ying <ying.huang@intel.com> wrote:

> --- /dev/null
> +++ b/include/asm-x86/atomic_types.h
> @@ -0,0 +1,13 @@
> +#ifndef __ARCH_X86_ATOMIC_DEF__
> +#define __ARCH_X86_ATOMIC_DEF__

looks good. A small detail, you'll also need:

 sed -i 's/ATOMIC_DEF/ATOMIC_TYPES.h/g' patches/separate-atomic.patch

	Ingo
