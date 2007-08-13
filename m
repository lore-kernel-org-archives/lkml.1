Return-Path: <linux-kernel-owner+w=401wt.eu-S946595AbXHMOQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S946595AbXHMOQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 10:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S944317AbXHMLQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 07:16:24 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:44225 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S944308AbXHMLQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 07:16:21 -0400
Date: Mon, 13 Aug 2007 06:15:22 -0500
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: joe@perches.com
Cc: torvalds@linux-foundation.org, paulus@samba.org, paulus@au1.ibm.com,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, anton@samba.org,
       anton@au1.ibm.com, akpm@linux-foundation.org
Subject: Re: [PATCH] [298/2many] MAINTAINERS - LINUX FOR 64BIT POWERPC
Message-ID: <20070813061522.57ca3662@zod.rchland.ibm.com>
In-Reply-To: <46bffaba.dVM9Q/vXNeROaC6B%joe@perches.com>
References: <46bffaba.dVM9Q/vXNeROaC6B%joe@perches.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Aug 2007 23:31:22 -0700
joe@perches.com wrote:

> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6d10932..36c4960 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2857,6 +2857,9 @@ M:	anton@au.ibm.com
>  W:	http://www.penguinppc.org/ppc64/
>  L:	linuxppc-dev@ozlabs.org
>  S:	Supported
> +F:	arch/powerpc/configs/ppc64_defconfig
> +F:	arch/powerpc/kernel/proc_ppc64.c
> +F:	include/asm-powerpc/pgtable-ppc64.h

Erm, there's a lot more to 64-bit PowerPC than those 3 files.  You're
better off just doing arch/powerpc/, include/asm-powerpc.

josh
