Return-Path: <linux-kernel-owner+w=401wt.eu-S1759890AbXK0XmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759890AbXK0XmK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 18:42:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757015AbXK0Xl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 18:41:56 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:26323 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbXK0Xlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 18:41:55 -0500
Date: Tue, 27 Nov 2007 15:40:55 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>
Subject: Re: [patch 05/14] percpu: Use a Kconfig variable to configure arch
 specific percpu setup
Message-Id: <20071127154055.35e07833.randy.dunlap@oracle.com>
In-Reply-To: <20071127001430.313046247@sgi.com>
References: <20071127001407.859743255@sgi.com>
	<20071127001430.313046247@sgi.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2007 16:14:12 -0800 Christoph Lameter wrote:

> The use of the __GENERIC_PERCPU is a bit problematic since arches
> may want to run their own percpu setup while using the generic
> percpu definitions. Replace it through a kconfig variable.
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Andi Kleen <ak@suse.de>
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> ---
> 
> Index: linux-2.6/arch/ia64/Kconfig
> ===================================================================
> --- linux-2.6.orig/arch/ia64/Kconfig	2007-11-26 15:38:56.415112360 -0800
> +++ linux-2.6/arch/ia64/Kconfig	2007-11-26 15:40:10.425862722 -0800
> @@ -75,6 +75,10 @@ config GENERIC_TIME_VSYSCALL
>  	bool
>  	default y
>  
> +config ARCH_SETS_UP_PER_CPU_AREA
> +	bool
> +	default y
> +
>  config DMI
>  	bool
>  	default y

> Index: linux-2.6/arch/sparc64/Kconfig
> ===================================================================
> --- linux-2.6.orig/arch/sparc64/Kconfig	2007-11-26 15:38:56.447111936 -0800
> +++ linux-2.6/arch/sparc64/Kconfig	2007-11-26 15:40:10.425862722 -0800
> @@ -66,6 +66,10 @@ config AUDIT_ARCH
>  	bool
>  	default y
>  
> +config ARCH_SETS_UP_PER_CPU_AREA
> +	bool
> +	default y

	def_bool y
  is the preferred form for those 2-liners above...


> +
>  config ARCH_NO_VIRT_TO_BUS
>  	def_bool y
>  


---
~Randy
