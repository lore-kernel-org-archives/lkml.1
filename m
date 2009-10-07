Return-Path: <linux-kernel-owner+w=401wt.eu-S1758458AbZJGHJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758458AbZJGHJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 03:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756590AbZJGHJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 03:09:20 -0400
Received: from mail-qy0-f202.google.com ([209.85.221.202]:54229 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756302AbZJGHJT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 03:09:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sD6Xkx/Ujnmko5lvhAXkhBOcfOUAC6unUTnX+FvRfg+t1tqxkAVt4jW3kShs7Ze3Zs
         CmczsS3Wuh5K2PiMOAqO8YZSqX94eVQVtClLgl5x9RBt7JkrzZJEjKJ4iYKv0sO3PAnW
         xDiCeZLJOjlasAwr0IW4zhjMbFpNQUeBf0VX0=
MIME-Version: 1.0
In-Reply-To: <20091007061814.GA7596@july>
References: <20091007061814.GA7596@july>
Date: Wed, 7 Oct 2009 12:38:42 +0530
Message-ID: <5d5443650910070008w5520890die68747bf5f0a9f13@mail.gmail.com>
Subject: Re: [PATCH 4/6] Haptic: add haptic configuration
From: Trilok Soni <soni.trilok@gmail.com>
To: Kyungmin Park <kyungmin.park@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kyungmin,

On Wed, Oct 7, 2009 at 11:48 AM, Kyungmin Park
<kyungmin.park@samsung.com> wrote:
> haptic class support
>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/Kconfig  |    2 ++
>  drivers/Makefile |    1 +
>  2 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/Kconfig b/drivers/Kconfig
> index 48bbdbe..a44348e 100644
> --- a/drivers/Kconfig
> +++ b/drivers/Kconfig
> @@ -90,6 +90,8 @@ source "drivers/memstick/Kconfig"
>
>  source "drivers/leds/Kconfig"
>
> +source "drivers/haptic/Kconfig"
> +
>  source "drivers/accessibility/Kconfig"
>
>  source "drivers/infiniband/Kconfig"
> diff --git a/drivers/Makefile b/drivers/Makefile
> index 6ee53c7..ee6f438 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -94,6 +94,7 @@ obj-y                         += idle/
>  obj-$(CONFIG_MMC)              += mmc/
>  obj-$(CONFIG_MEMSTICK)         += memstick/
>  obj-$(CONFIG_NEW_LEDS)         += leds/
> +obj-$(CONFIG_HAPTCI)           += haptic/

s/CONFIG_HAPTCI/CONFIG_HAPTIC :)

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
