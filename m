Return-Path: <linux-kernel-owner+w=401wt.eu-S934419AbZDJKvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934419AbZDJKvO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 06:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934332AbZDJKup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 06:50:45 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:6379 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934264AbZDJKuo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 06:50:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CktWzZ5iLQ/0v1LGj5VOdvipvYR3rrlf9m5uRwKeF4EQYOVe5emZox2NPcciQzxqUk
         n2Sd+W0y5HSXtIXapPrFnIM7XiRCs050XhnxG/59GzwZvYzt9OTZZ+z+gXHeC820sgMn
         lGY426gmUQyf9k95gIISHIB6oEjSUqZyJ/P0M=
MIME-Version: 1.0
In-Reply-To: <20090410103429.GA31367@elf.ucw.cz>
References: <20090410103429.GA31367@elf.ucw.cz>
Date: Fri, 10 Apr 2009 18:50:42 +0800
Message-ID: <f17812d70904100350l19fa7493ma9c4695d49d19398@mail.gmail.com>
Subject: Re: 2.6.30-rc1: white screen during boot (regression) on spitz
From: Eric Miao <eric.y.miao@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>,
       Russell King <rmk@arm.linux.org.uk>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       dbaryshkov@gmail.com, omegamoon@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 6:34 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
> After update to 2.6.30-rc1, sharp zaurus c-3000 fails to boot with
> white screen (with stripes). That's a regression w.r.t. 2.6.29.

What kind of white stripes? Does it look like the LCD controller
stops working or something.

There is a regression which caused X server hang during bootup,
with commit id 66c1ca0, which you can revert and have another
try.

>                                                                        Pavel
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Cheers
- eric
