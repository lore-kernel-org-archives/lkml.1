Return-Path: <linux-kernel-owner+w=401wt.eu-S1030390AbXFHIN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030390AbXFHIN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 04:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030246AbXFHIJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 04:09:05 -0400
Received: from aun.it.uu.se ([130.238.12.36]:43887 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939928AbXFHIJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 04:09:01 -0400
Date: Fri, 8 Jun 2007 10:07:52 +0200 (MEST)
Message-Id: <200706080807.l5887qJH017346@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: linux-kernel@vger.kernel.org, wli@holomorphy.com
Subject: Re: divorce CONFIG_X86_PAE from CONFIG_HIGHMEM64G
Cc: ak@suse.de, akpm@linux-foundation.org, lkml@rtr.ca
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007 19:35:51 -0700, William Lee Irwin III wrote:
> @@ -573,12 +574,12 @@
>  	config VMSPLIT_3G
>  		bool "3G/1G user/kernel split"
>  	config VMSPLIT_3G_OPT
> -		depends on !HIGHMEM
> +		depends on !X86_PAE
>  		bool "3G/1G user/kernel split (for full 1G low memory)"
>  	config VMSPLIT_2G
>  		bool "2G/2G user/kernel split"
>  	config VMSPLIT_2G_OPT
> -		depends on !HIGHMEM
> +		depends on !X86_PAE
>  		bool "2G/2G user/kernel split (for full 2G low memory)"
>  	config VMSPLIT_1G
>  		bool "1G/3G user/kernel split"

Is this really needed? I can see why VMSPLIT_{2,3}G_OPT would
depend on !HIGHMEM, but why would they depend on !X86_PAE?
