Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab0CHGdf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 01:33:35 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:41544 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab0CHGd2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 01:33:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Mczb2QuKpNOxpFrtngHeqTywq/MEEEciMfTo2yVJbqRMV/TExtUSh3xcdRM0fJsRyA
         sEOdSgngT7gvy7Sy1qWL6nJkcDgO+OiiHYyEv+4eSi6YD+xqP2UoqmwXXYzx9D5pbV6D
         GsEReCmUbynXr9X5jNZBsBOHhUFm/AANbiDpc=
MIME-Version: 1.0
In-Reply-To: <201003022006.o22K6QqH019931@hera.kernel.org>
References: <201003022006.o22K6QqH019931@hera.kernel.org>
Date: Mon, 8 Mar 2010 07:33:27 +0100
X-Google-Sender-Auth: 4c4a348edc624b87
Message-ID: <10f740e81003072233j1f9f6a0fr633e1fc65f4e5a5a@mail.gmail.com>
Subject: Re: ps3_gelic_wireless: fix format warning
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, cbe-oss-dev@lists.ozlabs.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 2, 2010 at 21:06, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> Gitweb:     http://git.kernel.org/linus/c6c97bdaa3307d0811f14c99c38c63a8dae36e1f
> Commit:     c6c97bdaa3307d0811f14c99c38c63a8dae36e1f
> Parent:     d3a571971e5af241074947fc80f6284677f6e014
> Author:     John W. Linville <linville@tuxdriver.com>
> AuthorDate: Mon Feb 1 09:55:56 2010 -0500
> Committer:  John W. Linville <linville@tuxdriver.com>
> CommitDate: Mon Feb 1 09:55:56 2010 -0500
>
>    ps3_gelic_wireless: fix format warning
>
>    Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/net/ps3_gelic_wireless.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/ps3_gelic_wireless.c b/drivers/net/ps3_gelic_wireless.c
> index d520e9e..448c5b6 100644
> --- a/drivers/net/ps3_gelic_wireless.c
> +++ b/drivers/net/ps3_gelic_wireless.c
> @@ -1449,7 +1449,7 @@ static int gelic_wl_start_scan(struct gelic_wl_info *wl, int always_scan,
>        void *buf = NULL;
>        size_t len;
>
> -       pr_debug("%s: <- always=%d essid_len=%d\n", __func__,
> +       pr_debug("%s: <- always=%d essid_len=%z\n", __func__,

`z' is just a modifier for a (missing) type, so this should be `%zu'.

>                 always_scan, essid_len);
>        if (mutex_lock_interruptible(&wl->scan_lock))
>                return -ERESTARTSYS;

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
