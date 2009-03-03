Return-Path: <linux-kernel-owner+w=401wt.eu-S1755572AbZCCKAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbZCCKAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 05:00:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204AbZCCKAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 05:00:09 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:40709 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbZCCKAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 05:00:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=LwubDKgVe8j91Rq7EkfDzfmtoQTmhDrwwx6rkDW5bE8gMUjGHb5jqygCkiDvv7Ykwy
         n0ByYYNbAmoufeudOtic0ojQJr6XnlchHrFvlvnDEAIMcSjTOdQZNs1GfrG4U42IYxFB
         5rnIEkzunbE59WOQInLRDW3b4FnBJa92Qpn/I=
MIME-Version: 1.0
In-Reply-To: <1236033772-20329-2-git-send-email-marcin.slusarz@gmail.com>
References: <1236033772-20329-2-git-send-email-marcin.slusarz@gmail.com>
Date: Tue, 3 Mar 2009 11:00:04 +0100
X-Google-Sender-Auth: 10888140f599e824
Message-ID: <10f740e80903030200y3f055c28u6a01f279a53cacc1@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] Add virtual "idle" device
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 2, 2009 at 23:42, Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> --- /dev/null
> +++ b/drivers/char/idle.c
> @@ -0,0 +1,445 @@

> +#ifdef DEBUG
> +#define idle_printk(args...) printk(KERN_DEBUG "IDLEDEV: " args)
> +#else
> +#define idle_printk(args...) do {} while (0)
> +#endif

Please use the standard debug interface, i.e.

#define pr_fmt(fmt) "IDLEDEV: " fmt

and use pr_debug() everywhere, to always have printf()-style format checking.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
