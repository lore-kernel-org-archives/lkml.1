Return-Path: <linux-kernel-owner+w=401wt.eu-S1759380AbYA0TjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759380AbYA0TjT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 14:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbYA0TjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 14:39:08 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:58413 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbYA0TjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 14:39:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=CSiMbYelAIykQY5xMV/Sus9IkevvQGdOKYGHDSHlr4UaGBSJ9d1FKUjS2BhoAaWbDGqiyir/tCkFO7P6sEHlh9uR3xKJCHfz2GsjJi51jriT1l+4Mv8dTbZc6jfvjuWbuxfbmNFkRE/ObruoxGpgMpSccLQMQlheP/HzJJcveD4=
Message-ID: <34539a480801271139y7261853bracc65b76bb13c78b@mail.gmail.com>
Date: Sun, 27 Jan 2008 14:39:03 -0500
From: "Ronald S. Bultje" <rbultje@ronald.bitfreak.net>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] drivers/media/video/zoran_card.c: en/decoder loading
Cc: "Martin Samuelsson" <sam.linux.kernel@gmail.com>
In-Reply-To: <20080127190129.6a1554ef.sam.linux.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080127190129.6a1554ef.sam.linux.kernel@gmail.com>
X-Google-Sender-Auth: eec87b410d403915
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Jan 27, 2008 1:01 PM, Martin Samuelsson <sam.linux.kernel@gmail.com> wrote:
> This enables the avs6eyes to load the bt866 and ks0127 drivers automatically.
>
> Signed-off-by: Martin Samuelsson <sam.linux.kernel@gmail.com>
> ---
>  zoran_card.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> --- linux-2.6.24-ori/drivers/media/video/zoran_card.c   2008-01-24 23:58:37.000000000 +0100
> +++ linux-2.6.24-sam/drivers/media/video/zoran_card.c   2008-01-27 17:16:51.000000000 +0100
> @@ -366,6 +366,12 @@ i2cid_to_modulename (u16 i2c_id)
>        case I2C_DRIVERID_MSE3000:
>                name = "mse3000";
>                break;*/
> +       case I2C_DRIVERID_BT866:
> +               name = "bt866";
> +               break;
> +       case I2C_DRIVERID_KS0127:
> +               name = "ks0127";
> +               break;
>        default:
>                break;
>        }

(For upstream people who will apply the patch in mainstream kernel:)
ack from maintainer.

Ronald

(and sorry to Martin for getting this msg twice.)
