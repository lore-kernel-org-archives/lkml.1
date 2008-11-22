Return-Path: <linux-kernel-owner+w=401wt.eu-S1756382AbYKVVxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382AbYKVVxX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 16:53:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbYKVVxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 16:53:12 -0500
Received: from gate.crashing.org ([63.228.1.57]:43252 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887AbYKVVxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 16:53:11 -0500
Subject: Re: [PATCH 20/32] uninorth-agp section mess
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@linux-foundation.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <E1L3wPK-0006Ym-Kq@ZenIV.linux.org.uk>
References: <E1L3wPK-0006Ym-Kq@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Sun, 23 Nov 2008 08:52:28 +1100
Message-Id: <1227390748.7185.277.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-11-22 at 17:36 +0000, Al Viro wrote:
> 'aperture' is declared devinitdata (the whole word of it) and
> is used from ->fetch_size() which can, AFAICS, be used on
> !HOTPLUG after init time.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

> ---
>  drivers/char/agp/uninorth-agp.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/char/agp/uninorth-agp.c b/drivers/char/agp/uninorth-agp.c
> --- a/drivers/char/agp/uninorth-agp.c
> +++ b/drivers/char/agp/uninorth-agp.c
> @@ -27,7 +27,7 @@
>  static int uninorth_rev;
>  static int is_u3;
>  
> -static char __devinitdata *aperture = NULL;
> +static char *aperture = NULL;
>  
>  static int uninorth_fetch_size(void)
>  {
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev

