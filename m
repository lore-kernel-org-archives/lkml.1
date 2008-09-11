Return-Path: <linux-kernel-owner+w=401wt.eu-S1756016AbYIKNqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016AbYIKNqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 09:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbYIKNqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 09:46:15 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:61540 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957AbYIKNqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 09:46:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=v+mPdTFUGcihHsdM/SE63F2RtbeApgGy09ugkJrBuPqgMjNs5UirdLr7tSu3GQrOhL
         6/PKLooiwmKcJ6LY82vQfOF6pO3RtrsZ39Wd7R4k7CYuvcm1EA5I4IF34j3TL3TO7YZN
         b5+lOqZ6iiwUJ+8bO1DkaX9AgKb9YJnjj9k0Y=
Message-ID: <80b317760809110646j1e9c5171v3fe78546cd62c9a7@mail.gmail.com>
Date: Thu, 11 Sep 2008 15:46:11 +0200
From: "Richard Genoud" <richard.genoud@gmail.com>
To: "Julia Lawall" <julia@diku.dk>
Subject: Re: [PATCH 1/5] drivers/infiniband/hw: Drop code after return
Cc: rolandd@cisco.com, sean.hefty@intel.com, hal.rosenstock@gmail.com,
       general@lists.openfabrics.org, vigneshbabu@gmail.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0809111432400.9593@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0809111432400.9593@pc-004.diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/11 Julia Lawall <julia@diku.dk>:
> From: Julia Lawall <julia@diku.dk>
>
> The break after the return serves no purpose.
>
> Signed-off-by: Julia Lawall <julia@diku.dk>
Reviewed-by: Richard Genoud <richard.genoud@gmail.com>
> ---
>  drivers/infiniband/hw/amso1100/c2_provider.c |    1 -
>  drivers/infiniband/hw/nes/nes_verbs.c        |    3 ---
>  2 files changed, 4 deletions(-)
>
> diff -u -p a/drivers/infiniband/hw/amso1100/c2_provider.c b/drivers/infiniband/hw/amso1100/c2_provider.c
> --- a/drivers/infiniband/hw/amso1100/c2_provider.c
> +++ b/drivers/infiniband/hw/amso1100/c2_provider.c
> @@ -272,7 +272,6 @@ static struct ib_qp *c2_create_qp(struct
>                pr_debug("%s: Invalid QP type: %d\n", __func__,
>                        init_attr->qp_type);
>                return ERR_PTR(-EINVAL);
> -               break;
>        }
>
>        if (err) {
> diff -u -p a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
> --- a/drivers/infiniband/hw/nes/nes_verbs.c
> +++ b/drivers/infiniband/hw/nes/nes_verbs.c
> @@ -1467,7 +1467,6 @@ static struct ib_qp *nes_create_qp(struc
>                default:
>                        nes_debug(NES_DBG_QP, "Invalid QP type: %d\n", init_attr->qp_type);
>                        return ERR_PTR(-EINVAL);
> -                       break;
>        }
>
>        /* update the QP table */
> @@ -2498,7 +2497,6 @@ static struct ib_mr *nes_reg_user_mr(str
>                        nes_debug(NES_DBG_MR, "Leaving, ibmr=%p", ibmr);
>
>                        return ibmr;
> -                       break;
>                case IWNES_MEMREG_TYPE_QP:
>                case IWNES_MEMREG_TYPE_CQ:
>                        nespbl = kzalloc(sizeof(*nespbl), GFP_KERNEL);
> @@ -2572,7 +2570,6 @@ static struct ib_mr *nes_reg_user_mr(str
>                        nesmr->ibmr.lkey = -1;
>                        nesmr->mode = req.reg_type;
>                        return &nesmr->ibmr;
> -                       break;
>        }
>
>        return ERR_PTR(-ENOSYS);
>
