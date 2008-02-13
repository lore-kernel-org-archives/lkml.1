Return-Path: <linux-kernel-owner+w=401wt.eu-S1764725AbYBMV4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764725AbYBMV4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:56:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932613AbYBMVev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:34:51 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:14562 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763507AbYBMVeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:34:50 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080213212955.GP3383@cs181133002.pp.htv.fi>
References: <20080213212955.GP3383@cs181133002.pp.htv.fi>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 21:34:24 +0000
Message-Id: <1202938464.30565.0.camel@cthulhu.hellion.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [2.6 patch] x86: don't make swapper_pg_fixmap global
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=c_voKAJjjp0A:10 a=qcrRp5rlbqkS0d6TfuPTVw==:17 a=U0lIkcartfNucc5DFyIA:9 a=x1FlWM6zw_I4Z5eAznBtVbTUNDkA:4 a=LI9Vle30uBYA:10 a=WuK_CZDBSqoA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-13 at 23:29 +0200, Adrian Bunk wrote:
> It's not required for swapper_pg_fixmap to be global.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Ian Campbell <ijc@hellion.org.uk>

> 
> ---
> cdaa89e8d9f49eecc6ec9052db1d65a62f1be04b diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
> index 74ef4a4..25eb985 100644
> --- a/arch/x86/kernel/head_32.S
> +++ b/arch/x86/kernel/head_32.S
> @@ -612,7 +612,7 @@ ENTRY(swapper_pg_pmd)
>  ENTRY(swapper_pg_dir)
>  	.fill 1024,4,0
>  #endif
> -ENTRY(swapper_pg_fixmap)
> +swapper_pg_fixmap:
>  	.fill 1024,4,0
>  ENTRY(empty_zero_page)
>  	.fill 4096,1,0
> 
-- 
Ian Campbell

Getting into trouble is easy.
		-- D. Winkel and F. Prosser

