Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbZLTUgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbZLTUgL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 15:36:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754596AbZLTUgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 15:36:09 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:63809 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686AbZLTUgI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 15:36:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=NY+ZixfghMY4YNb0XVop+jIHAy7OAXrJ96en9ooANaUbTZIQj1GMw0JgrhyPCOHHZr
         5ErrEx6v96SXq4sYEGFR0w9K7Wd4uOqPP8XbFuXhM0nzLBQ/M75dbQvcihpl5U4QpxmV
         Cc+1aPkw0B4Fn0lAF9liCPOhm1sq8ZtCgxryg=
MIME-Version: 1.0
In-Reply-To: <tip-6c9a74afc5d95321e33a727b3c563f3e7d6c4a5c@git.kernel.org>
References: <1261315437.4314.6.camel@laptop>
	 <tip-6c9a74afc5d95321e33a727b3c563f3e7d6c4a5c@git.kernel.org>
Date: Sun, 20 Dec 2009 21:36:03 +0100
X-Google-Sender-Auth: 98f4b79b9e42dc68
Message-ID: <10f740e80912201236l192d9fean5b8f191c658b09eb@mail.gmail.com>
Subject: Re: [tip:sched/urgent] sched: Restore printk sanity
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       joe@perches.com, torvalds@linux-foundation.org, peterz@infradead.org,
       efault@gmx.de, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 20, 2009 at 19:00, tip-bot for Peter Zijlstra
<peterz@infradead.org> wrote:
> Commit-ID:  6c9a74afc5d95321e33a727b3c563f3e7d6c4a5c
> Gitweb:     http://git.kernel.org/tip/6c9a74afc5d95321e33a727b3c563f3e7d6c4a5c
> Author:     Peter Zijlstra <peterz@infradead.org>
> AuthorDate: Sun, 20 Dec 2009 14:23:57 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Sun, 20 Dec 2009 18:45:57 +0100
>
> sched: Restore printk sanity
>
> Revert the braindead pr_* crap. (Commit 663997d "sched: Use
> pr_fmt() and pr_<level>()")
>
> It's dumb and causes stupid "sched: " strings all over the place.

Isn't it sufficient to just remove the `#define pr_fmt(fmt) ...' line?

Gr{oetje,eeting}s,

						Geert (pr_* fan)

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
