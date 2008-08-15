Return-Path: <linux-kernel-owner+w=401wt.eu-S1759435AbYHOOcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435AbYHOOcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 10:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756335AbYHOOcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 10:32:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42433 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296AbYHOOcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 10:32:08 -0400
Date: Fri, 15 Aug 2008 16:31:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, airlied@linux.ie,
       Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch 2/2] reduce tlb/cache flush times of agpgart memory
	allocation
Message-ID: <20080815143131.GF12954@elte.hu>
References: <1217832690.21811.9.camel@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217832690.21811.9.camel@sli10-desk.sh.intel.com>
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


* Shaohua Li <shaohua.li@intel.com> wrote:

> To reduce tlb/cache flush, makes agp memory allocation do one flush 
> after all pages in a region are changed to uc.
> 
> All agp drivers except agp-sgi uses agp_generic_alloc_page() for 
> .agp_alloc_page, so the patch should work for them. agp-sgi is only 
> for ia64, so not a problem too.

applied to tip/x86/pat - thanks!

I've Cc:-ed more PAT folks - any objections?

	Ingo
