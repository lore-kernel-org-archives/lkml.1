Return-Path: <linux-kernel-owner+w=401wt.eu-S933131AbXGKTzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933131AbXGKTzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 15:55:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763053AbXGKTyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 15:54:53 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:58387 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762465AbXGKTyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 15:54:52 -0400
Date: Wed, 11 Jul 2007 21:55:21 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [PATCH] Start to genericize kconfig for use by other projects.
Message-ID: <20070711195521.GO3492@stusta.de>
References: <200707111522.14240.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200707111522.14240.rob@landley.net>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 03:22:13PM -0400, Rob Landley wrote:
>...
> --- a/crypto/Makefile	Tue Jul 10 17:51:13 2007 -0700
> +++ b/crypto/Makefile	Wed Jul 11 15:07:07 2007 -0400
> @@ -50,3 +50,4 @@ obj-$(CONFIG_CRYPTO_CRC32C) += crc32c.o
>  obj-$(CONFIG_CRYPTO_CRC32C) += crc32c.o
>  
>  obj-$(CONFIG_CRYPTO_TEST) += tcrypt.o
> +obj-m += randint.o
>...

If you'd have included a diffstat as described in 
Documentation/SubmittingPatches section 1 point 14 you might have 
noticed this yourself...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

