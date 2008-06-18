Return-Path: <linux-kernel-owner+w=401wt.eu-S1754431AbYFRPta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbYFRPta (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 11:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751971AbYFRPtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 11:49:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60785 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751957AbYFRPtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 11:49:19 -0400
Date: Wed, 18 Jun 2008 08:48:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       Jan Engelhardt <jengelh@gmx.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: RFC [PATCH] x86: try to remove arch_get_ram_range
Message-Id: <20080618084850.40adb1a8.akpm@linux-foundation.org>
In-Reply-To: <20080618140726.GF11501@elte.hu>
References: <200806162010.55495.yhlu.kernel@gmail.com>
	<20080618140726.GF11501@elte.hu>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2008 16:07:26 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> 
> > want to remove arch_get_ram_range, and use early_node_map instead.
> 
> (small request: please include diffstat output in your patches in the 
> future if possible: "quilt refresh --diffstat" will do that - this way 
> people will know why they were Cc:-ed)
> 
> this touches the MM:
> 
>  arch/x86/mm/init_32.c     |    6 +++--
>  drivers/pci/intel-iommu.c |   51 +++++++++++++++++++++++++++++++++-------------
>  include/linux/mm.h        |    2 -
>  mm/page_alloc.c           |   10 ++++++---
>  4 files changed, 49 insertions(+), 20 deletions(-)
> 
> but has many dependencies on ongoing arch/x86 work. Andrew, is this 
> change fine with with you?
> 

Beats me - I don't even have a mm/page_alloc.c:work_with_active_regions()
in my tree.
