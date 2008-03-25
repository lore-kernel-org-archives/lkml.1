Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbYCYOdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbYCYOdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 10:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755348AbYCYOdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 10:33:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40419 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754764AbYCYOdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:33:40 -0400
Date: Tue, 25 Mar 2008 15:33:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, suresh.b.siddha@intel.com
Subject: Re: [PATCH] x86: PAT bug fix for attribute type check after
	reserve_memtype
Message-ID: <20080325143326.GC11323@elte.hu>
References: <20080324213955.GA10456@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080324213955.GA10456@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:

> Bug fixes for reserve_memtype() call in __ioremap and 
> pci_mmap_page_range(). If reserve_memtype returns non-zero, then it is 
> an error and subsequent free is not required. Requested and returned 
> prot value check should be done when reserve_memtype returns success.

thanks, applied.

> +	if (retval) {
> +		printk("reserve_memtype returned %d\n", retval);

that needs a KERN_INFO, and should be labeled "Warning: ...".

	Ingo
