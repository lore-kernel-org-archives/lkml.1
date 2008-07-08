Return-Path: <linux-kernel-owner+w=401wt.eu-S1756860AbYGHSbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860AbYGHSbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 14:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754793AbYGHSbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 14:31:24 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:37969 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705AbYGHSbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 14:31:23 -0400
Date: Tue, 8 Jul 2008 21:30:27 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [RFC 07/11] remove CONFIG_KMOD from sound
Message-ID: <20080708183027.GB11954@cs181140183.pp.htv.fi>
References: <20080708170015.470877000@sipsolutions.net> <20080708170046.726427000@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080708170046.726427000@sipsolutions.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2008 at 07:00:22PM +0200, Johannes Berg wrote:
>...
> --- everything.orig/sound/core/seq/seq_device.c	2008-07-08 18:54:05.000000000 +0200
> +++ everything/sound/core/seq/seq_device.c	2008-07-08 18:57:40.000000000 +0200
>...
> @@ -566,7 +566,7 @@ EXPORT_SYMBOL(snd_seq_device_load_driver
>  EXPORT_SYMBOL(snd_seq_device_new);
>  EXPORT_SYMBOL(snd_seq_device_register_driver);
>  EXPORT_SYMBOL(snd_seq_device_unregister_driver);
> -#ifdef CONFIG_KMOD
> +#ifdef CONFIG_MODULES
>  EXPORT_SYMBOL(snd_seq_autoload_lock);
>  EXPORT_SYMBOL(snd_seq_autoload_unlock);
>  #endif
>...

You can remove the #ifdef  

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

