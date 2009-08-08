Return-Path: <linux-kernel-owner+w=401wt.eu-S1752830AbZHHWbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbZHHWbc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 18:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbZHHWbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 18:31:32 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:57788 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbZHHWbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 18:31:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=C8jow8pKpxjYWMsoxTFWTUopY9U84cEWrcS75rF7LceeGxpXk65mqYJRqzpUJOMRT5
         Ml3Su9twAT5yWfMwzddep08lvIir0pEiK7CpPT7IA3OJit5C6kShq2Hxgv7j6bC3D5cJ
         I9FM8Ae7ATmTxjHUAKyIQXRJb5UTc6x9hRfP0=
MIME-Version: 1.0
Date: Sat, 8 Aug 2009 15:31:31 -0700
Message-ID: <dd18b0c30908081531k6682d5b5k14c78fa954656542@mail.gmail.com>
Subject: *** stack smashing detected ***: ./firefox-bin terminated
From: Justin Mattock <justinmattock@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How should I handle this:

*** stack smashing detected ***: ./firefox-bin terminated
======= Backtrace: =========
/lib64/libc.so.6(__fortify_fail+0x37)[0x7f765ab2a477]
/lib64/libc.so.6(__fortify_fail+0x0)[0x7f765ab2a440]
/home/name/LFS/net/firefox/plugins/libflashplayer.so[0x7f7646911a6f]
/home/name/LFS/net/firefox/plugins/libflashplayer.so[0x7f764690d67c]
/home/name/LFS/net/firefox/plugins/libflashplayer.so[0x7f764691077f]
/home/name/LFS/net/firefox/plugins/libflashplayer.so[0x7f76469090cd]
/home/name/LFS/net/firefox/plugins/libflashplayer.so[0x7f76466f95e0]
/home/name/LFS/net/firefox/plugins/libflashplayer.so[0x7f76466f9c1d]
/home/name/LFS/net/firefox/plugins/libflashplayer.so[0x7f76466bd944]
/home/name/LFS/net/firefox/plugins/libflashplayer.so[0x7f76466c738b]
/home/name/LFS/net/firefox/plugins/libflashplayer.so[0x7f76466af3e1]
/home/name/LFS/net/firefox/plugins/libflashplayer.so[0x7f76466a4af0]
/home/name/LFS/net/firefox/plugins/libflashplayer.so[0x7f764638ed29]
/home/name/LFS/net/firefox/plugins/libflashplayer.so[0x7f764637edaf]
/usr/lib64/libglib-2.0.so.0[0x7f765bbd477b]
/usr/lib64/libglib-2.0.so.0(g_main_context_dispatch+0x22e)[0x7f765bbd320e]
/usr/lib64/libglib-2.0.so.0[0x7f765bbd3958]
/usr/lib64/libglib-2.0.so.0(g_main_context_iteration+0x70)[0x7f765bbd3b40]
./libxul.so[0x7f765efd07a1]
./libxul.so[0x7f765efd0b71]
./libxul.so[0x7f765f08ea79]
./libxul.so[0x7f765f0628bd]
./libxul.so[0x7f765efd0883]
./libxul.so[0x7f765eeaadaf]
./libxul.so(XRE_main+0x213f)[0x7f765e812149]
./firefox-bin[0x401bc0]
/lib64/libc.so.6(__libc_start_main+0xec)[0x7f765aa65a4c]
./firefox-bin[0x4019b9]

even if I move the firefox package to /usr/lib64
this still occurs.

I would like to keep stack protection,
but having firefox crash over any flash content
is unattractive.

should I try firefox about this, or change something in the kernel?


-- 
Justin P. Mattock
