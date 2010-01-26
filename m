Return-Path: <linux-kernel-owner+w=401wt.eu-S1752733Ab0AZI5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab0AZI5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 03:57:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924Ab0AZI5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 03:57:11 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:37085 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab0AZI5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 03:57:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type;
        b=SWxSg201fOlklvhLMeVz6d9ea9YvNLJQMJZOjrRB2kB2qUPFL36G11L8KLLELJ+YNI
         Edrz9RrISQ87Lgq0qZLxNap7hlibpEAoPu8/MdKVtbG2+0yuSc3IWSSBjvJjuOkdNyZN
         XxwAkcBcEmtXiQ774OFMoPRhQ01u1GjAeO4hI=
MIME-Version: 1.0
Date: Tue, 26 Jan 2010 09:57:05 +0100
X-Google-Sender-Auth: c84f53fd5ccc87a8
Message-ID: <10f740e81001260057h37f3494dvefa3a37b2e1453a5@mail.gmail.com>
Subject: drivers/net/ariadne.c:165: error: 'set_multicast_list' undeclared 
	here (not in a function)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alexey Dobriyan <adobriyan@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Cc: Linux-Next <linux-next@vger.kernel.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://kisskb.ellerman.id.au/kisskb/buildresult/2076964/

drivers/net/ariadne.c:165: error: 'set_multicast_list' undeclared here
(not in a function)

Seems to be broken by:

commit a271623f871dda970319ca15dfad3a8c8c36249f
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Fri Jan 22 10:13:10 2010 +0000

    netdev: remove certain HAVE_ macros

    After netdev_ops compat code HAVE_* macros aren't needed, in fact
    they _will_ result in compile breakage for out of tree drivers.

    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
