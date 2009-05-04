Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068AbZEDHYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbZEDHYc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 03:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbZEDHYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 03:24:21 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:61347 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbZEDHYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 03:24:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=n5g27iBGBR+H58u6Ots7IzEqdPshs94pKlWeY7n3akr6m9gTErZOOTzkFrF+THE5SO
         oX48dY3n1rq3F6SLXEgR4F4Uzje5sn48kE3tbEGtmeGZj57/tl88497zFUMkryP+OWhd
         WdeIBwYndufr9ARXP9flg+/ogaCeIIQtAJMXU=
MIME-Version: 1.0
In-Reply-To: <45b4644e80c27b9d042b3960e3d99f0d444e0d92.1241105648.git.arnd@arndb.de>
References: <cover.1241105648.git.arnd@arndb.de>
	 <45b4644e80c27b9d042b3960e3d99f0d444e0d92.1241105648.git.arnd@arndb.de>
Date: Mon, 4 May 2009 09:24:19 +0200
X-Google-Sender-Auth: 58041eee445c7196
Message-ID: <10f740e80905040024w65493f4cvb0fa0f0bbd432e65@mail.gmail.com>
Subject: Re: [PATCH 12/27] asm-generic: add a NOMMU uaccess.h
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 6, 2008 at 17:31, Arnd Bergmann <arnd@arndb.de> wrote:
> index 549cb3a..ebeacd9 100644
> --- a/include/asm-generic/uaccess.h
> +++ b/include/asm-generic/uaccess.h

> +/*
> + * User space memory access functions, these should work
> + * on a ny machine that has kernel and user data in the same
         any

> + * address space, e.g. all NOMMU machines.
> + */

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
