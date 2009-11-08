Return-Path: <linux-kernel-owner+w=401wt.eu-S1754745AbZKHTpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbZKHTpu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 14:45:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbZKHTpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 14:45:50 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:44622 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbZKHTpt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 14:45:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=H1XHJjCpqyqta5CRI7KvQdftk6/o9vir5osiH+YqEUVr2EX/eHW/o0o1pNYDARU5p1
         6rJAtmzYjRdzYMreJ9GNywF+mLlzMRFlwGhZoNNcSHk9U5yTKjqrNGHQ5vjFPQHwHHDc
         tNUX3qnh7merakwfFle3/61G1A07r5nd88eio=
MIME-Version: 1.0
In-Reply-To: <1257708657-1232-1-git-send-email-tfransosi@gmail.com>
References: <1257708657-1232-1-git-send-email-tfransosi@gmail.com>
Date: Sun, 8 Nov 2009 17:45:53 -0200
Message-ID: <a4c8a6d00911081145p4765c795tbf873232d86f7c39@mail.gmail.com>
Subject: Re: [PATCH] ata: Clean up hard coded array size calculation.
From: Thiago Farina <tfransosi@gmail.com>
To: jgarzik@pobox.com
Cc: mlord@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thiago Farina <tfransosi@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 8, 2009 at 5:30 PM, Thiago Farina <tfransosi@gmail.com> wrote:
> Use ARRAY_SIZE macro of kernel api instead.
>
> Signed-off-by: Thiago Farina <tfransosi@gmail.com>
Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
> ---
>  drivers/ata/sata_mv.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
> index 6f5093b..a8a7be0 100644
> --- a/drivers/ata/sata_mv.c
> +++ b/drivers/ata/sata_mv.c
> @@ -2217,7 +2217,7 @@ static unsigned int mv_qc_issue_fis(struct ata_queued_cmd *qc)
>        int err = 0;
>
>        ata_tf_to_fis(&qc->tf, link->pmp, 1, (void *)fis);
> -       err = mv_send_fis(ap, fis, sizeof(fis) / sizeof(fis[0]));
> +       err = mv_send_fis(ap, fis, ARRAY_SIZE(fis));
>        if (err)
>                return err;
>
> --
> 1.6.5.2.150.g1b52a
>
>
