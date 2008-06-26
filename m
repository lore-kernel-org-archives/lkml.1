Return-Path: <linux-kernel-owner+w=401wt.eu-S1757098AbYFZIZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098AbYFZIZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 04:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbYFZIYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 04:24:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41571 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752550AbYFZIYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 04:24:49 -0400
Date: Thu, 26 Jun 2008 01:23:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bernhard Walle <bwalle@suse.de>
Cc: linux-kernel@vger.kernel.org, vgoyal@redhat.com, kexec@lists.infradead.org
Subject: Re: [PATCH] Remove CONFIG_EXPERIMENTAL from kdump
Message-Id: <20080626012337.a73c91d2.akpm@linux-foundation.org>
In-Reply-To: <1214465001-12338-1-git-send-email-bwalle@suse.de>
References: <20080625221635.GD32344@redhat.com>
	<1214465001-12338-1-git-send-email-bwalle@suse.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2008 09:23:21 +0200 Bernhard Walle <bwalle@suse.de> wrote:

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

What about powerpc, sh and ia64?


