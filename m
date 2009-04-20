Return-Path: <linux-kernel-owner+w=401wt.eu-S1756194AbZDTOid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbZDTOid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 10:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755661AbZDTOiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 10:38:23 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:42109 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498AbZDTOiW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 10:38:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=V/tgk3ix7Ei1/LpgrXbKj0k5EubgHLWr5cS8UkOEgkDjYem+8sbe1/NKCGyhPOnYvK
         BWGq0HL3BJs9j8N8wppxV5+XR33i3AYqnm4XWtiQM6uAWcKVonsi8SwT6TpvSaktQMmr
         PlZLAZ2s/IABc4GudgG2tPbb9XIyELXmw+3r8=
MIME-Version: 1.0
In-Reply-To: <20090417183210.6b704b24.randy.dunlap@oracle.com>
References: <20090417183210.6b704b24.randy.dunlap@oracle.com>
Date: Mon, 20 Apr 2009 10:38:21 -0400
Message-ID: <8bd0f97a0904200738m355642ebqaf682cf9c66d3b4b@mail.gmail.com>
Subject: Re: [PATCH] kmap_types: make most arches use generic header file
From: Mike Frysinger <vapier.adi@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       linux-arch@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 21:32, Randy Dunlap wrote:
> --- linux-2.6.30-rc2-git1.orig/arch/blackfin/include/asm/kmap_types.h
> +++ linux-2.6.30-rc2-git1/arch/blackfin/include/asm/kmap_types.h
> @@ -1,21 +1,6 @@
>  #ifndef _ASM_KMAP_TYPES_H
>  #define _ASM_KMAP_TYPES_H
>
> -enum km_type {
> -       KM_BOUNCE_READ,
> -       KM_SKB_SUNRPC_DATA,
> -       KM_SKB_DATA_SOFTIRQ,
> -       KM_USER0,
> -       KM_USER1,
> -       KM_BIO_SRC_IRQ,
> -       KM_BIO_DST_IRQ,
> -       KM_PTE0,
> -       KM_PTE1,
> -       KM_IRQ0,
> -       KM_IRQ1,
> -       KM_SOFTIRQ0,
> -       KM_SOFTIRQ1,
> -       KM_TYPE_NR
> -};
> +#include <asm-generic/kmap_types.h>
>
>  #endif

if the header is only there to redirect to the generic one, seems like
we could drop the #ifdef protection

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
