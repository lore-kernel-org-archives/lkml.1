Return-Path: <linux-kernel-owner+w=401wt.eu-S1756014AbZHWK4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbZHWK4Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 06:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756000AbZHWK4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 06:56:16 -0400
Received: from mail-pz0-f194.google.com ([209.85.222.194]:65462 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995AbZHWK4P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 06:56:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=iil92JSOLbZM0QLex3krIoMajsl+dvKFKOD4DW69b2QEwUBW2NB/FMoovJPO1ExTRf
         rN9n8TE1Fh/xj9kPYNMpmm60H/iiMI0YWsfgTN/tqDKtAT9JbXvlZVm3KHlCojE5e8gQ
         CgaKDMKAqadfLlkLHJg7adTmfqgK6L/U4VZUY=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.01.0908211810390.3158@localhost.localdomain>
References: <alpine.LFD.2.01.0908211810390.3158@localhost.localdomain>
Date: Sun, 23 Aug 2009 12:56:17 +0200
X-Google-Sender-Auth: 76cb81acc2c572d8
Message-ID: <10f740e80908230356j4622a042nb83da4952f940b2@mail.gmail.com>
Subject: Re: Linux 2.6.31-rc7
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 22, 2009 at 03:26, Linus
Torvalds<torvalds@linux-foundation.org> wrote:
> KOSAKI Motohiro (1):
>      mm: revert "oom: move oom_adj value"

drivers/staging/android/lowmemorykiller.c: In function 'lowmem_shrink':
drivers/staging/android/lowmemorykiller.c:108: error: 'struct
mm_struct' has no member named 'oom_adj'

I guess this one must be reverted as well?

commit a6a9f81ccc9f5c86ccc22bbed1960a57d0316e8b
Author: David Rientjes <rientjes@google.com>
Date:   Tue Jun 16 16:42:53 2009 -0700

    Staging: android: lowmemorykiller.c: fix it for "oom: move oom_adj value fro

    I'm about to merge "oom: move oom_adj value from task_struct to
    mm_struct", and this fixup is needed to repair linux-next's
    drivers/staging/android/lowmemorykiller.c.

    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
