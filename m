Return-Path: <linux-kernel-owner+w=401wt.eu-S932890AbXB0KQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932890AbXB0KQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 05:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932891AbXB0KQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 05:16:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46254 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932890AbXB0KQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 05:16:30 -0500
Date: Tue, 27 Feb 2007 11:09:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       William Lee Irwin III <wli@holomorphy.com>
Subject: Re: [patch 05/26] Xen-paravirt_ops: paravirt_ops: hooks to set up initial pagetable
Message-ID: <20070227100942.GB10827@elte.hu>
References: <20070227081337.434798469@goop.org> <20070227081630.650554241@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070227081630.650554241@goop.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.1.7
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4563]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> ===================================================================
> --- a/include/asm-i386/pgtable.h
> +++ b/include/asm-i386/pgtable.h
> @@ -15,7 +15,10 @@
>  #include <asm/processor.h>
>  #include <asm/fixmap.h>
>  #include <linux/threads.h>
> +
> +#ifdef CONFIG_PARAVIRT		/* guarded to prevent cyclic dependency */
>  #include <asm/paravirt.h>
> +#endif

avoid the cyclic dependency to begin with?

	Ingo
