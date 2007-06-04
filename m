Return-Path: <linux-kernel-owner+w=401wt.eu-S1757405AbXFDPNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405AbXFDPNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 11:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755017AbXFDPNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 11:13:09 -0400
Received: from smtp-out.google.com ([216.239.45.13]:10523 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575AbXFDPNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 11:13:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=yeFi+HXVuuQJ3IciyiX3NV3n/g/cBV6b/ySCydCHrmwY6OgrIbwoqM0TB7GU4i4RQ
	917D7Ol/J2Tx0QTuzunqA==
Date: Mon, 4 Jun 2007 08:08:21 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Stephane Eranian <eranian@frankl.hpl.hp.com>
cc: linux-kernel@vger.kernel.org, eranian@hpl.hp.com
Subject: Re: [PATCH 15/22] 2.6.22-rc3 perfmon2 : modified i386 files
In-Reply-To: <200705291348.l4TDmTxN019801@frankl.hpl.hp.com>
Message-ID: <alpine.DEB.0.99.0706040807520.11881@chino.kir.corp.google.com>
References: <200705291348.l4TDmTxN019801@frankl.hpl.hp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2007, Stephane Eranian wrote:

> diff --exclude=.git -urp linux-2.6.22.base/include/asm-i386/unistd.h linux-2.6.22/include/asm-i386/unistd.h
> --- linux-2.6.22.base/include/asm-i386/unistd.h	2007-05-29 03:17:41.000000000 -0700
> +++ linux-2.6.22/include/asm-i386/unistd.h	2007-05-29 03:24:14.000000000 -0700
> @@ -329,10 +329,22 @@
>  #define __NR_signalfd		321
>  #define __NR_timerfd		322
>  #define __NR_eventfd		323
> +#define __NR_pfm_create_context	324
> +#define __NR_pfm_write_pmcs	(__NR_pfm_create_context+1)
> +#define __NR_pfm_write_pmds	(__NR_pfm_create_context+2)
> +#define __NR_pfm_read_pmds	(__NR_pfm_create_context+3)
> +#define __NR_pfm_load_context	(__NR_pfm_create_context+4)
> +#define __NR_pfm_start		(__NR_pfm_create_context+5)
> +#define __NR_pfm_stop		(__NR_pfm_create_context+6)
> +#define __NR_pfm_restart	(__NR_pfm_create_context+7)
> +#define __NR_pfm_create_evtsets	(__NR_pfm_create_context+8)
> +#define __NR_pfm_getinfo_evtsets (__NR_pfm_create_context+9)
> +#define __NR_pfm_delete_evtsets (__NR_pfm_create_context+10)
> +#define __NR_pfm_unload_context	(__NR_pfm_create_context+11)
>  
>  #ifdef __KERNEL__
>  
> -#define NR_syscalls 324
> +#define NR_syscalls 335
>  


Should be 336.
