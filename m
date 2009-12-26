Return-Path: <linux-kernel-owner+w=401wt.eu-S1752091AbZLZKjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbZLZKjd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 05:39:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbZLZKjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 05:39:31 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:47835 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbZLZKja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 05:39:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type;
        b=mrIyD+Jey51lX3z2acrG2K7p4xU+DCjd0+f/g/KZm4SYxoGy7ey/w6WjKc7GA+PyJ/
         tFVRi95H44HN6hwdLL6Y3TJa9NOVic5Blw6YzWefXAeQu/k88mmEFMjrenCJ5GOF3XF9
         Sj5QPt+flTajvZ4Ot2plnEo675HjTip3ma/3E=
MIME-Version: 1.0
Date: Sat, 26 Dec 2009 11:39:27 +0100
X-Google-Sender-Auth: 1c5e07c5c5e2e2bb
Message-ID: <10f740e80912260239n17bbbd08w6c3065c12bde9c95@mail.gmail.com>
Subject: sys_recvmmsg: wire up or not?
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On m68k, I get:

<stdin>:1523:2: warning: #warning syscall recvmmsg not implemented

so I started to wire up sys_recvmmsg.
Then I noticed it's already accessible, through sys_socketcall, as m68k defines
__ARCH_WANT_SYS_SOCKETCALL. So I guess this is a false positive?

Surprisingly, several architectures have both defined __ARCH_WANT_SYS_SOCKETCALL
and wired up sys_recvmmsg. Is this intentional?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
