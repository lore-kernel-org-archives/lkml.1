Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbYIKNs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbYIKNs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 09:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755760AbYIKNre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 09:47:34 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:58186 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756512AbYIKNrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 09:47:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Ukom0nQu00UvUxCJXMD6TJfRrk8PhcvaYH1cM/SO3amnXEEm034Rd6QJmwQ7Xvv5TB
         AumZRjc/+dPL24Z7/6zfMfPz1rIYq9qSkn1VvbfMhz1hKlgfALkEg8F88VgSElSbMSl6
         cbCwOcq/feIh2xqPyNAGjNoMoIDPtLVd6Qb4Q=
Message-ID: <80b317760809110647wf1b81e3u799c63e0aa83a04@mail.gmail.com>
Date: Thu, 11 Sep 2008 15:47:31 +0200
From: "Richard Genoud" <richard.genoud@gmail.com>
To: "Julia Lawall" <julia@diku.dk>
Subject: Re: [PATCH 5/5] drivers/dma/ioat_dma.c: Drop code after return
Cc: maciej.sosnowski@intel.com, linux-kernel@vger.kernel.org,
       vigneshbabu@gmail.com, kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0809111434100.9593@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0809111434100.9593@pc-004.diku.dk>
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
>
>  drivers/dma/ioat_dma.c        |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
> index bc8c6e3..1ef68b3 100644
> --- a/drivers/dma/ioat_dma.c
> +++ b/drivers/dma/ioat_dma.c
> @@ -971,11 +971,9 @@ static struct ioat_desc_sw *ioat_dma_get_next_descriptor(
>        switch (ioat_chan->device->version) {
>        case IOAT_VER_1_2:
>                return ioat1_dma_get_next_descriptor(ioat_chan);
> -               break;
>        case IOAT_VER_2_0:
>        case IOAT_VER_3_0:
>                return ioat2_dma_get_next_descriptor(ioat_chan);
> -               break;
>        }
>        return NULL;
>  }
>
