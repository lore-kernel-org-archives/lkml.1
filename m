Return-Path: <linux-kernel-owner+w=401wt.eu-S1757078AbYGHMaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078AbYGHMaT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 08:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbYGHMaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 08:30:04 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:7354 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbYGHMaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 08:30:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=rpgzAS6fPfG0G8TurR0vq84PJKwc7INOJnBAqzh5RuVKUtIsmIEdT9vl2oMcokRvoz
         R5faaVdGE6iTZXlvibVB63XAaeg4D8nil7wCoBiUs4iiFLffSLrxUdO9P5NqkSzjfLBn
         JwLtLd/tY/g8PHW/ac8XQxowle0nw7ScW2Y5I=
Message-ID: <919fe2b30807080529j71ae1816sc035c90b5eee555c@mail.gmail.com>
Date: Tue, 8 Jul 2008 08:29:57 -0400
From: "Mark Asselstine" <asselsm@gmail.com>
To: "Alexander Beregalov" <a.beregalov@gmail.com>
Subject: Re: [PATCH] drm_memory.h: remove double inclusion of linux/vmalloc.h
Cc: kernel-janitors@vger.kernel.org, airlied@linux.ie,
       dri-devel@lists.sourceforge.net,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <a4423d670807060431w639f0b1ajcbad6471d50ef802@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4423d670807060431w639f0b1ajcbad6471d50ef802@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 6, 2008 at 7:31 AM, Alexander Beregalov
<a.beregalov@gmail.com> wrote:
> From: Alexander Beregalov <a.beregalov@gmail.com>
>
> Remove double inclusion of linux/vmalloc.h
>
> drivers/char/drm/drm_memory.h |    2 --
> 1 files changed, 0 insertions(+), 2 deletions(-)
>
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
> ---
>
> diff --git a/drivers/char/drm/drm_memory.h b/drivers/char/drm/drm_memory.h
> index 63e425b..15af9b3 100644
> --- a/drivers/char/drm/drm_memory.h
> +++ b/drivers/char/drm/drm_memory.h
> @@ -44,8 +44,6 @@
>
>  #if __OS_HAS_AGP
>
> -#include <linux/vmalloc.h>
> -

Why remove this one and not the one at the top of the file? As well
this file has #include of drmP.h, yet drmP.h is the only file I can
find that includes drm_memory.h. Based on this I would think there is
some additional cleanup that can go on here.

Regards,
Mark Asselstine

>  #ifdef HAVE_PAGE_AGP
>  #include <asm/agp.h>
>  #else
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
