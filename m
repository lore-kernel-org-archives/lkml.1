Return-Path: <linux-kernel-owner+w=401wt.eu-S1756886AbYBAIyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbYBAIyZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 03:54:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbYBAIyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 03:54:17 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:39954 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752202AbYBAIyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 03:54:15 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <47A251E9.4050606@goop.org>
References: <47A251E9.4050606@goop.org>
Content-Type: text/plain
Date: Fri, 01 Feb 2008 08:54:04 +0000
Message-Id: <1201856044.3804.1.camel@cthulhu.hellion.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: x86: PAE swapper_pg_dir needs to be page-sized
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-31 at 14:55 -0800, Jeremy Fitzhardinge wrote: 
> Xen currently needs swapper_pg_dir page aligned and sized.  This fixes
> the second part of that...
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

Acked-by: Ian Campbell <ijc@hellion.org.uk>

> ---
>  arch/x86/kernel/head_32.S |    1 +
>  1 file changed, 1 insertion(+)
> 
> ===================================================================
> --- a/arch/x86/kernel/head_32.S
> +++ b/arch/x86/kernel/head_32.S
> @@ -640,6 +640,7 @@
>  # else
>  #  error "Kernel PMDs should be 1, 2 or 3"
>  # endif
> +	.align PAGE_SIZE_asm		/* needs to be page-sized too */
>  #endif
>  
>  .data
> 
> 
> 
-- 
Ian Campbell

Yow!  Am I in Milwaukee?

