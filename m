Return-Path: <linux-kernel-owner+w=401wt.eu-S1762059AbZC2CGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762059AbZC2CGz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 22:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757008AbZC2CEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 22:04:14 -0400
Received: from ozlabs.org ([203.10.76.45]:46567 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754669AbZC2CEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 22:04:08 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] irq: correct CPUMASKS_OFFSTACK typo -v2
Date: Sun, 29 Mar 2009 12:33:52 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, Mike Travis <travis@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <49CDAB27.7050602@kernel.org> <200903281937.48755.rusty@rustcorp.com.au> <49CE8401.6040303@kernel.org>
In-Reply-To: <49CE8401.6040303@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903291233.53920.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 29 March 2009 06:39:37 Yinghai Lu wrote:
> 
> Impact: fix smp_affinity copying when moving irq_desc
> 
> CPUMASKS_OFFSTACK is not defined anywhere. it is a typo
> and init_allocate_desc_masks called before it set affinity to all cpus...
> 
> split init_alloc_desc_masks() into all_desc_masks() and init_desc_masks()
> so in the init_copy_desc_masks could use CPUMASK_OFFSTACK there.
> aka copy path will not calling init_desc_masks anymore.

Thankyou, this code is nicer than what was there before.

Thanks!
Rusty.
