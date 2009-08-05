Return-Path: <linux-kernel-owner+w=401wt.eu-S934452AbZHENu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934452AbZHENu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 09:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934435AbZHENu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 09:50:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60825 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934369AbZHENuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 09:50:21 -0400
Date: Wed, 5 Aug 2009 09:49:28 -0400
From: Neil Horman <nhorman@redhat.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, tony.luck@intel.com,
       linux-ia64@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [Patch 5/7] powerpc: add CONFIG_KEXEC_AUTO_RESERVE
Message-ID: <20090805134928.GH7259@hmsreliant.think-freely.org>
References: <20090805112123.6552.73574.sendpatchset@localhost.localdomain> <20090805112211.6552.58889.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090805112211.6552.58889.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 07:19:51AM -0400, Amerigo Wang wrote:
> 
> Introduce a new config option KEXEC_AUTO_RESERVE for powerpc.
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>
> 
> ---
> Index: linux-2.6/arch/powerpc/Kconfig
> ===================================================================
> --- linux-2.6.orig/arch/powerpc/Kconfig
> +++ linux-2.6/arch/powerpc/Kconfig
> @@ -346,6 +346,16 @@ config KEXEC
>  	  support.  As of this writing the exact hardware interface is
>  	  strongly in flux, so no good recommendation can be made.
>  
> +config KEXEC_AUTO_RESERVE
> +	bool "automatically reserve memory for kexec kernel"
> +	depends on KEXEC
> +	default y
> +	---help---
> +	  Automatically reserve memory for a kexec kernel, so that you don't
> +	  need to specify numbers for the "crashkernel=X@Y" boot option,
> +	  instead you can use "crashkernel=auto".
> +	  On PPC, 256M is reserved and only when you have memory > 4G.
> +
>  config CRASH_DUMP
>  	bool "Build a kdump crash kernel"
>  	depends on PPC64 || 6xx

Acked-by: Neil Horman <nhorman@tuxdriver.com>
