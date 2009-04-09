Return-Path: <linux-kernel-owner+w=401wt.eu-S935478AbZDIPmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935478AbZDIPmt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 11:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754274AbZDIPmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 11:42:31 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:43059 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934773AbZDIPm3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 11:42:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=NRYDkJgEwWGVjZLfUGnKF4y2kpTEyUCtyADGjk1OP+Icy9P2d5F3VZUW9e6UbzVljt
         v5E2H+I+Zf1WgWmfNy/nv3UUtJG5u1hRLLhk2LfggvwdHBjI29mpzRW8f3NvepfLRQtq
         c1xPSClHqzpL9T1Xb7x+W61ExLAultQxo+pEs=
MIME-Version: 1.0
In-Reply-To: <1239167872-8179-3-git-send-email-joe@perches.com>
References: <1239167872-8179-1-git-send-email-joe@perches.com>
	 <1239167872-8179-3-git-send-email-joe@perches.com>
Date: Thu, 9 Apr 2009 10:42:27 -0500
X-Google-Sender-Auth: f8b91f53ca2b303f
Message-ID: <ed82fe3e0904090842l357c6ee9yab8a99a384ca4089@mail.gmail.com>
Subject: Re: [PATCH 02/10] MAINTAINERS - Add file patterns
From: Timur Tabi <timur@freescale.com>
To: Joe Perches <joe@perches.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 8, 2009 at 12:17 AM, Joe Perches <joe@perches.com> wrote:

>  CIRRUS LOGIC CS4270 SOUND DRIVER
>  P:     Timur Tabi
>  M:     timur@freescale.com
>  L:     alsa-devel@alsa-project.org
>  S:     Supported
> +F:     sound/soc/codecs/cs4270*
> +F:     sound/soc/fsl/mpc8610_hpcd.c

mpc8610_hpcd.c is not part of the CS4270 driver.  It's only cs4270*

>  FREESCALE SOC SOUND DRIVERS
>  P:     Timur Tabi
>  M:     timur@freescale.com
>  L:     alsa-devel@alsa-project.org
>  L:     linuxppc-dev@ozlabs.org
>  S:     Supported
> +F:     sound/soc/fsl/

This takes care of mpc8610_hpcd.c, but it also includes
mpc5200_psc_i2s.c and soc-of-simple.c, which are not mine.

-- 
Timur Tabi
Linux kernel developer at Freescale
