Return-Path: <linux-kernel-owner+w=401wt.eu-S1756109AbYCGIiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbYCGIiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 03:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbYCGIiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 03:38:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47060 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144AbYCGIiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 03:38:15 -0500
Date: Fri, 7 Mar 2008 09:37:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       arjan@linux.intel.com, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add range_is_allowed() check to mmap of /dev/mem
Message-ID: <20080307083754.GD12150@elte.hu>
References: <20080307070147.GA9888@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080307070147.GA9888@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0111]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:

> Earlier patch that introduced CONFIG_NONPROMISC_DEVMEM, did the 
> range_is_allowed() check only for read and write. Add 
> range_is_allowed() check to mmap of /dev/mem as well.
> 
> Changes the paramaters of range_is_allowed() to pfn and size to handle 
> more than 32 bits of physical address on 32 bit arch cleanly.

thanks, applied.

	Ingo
