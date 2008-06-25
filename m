Return-Path: <linux-kernel-owner+w=401wt.eu-S1754252AbYFYWRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbYFYWRi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 18:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbYFYWR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 18:17:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736AbYFYWRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 18:17:24 -0400
Date: Wed, 25 Jun 2008 18:16:35 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Bernhard Walle <bwalle@suse.de>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove CONFIG_EXPERIMENTAL from kdump
Message-ID: <20080625221635.GD32344@redhat.com>
References: <1214430592-18043-1-git-send-email-bwalle@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214430592-18043-1-git-send-email-bwalle@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 11:49:52PM +0200, Bernhard Walle wrote:
> I would suggest to remove the "experimental" status from Kdump.
> Kdump is now in the kernel since a long time and used by Enterprise
> distributions. I don't think that "experimental" is true any more.
> 
> 
> Signed-off-by: Bernhard Walle <bwalle@suse.de>
> ---
>  arch/x86/Kconfig |    1 -
>  fs/Kconfig       |    2 +-
>  2 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index e0edaaa..f4f255b 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1190,7 +1190,6 @@ config KEXEC
>  
>  config CRASH_DUMP
>  	bool "kernel crash dumps (EXPERIMENTAL)"
> -	depends on EXPERIMENTAL
>  	depends on X86_64 || (X86_32 && HIGHMEM)
>  	help
>  	  Generate crash dump after being started by kexec.
> diff --git a/fs/Kconfig b/fs/Kconfig
> index cf12c40..b2252a4 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -930,7 +930,7 @@ config PROC_KCORE
>  
>  config PROC_VMCORE
>          bool "/proc/vmcore support (EXPERIMENTAL)"
> -        depends on PROC_FS && EXPERIMENTAL && CRASH_DUMP
> +        depends on PROC_FS && CRASH_DUMP
>  	default y
>          help
>          Exports the dump image of crashed kernel in ELF format.

Makes sense to me. Thanks.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Thanks
Vivek
