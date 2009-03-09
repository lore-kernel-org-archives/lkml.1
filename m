Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbZCIK7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbZCIK7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 06:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751192AbZCIK7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 06:59:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33230 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452AbZCIK7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 06:59:03 -0400
Date: Mon, 9 Mar 2009 07:58:32 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hannes Eder <hannes@hanneseder.net>
Cc: trivial@kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 05/15] NULL noise:
 drivers/media/dvb/frontends/drx397xD_fw.h
Message-ID: <20090309075832.67483c8e@caramujo.chehab.org>
In-Reply-To: <20090305191435.30062.72139.stgit@f10box.hanneseder.net>
References: <20090305190954.30062.44759.stgit@f10box.hanneseder.net>
	<20090305191435.30062.72139.stgit@f10box.hanneseder.net>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Mar 2009 20:14:39 +0100
Hannes Eder <hannes@hanneseder.net> wrote:

> Fix this sparse warnings:
>   drivers/media/dvb/frontends/drx397xD_fw.h:21:2: warning: Using plain integer as NULL pointer
>   drivers/media/dvb/frontends/drx397xD_fw.h:22:2: warning: Using plain integer as NULL pointer
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

> ---
> v2: other subject, as suggested by Al Viro
> 
>  drivers/media/dvb/frontends/drx397xD.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/dvb/frontends/drx397xD.c b/drivers/media/dvb/frontends/drx397xD.c
> index 1e81e71..172f1f9 100644
> --- a/drivers/media/dvb/frontends/drx397xD.c
> +++ b/drivers/media/dvb/frontends/drx397xD.c
> @@ -74,7 +74,7 @@ static struct {
>  } fw[] = {
>  #define _FW_ENTRY(a, b, c)	{					\
>  			.name	= a,					\
> -			.file	= 0,					\
> +			.file	= NULL,					\
>  			.lock	= __RW_LOCK_UNLOCKED(fw[c].lock),	\
>  			.refcnt = 0,					\
>  			.data	= { }		}
> 




Cheers,
Mauro
