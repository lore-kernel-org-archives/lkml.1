Return-Path: <linux-kernel-owner+w=401wt.eu-S1757440AbYGRPqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440AbYGRPqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 11:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbYGRPqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 11:46:35 -0400
Received: from www.tglx.de ([62.245.132.106]:41997 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbYGRPqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 11:46:34 -0400
Date: Fri, 18 Jul 2008 17:46:24 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, hjk@linutronix.de, gregkh@suse.de,
       akpm@linux-foundation.org
Subject: Re: [PATCH 00/06] uio: Various minor changes
Message-ID: <20080718154624.GE3284@local>
References: <20080718050402.16250.25213.sendpatchset@rx1.opensource.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080718050402.16250.25213.sendpatchset@rx1.opensource.se>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 02:04:02PM +0900, Magnus Damm wrote:
> Hi everyone,
> 
> Here comes a few UIO changes that I've had in my queue for a while.

Hi Magnus,
thanks a lot for your patches. I'll have a look at them ASAP, but it'll
take a few days. I'm busy moving to a new house ATM...

Greg, could you help reviewing these ?

Thanks,
Hans

> 
> [PATCH 01/06] uio: Use struct_uio_mem instead of index
> [PATCH 02/06] uio: Pass struct uio_mem to mmap functions
> [PATCH 03/06] uio: Remove vma->vm_private_data from uio_find_mem()
> [PATCH 04/06] uio: Store struct uio_mem ptr in vma->vm_private_data
> [PATCH 05/06] uio: Remove redundant vma->vm_flags setup code
> [PATCH 06/06] uio: Support multiple UIO_MEM_LOGICAL/VIRTUAL pages
> 
> Mostly small cleanups or performance improvements, except the last one
> which contains a fix for unsupported multi-page LOGICAL/VIRTUAL maps.
> 
> Signed-off-by: Magnus Damm <damm@igel.co.jp>
> ---
> 
>  Documentation/DocBook/uio-howto.tmpl |    2 
>  drivers/uio/uio.c                    |   91 +++++++++++++++-------------------
>  include/linux/uio_driver.h           |    1 
>  3 files changed, 44 insertions(+), 50 deletions(-)
