Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751273Ab0CAKK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 05:10:57 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45740 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab0CAKKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 05:10:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Sr9NQpWIy8AGnLKILjIOZdrKqlFYdjHY/HATAnUvgWNhv3DQB9x6Xk3AlQ7RD51o2K
         kdY4PDrowaeJ1JxYtP37+UCnXzqQ+ABeBjM0YJP7+uc1rqZUkNXIKoJUPokaj3oTJcNI
         5r5r9mAQ3xWnrqvuYUg4syEpcqJcb/bdIzHzE=
MIME-Version: 1.0
In-Reply-To: <201003011042.48923.elendil@planet.nl>
References: <20100301042249.GA12289@linux.vnet.ibm.com>
	 <201003011042.48923.elendil@planet.nl>
Date: Mon, 1 Mar 2010 11:10:54 +0100
X-Google-Sender-Auth: b6250db161a50fc7
Message-ID: <10f740e81003010210k3de9851fuf9f67f55b08af4f1@mail.gmail.com>
Subject: Re: [PATCH RFC] kconfig: place git SHA1 in .config output if in git 
	tree
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Frans Pop <elendil@planet.nl>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, zippel@linux-m68k.org, mingo@elte.hu,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 1, 2010 at 10:42, Frans Pop <elendil@planet.nl> wrote:
> Paul E. McKenney wrote:
>> This patch appends the SHA1 hash of the current git tree to the
>> kernel version line, or "[Not git tree]" if run from a non-git tree.
>> Uses "git log" to print the hash.
>
> Nice idea.
>
> However, I gave it a try and got:
> # Linux kernel version: 2.6.34-rc0 [Not git tree]
>
> Even though I *am* building from a git tree. It does not seem to work when
> building with KBUILD_OUTPUT set or when using 'O='.
>
> IMO that makes the practical value of the patch very limited. I'm afraid
> because of this it will increase confusion rather than add information.

scripts/setlocalversion handles this case correctly, so you may want to
look there...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
