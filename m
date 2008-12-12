Return-Path: <linux-kernel-owner+w=401wt.eu-S1757459AbYLLI2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459AbYLLI2R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 03:28:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbYLLI2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 03:28:05 -0500
Received: from ozlabs.org ([203.10.76.45]:54351 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbYLLI2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 03:28:03 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 1/4] x86: fix assign_irq_vector boot up problem
Date: Fri, 12 Dec 2008 18:57:55 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; i686; ; )
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
References: <20081211112806.499831000@polaris-admin.engr.sgi.com> <20081211112806.740820000@polaris-admin.engr.sgi.com>
In-Reply-To: <20081211112806.740820000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812121857.55929.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 December 2008 21:58:07 Mike Travis wrote:
> Impact: fix boot up problem.
> 
> Fix a problem encountered with the Intel SATA-AHCI disk driver
> right at system startup.  Cpumask_intersects really needs to be
> a 3-way intersect, and since we need a cpumask_var_t later on,
> then just use it for the 3-way intersect as well.

This one looks fine.

My plan was for Ingo to pull that for-ingo tree into his cpus4096 tree
and take the x86 patches from there.  But he hasn't so maybe I should
take this chance to fold that patch in?

Thanks,
Rusty.
