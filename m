Return-Path: <linux-kernel-owner+w=401wt.eu-S934209AbXFFAA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934209AbXFFAA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 20:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765148AbXFFAAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 20:00:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37512 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765524AbXFFAAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 20:00:20 -0400
Date: Tue, 5 Jun 2007 17:00:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH 2/2] UML - Fix kernel stack size on x86_64
Message-Id: <20070605170001.c8b2110e.akpm@linux-foundation.org>
In-Reply-To: <20070605205055.GA9770@c2.user-mode-linux.org>
References: <20070605205055.GA9770@c2.user-mode-linux.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2007 16:50:55 -0400
Jeff Dike <jdike@addtoit.com> wrote:

> [ This is 2.6.22 material ]
> 
> Having KERNEL_STACK_ORDER in defconfig overrides the value provided by
> Kconfig, breaking UML/x86_64, which wants 2 page stacks.
> 
> Signed-off-by: Jeff Dike <jdike@linux.intel.com>
> --
>  arch/um/defconfig |    1 -
>  1 file changed, 1 deletion(-)
> 
> Index: linux-2.6.21-mm/arch/um/defconfig
> ===================================================================
> --- linux-2.6.21-mm.orig/arch/um/defconfig	2007-06-05 12:18:35.000000000 -0400
> +++ linux-2.6.21-mm/arch/um/defconfig	2007-06-05 12:19:12.000000000 -0400
> @@ -86,7 +86,6 @@ CONFIG_MCONSOLE=y
>  # CONFIG_MAGIC_SYSRQ is not set
>  CONFIG_NEST_LEVEL=0
>  # CONFIG_HIGHMEM is not set
> -CONFIG_KERNEL_STACK_ORDER=0
>  CONFIG_UML_REAL_TIME_CLOCK=y
>  

That means the Kconfig rules are wrong, surely?
