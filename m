Return-Path: <linux-kernel-owner+w=401wt.eu-S946700AbXHMOUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S946700AbXHMOUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 10:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965908AbXHMLT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 07:19:56 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:43594 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965928AbXHMLTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 07:19:54 -0400
Date: Mon, 13 Aug 2007 06:18:54 -0500
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: joe@perches.com
Cc: torvalds@linux-foundation.org, mporter@kernel.crashing.org,
       linuxppc-embedded@ozlabs.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] [292/2many] MAINTAINERS - LINUX FOR POWERPC EMBEDDED
 PPC4XX
Message-ID: <20070813061854.644e6e5e@zod.rchland.ibm.com>
In-Reply-To: <46bffaaf.2ObqORfh5YL/9ILj%joe@perches.com>
References: <46bffaaf.2ObqORfh5YL/9ILj%joe@perches.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Aug 2007 23:31:11 -0700
joe@perches.com wrote:

> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0862965..38810b7 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2804,6 +2804,8 @@ M:	mporter@kernel.crashing.org
>  W:	http://www.penguinppc.org/
>  L:	linuxppc-embedded@ozlabs.org
>  S:	Maintained
> +F:	arch/ppc/syslib/ppc4xx_*
> +F:	include/asm-ppc/ppc4xx_*

You're missing arch/ppc/platforms/4xx/, among other things.  Also, we're
in the middle of merging 4xx to arch/powerpc.

josh
