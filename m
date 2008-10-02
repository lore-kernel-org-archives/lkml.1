Return-Path: <linux-kernel-owner+w=401wt.eu-S1753618AbYJBIaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618AbYJBIaS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 04:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbYJBIaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 04:30:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43950 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbYJBIaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 04:30:03 -0400
Date: Thu, 2 Oct 2008 10:29:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Woodhouse <dwmw2@infradead.org>, Avi Kivity <avi@redhat.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org
Subject: Re: [PATCH 1/2]Add Variable Page Size and IA64 Support in Intel
	IOMMU: Generic Part
Message-ID: <20081002082942.GA26084@elte.hu>
References: <BAE9DCEF64577A439B3A37F36F9B691C0339372B@orsmsx418.amr.corp.intel.com> <617E1C2C70743745A92448908E030B2A02AD5AD7@scsmsx411.amr.corp.intel.com> <20081001165725.GA21559@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081001165725.GA21559@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0120]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Fenghua Yu <fenghua.yu@intel.com> wrote:

> --- a/drivers/pci/dmar.c
> +++ b/drivers/pci/dmar.c
> @@ -35,6 +35,10 @@
>  #undef PREFIX
>  #define PREFIX "DMAR:"
>  
> +#ifdef CONFIG_IA64
> +#define cpu_has_x2apic 0
> +#endif

hm, that's not too nice - why not add it to arch/ia64/include/?

	Ingo
