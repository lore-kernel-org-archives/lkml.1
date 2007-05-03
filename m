Return-Path: <linux-kernel-owner+w=401wt.eu-S1751661AbXECGJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661AbXECGJa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 02:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754557AbXECGJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 02:09:30 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36144 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751661AbXECGJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 02:09:29 -0400
Date: Wed, 2 May 2007 23:09:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH] UML - forgot asm-um/cmpxchg.h
Message-Id: <20070502230919.cb6864df.akpm@linux-foundation.org>
In-Reply-To: <20070501193646.GA9482@c2.user-mode-linux.org>
References: <20070501193646.GA9482@c2.user-mode-linux.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007 15:36:46 -0400 Jeff Dike <jdike@addtoit.com> wrote:

> The i386 and x86_64 cmpxchg patches require an asm-um/cmpxchg.h for
> the UML build.
> 
> Signed-off-by: Jeff Dike <jdike@linux.intel.com>
> --
>  include/asm-um/cmpxchg.h |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> Index: linux-2.6.21-mm/include/asm-um/cmpxchg.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6.21-mm/include/asm-um/cmpxchg.h	2007-05-01 15:31:09.000000000 -0400
> @@ -0,0 +1,6 @@
> +#ifndef __UM_CMPXCHG_H
> +#define __UM_CMPXCHG_H
> +
> +#include "asm/arch/cmpxchg.h"
> +
> +#endif

OK, I clumped all three patches into one as I think that's required for
git-bisect friendliness.

