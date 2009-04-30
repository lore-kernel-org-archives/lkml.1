Return-Path: <linux-kernel-owner+w=401wt.eu-S1759717AbZD3INO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759717AbZD3INO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 04:13:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbZD3IM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 04:12:57 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:2656 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbZD3IM4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 04:12:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=da5QqrD4HMICqv2D144SW1w009CvN9hQM8kIUI5NsONlPZjV4sMVKWhRgPaqvcNxeW
         rYE3IfMTti3RPyZ139dopZulkk64PnNRIv/NwyWCp7SIMWxajaqlmMmKmu9NGNKEqbYS
         BGeUva4n8Pwrngs4m/c1hvuFmzzeq0XO4xbhY=
MIME-Version: 1.0
In-Reply-To: <49F85D9C.4000405@redhat.com>
References: <49F85D9C.4000405@redhat.com>
Date: Thu, 30 Apr 2009 13:42:55 +0530
Message-ID: <807b3a220904300112vf8e77e5g5075eeb8f63e029d@mail.gmail.com>
Subject: Re: [PATCH] block: remove unused __REQ_NR_BITS
From: Nikanth K <nikanth@gmail.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Nikanth Karthikesan <knikanth@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jerome

On Wed, Apr 29, 2009 at 7:31 PM, Jerome Marchand <jmarchan@redhat.com> wrote:
>
> Removes __REQ_NR_BITS which is not used since its only user
> (blk_dump_rq_flags()) stopped to use it.
>

See http://lkml.org/lkml/2009/4/27/140

A user for it is added by a patch in linux-2.6-block#for-2.6.31
see http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commit;h=9eb55b030c4b3227334ee4482402096cd1d1a6fe

Thanks
Nikanth

>
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
> ---
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 2755d5c..a101821 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -119,7 +119,6 @@ enum rq_flag_bits {
>        __REQ_INTEGRITY,        /* integrity metadata has been remapped */
>        __REQ_NOIDLE,           /* Don't anticipate more IO after this one */
>        __REQ_IO_STAT,          /* account I/O stat */
> -       __REQ_NR_BITS,          /* stops here */
>  };
>
>  #define REQ_RW         (1 << __REQ_RW)
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
