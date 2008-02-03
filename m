Return-Path: <linux-kernel-owner+w=401wt.eu-S936138AbYBCADm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936138AbYBCADm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 19:03:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935419AbYBCAA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 19:00:27 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:55928 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932685AbYBCAAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 19:00:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=k4aEEZSrdeOlwdmSXQDTEUsJn2CQtjN7jZKafCy5O5oBiDTwjmJimu9ugmvDICINOLXRX/vjqEjV9qGRjcMIoxkpTi/rUgjNP0qSPwJuwthR+I/l9BFyyuVWaPqqNj3MaLDahjIohbqFoNTGIMZxUbcg/LklH8tgWFAdTHwLHG0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 28/32] ide-tape: shorten some function names
Date: Sun, 3 Feb 2008 01:12:59 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
References: <1201427300-3954-1-git-send-email-petkovbb@gmail.com> <1201427300-3954-23-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1201427300-3954-23-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802030112.59217.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 January 2008, Borislav Petkov wrote:
> From: Borislav Petkov <bbpetkov@yahoo.de>
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> ---
>  drivers/ide/ide-tape.c |   29 +++++++++++++++--------------
>  1 files changed, 15 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
> index f8a4b27..d4c4255 100644
> --- a/drivers/ide/ide-tape.c
> +++ b/drivers/ide/ide-tape.c

[...]

> @@ -2290,10 +2290,10 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks, struct
>  }
>  
>  /*
> - *	idetape_insert_pipeline_into_queue is used to start servicing the
> + *	idetape_ins_ppl_into_queue is used to start servicing the
>   *	pipeline stages, starting from tape->next_stage.
>   */
> -static void idetape_insert_pipeline_into_queue (ide_drive_t *drive)
> +static void idetape_ins_ppl_into_queue(ide_drive_t *drive)

idetape_plug_pipeline?

Otherwise looks fine so please move it at the beginning of the series
and resubmit so I can apply it.

Thanks,
Bart
