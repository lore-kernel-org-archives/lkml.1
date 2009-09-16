Return-Path: <linux-kernel-owner+w=401wt.eu-S1758922AbZIPULq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922AbZIPULq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 16:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754746AbZIPULl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 16:11:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57968 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411AbZIPULl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 16:11:41 -0400
Subject: Re: [PATCH] Fix oprofile regression: select RING_BUFFER_ALLOW_SWAP
From: Steven Rostedt <srostedt@redhat.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Robert Richter <robert.richter@amd.com>
In-Reply-To: <200909162156.49239.borntraeger@de.ibm.com>
References: <200909162156.49239.borntraeger@de.ibm.com>
Content-Type: text/plain
Organization: Red Hat
Date: Wed, 16 Sep 2009 16:11:30 -0400
Message-Id: <1253131890.2964.168.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-16 at 21:56 +0200, Christian Borntraeger wrote:
> commit 85bac32c4a52c592b857f2c360cc5ec93a097d70                                                                                                                             
>     ring-buffer: only enable ring_buffer_swap_cpu when needed
> broke oprofile (at least on s390, but likely on all platforms).
> 
> this patch lets oprofile select RING_BUFER_ALLOW_SWAP to make 
> ring_buffer_swap_cpu usable for oprofile.

Thanks, I'll apply this for the 32 queue.

-- Steve

PS. Please send patches to my rostedt@goodmis.org account. I don't
always read my Red Hat email.

> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> CC-ed: Steven Rostedt <srostedt@redhat.com> 
> CC-ed: Ingo Molnar <mingo@elte.hu>
> CC-ed: Robert Richter <robert.richter@amd.com>                                                                                                                      
> ---
>  arch/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux-2.6/arch/Kconfig
> ===================================================================
> --- linux-2.6.orig/arch/Kconfig
> +++ linux-2.6/arch/Kconfig
> @@ -9,6 +9,7 @@ config OPROFILE
>  	depends on TRACING_SUPPORT
>  	select TRACING
>  	select RING_BUFFER
> +	select RING_BUFFER_ALLOW_SWAP
>  	help
>  	  OProfile is a profiling system capable of profiling the
>  	  whole system, include the kernel, kernel modules, libraries,

