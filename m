Return-Path: <linux-kernel-owner+w=401wt.eu-S1763352AbXFASpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763352AbXFASpZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 14:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762086AbXFASpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 14:45:11 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35927 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761617AbXFASpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 14:45:08 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Chandramouli Narayanan <mouli@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, ak@suse.de, akpm@linux-foundation.org
Subject: Re: [PATCH 2.6.21 1/3] x86_64: EFI64 support
References: <20070501185945.237601000@em64tdvp.jf.intel.com>
	<20070501190110.770881000@em64tdvp.jf.intel.com>
Date: Fri, 01 Jun 2007 12:44:13 -0600
In-Reply-To: <20070501190110.770881000@em64tdvp.jf.intel.com> (Chandramouli
	Narayanan's message of "Tue, 01 May 2007 11:59:46 -0700")
Message-ID: <m1abvj1pmq.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chandramouli Narayanan <mouli@linux.intel.com> writes:
>  
> diff -uprN -X linux-2.6.21rc7-git2-orig/Documentation/dontdiff
> linux-2.6.21rc7-git2-orig/drivers/char/Kconfig
> linux-2.6.21rc7-git2-uefi-finaltest/drivers/char/Kconfig
> --- linux-2.6.21rc7-git2-orig/drivers/char/Kconfig 2007-04-19 12:39:39.000000000
> -0700
> +++ linux-2.6.21rc7-git2-uefi-finaltest/drivers/char/Kconfig 2007-04-19
> 13:01:02.000000000 -0700
> @@ -837,7 +837,7 @@ config GEN_RTC_X
>  
>  config EFI_RTC
>  	bool "EFI Real Time Clock Services"
> -	depends on IA64
> +	depends on IA64 || X86_64

Please remove this.

We have an architecturally defined hardware realtime clock
on x86_64.  We don't need EFI to abstract it for us.

My condolences to hardware manufacturers that can't follow a
20 year old standard.

Eric
