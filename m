Return-Path: <linux-kernel-owner+w=401wt.eu-S1751605AbZJRGSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605AbZJRGSX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 02:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbZJRGSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 02:18:22 -0400
Received: from mail-px0-f171.google.com ([209.85.216.171]:43069 "EHLO
	mail-px0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbZJRGSV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 02:18:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HVYPo4+SFH1kUS/fEbA3vBVj8Z9RCF2iwg7GQrpxyG+pP70ELUHxpWxyDkgwPwXEo6
         O6uiHzSSRfHln1+fXFgYoHydXvHei0F/2UwjQxOT+OJw1Zo5//q2XN76ebCId9pASII/
         ZAbaMN6oF+7BVBsZM/B+qZwvgpT+0hVcB2K/s=
MIME-Version: 1.0
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190901E24552@mi8nycmail19.Mi8.com>
References: <BD79186B4FD85F4B8E60E381CAEE190901E24552@mi8nycmail19.Mi8.com>
Date: Sun, 18 Oct 2009 14:18:26 +0800
Message-ID: <2674af740910172318k2f9ac49ai227d3593612a310e@mail.gmail.com>
Subject: Re: [PATCH] jiffies.c: fix symbol was not declared noise
From: Yong Zhang <yong.zhang0@gmail.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 17, 2009 at 6:26 AM, H Hartley Sweeten
<hartleys@visionengravers.com> wrote:
> In kernel/time/jiffies.c, clocksource_jiffies should be static.
>
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Reviewed-by: Yong Zhang <yong.zhang0@gmail.com>

Cc'ed some experts.

>
> ---
>
> diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
> index 5404a84..36d2d83 100644
> --- a/kernel/time/jiffies.c
> +++ b/kernel/time/jiffies.c
> @@ -55,7 +55,7 @@ static cycle_t jiffies_read(struct clocksource *cs)
>        return (cycle_t) jiffies;
>  }
>
> -struct clocksource clocksource_jiffies = {
> +static struct clocksource clocksource_jiffies = {
>        .name           = "jiffies",
>        .rating         = 1, /* lowest valid rating*/
>        .read           = jiffies_read,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
