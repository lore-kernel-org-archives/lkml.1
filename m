Return-Path: <linux-kernel-owner+w=401wt.eu-S965601AbXBTAIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965601AbXBTAIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750933AbXBTAIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:08:25 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:36163 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750970AbXBTAIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:08:17 -0500
Date: Tue, 20 Feb 2007 01:08:16 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.20-mm1: PTRACE=y, PROC_FS=n compile error
Message-ID: <20070220000816.GM13958@stusta.de>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 05:14:08AM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.20-rc6-mm3:
>...
> +utrace-utrace-ptrace-compat.patch
>...
>  utrace tree
>...


This causes the following compile error with CONFIG_PTRACE=y, 
CONFIG_PROC_FS=n:

<--  snip  -->

...
  LD      .tmp_vmlinux1
kernel/built-in.o: In function `sys_ptrace':
(.text+0x2a3c2): undefined reference to `ptrace_may_attach'
make[1]: *** [.tmp_vmlinux1] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

