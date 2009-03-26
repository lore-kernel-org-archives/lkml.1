Return-Path: <linux-kernel-owner+w=401wt.eu-S1754199AbZCZFwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbZCZFwi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 01:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbZCZFw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 01:52:29 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:46515 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802AbZCZFw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 01:52:28 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18891.6159.109191.255560@drongo.ozlabs.ibm.com>
Date: Thu, 26 Mar 2009 16:52:15 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [RFC][PATCH 2/3] perf_counter: executable mmap() information
In-Reply-To: <20090325210542.293237509@chello.nl>
References: <20090325210419.408653980@chello.nl>
	<20090325210542.293237509@chello.nl>
X-Mailer: VM 8.0.12 under 22.2.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> --- linux-2.6.orig/include/linux/perf_counter.h
> +++ linux-2.6/include/linux/perf_counter.h
> @@ -137,7 +137,9 @@ struct perf_counter_hw_event {
>  				exclude_kernel :  1, /* ditto kernel          */
>  				exclude_hv     :  1, /* ditto hypervisor      */
>  				exclude_idle   :  1, /* don't count when idle */
> -				include_tid    :  1, /* include the tid */
> +				include_tid    :  1, /* include the tid       */
> +				mmap           :  1, /* include mmap data     */
> +				munmap         :  1, /* include munmap data   */
>  
>  				__reserved_1   : 54;

Nit: need to adjust the size of __reserved_1 here.  Or maybe just get
rid of it?

Paul.
