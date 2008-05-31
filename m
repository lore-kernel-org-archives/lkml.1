Return-Path: <linux-kernel-owner+w=401wt.eu-S1754160AbYEaIBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbYEaIBw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 04:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbYEaIBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 04:01:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55392 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473AbYEaIBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 04:01:43 -0400
Date: Sat, 31 May 2008 10:01:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: 32bit numa srat fix early_ioremap leak
Message-ID: <20080531080129.GA30343@elte.hu>
References: <200805110030.15510.yhlu.kernel@gmail.com> <200805211840.18619.yhlu.kernel@gmail.com> <200805251000.10205.yhlu.kernel@gmail.com> <200805291625.56942.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805291625.56942.yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> Pid: 0, comm: swapper Not tainted 2.6.26-rc4 #4
>  [<80b41289>] hlt_loop+0x0/0x3
>  [<8011efa0>] ? alloc_remap+0x50/0x70
>  [<8079e32e>] alloc_node_mem_map+0x5e/0xa0
>  [<8012e77b>] ? printk+0x1b/0x20
>  [<80b590f6>] free_area_init_node+0xc6/0x470
>  [<80b588fc>] ? __alloc_bootmem_node+0x2c/0x50
>  [<80b58ad8>] ? find_min_pfn_for_node+0x38/0x70
>  [<8012e77b>] ? printk+0x1b/0x20
>  [<80b597c4>] free_area_init_nodes+0x254/0x2d0
>  [<80b544d7>] zone_sizes_init+0x97/0xa0
>  [<80b48a03>] setup_arch+0x383/0x530
>  [<8012e77b>] ? printk+0x1b/0x20
>  [<80b41aa4>] start_kernel+0x64/0x350
>  [<80b412d8>] i386_start_kernel+0x8/0x10
>  =======================
> 
> this patch increase the acpi table limit to 32
> match early_ioremap with early_iounmap

applied all 4 early-reserve related fixes from you - thanks Yinghai!

	Ingo
