Return-Path: <linux-kernel-owner+w=401wt.eu-S1757533AbXEJFNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533AbXEJFNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 01:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754998AbXEJFNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 01:13:32 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:36213 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943AbXEJFNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 01:13:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=EmuB/ea2wwhTILEzEU38GJnSsHUOCSKUyiGt1R6e/a6HoAkp2H7UPDG5pE6lPMx5JJmztZNURSKiWQvD33yGHLBkUYi1W1jSiKdZBj8flfCiCCm5TjlF5sJEk4ZPT80fY/XpOOmrCCc/JnMlcxYAG8yBggZDYJ3q28TG7dmdD+Y=
Date: Thu, 10 May 2007 09:13:53 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [patch 06/10] Linux Kernel Markers - Non optimized architectures
Message-ID: <20070510051353.GB6640@martell.zuzino.mipt.ru>
References: <20070510015555.973107048@polymtl.ca> <20070510020916.836290342@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510020916.836290342@polymtl.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 09:56:01PM -0400, Mathieu Desnoyers wrote:
> This patch also includes marker code for non optimized architectures.

>  include/asm-alpha/marker.h     |   13 +++++++++++++
>  include/asm-arm/marker.h       |   13 +++++++++++++
>  include/asm-arm26/marker.h     |   13 +++++++++++++
>  include/asm-cris/marker.h      |   13 +++++++++++++
>  include/asm-frv/marker.h       |   13 +++++++++++++
>  include/asm-generic/marker.h   |   37 +++++++++++++++++++++++++++++++++++++
>  include/asm-h8300/marker.h     |   13 +++++++++++++
>  include/asm-ia64/marker.h      |   13 +++++++++++++
>  include/asm-m32r/marker.h      |   13 +++++++++++++
>  include/asm-m68k/marker.h      |   13 +++++++++++++
>  include/asm-m68knommu/marker.h |   13 +++++++++++++
>  include/asm-mips/marker.h      |   13 +++++++++++++
>  include/asm-parisc/marker.h    |   13 +++++++++++++
>  include/asm-ppc/marker.h       |   13 +++++++++++++
>  include/asm-s390/marker.h      |   13 +++++++++++++
>  include/asm-sh/marker.h        |   13 +++++++++++++
>  include/asm-sh64/marker.h      |   13 +++++++++++++
>  include/asm-sparc/marker.h     |   13 +++++++++++++
>  include/asm-sparc64/marker.h   |   13 +++++++++++++
>  include/asm-um/marker.h        |   13 +++++++++++++
>  include/asm-v850/marker.h      |   13 +++++++++++++
>  include/asm-x86_64/marker.h    |   13 +++++++++++++
>  include/asm-xtensa/marker.h    |   13 +++++++++++++
>  23 files changed, 323 insertions(+)

> --- /dev/null
> +++ linux-2.6-lttng/include/asm-arm/marker.h
> @@ -0,0 +1,13 @@
> +/*
> + * marker.h
> + *
> + * Code markup for dynamic and static tracing. Architecture specific
> + * optimisations.
> + *
> + * No optimisation implemented.
> + *
> + * This file is released under the GPLv2.
> + * See the file COPYING for more details.
> + */
> +
> +#include <asm-generic/marker.h>

Come on, one line file is enough!

