Return-Path: <linux-kernel-owner+w=401wt.eu-S1757538AbZB0BHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538AbZB0BHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 20:07:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbZB0BHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 20:07:33 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:45678 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbZB0BHc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 20:07:32 -0500
MIME-Version: 1.0
In-Reply-To: <20090222000441.17557.22989.stgit@vmbox.hanneseder.net>
References: <20090221235706.17557.97714.stgit@vmbox.hanneseder.net>
	 <20090222000441.17557.22989.stgit@vmbox.hanneseder.net>
Date: Fri, 27 Feb 2009 02:07:29 +0100
Message-ID: <154e089b0902261707j4e22787boecedaa097b2777b2@mail.gmail.com>
Subject: Re: [PATCH 10/16] viafb: fix sparse warning: Using plain integer as 
	NULL pointer
From: Hannes Eder <hannes@hanneseder.net>
To: trivial@kernel.org, Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added To, Cc]

On Sun, Feb 22, 2009 at 1:04 AM, Hannes Eder <hannes@hanneseder.net> wrote:
> Fix this sparse warning:
>  drivers/video/via/hw.c:2020:46: warning: Using plain integer as NULL pointer
>
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> ---
>  drivers/video/via/hw.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
> index fcd53ce..70d6b6c 100644
> --- a/drivers/video/via/hw.c
> +++ b/drivers/video/via/hw.c
> @@ -2017,7 +2017,7 @@ static void init_gfx_chip_info(void)
>        /* Indentify GFX Chip Name */
>        for (i = 0; pciidlist[i].vendor != 0; i++) {
>                pdev = pci_get_device(pciidlist[i].vendor,
> -                       pciidlist[i].device, 0);
> +                       pciidlist[i].device, NULL);
>                if (pdev)
>                        break;
>        }
>
>
