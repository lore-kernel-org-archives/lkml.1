Return-Path: <linux-kernel-owner+w=401wt.eu-S1755138AbYGHNFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138AbYGHNFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 09:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbYGHNEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 09:04:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:59767 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbYGHNEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 09:04:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:sender:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references:x-google-sender-auth;
        b=Q02JgIOdqng5mvRYuWr2sFlAh8tDG0Hyjg88rSYmNQLAIqfLfbXiZpFj3OvQZwDpUo
         OQII1s3/FguOKnTCJADFQSl9Qv5SQyYe6keP3nlB6dTTIIVZfsoQPi1N3UV+miEYEsXV
         yyGef7GzRJByDcYvM4bvHEUFkIT87JGyLhSJ8=
Message-ID: <919fe2b30807080604x68620b15ndf0bd81605df6834@mail.gmail.com>
Date: Tue, 8 Jul 2008 09:04:51 -0400
From: "Mark Asselstine" <mark.asselstine@windriver.com>
Reply-To: mark.asselstine@windriver.com
To: "Alexander Beregalov" <a.beregalov@gmail.com>
Subject: Re: [PATCH] scsi_cmnd.h: remove double inclusion of linux/blkdev.h
Cc: James.Bottomley@hansenpartnership.com, bharrosh@panasas.com,
       linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <a4423d670807060601sa56948ak812c4569297fada6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4423d670807060601sa56948ak812c4569297fada6@mail.gmail.com>
X-Google-Sender-Auth: e889f87a34a246c9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 6, 2008 at 9:01 AM, Alexander Beregalov
<a.beregalov@gmail.com> wrote:
> From: Alexander Beregalov <a.beregalov@gmail.com>
>
> Remove double inclusion of linux/blkdev.h
>
>  include/scsi/scsi_cmnd.h |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
> ---
>
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 3e46dfa..66c9448 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -7,7 +7,6 @@
>  #include <linux/types.h>
>  #include <linux/timer.h>
>  #include <linux/scatterlist.h>
> -#include <linux/blkdev.h>
>

Reviewed-by: Mark Asselstine <mark.asselstine@windriver.com>

>  struct Scsi_Host;
>  struct scsi_device;
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
