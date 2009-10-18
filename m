Return-Path: <linux-kernel-owner+w=401wt.eu-S1751899AbZJRGcF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899AbZJRGcF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 02:32:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbZJRGcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 02:32:05 -0400
Received: from mail-px0-f171.google.com ([209.85.216.171]:35513 "EHLO
	mail-px0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbZJRGcD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 02:32:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=q3b8JaPNR8m91HDmtx89BMD3lJSSiEhuOaK603N5WwV4e+dpAOdDFbyl1dYBSC+8Zj
         YWXAOSm+s5ag7TDZtDyw5zcmHYxam38hGFKw8DDs10OCJLAHalmmjgd1B27W+qS05iHg
         ftPO7OsDvqibcrZ9uixCZzu0+BLe3wnJb0sak=
MIME-Version: 1.0
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190901E24550@mi8nycmail19.Mi8.com>
References: <BD79186B4FD85F4B8E60E381CAEE190901E24550@mi8nycmail19.Mi8.com>
Date: Sun, 18 Oct 2009 14:25:25 +0800
Message-ID: <2674af740910172325n2bfeb444i41966fd95fc7951c@mail.gmail.com>
Subject: Re: [PATCH] clockevents.c: fix symbol was not declared noise
From: Yong Zhang <yong.zhang0@gmail.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       john stultz <johnstul@us.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 17, 2009 at 6:19 AM, H Hartley Sweeten
<hartleys@visionengravers.com> wrote:
> Include "tick-internal.h" in order to pick up the extern function
> prototype for clockevents_shutdown().  This quiets the following
> spares build noise:
>
>  warning: symbol 'clockevents_shutdown' was not declared. Should it be static?
>
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>

Looks good.
Reviewed-by: Yong Zhang <yong.zhang0@gmail.com>

Cc'ed some experts.

> ---
>
> diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
> index 620b58a..c30ba1f 100644
> --- a/kernel/time/clockevents.c
> +++ b/kernel/time/clockevents.c
> @@ -20,6 +20,8 @@
>  #include <linux/sysdev.h>
>  #include <linux/tick.h>
>
> +#include "tick-internal.h"
> +
>  /* The registered clock event devices */
>  static LIST_HEAD(clockevent_devices);
>  static LIST_HEAD(clockevents_released);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
