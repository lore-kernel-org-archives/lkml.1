Return-Path: <linux-kernel-owner+w=401wt.eu-S1756099AbYGXX1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbYGXX1b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 19:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755937AbYGXX1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 19:27:10 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:46108 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755916AbYGXX1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 19:27:08 -0400
Subject: Re: [PATCH -next] kmemcheck: include module.h to prevent warnings
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, vegardno@ifi.uio.no,
       akpm <akpm@linux-foundation.org>
In-Reply-To: <20080724160932.cdcf4927.randy.dunlap@oracle.com>
References: <20080724160932.cdcf4927.randy.dunlap@oracle.com>
Date: Fri, 25 Jul 2008 02:27:03 +0300
Message-Id: <1216942023.12392.17.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-24 at 16:09 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> kmemcheck/shadow.c needs to include <linux/module.h> to prevent
> the following warnings:
> 
> linux-next-20080724/arch/x86/mm/kmemcheck/shadow.c:64: warning : data definition has no type or storage class
> linux-next-20080724/arch/x86/mm/kmemcheck/shadow.c:64: warning : type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
> linux-next-20080724/arch/x86/mm/kmemcheck/shadow.c:64: warning : parameter names (without types) in function declaration
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Looks good to me.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

> ---
>  arch/x86/mm/kmemcheck/shadow.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-next-20080724.orig/arch/x86/mm/kmemcheck/shadow.c
> +++ linux-next-20080724/arch/x86/mm/kmemcheck/shadow.c
> @@ -1,5 +1,6 @@
>  #include <linux/kmemcheck.h>
>  #include <linux/mm.h>
> +#include <linux/module.h>
>  
>  #include <asm/page.h>
>  #include <asm/pgtable.h>
> 
> 
> ---
> ~Randy
> Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
> http://linuxplumbersconf.org/

