Return-Path: <linux-kernel-owner+w=401wt.eu-S1756376AbYGaTE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376AbYGaTE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 15:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752437AbYGaTER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 15:04:17 -0400
Received: from gate.crashing.org ([63.228.1.57]:44541 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753096AbYGaTEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 15:04:16 -0400
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Kumar Gala <galak@kernel.crashing.org>
Message-Id: <E4D699C2-07A8-42FF-A863-5595099CEC4D@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
In-Reply-To: <Pine.LNX.4.64.0807311345380.8012@blarg.am.freescale.net>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH] powerpc/mm: Implement _PAGE_SPECIAL & pte_special() for 32-bit
Date: Thu, 31 Jul 2008 13:50:28 -0500
References: <Pine.LNX.4.64.0807311345380.8012@blarg.am.freescale.net>
X-Mailer: Apple Mail (2.926)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 31, 2008, at 1:48 PM, Kumar Gala wrote:

> Implement _PAGE_SPECIAL and pte_special() for 32-bit powerpc. This  
> bit will
> be used by the fast get_user_pages() to differenciate PTEs that  
> correspond
> to a valid struct page from special mappings that don't such as IO  
> mappings
> obtained via io_remap_pfn_ranges().
>
> We currently only implement this on sub-arch that support SMP or  
> will so
> in the future (6xx, 44x, FSL-BookE) and not (8xx, 40x).
>
> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> ---
> Nick, do you forsee using _PAGE_SPECIAL for other applications that  
> would
> be of interested to non-SMP hw?
>
> We can look at adding it into 8xx and 40x, but was being lazy as I  
> assume
> there is no point.
>
> - k

Josh,

Can you test this on 44x for me.

thanks

- k
