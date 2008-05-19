Return-Path: <linux-kernel-owner+w=401wt.eu-S1763921AbYESVrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763921AbYESVrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 17:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758146AbYESVra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 17:47:30 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:49470 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029AbYESVr3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 17:47:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IJ6qgSI88IMVYSUjdgnA1XM9rdKv3+Sywl1CcG7LzR+LWRY+1EipFzWQN6+V4/imicnSR87M4x8fjqBU6Iclo3Tx8mOPjfLDdYqhR6e7gJKnKV2Wf/KoaN+o6RTNrWrbpOLz/wIDGuaXJf6TrunRDJYKbWuE/ZapPTwxsgCZye0=
Message-ID: <9a8748490805191447j6c8b51bay6a386c3dbb372e4c@mail.gmail.com>
Date: Mon, 19 May 2008 23:47:18 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "=?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?=" <Uwe.Kleine-Koenig@digi.com>
Subject: Re: [PATCH] fix typo "thier" -> "their"
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
In-Reply-To: <1207135399-4516-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1207135399-4516-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

I've applied the first drivers/base/sys.c part of the patch to the
Trivial tree. The drivers/pnp/manager.c bit no longer applies.

/Jesper Juhl


2008/4/2 Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>:
> Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
> Cc: trivial@kernel.org
> ---
>  drivers/base/sys.c    |    2 +-
>  drivers/pnp/manager.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/base/sys.c b/drivers/base/sys.c
> index 8e13fd9..84be616 100644
> --- a/drivers/base/sys.c
> +++ b/drivers/base/sys.c
> @@ -283,7 +283,7 @@ void sysdev_unregister(struct sys_device * sysdev)
>  *     and the class driver.
>  *
>  *     Note: The list is iterated in reverse order, so that we shut down
> - *     child devices before we shut down thier parents. The list ordering
> + *     child devices before we shut down their parents. The list ordering
>  *     is guaranteed by virtue of the fact that child devices are registered
>  *     after their parents.
>  */
> diff --git a/drivers/pnp/manager.c b/drivers/pnp/manager.c
> index c28caf2..745a668 100644
> --- a/drivers/pnp/manager.c
> +++ b/drivers/pnp/manager.c
> @@ -382,7 +382,7 @@ fail:
>  * @res: pointer to the new resource config
>  * @mode: 0 or PNP_CONFIG_FORCE
>  *
> - * This function can be used by drivers that want to manually set thier resources.
> + * This function can be used by drivers that want to manually set their resources.
>  */
>  int pnp_manual_config_dev(struct pnp_dev *dev, struct pnp_resource_table *res,
>                          int mode)
> --
> 1.5.4.5
>
>



-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please http://www.expita.com/nomime.html
