Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbZIJHpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbZIJHpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 03:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbZIJHpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 03:45:20 -0400
Received: from mail-px0-f194.google.com ([209.85.216.194]:53428 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbZIJHpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 03:45:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type;
        b=tJ5HAtK/M+ViQCiXgOHQMp+z5ei9Hvw9QeJ2gwK4nuopwrDNCtuTHrCRGvyVMj5cK5
         OPBSO3PDYz37K+Su0m3ghueEqA59/5dXYoXqYQMwfU6QonE9fxXaS6mQmKICvaIq9ltG
         QdnD8PNyVZZaa8AVpAKfOf9Ovsfzhx4UF3ueY=
MIME-Version: 1.0
Date: Thu, 10 Sep 2009 09:45:22 +0200
X-Google-Sender-Auth: 060f317cb5246210
Message-ID: <10f740e80909100045n3f830091l2d5430adc85004c2@mail.gmail.com>
Subject: ERROR: "strchr" [drivers/md/dm-log-userspace.ko] undefined!
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of Sep 6 (http://kisskb.ellerman.id.au/kisskb/config/164/), the
m68k allmodconfig build
fails with:

| ERROR: "strchr" [drivers/md/dm-log-userspace.ko] undefined!

This was introduced in v2.6.31-rc9 by commit
b8313b6da7e2e7c7f47d93d8561969a3ff9ba0ea
(dm log: remove incorrect field from userspace table output).

It seems the newly added call to strstr() is turned into a call to
strchr() by gcc.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
