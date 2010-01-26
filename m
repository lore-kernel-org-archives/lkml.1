Return-Path: <linux-kernel-owner+w=401wt.eu-S1751968Ab0AZWnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab0AZWnO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 17:43:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761Ab0AZWnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 17:43:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37948 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755Ab0AZWnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 17:43:13 -0500
Date: Tue, 26 Jan 2010 23:43:11 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Shahar Havivi <shaharh@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Remove unused variables
In-Reply-To: <b0ae6fcc1001200359y8779182j76f92b50924b340b@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1001262342240.30977@pobox.suse.cz>
References: <b0ae6fcc1001200359y8779182j76f92b50924b340b@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jan 2010, Shahar Havivi wrote:

> Remove unused fields in drivers/char/vt.c
> variables orig_buf and orig_count are assigned but never used.
> Shahar Havivi

Could you please resend with your Signed-off-by line, as described in 
Documentation/SubmittingPatches, so that I could apply the patch?

> ---
>  drivers/char/vt.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
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

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
