Return-Path: <linux-kernel-owner+w=401wt.eu-S1753287Ab0A0JPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab0A0JPY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 04:15:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262Ab0A0JPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 04:15:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53777 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744Ab0A0JPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 04:15:21 -0500
Date: Wed, 27 Jan 2010 10:15:20 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Shahar Havivi <shaharh@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Remove unused variables
In-Reply-To: <b0ae6fcc1001270049m6e2e7b1dre9971e57e282b48a@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1001271013580.30977@pobox.suse.cz>
References: <b0ae6fcc1001200359y8779182j76f92b50924b340b@mail.gmail.com>  <alpine.LNX.2.00.1001262342240.30977@pobox.suse.cz> <b0ae6fcc1001270049m6e2e7b1dre9971e57e282b48a@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jan 2010, Shahar Havivi wrote:

> Remove unused fields in drivers/char/vt.c
> variables orig_buf and orig_count are assigned but never used.
> 
> Signed-off-by: Shahar Havivi <shaharh@gmail.com>
> ---
>  drivers/char/vt.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> diff --git a/drivers/char/vt.c b/drivers/char/vt.c
> index 50faa1f..94f530a 100644
> --- a/drivers/char/vt.c
> +++ b/drivers/char/vt.c
> @@ -2119,8 +2119,6 @@ static int do_con_write(struct tty_struct *tty,
> const unsigned char *buf, int co
>     uint8_t inverse;
>     uint8_t width;
>     u16 himask, charmask;
> -   const unsigned char *orig_buf = NULL;
> -   int orig_count;
> 
>     if (in_interrupt())
>         return count;
> @@ -2142,8 +2140,6 @@ static int do_con_write(struct tty_struct *tty,
> const unsigned char *buf, int co
>         release_console_sem();
>         return 0;
>     }
> -   orig_buf = buf;
> -   orig_count = count;
> 
>     himask = vc->vc_hi_font_mask;
>     charmask = himask ? 0x1ff : 0xff;

Your patch is whitespace damaged and line wrapped.

I have fixed it by hand and applied it, but please fix your mail client 
for any patch submissions in the future.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
