Return-Path: <linux-kernel-owner+w=401wt.eu-S1758447AbYDRVa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758447AbYDRVa3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 17:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbYDRVaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 17:30:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56631 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751134AbYDRVaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 17:30:14 -0400
Date: Fri, 18 Apr 2008 14:29:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: 4kstacks default
Message-Id: <20080418142934.38ce6bf4.akpm@linux-foundation.org>
In-Reply-To: <200804181737.m3IHbabI010051@hera.kernel.org>
References: <200804181737.m3IHbabI010051@hera.kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008 17:37:36 GMT
Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:

> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d61ecf0b53131564949bc4196e70f676000a845a
> Commit:     d61ecf0b53131564949bc4196e70f676000a845a
> Parent:     f408b43ceedce49f26c01cd4a68dbbdbe2743e51
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Fri Apr 4 17:11:09 2008 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Thu Apr 17 17:41:34 2008 +0200
> 
>     x86: 4kstacks default
>     
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/Kconfig.debug |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
> index f4413c0..610aaec 100644
> --- a/arch/x86/Kconfig.debug
> +++ b/arch/x86/Kconfig.debug
> @@ -106,8 +106,8 @@ config DEBUG_NX_TEST
>  
>  config 4KSTACKS
>  	bool "Use 4Kb for kernel stacks instead of 8Kb"
> -	depends on DEBUG_KERNEL
>  	depends on X86_32
> +	default y

This patch will cause kernels to crash.

It has no changelog which explains or justifies the alteration.

afaict the patch was not posted to the mailing list and was not
discussed or reviewed.
