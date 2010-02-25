Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab0BYIuc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 03:50:32 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53833 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab0BYIua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 03:50:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=XgzTYSsAhzB8J+N+kdIGRmaG1r8fBkAAPvPg1mTuIs74ksrpmwhCioWkRWWuYtSWVP
         CtJ48qGKrH/UQ38Nn4fYgkDCog4LyI8n+KZ6rYXDJO6toHVVm8L/VBhy3jqaSmsvIN+o
         hNkrFvROkjOSclXax6vM3N159k2+WX8/Jnu4I=
MIME-Version: 1.0
In-Reply-To: <961aa3351002241738r7bbdc811p1fe80aabc336ae85@mail.gmail.com>
References: <1266934273-9371-1-git-send-email-akinobu.mita@gmail.com>
	 <20100224162152.GK3687@quack.suse.cz>
	 <961aa3351002241738r7bbdc811p1fe80aabc336ae85@mail.gmail.com>
Date: Thu, 25 Feb 2010 09:50:28 +0100
X-Google-Sender-Auth: c8f4750f52a84498
Message-ID: <10f740e81002250050g287f7753g96063376ecee9487@mail.gmail.com>
Subject: Re: [PATCH] udf: use ext2_find_next_bit
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
       Linux-Next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 02:38, Akinobu Mita <akinobu.mita@gmail.com> wrote:
> 2010/2/25 Jan Kara <jack@suse.cz>:
>> On Tue 23-02-10 23:11:13, Akinobu Mita wrote:
>>> Use ext2_find_next_bit (generic_find_next_le_bit) to find the set bit
>>> in little endian bitmap region.

Is any of this in linux-next now?

http://kisskb.ellerman.id.au/kisskb/buildresult/2208481/
| fs/udf/balloc.c:274: error: implicit declaration of function
'generic_find_next_le_bit'

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
