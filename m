Return-Path: <linux-kernel-owner+w=401wt.eu-S1753216AbXEXUop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbXEXUop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 16:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750841AbXEXUoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 16:44:38 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:39818 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750811AbXEXUoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 16:44:37 -0400
Date: Thu, 24 May 2007 13:44:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ben Collins <bcollins@ubuntu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] i386/x86_64: Allow disabling the putstr's from
 compressed boot wrapper (fixed)
Message-Id: <20070524134433.731ef20f.akpm@linux-foundation.org>
In-Reply-To: <b31c080.git.bcollins@ubuntu.com>
References: <98cd38b5.git.bcollins@ubuntu.com>
	<b31c080.git.bcollins@ubuntu.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007 17:59:10 -0400
Ben Collins <bcollins@ubuntu.com> wrote:

> Updated to include proper spacing for putstr() macro.
> 
> Signed-off-by: Ben Collins <bcollins@ubuntu.com>
> ---
>  arch/i386/Kconfig.debug            |    6 ++++++
>  arch/i386/boot/compressed/misc.c   |    8 +++++---
>  arch/x86_64/Kconfig.debug          |    6 ++++++
>  arch/x86_64/boot/compressed/misc.c |    8 +++++---
>  4 files changed, 22 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/i386/Kconfig.debug b/arch/i386/Kconfig.debug
> --- a/arch/i386/Kconfig.debug
> +++ b/arch/i386/Kconfig.debug
> @@ -19,6 +19,12 @@ config EARLY_PRINTK
>  	  with klogd/syslogd or the X server. You should normally N here,
>  	  unless you want to debug such a crash.
>  
> +config WRAPPER_PRINT
> +	bool "Boot wrapper print" if EMBEDDED
> +	default y
> +	help
> +	  Enable informational output from the bootwrapper (bzImage and zImage).
> +

What is the reason for making this change to the kernel?
