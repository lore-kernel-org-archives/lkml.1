Return-Path: <linux-kernel-owner+w=401wt.eu-S1754227AbZJ0EkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbZJ0EkX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 00:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751639AbZJ0EkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 00:40:23 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:51408 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbZJ0EkW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 00:40:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=XHNFGiuM6/sCeaeiBtF5V/VzcfCdKvHgw3I6vWpXvmNA7If2Y5CzRKlepr7CWh8Bc9
         ZdpG7k3iPREDlwrcZh706iFIJAqGkkUhG84FzuoqwF/1zqC73HFB/rQrDE0me3VYelF/
         D5cYM/ikcbTfW21u8c6czaEdfMAEFRhAx1Yjk=
MIME-Version: 1.0
In-Reply-To: <1256316741-14053-1-git-send-email-bryan.wu@canonical.com>
References: <1256316741-14053-1-git-send-email-bryan.wu@canonical.com>
From: Eric Miao <eric.miao@canonical.com>
Date: Tue, 27 Oct 2009 12:40:07 +0800
X-Google-Sender-Auth: b7943a0d8af45996
Message-ID: <f17812d70910262140i63e4d2f0x708521a9287ca386@mail.gmail.com>
Subject: Re: [PATCH] Staging: Android logger: fix compiling error
To: Bryan Wu <bryan.wu@canonical.com>
Cc: gregkh@suse.de, kernel-team@lists.ubuntu.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Compiling broke since commit a99bbaf5ee6bad1aca0c88ea65ec6e5373e86184
>    headers: remove sched.h from poll.h
>
> Adding <linux/sched.h> to fix this compiling bug.
>

Bryan,

Is this something caused by incorrect pxa header files?

> Cc: Alexey Dobriyan <adobriyan@gmail.com>
> Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
> ---
>  drivers/staging/android/logger.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
> index 6c10b45..a8eb7d1 100644
> --- a/drivers/staging/android/logger.c
> +++ b/drivers/staging/android/logger.c
> @@ -21,6 +21,7 @@
>  #include <linux/fs.h>
>  #include <linux/miscdevice.h>
>  #include <linux/uaccess.h>
> +#include <linux/sched.h>
>  #include <linux/poll.h>
>  #include <linux/time.h>
>  #include "logger.h"
> --
> 1.6.3.3
>
>
> --
> kernel-team mailing list
> kernel-team@lists.ubuntu.com
> https://lists.ubuntu.com/mailman/listinfo/kernel-team
>
