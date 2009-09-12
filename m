Return-Path: <linux-kernel-owner+w=401wt.eu-S1752432AbZILHxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbZILHxF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 03:53:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbZILHxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 03:53:04 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:52216 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbZILHwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 03:52:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :message-id;
        b=B9I+R3ep7GMsExFOB3VTaVhodxvFGgxlK3Jh1p5EpLMmYCG/t15G6RkEct+Fhiqr8T
         /Z3U4XepP0R6Gt+yCdV0wqC/tz1qbNcch02pEWfNfLKkmpL0beF0PjzsXdXh536xVGVe
         E6EOqkZKxek5uzuNJRTJ7vFb7ipS2CkKIvNzY=
From: Volker Armin Hemmann <volkerarmin@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.31 ehci problem - mouse dead on scroll
Date: Sat, 12 Sep 2009 09:46:59 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31r4; KDE/4.3.1; x86_64; ; )
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_zH1qKILWhFkTdQP"
Message-Id: <200909120946.59517.volkerarmin@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_zH1qKILWhFkTdQP
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi,

I have a nice logitech wireless mouse. With 2.6.30 and earlier it works wel=
l.

With 2.6.31 it sometimes kills the ehci bus, if I scroll too fast. Very slo=
w=20
scrolling is ok, not scrolling is ok. Fast scrolling, bus is dead and dmesg=
=20
looks like this:

[  879.193292] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  879.193308] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  879.193316] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  879.193325] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  879.193774] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  879.193780] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  879.253291] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  879.253306] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  879.253312] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  879.253319] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  879.253770] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  879.253776] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  879.267040] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  879.267055] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  879.267063] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  879.267071] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  879.267666] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  879.267675] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  879.280372] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  879.280386] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  879.280392] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  879.280400] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  879.281539] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  879.281548] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  879.341202] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  879.341216] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  879.341222] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  879.341229] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  879.341788] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  879.341797] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  879.401202] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  879.401216] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  879.401222] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  879.401230] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  879.402035] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  879.402043] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  879.461202] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  879.461216] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  879.461222] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  879.461229] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  879.461778] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  879.461786] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  879.521203] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  879.521217] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  879.521223] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  879.521230] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  879.522027] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  879.522035] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  879.581204] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  879.581218] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  879.581224] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  879.581232] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  879.581765] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  879.581773] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  879.641198] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  879.641212] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  879.641218] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  879.641226] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  879.642018] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  879.642027] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  879.701202] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  879.701216] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  879.701222] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  879.701230] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  879.701762] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  879.701770] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  879.761201] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  879.761215] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  879.761221] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  879.761229] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  879.762010] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  879.762018] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  879.821206] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  879.821220] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  879.821226] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  879.821234] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  879.821763] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  879.821771] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  879.881203] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  879.881217] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  879.881223] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  879.881230] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  879.882001] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  879.882010] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  879.941205] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  879.941219] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  879.941225] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  879.941233] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  879.941721] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  879.941727] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  880.000665] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  880.000679] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  880.000686] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  880.000694] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  880.001243] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  880.001251] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  880.061201] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  880.061215] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  880.061221] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  880.061228] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  880.061712] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  880.061718] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  880.121200] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  880.121213] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  880.121219] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  880.121226] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  880.121982] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  880.121990] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  880.181204] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  880.181217] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  880.181223] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  880.181231] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  880.181704] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  880.181710] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  880.241202] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  880.241216] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  880.241222] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  880.241229] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  880.241973] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  880.241982] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  880.301205] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  880.301218] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  880.301224] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  880.301232] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  880.301696] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  880.301702] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  880.361202] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  880.361216] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  880.361222] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  880.361229] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  880.361965] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  880.361973] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  880.421204] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  880.421218] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  880.421224] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  880.421231] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  880.421687] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  880.421693] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  880.481202] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  880.481216] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  880.481222] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  880.481229] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  880.481957] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  880.481965] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  880.541204] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  880.541218] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  880.541224] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  880.541231] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  880.541827] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  880.541835] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  880.600584] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  880.600597] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  880.600603] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  880.600611] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  880.601210] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  880.601218] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  880.661204] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  880.661218] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  880.661224] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  880.661231] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  880.661670] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  880.661676] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  880.721202] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  880.721215] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  880.721221] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  880.721229] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  880.721940] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  880.721948] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  880.781204] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  880.781217] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  880.781223] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  880.781231] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  880.781662] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  880.781668] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  880.841202] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  880.841215] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  880.841221] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  880.841229] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  880.841931] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  880.841939] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  880.901204] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  880.901217] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  880.901223] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  880.901230] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  880.901653] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  880.901659] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  880.959949] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  880.959963] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  880.959969] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  880.959977] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  880.960400] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  880.960406] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  881.019964] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  881.019979] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  881.019987] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  881.019995] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]=
                   =20
[  881.021057] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule  =
                   =20
[  881.021066] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]  =
                   =20
[  881.080653] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.080667] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  881.080673] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.080681] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.081143] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  881.081149] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.140567] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.140581] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  881.140587] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.140594] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.141652] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  881.141661] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.200516] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.200529] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  881.200535] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.200543] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.201156] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  881.201165] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.260490] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.260504] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  881.260510] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.260517] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.261049] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  881.261057] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.319954] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.319969] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  881.319976] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.319984] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.320387] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  881.320394] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.380653] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.380666] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  881.380672] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.380680] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.381627] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  881.381633] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.440598] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.440611] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  881.440618] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.440625] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.441159] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  881.441167] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.500563] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.500577] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  881.500583] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.500590] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.501625] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  881.501634] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.560402] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.560415] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  881.560421] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.560428] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.561132] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  881.561140] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.619961] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.619974] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  881.619980] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.619988] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.620877] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  881.620885] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]


and the only thing to get the mouse back is rmmod ehci_hcd modprobe ehci_hc=
d.

It does not happen everytime - of course always if it is most annoying and=
=20
never when I really don't care ;)

mouse is attached to a 4port revoltec disk usb 2.0 hub with an external pow=
er=20
brick.


When I want to attach the mouse directly, I have to load ohci_hcd FIRST. AN=
D=20
after that lsusb just hangs, but I seem to be able to scroll as much as I=20
want.

 2762.596422] ohci_hcd 0000:00:14.5: auto-stop root hub
[ 2762.596444] ohci_hcd 0000:00:13.1: auto-stop root hub
[ 2762.596460] ohci_hcd 0000:00:13.0: auto-stop root hub
[ 2762.596476] ohci_hcd 0000:00:12.0: auto-stop root hub
[ 2764.317678] hub 7-0:1.0: hub_suspend
[ 2764.317693] usb usb7: bus auto-suspend
[ 2764.317701] ohci_hcd 0000:00:14.5: suspend root hub
[ 2764.317711] hub 6-0:1.0: hub_suspend
[ 2764.317717] usb usb6: bus auto-suspend
[ 2764.317722] ohci_hcd 0000:00:13.1: suspend root hub
[ 2764.317730] hub 5-0:1.0: hub_suspend
[ 2764.317736] usb usb5: bus auto-suspend
[ 2764.317741] ohci_hcd 0000:00:13.0: suspend root hub
[ 2764.317748] hub 3-0:1.0: hub_suspend
[ 2764.317753] usb usb3: bus auto-suspend
[ 2764.317758] ohci_hcd 0000:00:12.0: suspend root hub
[ 2764.317766] hub 2-0:1.0: hub_suspend
[ 2764.317771] usb usb2: bus auto-suspend
[ 2764.317775] ehci_hcd 0000:00:13.2: suspend root hub
[ 2766.703520] usb 1-2: lsusb timed out on ep0in len=3D0/2
[ 2766.703529] usb 1-2: retry with reset-resume
[ 2766.756878] ehci_hcd 0000:00:12.2: port 2 high speed
[ 2766.756891] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER=
=20
sig=3Dse0 PE CONNECT
[ 2766.810184] usb 1-2: reset high speed USB device using ehci_hcd and addr=
ess=20
2
[ 2771.819775] usb 1-2: lsusb timed out on ep0in len=3D0/64
[ 2776.830158] usb 1-2: lsusb timed out on ep0in len=3D0/64
[ 2781.839773] usb 1-2: lsusb timed out on ep0in len=3D0/64
[ 2781.893563] ehci_hcd 0000:00:12.2: port 2 high speed
[ 2781.893576] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER=
=20
sig=3Dse0 PE CONNECT
[ 2781.946445] usb 1-2: device descriptor read/64, error -110
[ 2787.059772] usb 1-2: lsusb timed out on ep0in len=3D0/64
[ 2792.069779] usb 1-2: lsusb timed out on ep0in len=3D0/64
[ 2797.079778] usb 1-2: lsusb timed out on ep0in len=3D0/64
[ 2797.133554] ehci_hcd 0000:00:12.2: port 2 high speed
[ 2797.133567] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER=
=20
sig=3Dse0 PE CONNECT
[ 2797.186444] usb 1-2: device descriptor read/64, error -110
[ 2797.343527] ehci_hcd 0000:00:12.2: port 2 high speed
[ 2797.343540] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER=
=20
sig=3Dse0 PE CONNECT
[ 2797.396442] usb 1-2: reset high speed USB device using ehci_hcd and addr=
ess=20
2
[ 2802.406446] usb 1-2: lsusb timed out on ep0in len=3D0/64
[ 2807.416445] usb 1-2: lsusb timed out on ep0in len=3D0/64
[ 2812.426443] usb 1-2: lsusb timed out on ep0in len=3D0/64
[ 2812.480192] ehci_hcd 0000:00:12.2: port 2 high speed
[ 2812.480205] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER=
=20
sig=3Dse0 PE CONNECT
[ 2812.533519] usb 1-2: device descriptor read/64, error -110
[ 2817.646850] usb 1-2: lsusb timed out on ep0in len=3D0/64


Here is lspci:

lspci -v
00:00.0 Host bridge: ATI Technologies Inc RX780/RX790 Chipset Host Bridge
        Subsystem: ASRock Incorporation A770CrossFire Motherboard       =20
        Flags: bus master, 66MHz, medium devsel, latency 0              =20
        Memory at <ignored> (64-bit, non-prefetchable)                  =20
        Capabilities: [c4] HyperTransport: Slave or Primary Interface   =20
        Capabilities: [40] HyperTransport: Retry Mode                   =20
        Capabilities: [54] HyperTransport: UnitID Clumping              =20
        Capabilities: [9c] HyperTransport: #1a                          =20

00:02.0 PCI bridge: ATI Technologies Inc RD790 PCI to PCI bridge (external=
=20
gfx0 port A) (prog-if 00 [Normal decode])                                  =
                                       =20
        Flags: bus master, fast devsel, latency 0                          =
                   =20
        Bus: primary=3D00, secondary=3D02, subordinate=3D02, sec-latency=3D=
0                          =20
        I/O behind bridge: 0000c000-0000cfff                               =
                   =20
        Memory behind bridge: fdf00000-fdffffff                            =
                   =20
        Prefetchable memory behind bridge: 00000000d0000000-00000000dffffff=
f                  =20
        Capabilities: [50] Power Management version 3                      =
                   =20
        Capabilities: [58] Express Root Port (Slot-), MSI 00               =
                   =20
        Capabilities: [a0] MSI: Enable+ Count=3D1/1 Maskable- 64bit-       =
                     =20
        Capabilities: [b0] Subsystem: ASRock Incorporation A770CrossFire=20
Motherboard          =20
        Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+      =
                   =20
        Capabilities: [100] Vendor Specific Information <?>                =
                   =20
        Capabilities: [110] Virtual Channel <?>                            =
                   =20
        Kernel driver in use: pcieport-driver                              =
                   =20

00:09.0 PCI bridge: ATI Technologies Inc RD790 PCI to PCI bridge (PCI expre=
ss=20
gpp port E) (prog-if 00 [Normal decode])                                   =
                                    =20
        Flags: bus master, fast devsel, latency 0                          =
                   =20
        Bus: primary=3D00, secondary=3D03, subordinate=3D04, sec-latency=3D=
0                          =20
        I/O behind bridge: 0000d000-0000dfff                               =
                   =20
        Memory behind bridge: fe000000-febfffff                            =
                   =20
        Prefetchable memory behind bridge: 00000000fa000000-00000000fceffff=
f                  =20
        Capabilities: [50] Power Management version 3                      =
                   =20
        Capabilities: [58] Express Root Port (Slot-), MSI 00               =
                   =20
        Capabilities: [a0] MSI: Enable+ Count=3D1/1 Maskable- 64bit-       =
                     =20
        Capabilities: [b0] Subsystem: ASRock Incorporation A770CrossFire=20
Motherboard          =20
        Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+      =
                   =20
        Capabilities: [100] Vendor Specific Information <?>                =
                   =20
        Capabilities: [110] Virtual Channel <?>                            =
                   =20
        Kernel driver in use: pcieport-driver                              =
                   =20

00:0a.0 PCI bridge: ATI Technologies Inc RD790 PCI to PCI bridge (PCI expre=
ss=20
gpp port F) (prog-if 00 [Normal decode])                                   =
                                    =20
        Flags: bus master, fast devsel, latency 0                          =
                   =20
        Bus: primary=3D00, secondary=3D01, subordinate=3D01, sec-latency=3D=
0                          =20
        I/O behind bridge: 0000b000-0000bfff                               =
                   =20
        Memory behind bridge: fde00000-fdefffff                            =
                   =20
        Prefetchable memory behind bridge: 00000000cff00000-00000000cffffff=
f                  =20
        Capabilities: [50] Power Management version 3                      =
                   =20
        Capabilities: [58] Express Root Port (Slot-), MSI 00               =
                   =20
        Capabilities: [a0] MSI: Enable+ Count=3D1/1 Maskable- 64bit-       =
                     =20
        Capabilities: [b0] Subsystem: ASRock Incorporation A770CrossFire=20
Motherboard          =20
        Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+      =
                   =20
        Capabilities: [100] Vendor Specific Information <?>                =
                   =20
        Capabilities: [110] Virtual Channel <?>                            =
                   =20
        Kernel driver in use: pcieport-driver                              =
                   =20

00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA Controller=20
[AHCI mode] (prog-if 01 [AHCI 1.0])                                        =
                                        =20
        Subsystem: ASRock Incorporation Device 4391                        =
                   =20
        Flags: bus master, 66MHz, medium devsel, latency 128, IRQ 22       =
                   =20
        I/O ports at a000 [size=3D8]                                       =
                     =20
        I/O ports at 9000 [size=3D4]                                       =
                     =20
        I/O ports at 8000 [size=3D8]                                       =
                     =20
        I/O ports at 7000 [size=3D4]                                       =
                     =20
        I/O ports at 6000 [size=3D16]                                      =
                     =20
        Memory at fddff800 (32-bit, non-prefetchable) [size=3D1K]          =
                     =20
        Capabilities: [60] Power Management version 2                      =
                   =20
        Capabilities: [70] SATA HBA <?>                                    =
                   =20
        Kernel driver in use: ahci                                         =
                   =20

00:12.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controll=
er=20
(prog-if 10 [OHCI])                                                        =
                                    =20
        Subsystem: ASRock Incorporation Device 4397                        =
                   =20
        Flags: bus master, 66MHz, medium devsel, latency 128, IRQ 7        =
                   =20
        Memory at fddfe000 (32-bit, non-prefetchable) [size=3D4K]          =
                     =20
        Kernel modules: ohci-hcd                                           =
                   =20

00:12.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller (pr=
og-
if 10 [OHCI])
        Subsystem: ASRock Incorporation Device 4398                        =
               =20
        Flags: bus master, 66MHz, medium devsel, latency 128, IRQ 7        =
               =20
        Memory at fddfd000 (32-bit, non-prefetchable) [size=3D4K]          =
                 =20
        Kernel modules: ohci-hcd                                           =
               =20

00:12.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controlle=
r=20
(prog-if 20 [EHCI])                                                        =
                                     =20
        Subsystem: ASRock Incorporation Device 4396                        =
                   =20
        Flags: bus master, 66MHz, medium devsel, latency 128, IRQ 17       =
                   =20
        Memory at fddff000 (32-bit, non-prefetchable) [size=3D256]         =
                     =20
        Capabilities: [c0] Power Management version 2                      =
                   =20
        Capabilities: [e4] Debug port: BAR=3D1 offset=3D00e0               =
                       =20
        Kernel driver in use: ehci_hcd                                     =
                   =20
        Kernel modules: ehci-hcd                                           =
                   =20

00:13.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controll=
er=20
(prog-if 10 [OHCI])                                                        =
                                    =20
        Subsystem: ASRock Incorporation Device 4397                        =
                   =20
        Flags: bus master, 66MHz, medium devsel, latency 128, IRQ 10       =
                   =20
        Memory at fddfc000 (32-bit, non-prefetchable) [size=3D4K]          =
                     =20
        Kernel modules: ohci-hcd                                           =
                   =20

00:13.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller (pr=
og-
if 10 [OHCI])
        Subsystem: ASRock Incorporation Device 4398                        =
               =20
        Flags: bus master, 66MHz, medium devsel, latency 128, IRQ 10       =
               =20
        Memory at fddf7000 (32-bit, non-prefetchable) [size=3D4K]          =
                 =20
        Kernel modules: ohci-hcd                                           =
               =20

00:13.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controlle=
r=20
(prog-if 20 [EHCI])                                                        =
                                     =20
        Subsystem: ASRock Incorporation Device 4396                        =
                   =20
        Flags: bus master, 66MHz, medium devsel, latency 128, IRQ 19       =
                   =20
        Memory at fddf6800 (32-bit, non-prefetchable) [size=3D256]         =
                     =20
        Capabilities: [c0] Power Management version 2                      =
                   =20
        Capabilities: [e4] Debug port: BAR=3D1 offset=3D00e0               =
                       =20
        Kernel driver in use: ehci_hcd                                     =
                   =20
        Kernel modules: ehci-hcd                                           =
                   =20

00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 3a)
        Subsystem: ASRock Incorporation Device 4385               =20
        Flags: 66MHz, medium devsel                               =20
        Capabilities: [b0] HyperTransport: MSI Mapping Enable- Fixed+
        Kernel modules: i2c-piix4                                   =20

00:14.1 IDE interface: ATI Technologies Inc SB700/SB800 IDE Controller (pro=
g-
if 8a [Master SecP PriP])                                                  =
                                     =20
        Subsystem: ASRock Incorporation Device 439c                        =
                   =20
        Flags: bus master, 66MHz, medium devsel, latency 0                 =
                   =20
        I/O ports at 01f0 [size=3D8]                                       =
                     =20
        I/O ports at 03f4 [size=3D1]                                       =
                     =20
        I/O ports at 0170 [size=3D8]                                       =
                     =20
        I/O ports at 0374 [size=3D1]                                       =
                     =20
        I/O ports at ff00 [size=3D16]                                      =
                     =20
        Capabilities: [70] MSI: Enable- Count=3D1/1 Maskable- 64bit-       =
                     =20

00:14.3 ISA bridge: ATI Technologies Inc SB700/SB800 LPC host controller
        Subsystem: ASRock Incorporation Device 439d                    =20
        Flags: bus master, 66MHz, medium devsel, latency 0             =20

00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge (prog-if 0=
1=20
[Subtractive decode])                                                      =
                                     =20
        Flags: bus master, 66MHz, medium devsel, latency 64                =
                   =20
        Bus: primary=3D00, secondary=3D05, subordinate=3D05, sec-latency=3D=
64                         =20
        I/O behind bridge: 0000e000-0000efff                               =
                   =20
        Prefetchable memory behind bridge: fcf00000-fcffffff               =
                   =20

00:14.5 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI2 Controll=
er=20
(prog-if 10 [OHCI])                                                        =
                                    =20
        Subsystem: ASRock Incorporation Device 4399                        =
                   =20
        Flags: bus master, 66MHz, medium devsel, latency 128, IRQ 10       =
                   =20
        Memory at fddf5000 (32-bit, non-prefetchable) [size=3D4K]          =
                     =20
        Kernel modules: ohci-hcd                                           =
                   =20

00:18.0 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64,=20
Sempron] HyperTransport Configuration                                      =
                                        =20
        Flags: fast devsel                                                 =
                   =20
        Capabilities: [80] HyperTransport: Host or Secondary Interface     =
                   =20

00:18.1 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64,=20
Sempron] Address Map
        Flags: fast devsel                                                 =
                  =20

00:18.2 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64,=20
Sempron] DRAM Controller                                                   =
                                        =20
        Flags: fast devsel                                                 =
                   =20

00:18.3 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64,=20
Sempron] Miscellaneous Control                                             =
                                        =20
        Flags: fast devsel                                                 =
                   =20
        Capabilities: [f0] Secure device <?>                               =
                   =20

00:18.4 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64,=20
Sempron] Link Control
        Flags: fast devsel

01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B =
PCI=20
Express Gigabit Ethernet controller (rev 02)
        Subsystem: ASRock Incorporation Motherboard (one of many)
        Flags: bus master, fast devsel, latency 0, IRQ 28
        I/O ports at b800 [size=3D256]
        Memory at cffff000 (64-bit, prefetchable) [size=3D4K]
        Memory at cffe0000 (64-bit, prefetchable) [size=3D64K]
        Expansion ROM at fdef0000 [disabled] [size=3D64K]
        Capabilities: [40] Power Management version 3
        Capabilities: [50] MSI: Enable+ Count=3D1/2 Maskable- 64bit+
        Capabilities: [70] Express Endpoint, MSI 01
        Capabilities: [b0] MSI-X: Enable- Count=3D2 Masked-
        Capabilities: [d0] Vital Product Data
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [140] Virtual Channel <?>
        Capabilities: [160] Device Serial Number 78-56-34-12-68-4c-e0-00
        Kernel driver in use: r8169
        Kernel modules: r8169

02:00.0 VGA compatible controller: ATI Technologies Inc Radeon HD 3870 (pro=
g-
if 00 [VGA controller])
        Subsystem: Info-Tek Corp. Device 4070
        Flags: bus master, fast devsel, latency 0, IRQ 29
        Memory at d0000000 (64-bit, prefetchable) [size=3D256M]
        Memory at fdff0000 (64-bit, non-prefetchable) [size=3D64K]
        I/O ports at c000 [size=3D256]
        Expansion ROM at fdfc0000 [disabled] [size=3D128K]
        Capabilities: [50] Power Management version 3
        Capabilities: [58] Express Legacy Endpoint, MSI 00
        Capabilities: [a0] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
        Capabilities: [100] Vendor Specific Information <?>
        Kernel driver in use: fglrx_pci
        Kernel modules: fglrx

02:00.1 Audio device: ATI Technologies Inc Radeon HD 3870 Audio device
        Subsystem: Info-Tek Corp. Device aa18
        Flags: bus master, fast devsel, latency 0, IRQ 10
        Memory at fdfec000 (64-bit, non-prefetchable) [size=3D16K]
        Capabilities: [50] Power Management version 3
        Capabilities: [58] Express Legacy Endpoint, MSI 00
        Capabilities: [a0] MSI: Enable- Count=3D1/1 Maskable- 64bit+
        Capabilities: [100] Vendor Specific Information <?>
        Kernel modules: snd-hda-intel

05:06.0 Multimedia video controller: Brooktree Corporation Bt848 Video Capt=
ure=20
(rev 12)
        Flags: bus master, medium devsel, latency 128, IRQ 21
        Memory at fcfff000 (32-bit, prefetchable) [size=3D4K]
        Kernel driver in use: bttv
        Kernel modules: bttv

05:08.0 Multimedia audio controller: Creative Labs SB0400 Audigy2 Value
        Subsystem: Creative Labs Device 1001
        Flags: bus master, medium devsel, latency 128, IRQ 23
        I/O ports at e800 [size=3D64]
        Capabilities: [dc] Power Management version 2
        Kernel driver in use: EMU10K1_Audigy
        Kernel modules: snd-emu10k1

lsusb:
lsusb -v

Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Device Descriptor:                                           =20
  bLength                18                                  =20
  bDescriptorType         1                                  =20
  bcdUSB               2.00                                  =20
  bDeviceClass            9 Hub                              =20
  bDeviceSubClass         0 Unused                           =20
  bDeviceProtocol         0 Full speed (or root) hub         =20
  bMaxPacketSize0        64                                  =20
  idVendor           0x1d6b Linux Foundation                 =20
  idProduct          0x0002 2.0 root hub                     =20
  bcdDevice            2.06                                  =20
  iManufacturer           3 Linux 2.6.31r4 ehci_hcd          =20
  iProduct                2 EHCI Host Controller             =20
  iSerial                 1 0000:00:13.2                     =20
  bNumConfigurations      1                                  =20
  Configuration Descriptor:                                  =20
    bLength                 9                                =20
    bDescriptorType         2                                =20
    wTotalLength           25                                =20
    bNumInterfaces          1                                =20
    bConfigurationValue     1                                =20
    iConfiguration          0                                =20
    bmAttributes         0xe0                                =20
      Self Powered                                           =20
      Remote Wakeup                                          =20
    MaxPower                0mA                              =20
    Interface Descriptor:                                    =20
      bLength                 9                              =20
      bDescriptorType         4                              =20
      bInterfaceNumber        0                              =20
      bAlternateSetting       0                              =20
      bNumEndpoints           1                              =20
      bInterfaceClass         9 Hub                          =20
      bInterfaceSubClass      0 Unused                       =20
      bInterfaceProtocol      0 Full speed (or root) hub     =20
      iInterface              0                              =20
      Endpoint Descriptor:                                   =20
        bLength                 7                            =20
        bDescriptorType         5                            =20
        bEndpointAddress     0x81  EP 1 IN                   =20
        bmAttributes            3                            =20
          Transfer Type            Interrupt                 =20
          Synch Type               None                      =20
          Usage Type               Data                      =20
        wMaxPacketSize     0x0004  1x 4 bytes                =20
        bInterval              12                            =20
Hub Descriptor:                                              =20
  bLength               9                                    =20
  bDescriptorType      41                                    =20
  nNbrPorts             6                                    =20
  wHubCharacteristic 0x000a                                  =20
    No power switching (usb 1.0)                             =20
    Per-port overcurrent protection                          =20
  bPwrOn2PwrGood       10 * 2 milli seconds                  =20
  bHubContrCurrent      0 milli Ampere                       =20
  DeviceRemovable    0x00                                    =20
  PortPwrCtrlMask    0xff                                    =20
 Hub Port Status:                                            =20
   Port 1: 0000.0100 power                                   =20
   Port 2: 0000.0100 power                                   =20
   Port 3: 0000.0100 power                                   =20
   Port 4: 0000.0100 power                                   =20
   Port 5: 0000.0100 power                                   =20
   Port 6: 0000.0100 power                                   =20
Device Status:     0x0003                                    =20
  Self Powered                                               =20
  Remote Wakeup Enabled                                      =20

Bus 001 Device 003: ID 046d:c518 Logitech, Inc. MX610 Laser Cordless Mouse
Device Descriptor:                                                       =20
  bLength                18                                              =20
  bDescriptorType         1                                              =20
  bcdUSB               2.00                                              =20
  bDeviceClass            0 (Defined at Interface level)                 =20
  bDeviceSubClass         0                                              =20
  bDeviceProtocol         0                                              =20
  bMaxPacketSize0         8                                              =20
  idVendor           0x046d Logitech, Inc.                               =20
  idProduct          0xc518 MX610 Laser Cordless Mouse                   =20
  bcdDevice           42.03                                              =20
  iManufacturer           1 Logitech                                     =20
  iProduct                2 USB Receiver                                 =20
  iSerial                 0                                              =20
  bNumConfigurations      1                                              =20
  Configuration Descriptor:                                              =20
    bLength                 9                                            =20
    bDescriptorType         2                                            =20
    wTotalLength           59                                            =20
    bNumInterfaces          2                                            =20
    bConfigurationValue     1                                            =20
    iConfiguration          4 RR42.03_B0039                              =20
    bmAttributes         0xa0                                            =20
      (Bus Powered)                                                      =20
      Remote Wakeup                                                      =20
    MaxPower               98mA                                          =20
    Interface Descriptor:                                                =20
      bLength                 9                                          =20
      bDescriptorType         4                                          =20
      bInterfaceNumber        0                                          =20
      bAlternateSetting       0                                          =20
      bNumEndpoints           1                                          =20
      bInterfaceClass         3 Human Interface Device                   =20
      bInterfaceSubClass      1 Boot Interface Subclass                  =20
      bInterfaceProtocol      2 Mouse                                    =20
      iInterface              0                                          =20
      ** UNRECOGNIZED:  09 21 11 01 00 01 22 43 00                       =20
      Endpoint Descriptor:                                               =20
        bLength                 7                                        =20
        bDescriptorType         5                                        =20
        bEndpointAddress     0x81  EP 1 IN                               =20
        bmAttributes            3                                        =20
          Transfer Type            Interrupt                             =20
          Synch Type               None                                  =20
          Usage Type               Data                                  =20
        wMaxPacketSize     0x0008  1x 8 bytes                            =20
        bInterval              10                                        =20
    Interface Descriptor:                                                =20
      bLength                 9                                          =20
      bDescriptorType         4                                          =20
      bInterfaceNumber        1                                          =20
      bAlternateSetting       0                                          =20
      bNumEndpoints           1                                          =20
      bInterfaceClass         3 Human Interface Device                   =20
      bInterfaceSubClass      0 No Subclass                              =20
      bInterfaceProtocol      0 None                                     =20
      iInterface              0                                          =20
      ** UNRECOGNIZED:  09 21 11 01 00 01 22 4f 00                       =20
      Endpoint Descriptor:                                               =20
        bLength                 7                                        =20
        bDescriptorType         5                                        =20
        bEndpointAddress     0x82  EP 2 IN                               =20
        bmAttributes            3                                        =20
          Transfer Type            Interrupt                             =20
          Synch Type               None                                  =20
          Usage Type               Data                                  =20
        wMaxPacketSize     0x0008  1x 8 bytes                            =20
        bInterval              10                                        =20
Device Status:     0x0000                                                =20
  (Bus Powered)                                                          =20

Bus 001 Device 002: ID 05e3:0608 Genesys Logic, Inc. USB-2.0 4-Port HUB
Device Descriptor:                                                    =20
  bLength                18                                           =20
  bDescriptorType         1                                           =20
  bcdUSB               2.00                                           =20
  bDeviceClass            9 Hub                                       =20
  bDeviceSubClass         0 Unused                                    =20
  bDeviceProtocol         1 Single TT                                 =20
  bMaxPacketSize0        64                                           =20
  idVendor           0x05e3 Genesys Logic, Inc.                       =20
  idProduct          0x0608 USB-2.0 4-Port HUB                        =20
  bcdDevice            7.02                                           =20
  iManufacturer           0                                           =20
  iProduct                1 USB2.0 Hub                                =20
  iSerial                 0                                           =20
  bNumConfigurations      1                                           =20
  Configuration Descriptor:                                           =20
    bLength                 9                                         =20
    bDescriptorType         2                                         =20
    wTotalLength           25                                         =20
    bNumInterfaces          1                                         =20
    bConfigurationValue     1                                         =20
    iConfiguration          0                                         =20
    bmAttributes         0xe0                                         =20
      Self Powered                                                    =20
      Remote Wakeup                                                   =20
    MaxPower              100mA                                       =20
    Interface Descriptor:                                             =20
      bLength                 9                                       =20
      bDescriptorType         4                                       =20
      bInterfaceNumber        0                                       =20
      bAlternateSetting       0                                       =20
      bNumEndpoints           1                                       =20
      bInterfaceClass         9 Hub                                   =20
      bInterfaceSubClass      0 Unused                                =20
      bInterfaceProtocol      0 Full speed (or root) hub              =20
      iInterface              0                                       =20
      Endpoint Descriptor:                                            =20
        bLength                 7                                     =20
        bDescriptorType         5                                     =20
        bEndpointAddress     0x81  EP 1 IN                            =20
        bmAttributes            3                                     =20
          Transfer Type            Interrupt                          =20
          Synch Type               None                               =20
          Usage Type               Data                               =20
        wMaxPacketSize     0x0001  1x 1 bytes                         =20
        bInterval              12                                     =20
Hub Descriptor:                                                       =20
  bLength               9                                             =20
  bDescriptorType      41                                             =20
  nNbrPorts             4                                             =20
  wHubCharacteristic 0x00e9                                           =20
    Per-port power switching                                          =20
    Per-port overcurrent protection                                   =20
    TT think time 32 FS bits                                          =20
    Port indicators                                                   =20
  bPwrOn2PwrGood       50 * 2 milli seconds                           =20
  bHubContrCurrent    100 milli Ampere                                =20
  DeviceRemovable    0x00                                             =20
  PortPwrCtrlMask    0xff                                             =20
 Hub Port Status:                                                     =20
   Port 1: 0000.0100 power                                            =20
   Port 2: 0000.0303 lowspeed power enable connect                    =20
   Port 3: 0000.0100 power                                            =20
   Port 4: 0000.0100 power                                            =20
Device Qualifier (for other device speed):                            =20
  bLength                10                                           =20
  bDescriptorType         6                                           =20
  bcdUSB               2.00                                           =20
  bDeviceClass            9 Hub                                       =20
  bDeviceSubClass         0 Unused                                    =20
  bDeviceProtocol         0 Full speed (or root) hub                  =20
  bMaxPacketSize0        64                                           =20
  bNumConfigurations      1                                           =20
Device Status:     0x0003                                             =20
  Self Powered                                                        =20
  Remote Wakeup Enabled                                               =20

Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Device Descriptor:                                           =20
  bLength                18                                  =20
  bDescriptorType         1                                  =20
  bcdUSB               2.00                                  =20
  bDeviceClass            9 Hub                              =20
  bDeviceSubClass         0 Unused                           =20
  bDeviceProtocol         0 Full speed (or root) hub         =20
  bMaxPacketSize0        64
  idVendor           0x1d6b Linux Foundation
  idProduct          0x0002 2.0 root hub
  bcdDevice            2.06
  iManufacturer           3 Linux 2.6.31r4 ehci_hcd
  iProduct                2 EHCI Host Controller
  iSerial                 1 0000:00:12.2
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0004  1x 4 bytes
        bInterval              12
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             6
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood       10 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0503 highspeed power enable connect
   Port 3: 0000.0100 power
   Port 4: 0000.0100 power
   Port 5: 0000.0100 power
   Port 6: 0000.0100 power
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled

config&dmesg are attached.

Gl=FCck Auf,
Volker


ps. if you think it makes a difference I can redo it without fglrx.=20

pps. please cc me, not subscribed.

--Boundary-00=_zH1qKILWhFkTdQP
Content-Type: text/plain;
  charset="ISO-8859-15";
  name="dmesg_usb.out"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg_usb.out"

[    0.000000] Linux version 2.6.31r4 (root@energy) (gcc version 4.4.1 (Gentoo 4.4.1 p1.0) ) #1 SMP Thu Sep 10 10:48:07 CEST 2009
[    0.000000] Command line: root=/dev/md1 md=3,/dev/sda3,/dev/sdb3,/dev/sdc3 nmi_watchdog=0 mtrr_spare_reg_nr=1
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000c7eb0000 (usable)
[    0.000000]  BIOS-e820: 00000000c7eb0000 - 00000000c7ec0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000c7ec0000 - 00000000c7ef0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000c7ef0000 - 00000000c7f00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000238000000 (usable)
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0x238000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000C0000000 mask FFFFF8000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000238000000 aka 9088M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000c8000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xc7eb0 max_arch_pfn = 0x400000000
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009fc00 (usable)
[    0.000000]  modified: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e6000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000c7eb0000 (usable)
[    0.000000]  modified: 00000000c7eb0000 - 00000000c7ec0000 (ACPI data)
[    0.000000]  modified: 00000000c7ec0000 - 00000000c7ef0000 (ACPI NVS)
[    0.000000]  modified: 00000000c7ef0000 - 00000000c7f00000 (reserved)
[    0.000000]  modified: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000238000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000000000000-00000000c7eb0000
[    0.000000]  0000000000 - 00c0000000 page 1G
[    0.000000]  00c0000000 - 00c7e00000 page 2M
[    0.000000]  00c7e00000 - 00c7eb0000 page 4k
[    0.000000] kernel direct mapping tables up to c7eb0000 @ 10000-13000
[    0.000000] init_memory_mapping: 0000000100000000-0000000238000000
[    0.000000]  0100000000 - 0200000000 page 1G
[    0.000000]  0200000000 - 0238000000 page 2M
[    0.000000] kernel direct mapping tables up to 238000000 @ 12000-14000
[    0.000000] ACPI: RSDP 00000000000fa7c0 00014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 00000000c7eb0000 00040 (v01 050609 RSDT2000 20090506 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000c7eb0200 00084 (v02 A M I  OEMFACP  12000601 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000c7eb0440 08512 (v01  AS140 AS140121 00000121 INTL 20051117)
[    0.000000] ACPI: FACS 00000000c7ec0000 00040
[    0.000000] ACPI: APIC 00000000c7eb0390 0006C (v01 050609 APIC2000 20090506 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000c7eb0400 0003C (v01 050609 OEMMCFG  20090506 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000c7ec0040 00071 (v01 050609 OEMB2000 20090506 MSFT 00000097)
[    0.000000] ACPI: AAFT 00000000c7eb8960 00027 (v01 050609 OEMAAFT  20090506 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000c7eb8990 00038 (v01 050609 OEMHPET  20090506 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000c7eb89d0 0088C (v01 A M I  POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 0238000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 00015fb8c0]    TEXT DATA BSS ==> [0001000000 - 00015fb8c0]
[    0.000000]   #3 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
[    0.000000]   #4 [00015fc000 - 00015fc133]              BRK ==> [00015fc000 - 00015fc133]
[    0.000000]   #5 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]
[    0.000000]   #6 [0000012000 - 0000013000]          PGTABLE ==> [0000012000 - 0000013000]
[    0.000000]  [ffffea0000000000-ffffea0007dfffff] PMD -> [ffff880028600000-ffff88002f7fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00238000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000c7eb0
[    0.000000]     0: 0x00100000 -> 0x00238000
[    0.000000] On node 0 totalpages: 2096703
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 102 pages reserved
[    0.000000]   DMA zone: 3825 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 800488 pages, LIFO batch:31
[    0.000000]   Normal zone: 17472 pages used for memmap
[    0.000000]   Normal zone: 1260480 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e6000
[    0.000000] PM: Registered nosave memory: 00000000000e6000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000c7eb0000 - 00000000c7ec0000
[    0.000000] PM: Registered nosave memory: 00000000c7ec0000 - 00000000c7ef0000
[    0.000000] PM: Registered nosave memory: 00000000c7ef0000 - 00000000c7f00000
[    0.000000] PM: Registered nosave memory: 00000000c7f00000 - 00000000fff00000
[    0.000000] PM: Registered nosave memory: 00000000fff00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c7f00000 (gap: c7f00000:38000000)
[    0.000000] NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages at ffff880028034000, static data 72160 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2064793
[    0.000000] Kernel command line: root=/dev/md1 md=3,/dev/sda3,/dev/sdb3,/dev/sdc3 nmi_watchdog=0 mtrr_spare_reg_nr=1
[    0.000000] md: Will configure md3 (super-block) from /dev/sda3,/dev/sdb3,/dev/sdc3, below.
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.000000] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ 2a42000000 size 32 MB
[    0.000000] Aperture beyond 4GB. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ 20000000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000024000000
[    0.000000] Memory: 8184476k/9306112k available (3500k kernel code, 919300k absent, 201380k reserved, 1751k data, 376k init)
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:440
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 3200.024 MHz processor.
[    0.000611] Console: colour VGA+ 80x25
[    0.000614] console [tty0] enabled
[    0.003333] hpet clockevent registered
[    0.003333]   alloc irq_desc for 24 on node 0
[    0.003333]   alloc kstat_irqs on node 0
[    0.003333] HPET: 4 timers in total, 1 timers will be used for per-cpu timer
[    0.003333] Calibrating delay loop (skipped), value calculated using timer frequency.. 6402.70 BogoMIPS (lpj=10666733)
[    0.003333] Mount-cache hash table entries: 256
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.003333] CPU: L2 Cache: 512K (64 bytes/line)
[    0.003333] tseg: 0000000000
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 0
[    0.003333] mce: CPU supports 6 MCE banks
[    0.003333] using C1E aware idle routine
[    0.003333] ACPI: Core revision 20090521
[    0.013374] Setting APIC routing to flat
[    0.013697] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.047508] CPU0: AMD Phenom(tm) II X4 955 Processor stepping 02
[    0.049999] Booting processor 1 APIC 0x1 ip 0x6000
[    0.003333] Initializing CPU#1
[    0.003333] Calibrating delay using timer specific routine.. 6402.85 BogoMIPS (lpj=10666968)
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.003333] CPU: L2 Cache: 512K (64 bytes/line)
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 1
[    0.003333] mce: CPU supports 6 MCE banks
[    0.003333] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.140825] CPU1: AMD Phenom(tm) II X4 955 Processor stepping 02
[    0.141173] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.143366] Booting processor 2 APIC 0x2 ip 0x6000
[    0.003333] Initializing CPU#2
[    0.003333] Calibrating delay using timer specific routine.. 6402.85 BogoMIPS (lpj=10666967)
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.003333] CPU: L2 Cache: 512K (64 bytes/line)
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 2
[    0.003333] mce: CPU supports 6 MCE banks
[    0.003333] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
[    0.237579] CPU2: AMD Phenom(tm) II X4 955 Processor stepping 02
[    0.237926] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.240033] Booting processor 3 APIC 0x3 ip 0x6000
[    0.003333] Initializing CPU#3
[    0.003333] Calibrating delay using timer specific routine.. 6402.86 BogoMIPS (lpj=10666977)
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.003333] CPU: L2 Cache: 512K (64 bytes/line)
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 3
[    0.003333] mce: CPU supports 6 MCE banks
[    0.003333] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
[    0.334238] CPU3: AMD Phenom(tm) II X4 955 Processor stepping 02
[    0.334585] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.336673] Brought up 4 CPUs
[    0.336707] Total of 4 processors activated (25610.27 BogoMIPS).
[    0.336775] CPU0 attaching sched-domain:
[    0.336777]  domain 0: span 0-3 level MC
[    0.336778]   groups: 0 1 2 3
[    0.336782] CPU1 attaching sched-domain:
[    0.336783]  domain 0: span 0-3 level MC
[    0.336784]   groups: 1 2 3 0
[    0.336787] CPU2 attaching sched-domain:
[    0.336788]  domain 0: span 0-3 level MC
[    0.336789]   groups: 2 3 0 1
[    0.336791] CPU3 attaching sched-domain:
[    0.336792]  domain 0: span 0-3 level MC
[    0.336793]   groups: 3 0 1 2
[    0.336825] xor: automatically using best checksumming function: generic_sse
[    0.353333]    generic_sse: 12835.200 MB/sec
[    0.353367] xor: using function: generic_sse (12835.200 MB/sec)
[    0.353421] Time:  8:55:41  Date: 09/12/09
[    0.353469] NET: Registered protocol family 16
[    0.353517] node 0 link 0: io port [1000, ffffff]
[    0.353517] TOM: 00000000c8000000 aka 3200M
[    0.353517] Fam 10h mmconf [e0000000, efffffff]
[    0.353517] node 0 link 0: mmio [e0000000, efffffff] ==> none
[    0.353517] node 0 link 0: mmio [f0000000, ffffffff]
[    0.353517] node 0 link 0: mmio [a0000, bffff]
[    0.353517] node 0 link 0: mmio [c8000000, dfffffff]
[    0.353517] TOM2: 0000000238000000 aka 9088M
[    0.353517] bus: [00,07] on node 0 link 0
[    0.353517] bus: 00 index 0 io port: [0, ffff]
[    0.353517] bus: 00 index 1 mmio: [f0000000, ffffffff]
[    0.353517] bus: 00 index 2 mmio: [a0000, bffff]
[    0.353517] bus: 00 index 3 mmio: [c8000000, dfffffff]
[    0.353517] bus: 00 index 4 mmio: [238000000, fcffffffff]
[    0.353517] ACPI: bus type pci registered
[    0.353517] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.353517] PCI: Not using MMCONFIG.
[    0.353517] PCI: Using configuration type 1 for base access
[    0.353517] PCI: Using configuration type 1 for extended access
[    0.353517] bio: create slab <bio-0> at 0
[    0.356669] ACPI: EC: Look up EC in DSDT
[    0.364027] ACPI: Interpreter enabled
[    0.364550] ACPI: (supports S0 S1 S3 S4 S5)
[    0.364667] ACPI: Using IOAPIC for interrupt routing
[    0.364739] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.367533] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.372769] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.377208] ACPI: No dock devices found.
[    0.377208] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.377208] pci 0000:00:00.0: reg 1c 64bit mmio: [0xe0000000-0xffffffff]
[    0.377208] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.377208] pci 0000:00:02.0: PME# disabled
[    0.377208] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    0.377208] pci 0000:00:09.0: PME# disabled
[    0.377208] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    0.377208] pci 0000:00:0a.0: PME# disabled
[    0.377208] pci 0000:00:11.0: reg 10 io port: [0xa000-0xa007]
[    0.377208] pci 0000:00:11.0: reg 14 io port: [0x9000-0x9003]
[    0.377208] pci 0000:00:11.0: reg 18 io port: [0x8000-0x8007]
[    0.377208] pci 0000:00:11.0: reg 1c io port: [0x7000-0x7003]
[    0.377208] pci 0000:00:11.0: reg 20 io port: [0x6000-0x600f]
[    0.377208] pci 0000:00:11.0: reg 24 32bit mmio: [0xfddff800-0xfddffbff]
[    0.377208] pci 0000:00:12.0: reg 10 32bit mmio: [0xfddfe000-0xfddfefff]
[    0.377208] pci 0000:00:12.1: reg 10 32bit mmio: [0xfddfd000-0xfddfdfff]
[    0.377241] pci 0000:00:12.2: reg 10 32bit mmio: [0xfddff000-0xfddff0ff]
[    0.377290] pci 0000:00:12.2: supports D1 D2
[    0.377292] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.377328] pci 0000:00:12.2: PME# disabled
[    0.377389] pci 0000:00:13.0: reg 10 32bit mmio: [0xfddfc000-0xfddfcfff]
[    0.377440] pci 0000:00:13.1: reg 10 32bit mmio: [0xfddf7000-0xfddf7fff]
[    0.377508] pci 0000:00:13.2: reg 10 32bit mmio: [0xfddf6800-0xfddf68ff]
[    0.377557] pci 0000:00:13.2: supports D1 D2
[    0.377558] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.377595] pci 0000:00:13.2: PME# disabled
[    0.377737] pci 0000:00:14.1: reg 10 io port: [0x00-0x07]
[    0.377742] pci 0000:00:14.1: reg 14 io port: [0x00-0x03]
[    0.377748] pci 0000:00:14.1: reg 18 io port: [0x00-0x07]
[    0.377754] pci 0000:00:14.1: reg 1c io port: [0x00-0x03]
[    0.377759] pci 0000:00:14.1: reg 20 io port: [0xff00-0xff0f]
[    0.377883] pci 0000:00:14.5: reg 10 32bit mmio: [0xfddf5000-0xfddf5fff]
[    0.380051] pci 0000:02:00.0: reg 10 64bit mmio: [0xd0000000-0xdfffffff]
[    0.380059] pci 0000:02:00.0: reg 18 64bit mmio: [0xfdff0000-0xfdffffff]
[    0.380063] pci 0000:02:00.0: reg 20 io port: [0xc000-0xc0ff]
[    0.380070] pci 0000:02:00.0: reg 30 32bit mmio: [0xfdfc0000-0xfdfdffff]
[    0.380086] pci 0000:02:00.0: supports D1 D2
[    0.380114] pci 0000:02:00.1: reg 10 64bit mmio: [0xfdfec000-0xfdfeffff]
[    0.380144] pci 0000:02:00.1: supports D1 D2
[    0.380194] pci 0000:00:02.0: bridge io port: [0xc000-0xcfff]
[    0.380196] pci 0000:00:02.0: bridge 32bit mmio: [0xfdf00000-0xfdffffff]
[    0.380199] pci 0000:00:02.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
[    0.380242] pci 0000:00:09.0: bridge io port: [0xd000-0xdfff]
[    0.380244] pci 0000:00:09.0: bridge 32bit mmio: [0xfe000000-0xfebfffff]
[    0.380247] pci 0000:00:09.0: bridge 64bit mmio pref: [0xfa000000-0xfcefffff]
[    0.380277] pci 0000:01:00.0: reg 10 io port: [0xb800-0xb8ff]
[    0.380291] pci 0000:01:00.0: reg 18 64bit mmio: [0xcffff000-0xcfffffff]
[    0.380300] pci 0000:01:00.0: reg 20 64bit mmio: [0xcffe0000-0xcffeffff]
[    0.380306] pci 0000:01:00.0: reg 30 32bit mmio: [0xfdef0000-0xfdefffff]
[    0.380333] pci 0000:01:00.0: supports D1 D2
[    0.380334] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.380371] pci 0000:01:00.0: PME# disabled
[    0.380456] pci 0000:00:0a.0: bridge io port: [0xb000-0xbfff]
[    0.380459] pci 0000:00:0a.0: bridge 32bit mmio: [0xfde00000-0xfdefffff]
[    0.380461] pci 0000:00:0a.0: bridge 64bit mmio pref: [0xcff00000-0xcfffffff]
[    0.380496] pci 0000:05:06.0: reg 10 32bit mmio: [0xfcfff000-0xfcffffff]
[    0.380576] pci 0000:05:08.0: reg 10 io port: [0xe800-0xe83f]
[    0.380633] pci 0000:05:08.0: supports D1 D2
[    0.380675] pci 0000:00:14.4: transparent bridge
[    0.380711] pci 0000:00:14.4: bridge io port: [0xe000-0xefff]
[    0.380717] pci 0000:00:14.4: bridge 32bit mmio pref: [0xfcf00000-0xfcffffff]
[    0.380729] pci_bus 0000:00: on NUMA node 0
[    0.380732] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.380866] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE2._PRT]
[    0.380911] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEA._PRT]
[    0.380955] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
[    0.381020] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE9._PRT]
[    0.383431] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 *7 10 11 12 14 15)
[    0.383619] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 10 *11 12 14 15)
[    0.383847] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 *10 11 12 14 15)
[    0.384073] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 *10 11 12 14 15)
[    0.384300] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.384571] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 *11 12 14 15)
[    0.384797] ACPI: PCI Interrupt Link [LNKG] (IRQs *4 10 11 12 14 15)
[    0.385010] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 *10 11 12 14 15)
[    0.385196] SCSI subsystem initialized
[    0.385196] libata version 3.00 loaded.
[    0.385196] usbcore: registered new interface driver usbfs
[    0.385196] usbcore: registered new interface driver hub
[    0.385196] usbcore: registered new device driver usb
[    0.440015] raid6: int64x1   2753 MB/s
[    0.496674] raid6: int64x2   3854 MB/s
[    0.553348] raid6: int64x4   2851 MB/s
[    0.610005] raid6: int64x8   2530 MB/s
[    0.666677] raid6: sse2x1    4192 MB/s
[    0.723339] raid6: sse2x2    7033 MB/s
[    0.780000] raid6: sse2x4    8009 MB/s
[    0.780034] raid6: using algorithm sse2x4 (8009 MB/s)
[    0.780080] PCI: Using ACPI for IRQ routing
[    0.780080] pci 0000:00:00.0: BAR 3: address space collision on of device [0xe0000000-0xffffffff]
[    0.780092] pci 0000:00:00.0: BAR 3: can't allocate resource
[    0.790099] PCI-DMA: Disabling AGP.
[    0.790184] PCI-DMA: aperture base @ 20000000 size 65536 KB
[    0.790184] PCI-DMA: using GART IOMMU.
[    0.790184] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.791862] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 24, 0
[    0.791969] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    0.796699] hpet: hpet2 irq 24 for MSI
[    0.803349] Switched to high resolution mode on CPU 0
[    0.804515] Switched to high resolution mode on CPU 1
[    0.804601] Switched to high resolution mode on CPU 3
[    0.804605] Switched to high resolution mode on CPU 2
[    0.816701] pnp: PnP ACPI init
[    0.816752] ACPI: bus type pnp registered
[    0.819022] pnp 00:0b: mem resource (0x0-0x9ffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.819077] pnp 00:0b: mem resource (0xc0000-0xcffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.819131] pnp 00:0b: mem resource (0xe0000-0xfffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.819186] pnp 00:0b: mem resource (0x100000-0xc7efffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.819509] pnp: PnP ACPI: found 12 devices
[    0.819543] ACPI: ACPI bus type pnp unregistered
[    0.819583] system 00:06: iomem range 0xfec00000-0xfec00fff could not be reserved
[    0.819636] system 00:06: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.819674] system 00:07: ioport range 0x4d0-0x4d1 has been reserved
[    0.819709] system 00:07: ioport range 0x40b-0x40b has been reserved
[    0.819744] system 00:07: ioport range 0x4d6-0x4d6 has been reserved
[    0.819779] system 00:07: ioport range 0xc00-0xc01 has been reserved
[    0.819814] system 00:07: ioport range 0xc14-0xc14 has been reserved
[    0.819849] system 00:07: ioport range 0xc50-0xc51 has been reserved
[    0.819883] system 00:07: ioport range 0xc52-0xc52 has been reserved
[    0.819918] system 00:07: ioport range 0xc6c-0xc6c has been reserved
[    0.819953] system 00:07: ioport range 0xc6f-0xc6f has been reserved
[    0.819988] system 00:07: ioport range 0xcd0-0xcd1 has been reserved
[    0.820033] system 00:07: ioport range 0xcd2-0xcd3 has been reserved
[    0.820068] system 00:07: ioport range 0xcd4-0xcd5 has been reserved
[    0.820103] system 00:07: ioport range 0xcd6-0xcd7 has been reserved
[    0.820138] system 00:07: ioport range 0xcd8-0xcdf has been reserved
[    0.820173] system 00:07: ioport range 0x800-0x89f has been reserved
[    0.820207] system 00:07: ioport range 0xb00-0xb0f has been reserved
[    0.820242] system 00:07: ioport range 0xb20-0xb3f has been reserved
[    0.820277] system 00:07: ioport range 0x900-0x90f has been reserved
[    0.820312] system 00:07: ioport range 0x910-0x91f has been reserved
[    0.820347] system 00:07: ioport range 0xfe00-0xfefe has been reserved
[    0.820382] system 00:07: iomem range 0xffb80000-0xffbfffff has been reserved
[    0.820418] system 00:07: iomem range 0xfec10000-0xfec1001f has been reserved
[    0.820455] system 00:09: ioport range 0x290-0x29f has been reserved
[    0.820491] system 00:0a: iomem range 0xe0000000-0xefffffff has been reserved
[    0.820527] system 00:0b: iomem range 0xfec00000-0xffffffff could not be reserved
[    0.825428] pci 0000:00:02.0: PCI bridge, secondary bus 0000:02
[    0.825463] pci 0000:00:02.0:   IO window: 0xc000-0xcfff
[    0.825499] pci 0000:00:02.0:   MEM window: 0xfdf00000-0xfdffffff
[    0.825534] pci 0000:00:02.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
[    0.825589] pci 0000:00:09.0: PCI bridge, secondary bus 0000:03
[    0.825624] pci 0000:00:09.0:   IO window: 0xd000-0xdfff
[    0.825659] pci 0000:00:09.0:   MEM window: 0xfe000000-0xfebfffff
[    0.825695] pci 0000:00:09.0:   PREFETCH window: 0x000000fa000000-0x000000fcefffff
[    0.825749] pci 0000:00:0a.0: PCI bridge, secondary bus 0000:01
[    0.825784] pci 0000:00:0a.0:   IO window: 0xb000-0xbfff
[    0.825819] pci 0000:00:0a.0:   MEM window: 0xfde00000-0xfdefffff
[    0.825855] pci 0000:00:0a.0:   PREFETCH window: 0x000000cff00000-0x000000cfffffff
[    0.825910] pci 0000:00:14.4: PCI bridge, secondary bus 0000:05
[    0.825945] pci 0000:00:14.4:   IO window: 0xe000-0xefff
[    0.825982] pci 0000:00:14.4:   MEM window: disabled
[    0.826018] pci 0000:00:14.4:   PREFETCH window: 0xfcf00000-0xfcffffff
[    0.826059]   alloc irq_desc for 18 on node -1
[    0.826061]   alloc kstat_irqs on node -1
[    0.826064] pci 0000:00:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.826101] pci 0000:00:02.0: setting latency timer to 64
[    0.826104]   alloc irq_desc for 17 on node -1
[    0.826106]   alloc kstat_irqs on node -1
[    0.826108] pci 0000:00:09.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.826143] pci 0000:00:09.0: setting latency timer to 64
[    0.826146] pci 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.826182] pci 0000:00:0a.0: setting latency timer to 64
[    0.826188] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.826190] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.826192] pci_bus 0000:02: resource 0 io:  [0xc000-0xcfff]
[    0.826193] pci_bus 0000:02: resource 1 mem: [0xfdf00000-0xfdffffff]
[    0.826194] pci_bus 0000:02: resource 2 pref mem [0xd0000000-0xdfffffff]
[    0.826196] pci_bus 0000:03: resource 0 io:  [0xd000-0xdfff]
[    0.826197] pci_bus 0000:03: resource 1 mem: [0xfe000000-0xfebfffff]
[    0.826199] pci_bus 0000:03: resource 2 pref mem [0xfa000000-0xfcefffff]
[    0.826200] pci_bus 0000:01: resource 0 io:  [0xb000-0xbfff]
[    0.826201] pci_bus 0000:01: resource 1 mem: [0xfde00000-0xfdefffff]
[    0.826203] pci_bus 0000:01: resource 2 pref mem [0xcff00000-0xcfffffff]
[    0.826204] pci_bus 0000:05: resource 0 io:  [0xe000-0xefff]
[    0.826205] pci_bus 0000:05: resource 2 pref mem [0xfcf00000-0xfcffffff]
[    0.826207] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
[    0.826208] pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.826219] NET: Registered protocol family 2
[    0.826275] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.826759] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.827731] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.828134] TCP: Hash tables configured (established 262144 bind 65536)
[    0.828169] TCP reno registered
[    0.828247] NET: Registered protocol family 1
[    0.829470] Scanning for low memory corruption every 60 seconds
[    0.830211] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.830335] Loading Reiser4. See www.namesys.com for a description of Reiser4.
[    0.830421] msgmni has been set to 15987
[    0.830725] alg: No test for stdrng (krng)
[    0.830767] async_tx: api initialized (sync-only)
[    0.830840] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.830894] io scheduler noop registered
[    0.830928] io scheduler cfq registered (default)
[    0.831060] pci 0000:02:00.0: Boot video device
[    0.831165]   alloc irq_desc for 25 on node -1
[    0.831166]   alloc kstat_irqs on node -1
[    0.831172] pcieport-driver 0000:00:02.0: irq 25 for MSI/MSI-X
[    0.831176] pcieport-driver 0000:00:02.0: setting latency timer to 64
[    0.831269]   alloc irq_desc for 26 on node -1
[    0.831270]   alloc kstat_irqs on node -1
[    0.831273] pcieport-driver 0000:00:09.0: irq 26 for MSI/MSI-X
[    0.831276] pcieport-driver 0000:00:09.0: setting latency timer to 64
[    0.831368]   alloc irq_desc for 27 on node -1
[    0.831369]   alloc kstat_irqs on node -1
[    0.831372] pcieport-driver 0000:00:0a.0: irq 27 for MSI/MSI-X
[    0.831375] pcieport-driver 0000:00:0a.0: setting latency timer to 64
[    0.831584] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.831637] ACPI: Power Button [PWRF]
[    0.831729] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    0.831782] ACPI: Power Button [PWRB]
[    0.831934] processor LNXCPU:00: registered as cooling_device0
[    0.831969] ACPI: Processor [CPU0] (supports 8 throttling states)
[    0.832067] processor LNXCPU:01: registered as cooling_device1
[    0.832138] processor LNXCPU:02: registered as cooling_device2
[    0.832210] processor LNXCPU:03: registered as cooling_device3
[    0.835952] Linux agpgart interface v0.103
[    0.836148] ahci 0000:00:11.0: version 3.0
[    0.836158]   alloc irq_desc for 22 on node -1
[    0.836159]   alloc kstat_irqs on node -1
[    0.836163] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    0.836311] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    0.836366] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part 
[    0.836913] scsi0 : ahci
[    0.837041] scsi1 : ahci
[    0.837143] scsi2 : ahci
[    0.837240] scsi3 : ahci
[    0.837339] scsi4 : ahci
[    0.837437] scsi5 : ahci
[    0.837618] ata1: SATA max UDMA/133 
[    0.837653] ata2: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddff980 irq 22
[    0.837707] ata3: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffa00 irq 22
[    0.837761] ata4: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffa80 irq 22
[    0.837815] ata5: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffb00 irq 22
[    0.837869] ata6: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffb80 irq 22
[    0.838115] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    0.838149] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    0.838594] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.838700] mice: PS/2 mouse device common for all mice
[    0.838858] rtc_cmos 00:02: RTC can wake from S4
[    0.838925] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    0.838981] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.839039] md: raid1 personality registered for level 1
[    0.839074] md: raid6 personality registered for level 6
[    0.839108] md: raid5 personality registered for level 5
[    0.839142] md: raid4 personality registered for level 4
[    0.839727] cpuidle: using governor ladder
[    0.839761] cpuidle: using governor menu
[    0.840235] usbcore: registered new interface driver hiddev
[    0.840289] usbcore: registered new interface driver usbhid
[    0.840324] usbhid: v2.6:USB HID core driver
[    0.840384] Advanced Linux Sound Architecture Driver Version 1.0.20.
[    0.840421] ALSA device list:
[    0.840454]   No soundcards found.
[    0.840522] TCP cubic registered
[    0.840561] NET: Registered protocol family 10
[    0.840689] IPv6 over IPv4 tunneling driver
[    0.840821] NET: Registered protocol family 17
[    0.840873] powernow-k8: Found 1 AMD Phenom(tm) II X4 955 Processor processors (4 cpu cores) (version 2.20.00)
[    0.840949] powernow-k8:    0 : pstate 0 (3200 MHz)
[    0.840983] powernow-k8:    1 : pstate 1 (2500 MHz)
[    0.841016] powernow-k8:    2 : pstate 2 (2100 MHz)
[    0.841050] powernow-k8:    3 : pstate 3 (800 MHz)
[    0.841445] PM: Resume from disk failed.
[    0.841526]   Magic number: 9:656:927
[    0.865824] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    1.156715] ata5: SATA link down (SStatus 0 SControl 300)
[    1.156718] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.156810] ata6: SATA link down (SStatus 0 SControl 300)
[    1.156868] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.156923] ata3: SATA link down (SStatus 0 SControl 300)
[    1.163042] ata2.00: ATA-7: SAMSUNG HD502IJ, 1AA01110, max UDMA7
[    1.163080] ata2.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.163203] ata4.00: ATA-7: SAMSUNG HD753LJ, 1AA01113, max UDMA7
[    1.163238] ata4.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.169502] ata2.00: configured for UDMA/133
[    1.169641] ata4.00: configured for UDMA/133
[    1.556704] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.563060] ata1.00: ATA-7: SAMSUNG HD502IJ, 1AA01109, max UDMA7
[    1.563097] ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.569517] ata1.00: configured for UDMA/133
[    1.580090] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD502IJ  1AA0 PQ: 0 ANSI: 5
[    1.580349] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    1.580370] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.580442] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD502IJ  1AA0 PQ: 0 ANSI: 5
[    1.580546] sd 0:0:0:0: [sda] Write Protect is off
[    1.580579] sd 1:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    1.580600] sd 1:0:0:0: [sdb] Write Protect is off
[    1.580601] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.580611] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.580664]  sdb:
[    1.580721] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    1.580811] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.580822] scsi 3:0:0:0: Direct-Access     ATA      SAMSUNG HD753LJ  1AA0 PQ: 0 ANSI: 5
[    1.580824] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.580885]  sda:
[    1.581074] sd 3:0:0:0: [sdc] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
[    1.581136] sd 3:0:0:0: Attached scsi generic sg2 type 0
[    1.581231] sd 3:0:0:0: [sdc] Write Protect is off
[    1.581265] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    1.581275] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.581371]  sdc: sdc1 sdc2 sdc3 sdc4 < sdb1 sdb2 sdb3 sdb4 < sda1 sda2 sda3 sda4 < sdc5 sda5 sdb5 sdc6 sda6 >
[    1.608504] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.610987]  sdb6 >
[    1.611333] sd 1:0:0:0: [sdb] Attached SCSI disk
[    1.614555]  sdc7 >
[    1.614941] sd 3:0:0:0: [sdc] Attached SCSI disk
[    1.614982] md: Waiting for all devices to be available before autodetect
[    1.615017] md: If you don't use raid, use raid=noautodetect
[    1.615133] md: Autodetecting RAID arrays.
[    1.704735] md: Scanned 12 and added 12 devices.
[    1.704770] md: autorun ...
[    1.704804] md: considering sdc6 ...
[    1.704840] md:  adding sdc6 ...
[    1.704874] md: sdc5 has different UUID to sdc6
[    1.704909] md: sdc3 has different UUID to sdc6
[    1.704944] md: sdc1 has different UUID to sdc6
[    1.704980] md:  adding sdb6 ...
[    1.705014] md: sdb5 has different UUID to sdc6
[    1.705049] md: sdb3 has different UUID to sdc6
[    1.705084] md: sdb1 has different UUID to sdc6
[    1.705119] md:  adding sda6 ...
[    1.705153] md: sda5 has different UUID to sdc6
[    1.705188] md: sda3 has different UUID to sdc6
[    1.705223] md: sda1 has different UUID to sdc6
[    1.705370] md: created md3
[    1.705404] md: bind<sda6>
[    1.705441] md: bind<sdb6>
[    1.705477] md: bind<sdc6>
[    1.705513] md: running: <sdc6><sdb6><sda6>
[    1.705658] raid5: device sdc6 operational as raid disk 2
[    1.705693] raid5: device sdb6 operational as raid disk 1
[    1.705727] raid5: device sda6 operational as raid disk 0
[    1.705882] raid5: allocated 3220kB for md3
[    1.705930] raid5: raid level 5 set md3 active with 3 out of 3 devices, algorithm 2
[    1.705983] RAID5 conf printout:
[    1.706017]  --- rd:3 wd:3
[    1.706050]  disk 0, o:1, dev:sda6
[    1.706083]  disk 1, o:1, dev:sdb6
[    1.706116]  disk 2, o:1, dev:sdc6
[    1.706164] md3: detected capacity change from 0 to 864065421312
[    1.706223] md: considering sdc5 ...
[    1.706258] md:  adding sdc5 ...
[    1.706293] md: sdc3 has different UUID to sdc5
[    1.706327] md: sdc1 has different UUID to sdc5
[    1.706363] md:  adding sdb5 ...
[    1.706397] md: sdb3 has different UUID to sdc5
[    1.706432] md: sdb1 has different UUID to sdc5
[    1.706468] md:  adding sda5 ...
[    1.706502] md: sda3 has different UUID to sdc5
[    1.706537] md: sda1 has different UUID to sdc5
[    1.706638] md: created md2
[    1.706673] md: bind<sda5>
[    1.706709] md: bind<sdb5>
[    1.706745] md: bind<sdc5>
[    1.706781] md: running: <sdc5><sdb5><sda5>
[    1.706919] raid5: device sdc5 operational as raid disk 2
[    1.706953] raid5: device sdb5 operational as raid disk 1
[    1.706987] raid5: device sda5 operational as raid disk 0
[    1.707142] raid5: allocated 3220kB for md2
[    1.707189] raid5: raid level 5 set md2 active with 3 out of 3 devices, algorithm 2
[    1.707242] RAID5 conf printout:
[    1.707275]  --- rd:3 wd:3
[    1.707308]  disk 0, o:1, dev:sda5
[    1.707342]  disk 1, o:1, dev:sdb5
[    1.707375]  disk 2, o:1, dev:sdc5
[    1.707420] md2: detected capacity change from 0 to 40007499776
[    1.707477] md: considering sdc3 ...
[    1.707513] md:  adding sdc3 ...
[    1.707547] md: sdc1 has different UUID to sdc3
[    1.707583] md:  adding sdb3 ...
[    1.707617] md: sdb1 has different UUID to sdc3
[    1.707652] md:  adding sda3 ...
[    1.707687] md: sda1 has different UUID to sdc3
[    1.707788] md: created md1
[    1.707821] md: bind<sda3>
[    1.707857] md: bind<sdb3>
[    1.707893] md: bind<sdc3>
[    1.707933] md: running: <sdc3><sdb3><sda3>
[    1.708072] raid5: device sdc3 operational as raid disk 2
[    1.708106] raid5: device sdb3 operational as raid disk 1
[    1.708140] raid5: device sda3 operational as raid disk 0
[    1.708299] raid5: allocated 3220kB for md1
[    1.708346] raid5: raid level 5 set md1 active with 3 out of 3 devices, algorithm 2
[    1.708399] RAID5 conf printout:
[    1.708432]  --- rd:3 wd:3
[    1.708465]  disk 0, o:1, dev:sda3
[    1.708498]  disk 1, o:1, dev:sdb3
[    1.708532]  disk 2, o:1, dev:sdc3
[    1.708580] md1: detected capacity change from 0 to 79998877696
[    1.708637] md: considering sdc1 ...
[    1.708673] md:  adding sdc1 ...
[    1.708708] md:  adding sdb1 ...
[    1.708743] md:  adding sda1 ...
[    1.708777] md: created md0
[    1.708810] md: bind<sda1>
[    1.708846] md: bind<sdb1>
[    1.708882] md: bind<sdc1>
[    1.708917] md: running: <sdc1><sdb1><sda1>
[    1.709088] raid1: raid set md0 active with 3 out of 3 mirrors
[    1.709132] md0: detected capacity change from 0 to 65667072
[    1.709188] md: ... autorun DONE.
[    1.709240] md: Loading md3: /dev/sda3
[    1.709278]  md3: unknown partition table
[    1.709438] md: couldn't update array info. -22
[    1.709475] md: could not bd_claim sda3.
[    1.709509] md: md_import_device returned -16
[    1.709545] md: could not bd_claim sdb3.
[    1.709578] md: md_import_device returned -16
[    1.709614] md: could not bd_claim sdc3.
[    1.709648] md: md_import_device returned -16
[    1.709682] md: starting md3 failed
[    1.709759]  md1: unknown partition table
[    1.746818] reiser4: md1: found disk format 4.0.0.
[    5.787143] VFS: Mounted root (reiser4 filesystem) readonly on device 9:1.
[    5.787680] Freeing unused kernel memory: 376k freed
[    9.076258] udev: starting version 145
[    9.375067]  md0:
[    9.375230]  md2: unknown partition table
[    9.379191]  unknown partition table
[   10.417189] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[   10.417205] r8169 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   10.417448] r8169 0000:01:00.0: setting latency timer to 64
[   10.417479]   alloc irq_desc for 28 on node -1
[   10.417481]   alloc kstat_irqs on node -1
[   10.417491] r8169 0000:01:00.0: irq 28 for MSI/MSI-X
[   10.417595] eth0: RTL8168c/8111c at 0xffffc90012f06000, 00:19:66:86:ce:12, XID 3c4000c0 IRQ 28
[   10.456192] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   10.456195] ehci_hcd: block sizes: qh 192 qtd 96 itd 192 sitd 96
[   10.456221] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   10.456261] ehci_hcd 0000:00:12.2: EHCI Host Controller
[   10.456275] drivers/usb/core/inode.c: creating file 'devices'
[   10.456277] drivers/usb/core/inode.c: creating file '001'
[   10.456311] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[   10.456317] ehci_hcd 0000:00:12.2: reset hcs_params 0x102306 dbg=1 cc=2 pcc=3 ordered !ppc ports=6
[   10.456320] ehci_hcd 0000:00:12.2: reset hcc_params a072 thresh 7 uframes 256/512/1024
[   10.456344] ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze workaround
[   10.456350] ehci_hcd 0000:00:12.2: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[   10.456362] ehci_hcd 0000:00:12.2: debug port 1
[   10.456367] ehci_hcd 0000:00:12.2: MWI active
[   10.456368] ehci_hcd 0000:00:12.2: supports USB remote wakeup
[   10.456382] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfddff000
[   10.456385] ehci_hcd 0000:00:12.2: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[   10.456390] ehci_hcd 0000:00:12.2: init command 010009 (park)=0 ithresh=1 period=256 RUN
[   10.464600] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[   10.464640] usb usb1: default language 0x0409
[   10.464644] usb usb1: udev 1, busnum 1, minor = 0
[   10.464645] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   10.464646] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   10.464648] usb usb1: Product: EHCI Host Controller
[   10.464649] usb usb1: Manufacturer: Linux 2.6.31r4 ehci_hcd
[   10.464650] usb usb1: SerialNumber: 0000:00:12.2
[   10.464683] usb usb1: uevent
[   10.464692] usb usb1: usb_probe_device
[   10.464693] usb usb1: configuration #1 chosen from 1 choice
[   10.464699] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[   10.464706] usb 1-0:1.0: uevent
[   10.464713] hub 1-0:1.0: usb_probe_interface
[   10.464714] hub 1-0:1.0: usb_probe_interface - got id
[   10.464716] hub 1-0:1.0: USB hub found
[   10.464721] hub 1-0:1.0: 6 ports detected
[   10.464722] hub 1-0:1.0: standalone hub
[   10.464723] hub 1-0:1.0: no power switching (usb 1.0)
[   10.464724] hub 1-0:1.0: individual port over-current protection
[   10.464725] hub 1-0:1.0: power on to power good time: 20ms
[   10.464728] hub 1-0:1.0: local power source is good
[   10.464729] hub 1-0:1.0: trying to enable port power on non-switchable hub
[   10.464754] drivers/usb/core/inode.c: creating file '001'
[   10.464775]   alloc irq_desc for 19 on node -1
[   10.464777]   alloc kstat_irqs on node -1
[   10.464781] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   10.464815] ehci_hcd 0000:00:13.2: EHCI Host Controller
[   10.464819] drivers/usb/core/inode.c: creating file '002'
[   10.464837] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[   10.464843] ehci_hcd 0000:00:13.2: reset hcs_params 0x102306 dbg=1 cc=2 pcc=3 ordered !ppc ports=6
[   10.464846] ehci_hcd 0000:00:13.2: reset hcc_params a072 thresh 7 uframes 256/512/1024
[   10.464860] ehci_hcd 0000:00:13.2: applying AMD SB600/SB700 USB freeze workaround
[   10.464866] ehci_hcd 0000:00:13.2: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[   10.464878] ehci_hcd 0000:00:13.2: debug port 1
[   10.464881] ehci_hcd 0000:00:13.2: MWI active
[   10.464882] ehci_hcd 0000:00:13.2: supports USB remote wakeup
[   10.464893] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfddf6800
[   10.464896] ehci_hcd 0000:00:13.2: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[   10.464901] ehci_hcd 0000:00:13.2: init command 010009 (park)=0 ithresh=1 period=256 RUN
[   10.474597] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[   10.474611] usb usb2: default language 0x0409
[   10.474615] usb usb2: udev 1, busnum 2, minor = 128
[   10.474616] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[   10.474618] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   10.474619] usb usb2: Product: EHCI Host Controller
[   10.474620] usb usb2: Manufacturer: Linux 2.6.31r4 ehci_hcd
[   10.474621] usb usb2: SerialNumber: 0000:00:13.2
[   10.474645] usb usb2: uevent
[   10.474652] usb usb2: usb_probe_device
[   10.474653] usb usb2: configuration #1 chosen from 1 choice
[   10.474657] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[   10.474664] usb 2-0:1.0: uevent
[   10.474670] hub 2-0:1.0: usb_probe_interface
[   10.474671] hub 2-0:1.0: usb_probe_interface - got id
[   10.474672] hub 2-0:1.0: USB hub found
[   10.474676] hub 2-0:1.0: 6 ports detected
[   10.474677] hub 2-0:1.0: standalone hub
[   10.474678] hub 2-0:1.0: no power switching (usb 1.0)
[   10.474679] hub 2-0:1.0: individual port over-current protection
[   10.474680] hub 2-0:1.0: power on to power good time: 20ms
[   10.474682] hub 2-0:1.0: local power source is good
[   10.474683] hub 2-0:1.0: trying to enable port power on non-switchable hub
[   10.474707] drivers/usb/core/inode.c: creating file '001'
[   10.501150] Linux video capture interface: v2.00
[   10.510499] bttv: driver version 0.9.18 loaded
[   10.510501] bttv: using 8 buffers with 2080k (520 pages) each for capture
[   10.510541] bttv: Bt8xx card found (0).
[   10.510557]   alloc irq_desc for 21 on node -1
[   10.510557]   alloc kstat_irqs on node -1
[   10.510557] bttv 0000:05:06.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[   10.510565] bttv0: Bt848 (rev 18) at 0000:05:06.0, irq: 21, latency: 128, mmio: 0xfcfff000
[   10.510604] bttv0: using: Terratec TerraTV+ Version 1.0 (Bt848)/ Terra TValue Version 1.0/ Vobis TV-Boostar [card=25,insmod option]
[   10.510606] IRQ 21/bttv0: IRQF_DISABLED is not guaranteed on shared IRQs
[   10.510639] bttv0: gpio: en=00000000, out=00000000 in=00ffffff [init]
[   10.564596] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
[   10.564598] hub 1-0:1.0: port 2: status 0501 change 0001
[   10.574607] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
[   10.664597] hub 1-0:1.0: state 7 ports 6 chg 0004 evt 0000
[   10.664606] hub 1-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
[   10.720448] ehci_hcd 0000:00:12.2: port 2 high speed
[   10.720452] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[   10.773769] usb 1-2: new high speed USB device using ehci_hcd and address 2
[   10.825391] ehci_hcd 0000:00:12.2: port 2 high speed
[   10.825394] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[   10.901623] usb 1-2: default language 0x0409
[   10.901873] usb 1-2: udev 2, busnum 1, minor = 1
[   10.901874] usb 1-2: New USB device found, idVendor=05e3, idProduct=0608
[   10.901875] usb 1-2: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[   10.901877] usb 1-2: Product: USB2.0 Hub
[   10.901913] usb 1-2: uevent
[   10.901921] usb 1-2: usb_probe_device
[   10.901923] usb 1-2: configuration #1 chosen from 1 choice
[   10.902322] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
[   10.902333] usb 1-2:1.0: uevent
[   10.902341] hub 1-2:1.0: usb_probe_interface
[   10.902342] hub 1-2:1.0: usb_probe_interface - got id
[   10.902343] hub 1-2:1.0: USB hub found
[   10.902622] hub 1-2:1.0: 4 ports detected
[   10.902623] hub 1-2:1.0: standalone hub
[   10.902624] hub 1-2:1.0: individual port power switching
[   10.902625] hub 1-2:1.0: individual port over-current protection
[   10.902626] hub 1-2:1.0: Single TT
[   10.902628] hub 1-2:1.0: TT requires at most 32 FS bit times (2664 ns)
[   10.902629] hub 1-2:1.0: Port indicators are supported
[   10.902630] hub 1-2:1.0: power on to power good time: 100ms
[   10.902997] hub 1-2:1.0: local power source is good
[   10.902999] hub 1-2:1.0: enabling power on all ports
[   10.904011] drivers/usb/core/inode.c: creating file '002'
[   11.006491] hub 1-2:1.0: port 2: status 0301 change 0001
[   11.109710] usb 1-2: link qh256-0001/ffff8800c7800180 start 1 [1/0 us]
[   11.109718] hub 1-2:1.0: state 7 ports 4 chg 0004 evt 0000
[   11.109985] hub 1-2:1.0: port 2, status 0301, change 0000, 1.5 Mb/s
[   11.176980] usb 1-2.2: new low speed USB device using ehci_hcd and address 3
[   11.274107] usb 1-2.2: skipped 1 descriptor after interface
[   11.274109] usb 1-2.2: skipped 1 descriptor after interface
[   11.274730] usb 1-2.2: default language 0x0409
[   11.276856] usb 1-2.2: udev 3, busnum 1, minor = 2
[   11.276858] usb 1-2.2: New USB device found, idVendor=046d, idProduct=c518
[   11.276859] usb 1-2.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   11.276860] usb 1-2.2: Product: USB Receiver
[   11.276861] usb 1-2.2: Manufacturer: Logitech
[   11.276887] usb 1-2.2: uevent
[   11.276895] usb 1-2.2: usb_probe_device
[   11.276896] usb 1-2.2: configuration #1 chosen from 1 choice
[   11.284098] usb 1-2.2: adding 1-2.2:1.0 (config #1, interface 0)
[   11.284111] usb 1-2.2:1.0: uevent
[   11.284121] usbhid 1-2.2:1.0: usb_probe_interface
[   11.284122] usbhid 1-2.2:1.0: usb_probe_interface - got id
[   11.284458] usb 1-2: clear tt buffer port 2, a3 ep0 t80008d42
[   11.287480] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.2/1-2.2:1.0/input/input3
[   11.287518] generic-usb 0003:046D:C518.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:12.2-2.2/input0
[   11.287526] usb 1-2.2: adding 1-2.2:1.1 (config #1, interface 1)
[   11.287535] usb 1-2.2:1.1: uevent
[   11.287542] usbhid 1-2.2:1.1: usb_probe_interface
[   11.287543] usbhid 1-2.2:1.1: usb_probe_interface - got id
[   11.287832] usb 1-2: clear tt buffer port 2, a3 ep0 t80008d42
[   11.293155] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.2/1-2.2:1.1/input/input4
[   11.293164] usb 1-2.2: link qh8-0601/ffff8800c7800300 start 2 [1/2 us]
[   11.293182] drivers/usb/core/file.c: looking for a minor, starting at 96
[   11.293211] generic-usb 0003:046D:C518.0002: input,hiddev96,hidraw1: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:12.2-2.2/input1
[   11.293220] drivers/usb/core/inode.c: creating file '003'
[   11.293230] hub 1-2:1.0: state 7 ports 4 chg 0000 evt 0004
[   11.319000] usb 1-2.2:1.0: uevent
[   11.319056] usb 1-2.2: uevent
[   11.319081] usb 1-2.2:1.0: uevent
[   11.319139] usb 1-2.2: uevent
[   11.319648] usb 1-2.2:1.1: uevent
[   11.319688] usb 1-2.2:1.0: uevent
[   11.319701] usb 1-2.2: uevent
[   11.320464] usb 1-2.2:1.1: uevent
[   11.320773] usb 1-2.2:1.0: uevent
[   11.514605] bttv0: tea5757: read timeout
[   11.514607] bttv0: tuner type=5
[   11.536604] bttv0: audio absent, no audio device found!
[   11.554096] TUNER: Unable to find symbol tea5767_autodetection()
[   11.554099] tuner 0-0060: chip found @ 0xc0 (bt848 #0 [sw])
[   11.556835] tuner-simple 0-0060: creating new instance
[   11.556837] tuner-simple 0-0060: type set to 5 (Philips PAL_BG (FI1216 and compatibles))
[   11.557638] bttv0: registered device video0
[   11.557670] bttv0: registered device vbi0
[   11.854232] reiser4: md2: found disk format 4.0.0.
[   13.337101] hub 2-0:1.0: hub_suspend
[   13.337107] usb usb2: bus auto-suspend
[   13.337109] ehci_hcd 0000:00:13.2: suspend root hub
[   13.661545] reiser4: md3: found disk format 4.0.0.
[   54.912542] reiser4: sdc7: found disk format 4.0.0.
[   67.247206] Adding 7815612k swap on /dev/sda2.  Priority:1 extents:1 across:7815612k 
[   67.253566] Adding 7815612k swap on /dev/sdb2.  Priority:1 extents:1 across:7815612k 
[   67.326107] Adding 7815612k swap on /dev/sdc2.  Priority:1 extents:1 across:7815612k 
[   67.990047] w83627ehf: Found W83627EHG chip at 0x290
[   68.248378] r8169: eth0: link up
[   68.248383] r8169: eth0: link up
[   70.012605] usb usb1: uevent
[   70.012647] usb 1-0:1.0: uevent
[   70.012684] usb 1-2: uevent
[   70.012725] usb 1-2.2: uevent
[   70.012765] usb 1-2.2:1.0: uevent
[   70.013037] usb 1-2.2:1.1: uevent
[   70.013289] usb 1-2:1.0: uevent
[   70.013440] usb usb2: uevent
[   70.013479] usb 2-0:1.0: uevent
[   71.034214]   alloc irq_desc for 23 on node -1
[   71.034218]   alloc kstat_irqs on node -1
[   71.034224] EMU10K1_Audigy 0000:05:08.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   71.040204] Audigy2 value: Special config.
[   72.316188] fglrx: module license 'Proprietary. (C) 2002 - ATI Technologies, Starnberg, GERMANY' taints kernel.
[   72.316197] Disabling lock debugging due to kernel taint
[   72.337649] [fglrx] Maximum main memory to use for locked dma buffers: 7760 MBytes.
[   72.337725] [fglrx]   vendor: 1002 device: 9501 count: 1
[   72.337921] [fglrx] ioport: bar 4, base 0xc000, size: 0x100
[   72.337933] pci 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   72.337939] pci 0000:02:00.0: setting latency timer to 64
[   72.338071] [fglrx] Kernel PAT support is enabled
[   72.338086] [fglrx] module loaded - fglrx 8.66.2 [Sep  1 2009] with 1 minors
[   72.501859]   alloc irq_desc for 29 on node -1
[   72.501861]   alloc kstat_irqs on node -1
[   72.501869] fglrx_pci 0000:02:00.0: irq 29 for MSI/MSI-X
[   72.502208] [fglrx] Firegl kernel thread PID: 3826
[   74.623068] [fglrx] Gart USWC size:1279 M.
[   74.623071] [fglrx] Gart cacheable size:508 M.
[   74.623076] [fglrx] Reserved FB block: Shared offset:0, size:1000000 
[   74.623078] [fglrx] Reserved FB block: Unshared offset:fbff000, size:401000 
[   74.623081] [fglrx] Reserved FB block: Unshared offset:1fffc000, size:4000 
[   75.794214] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  278.630401] reiser4[kmail(4033)]: disable_write_barrier (fs/reiser4/wander.c:235)[zam-1055]:
[  278.630405] NOTICE: md3 does not support write barriers, using synchronous write instead.
[  616.824975] reiser4[ktxnmgrd:md1:ru(581)]: disable_write_barrier (fs/reiser4/wander.c:235)[zam-1055]:
[  616.824979] NOTICE: md1 does not support write barriers, using synchronous write instead.
[  671.609119] reiser4[qmgr(3681)]: disable_write_barrier (fs/reiser4/wander.c:235)[zam-1055]:
[  671.609121] NOTICE: md2 does not support write barriers, using synchronous write instead.
[  879.193292] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.193308] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  879.193316] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.193325] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.193774] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  879.193780] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.253291] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.253306] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  879.253312] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.253319] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.253770] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  879.253776] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.267040] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.267055] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  879.267063] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.267071] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.267666] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  879.267675] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.280372] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.280386] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  879.280392] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.280400] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.281539] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  879.281548] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.341202] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.341216] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  879.341222] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.341229] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.341788] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  879.341797] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.401202] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.401216] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  879.401222] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.401230] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.402035] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  879.402043] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.461202] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.461216] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  879.461222] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.461229] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.461778] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  879.461786] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.521203] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.521217] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  879.521223] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.521230] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.522027] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  879.522035] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.581204] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.581218] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  879.581224] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.581232] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.581765] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  879.581773] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.641198] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.641212] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  879.641218] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.641226] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.642018] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  879.642027] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.701202] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.701216] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  879.701222] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.701230] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.701762] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  879.701770] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.761201] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.761215] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  879.761221] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.761229] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.762010] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  879.762018] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.821206] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.821220] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  879.821226] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.821234] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.821763] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  879.821771] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.881203] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.881217] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  879.881223] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.881230] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.882001] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  879.882010] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.941205] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.941219] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  879.941225] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.941233] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  879.941721] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  879.941727] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.000665] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.000679] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  880.000686] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.000694] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.001243] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  880.001251] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.061201] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.061215] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  880.061221] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.061228] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.061712] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  880.061718] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.121200] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.121213] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  880.121219] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.121226] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.121982] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  880.121990] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.181204] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.181217] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  880.181223] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.181231] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.181704] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  880.181710] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.241202] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.241216] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  880.241222] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.241229] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.241973] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  880.241982] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.301205] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.301218] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  880.301224] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.301232] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.301696] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  880.301702] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.361202] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.361216] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  880.361222] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.361229] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.361965] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  880.361973] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.421204] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.421218] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  880.421224] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.421231] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.421687] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  880.421693] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.481202] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.481216] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  880.481222] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.481229] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.481957] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  880.481965] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.541204] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.541218] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  880.541224] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.541231] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.541827] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  880.541835] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.600584] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.600597] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  880.600603] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.600611] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.601210] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  880.601218] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.661204] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.661218] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  880.661224] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.661231] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.661670] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  880.661676] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.721202] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.721215] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  880.721221] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.721229] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.721940] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  880.721948] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.781204] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.781217] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  880.781223] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.781231] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.781662] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  880.781668] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.841202] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.841215] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  880.841221] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.841229] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.841931] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  880.841939] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.901204] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.901217] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  880.901223] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.901230] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.901653] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  880.901659] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.959949] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.959963] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  880.959969] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.959977] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  880.960400] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  880.960406] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.019964] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.019979] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  881.019987] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.019995] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.021057] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  881.021066] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.080653] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.080667] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  881.080673] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.080681] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.081143] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  881.081149] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.140567] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.140581] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  881.140587] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.140594] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.141652] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  881.141661] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.200516] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.200529] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  881.200535] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.200543] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.201156] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  881.201165] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.260490] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.260504] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  881.260510] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.260517] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.261049] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  881.261057] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.319954] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.319969] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  881.319976] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.319984] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.320387] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  881.320394] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.380653] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.380666] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  881.380672] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.380680] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.381627] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  881.381633] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.440598] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.440611] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  881.440618] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.440625] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.441159] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  881.441167] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.500563] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.500577] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  881.500583] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.500590] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.501625] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  881.501634] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.560402] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.560415] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  881.560421] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.560428] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.561132] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  881.561140] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.619961] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.619974] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  881.619980] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.619988] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  881.620877] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  881.620885] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  904.364873] ehci_hcd 0000:00:13.2: remove, state 4
[  904.364879] ehci_hcd 0000:00:13.2: roothub graceful disconnect
[  904.364893] usb usb2: USB disconnect, address 1
[  904.364897] usb usb2: unregistering device
[  904.364902] usb usb2: usb_disable_device nuking all URBs
[  904.364909] usb usb2: unregistering interface 2-0:1.0
[  904.365005] usb 2-0:1.0: uevent
[  904.365502] usb usb2: uevent
[  904.366029] ehci_hcd 0000:00:13.2: stop
[  904.366047] ehci_hcd 0000:00:13.2: reset command 01000a (park)=0 ithresh=1 period=256 Reset HALT
[  904.366080] ehci_hcd 0000:00:13.2: irq normal 0 err 0 reclaim 0 (lost 0)
[  904.366085] ehci_hcd 0000:00:13.2: complete 0 unlink 0
[  904.366096] ehci_hcd 0000:00:13.2: ehci_stop completed status 1000 Halt
[  904.366110] ehci_hcd 0000:00:13.2: USB bus 2 deregistered
[  904.366587] ehci_hcd 0000:00:13.2: PCI INT B disabled
[  904.366606] ehci_hcd 0000:00:12.2: remove, state 1
[  904.366610] ehci_hcd 0000:00:12.2: roothub graceful disconnect
[  904.366622] usb usb1: USB disconnect, address 1
[  904.366626] usb 1-2: USB disconnect, address 2
[  904.366631] usb 1-2.2: USB disconnect, address 3
[  904.366635] usb 1-2.2: unregistering device
[  904.366640] usb 1-2.2: usb_disable_device nuking all URBs
[  904.366654] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  904.366667] ehci_hcd 0000:00:12.2: shutdown urb ffff8802338e53c0 ep1in-intr
[  904.366676] usb 1-2.2: unlink qh8-0601/ffff8800c7800300 start 2 [1/2 us]
[  904.366686] ehci_hcd 0000:00:12.2: shutdown urb ffff88023401a900 ep2in-intr
[  904.366693] usb 1-2.2: unregistering interface 1-2.2:1.0
[  904.412374] usb 1-2.2:1.0: uevent
[  904.412565] usb 1-2.2: unregistering interface 1-2.2:1.1
[  904.451610] drivers/usb/core/file.c: removing 96 minor
[  904.452943] usb 1-2.2:1.1: uevent
[  904.453302] usb 1-2.2: uevent
[  904.453725] usb 1-2: unregistering device
[  904.453730] usb 1-2: usb_disable_device nuking all URBs
[  904.453743] usb 1-2: unlink qh256-0001/ffff8800c7800180 start 1 [1/0 us]
[  904.453810] ehci_hcd 0000:00:12.2: shutdown urb ffff8802344f93c0 ep1in-intr
[  904.453817] usb 1-2: unregistering interface 1-2:1.0
[  904.453903] usb 1-2:1.0: uevent
[  904.454230] usb 1-2: uevent
[  904.455278] usb usb1: unregistering device
[  904.455285] usb usb1: usb_disable_device nuking all URBs
[  904.455295] ehci_hcd 0000:00:12.2: shutdown urb ffff8802338e5c00 ep1in-intr
[  904.455301] usb usb1: unregistering interface 1-0:1.0
[  904.455390] usb 1-0:1.0: uevent
[  904.455739] usb usb1: uevent
[  904.456154] ehci_hcd 0000:00:12.2: stop
[  904.456250] ehci_hcd 0000:00:12.2: reset command 01000a (park)=0 ithresh=1 period=256 Reset HALT
[  904.456280] ehci_hcd 0000:00:12.2: irq normal 9915 err 2 reclaim 58 (lost 0)
[  904.456285] ehci_hcd 0000:00:12.2: complete 9960 unlink 3
[  904.456293] ehci_hcd 0000:00:12.2: ehci_stop completed status 1000 Halt
[  904.456305] ehci_hcd 0000:00:12.2: USB bus 1 deregistered
[  904.456765] ehci_hcd 0000:00:12.2: PCI INT B disabled
[  908.805516] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[  908.805524] ehci_hcd: block sizes: qh 192 qtd 96 itd 192 sitd 96
[  908.805581] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[  908.805709] ehci_hcd 0000:00:12.2: EHCI Host Controller
[  908.805772] drivers/usb/core/inode.c: creating file 'devices'
[  908.805781] drivers/usb/core/inode.c: creating file '001'
[  908.805925] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[  908.805943] ehci_hcd 0000:00:12.2: reset hcs_params 0x102306 dbg=1 cc=2 pcc=3 ordered !ppc ports=6
[  908.805952] ehci_hcd 0000:00:12.2: reset hcc_params a072 thresh 7 uframes 256/512/1024
[  908.806002] ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze workaround
[  908.806018] ehci_hcd 0000:00:12.2: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[  908.806039] ehci_hcd 0000:00:12.2: debug port 1
[  908.806046] ehci_hcd 0000:00:12.2: MWI active
[  908.806051] ehci_hcd 0000:00:12.2: supports USB remote wakeup
[  908.806070] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfddff000
[  908.806080] ehci_hcd 0000:00:12.2: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[  908.806092] ehci_hcd 0000:00:12.2: init command 010009 (park)=0 ithresh=1 period=256 RUN
[  908.816649] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[  908.816702] usb usb1: default language 0x0409
[  908.816717] usb usb1: udev 1, busnum 1, minor = 0
[  908.816722] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[  908.816727] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[  908.816732] usb usb1: Product: EHCI Host Controller
[  908.816736] usb usb1: Manufacturer: Linux 2.6.31r4 ehci_hcd
[  908.816740] usb usb1: SerialNumber: 0000:00:12.2
[  908.816833] usb usb1: uevent
[  908.816960] usb usb1: usb_probe_device
[  908.816966] usb usb1: configuration #1 chosen from 1 choice
[  908.816981] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[  908.817013] usb 1-0:1.0: uevent
[  908.817101] hub 1-0:1.0: usb_probe_interface
[  908.817106] hub 1-0:1.0: usb_probe_interface - got id
[  908.817111] hub 1-0:1.0: USB hub found
[  908.817125] hub 1-0:1.0: 6 ports detected
[  908.817129] hub 1-0:1.0: standalone hub
[  908.817132] hub 1-0:1.0: no power switching (usb 1.0)
[  908.817137] hub 1-0:1.0: individual port over-current protection
[  908.817142] hub 1-0:1.0: power on to power good time: 20ms
[  908.817151] hub 1-0:1.0: local power source is good
[  908.817156] hub 1-0:1.0: trying to enable port power on non-switchable hub
[  908.817213] drivers/usb/core/inode.c: creating file '001'
[  908.817274] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[  908.817309] ehci_hcd 0000:00:13.2: EHCI Host Controller
[  908.817322] drivers/usb/core/inode.c: creating file '002'
[  908.817455] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[  908.817470] ehci_hcd 0000:00:13.2: reset hcs_params 0x102306 dbg=1 cc=2 pcc=3 ordered !ppc ports=6
[  908.817479] ehci_hcd 0000:00:13.2: reset hcc_params a072 thresh 7 uframes 256/512/1024
[  908.817512] ehci_hcd 0000:00:13.2: applying AMD SB600/SB700 USB freeze workaround
[  908.817527] ehci_hcd 0000:00:13.2: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[  908.817549] ehci_hcd 0000:00:13.2: debug port 1
[  908.817557] ehci_hcd 0000:00:13.2: MWI active
[  908.817561] ehci_hcd 0000:00:13.2: supports USB remote wakeup
[  908.817579] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfddf6800
[  908.817589] ehci_hcd 0000:00:13.2: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[  908.817601] ehci_hcd 0000:00:13.2: init command 010009 (park)=0 ithresh=1 period=256 RUN
[  908.826625] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[  908.826673] usb usb2: default language 0x0409
[  908.826687] usb usb2: udev 1, busnum 2, minor = 128
[  908.826692] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[  908.826697] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[  908.826701] usb usb2: Product: EHCI Host Controller
[  908.826706] usb usb2: Manufacturer: Linux 2.6.31r4 ehci_hcd
[  908.826709] usb usb2: SerialNumber: 0000:00:13.2
[  908.826799] usb usb2: uevent
[  908.828979] usb usb2: usb_probe_device
[  908.828988] usb usb2: configuration #1 chosen from 1 choice
[  908.829006] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[  908.829053] usb 2-0:1.0: uevent
[  908.829142] hub 2-0:1.0: usb_probe_interface
[  908.829147] hub 2-0:1.0: usb_probe_interface - got id
[  908.829151] hub 2-0:1.0: USB hub found
[  908.829166] hub 2-0:1.0: 6 ports detected
[  908.829170] hub 2-0:1.0: standalone hub
[  908.829173] hub 2-0:1.0: no power switching (usb 1.0)
[  908.829177] hub 2-0:1.0: individual port over-current protection
[  908.829182] hub 2-0:1.0: power on to power good time: 20ms
[  908.829191] hub 2-0:1.0: local power source is good
[  908.829196] hub 2-0:1.0: trying to enable port power on non-switchable hub
[  908.829251] drivers/usb/core/inode.c: creating file '001'
[  908.916634] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
[  908.916644] hub 1-0:1.0: port 2: status 0501 change 0001
[  908.926660] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
[  909.016640] hub 1-0:1.0: state 7 ports 6 chg 0004 evt 0000
[  909.016661] hub 1-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
[  909.069977] ehci_hcd 0000:00:12.2: port 2 high speed
[  909.069988] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[  909.123299] usb 1-2: new high speed USB device using ehci_hcd and address 2
[  909.176673] ehci_hcd 0000:00:12.2: port 2 high speed
[  909.176684] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[  909.249582] usb 1-2: default language 0x0409
[  909.249957] usb 1-2: udev 2, busnum 1, minor = 1
[  909.249962] usb 1-2: New USB device found, idVendor=05e3, idProduct=0608
[  909.249968] usb 1-2: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[  909.249973] usb 1-2: Product: USB2.0 Hub
[  909.250080] usb 1-2: uevent
[  909.250110] usb 1-2: usb_probe_device
[  909.250116] usb 1-2: configuration #1 chosen from 1 choice
[  909.251706] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
[  909.251747] usb 1-2:1.0: uevent
[  909.251775] hub 1-2:1.0: usb_probe_interface
[  909.251779] hub 1-2:1.0: usb_probe_interface - got id
[  909.251784] hub 1-2:1.0: USB hub found
[  909.252463] hub 1-2:1.0: 4 ports detected
[  909.252468] hub 1-2:1.0: standalone hub
[  909.252472] hub 1-2:1.0: individual port power switching
[  909.252477] hub 1-2:1.0: individual port over-current protection
[  909.252481] hub 1-2:1.0: Single TT
[  909.252486] hub 1-2:1.0: TT requires at most 32 FS bit times (2664 ns)
[  909.252491] hub 1-2:1.0: Port indicators are supported
[  909.252495] hub 1-2:1.0: power on to power good time: 100ms
[  909.252954] hub 1-2:1.0: local power source is good
[  909.252959] hub 1-2:1.0: enabling power on all ports
[  909.254111] drivers/usb/core/inode.c: creating file '002'
[  909.353828] hub 1-2:1.0: port 2: status 0301 change 0001
[  909.453299] usb 1-2: link qh256-0001/ffff8800c75b1180 start 1 [1/0 us]
[  909.453316] hub 1-2:1.0: state 7 ports 4 chg 0004 evt 0000
[  909.453576] hub 1-2:1.0: port 2, status 0301, change 0000, 1.5 Mb/s
[  909.520613] usb 1-2.2: new low speed USB device using ehci_hcd and address 3
[  909.607465] usb 1-2.2: skipped 1 descriptor after interface
[  909.607473] usb 1-2.2: skipped 1 descriptor after interface
[  909.608039] usb 1-2.2: default language 0x0409
[  909.610333] usb 1-2.2: udev 3, busnum 1, minor = 2
[  909.610340] usb 1-2.2: New USB device found, idVendor=046d, idProduct=c518
[  909.610346] usb 1-2.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[  909.610351] usb 1-2.2: Product: USB Receiver
[  909.610354] usb 1-2.2: Manufacturer: Logitech
[  909.610459] usb 1-2.2: uevent
[  909.610486] usb 1-2.2: usb_probe_device
[  909.610491] usb 1-2.2: configuration #1 chosen from 1 choice
[  909.617848] usb 1-2.2: adding 1-2.2:1.0 (config #1, interface 0)
[  909.617896] usb 1-2.2:1.0: uevent
[  909.617928] usbhid 1-2.2:1.0: usb_probe_interface
[  909.617932] usbhid 1-2.2:1.0: usb_probe_interface - got id
[  909.618302] usb 1-2: clear tt buffer port 2, a3 ep0 t80008d42
[  909.621813] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.2/1-2.2:1.0/input/input5
[  909.621949] generic-usb 0003:046D:C518.0003: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:12.2-2.2/input0
[  909.621982] usb 1-2.2: adding 1-2.2:1.1 (config #1, interface 1)
[  909.622012] usb 1-2.2:1.1: uevent
[  909.622037] usbhid 1-2.2:1.1: usb_probe_interface
[  909.622041] usbhid 1-2.2:1.1: usb_probe_interface - got id
[  909.622423] usb 1-2: clear tt buffer port 2, a3 ep0 t80008d42
[  909.630021] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.2/1-2.2:1.1/input/input6
[  909.630044] usb 1-2.2: link qh8-0601/ffff8800c75b1300 start 2 [1/2 us]
[  909.630101] drivers/usb/core/file.c: looking for a minor, starting at 96
[  909.630206] generic-usb 0003:046D:C518.0004: input,hiddev96,hidraw1: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:12.2-2.2/input1
[  909.630241] drivers/usb/core/inode.c: creating file '003'
[  909.630287] hub 1-2:1.0: state 7 ports 4 chg 0000 evt 0004
[  909.635759] usb 1-2.2:1.1: uevent
[  909.635924] usb 1-2.2: uevent
[  909.638266] usb 1-2.2:1.1: uevent
[  909.642198] usb 1-2.2:1.0: uevent
[  909.642253] usb 1-2.2: uevent
[  909.642728] usb 1-2.2:1.0: uevent
[  909.642776] usb 1-2.2: uevent
[  909.642970] usb 1-2.2:1.0: uevent
[  909.643666] usb 1-2.2:1.0: uevent
[  909.667020] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[  911.327450] hub 2-0:1.0: hub_suspend
[  911.327465] usb usb2: bus auto-suspend
[  911.327470] ehci_hcd 0000:00:13.2: suspend root hub
[ 1545.934453] usb 1-2.2: unlink qh8-0601/ffff8800c75b1300 start 2 [1/2 us]
[ 1545.934460] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b1300 schedule
[ 1545.934462] usb 1-2.2: link qh8-0601/ffff8800c75b1300 start 2 [1/2 us]
[ 1545.934465] usb 1-2.2: unlink qh8-0601/ffff8800c75b1300 start 2 [1/2 us]
[ 1545.934820] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b1300 schedule
[ 1545.934821] usb 1-2.2: link qh8-0601/ffff8800c75b1300 start 2 [1/2 us]
[ 1572.946564] usb 1-2.2: unlink qh8-0601/ffff8800c75b1300 start 2 [1/2 us]
[ 1572.946580] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b1300 schedule
[ 1572.946587] usb 1-2.2: link qh8-0601/ffff8800c75b1300 start 2 [1/2 us]
[ 1572.946596] usb 1-2.2: unlink qh8-0601/ffff8800c75b1300 start 2 [1/2 us]
[ 1572.947232] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b1300 schedule
[ 1572.947242] usb 1-2.2: link qh8-0601/ffff8800c75b1300 start 2 [1/2 us]
[ 1990.376930] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1990.376946] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1990.376953] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1990.376962] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1990.377450] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1990.377456] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1990.836933] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1990.836949] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1990.836955] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1990.836963] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1990.837563] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1990.837573] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1992.396516] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1992.396532] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1992.396539] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1992.396547] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1992.397208] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1992.397214] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1992.406515] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1992.406531] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1992.406538] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1992.406547] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1992.407429] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1992.407439] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1992.567756] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1992.567769] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1992.567775] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1992.567782] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1992.568278] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1992.568283] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1992.626514] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1992.626527] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1992.626533] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1992.626540] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1992.627023] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1992.627029] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1992.686512] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1992.686525] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1992.686530] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1992.686537] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1992.687293] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1992.687301] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1992.746513] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1992.746525] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1992.746531] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1992.746538] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1992.747015] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1992.747020] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1992.806511] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1992.806524] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1992.806530] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1992.806537] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1992.807284] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1992.807292] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1992.866514] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1992.866526] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1992.866532] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1992.866539] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1992.867006] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1992.867011] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1994.526517] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1994.526531] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1994.526537] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1994.526544] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1994.527163] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1994.527171] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1994.586510] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1994.586523] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1994.586529] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1994.586536] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1994.587661] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1994.587669] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1994.597761] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1994.597773] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1994.597779] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1994.597786] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1994.598259] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1994.598265] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1994.756518] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1994.756530] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1994.756536] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1994.756543] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1994.757149] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1994.757157] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1994.766510] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1994.766522] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1994.766528] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1994.766535] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1994.767247] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1994.767254] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1994.826513] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1994.826525] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1994.826531] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1994.826538] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1994.827643] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1994.827652] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1994.886512] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1994.886524] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1994.886530] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1994.886537] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1994.887137] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1994.887145] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1994.946512] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1994.946525] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1994.946531] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1994.946538] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1994.947635] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1994.947643] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1994.957761] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1994.957773] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1994.957779] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1994.957786] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1994.958233] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1994.958239] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.016510] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.016523] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1995.016529] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.016537] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.017380] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1995.017389] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.076511] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.076524] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1995.076530] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.076537] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.077127] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1995.077136] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.086510] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.086522] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1995.086528] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.086535] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.087225] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1995.087231] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.146512] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.146525] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1995.146531] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.146538] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.147621] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1995.147630] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.157761] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.157773] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1995.157779] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.157786] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.158219] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1995.158226] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.216510] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.216523] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1995.216528] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.216536] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.217366] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1995.217375] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.276512] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.276525] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1995.276531] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.276538] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.277109] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1995.277118] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.286509] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.286522] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1995.286528] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.286535] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.287211] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1995.287217] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.346513] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.346526] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1995.346531] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.346539] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.347608] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1995.347616] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.357761] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.357773] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1995.357779] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.357786] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.358206] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1995.358212] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.416510] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.416523] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1995.416528] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.416536] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.417352] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1995.417360] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.476512] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.476525] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1995.476531] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.476538] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.477094] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1995.477102] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.486510] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.486522] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1995.486528] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.486535] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.487197] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1995.487203] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.546512] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.546524] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1995.546530] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.546537] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.547594] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1995.547602] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.557761] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.557773] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1995.557779] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.557786] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.558192] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1995.558197] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.616511] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.616523] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1995.616529] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.616536] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.617338] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1995.617346] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.676512] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.676525] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1995.676531] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.676538] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.677084] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1995.677092] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.686510] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.686522] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1995.686528] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.686535] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.687183] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1995.687189] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.946518] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.946530] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1995.946536] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.946543] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.947042] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1995.947047] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.957761] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.957773] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1995.957779] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.957786] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1995.958164] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1995.958170] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.016506] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.016519] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.016525] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.016532] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.017310] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.017318] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.076512] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.076525] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.076530] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.076537] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.077061] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.077069] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.086510] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.086522] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.086528] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.086535] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.087155] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.087161] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.146513] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.146526] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.146531] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.146538] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.147552] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.147560] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.157761] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.157773] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.157779] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.157786] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.158275] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.158281] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.216510] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.216523] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.216528] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.216536] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.217297] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.217305] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.276512] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.276525] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.276530] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.276538] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.277019] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.277025] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.286509] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.286522] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.286528] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.286535] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.287142] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.287148] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.346516] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.346528] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.346534] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.346541] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.347538] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.347546] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.357760] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.357773] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.357779] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.357786] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.358261] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.358267] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.416514] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.416527] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.416532] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.416540] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.417282] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.417290] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.476512] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.476525] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.476530] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.476537] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.477150] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.477158] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.536514] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.536526] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.536532] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.536539] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.537274] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.537282] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.596512] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.596525] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.596531] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.596538] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.596997] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.597003] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.606510] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.606522] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.606528] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.606535] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.607119] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.607125] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.666513] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.666525] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.666531] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.666538] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.667516] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.667524] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.677760] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.677773] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.677779] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.677786] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.678239] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.678245] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.736514] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.736526] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.736532] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.736539] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.737260] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.737268] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.796512] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.796525] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.796530] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.796537] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.797129] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.797137] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.856514] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.856526] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.856532] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.856539] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.857252] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.857260] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.916512] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.916525] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.916530] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.916537] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.917122] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.917130] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.926509] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.926522] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.926528] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.926535] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.927097] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.927103] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.986515] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.986527] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.986533] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.986540] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1996.987493] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1996.987502] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1997.046511] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1997.046524] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1997.046529] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1997.046536] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1997.046965] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1997.046971] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1997.106512] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1997.106525] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1997.106531] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1997.106538] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1997.107485] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1997.107493] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1997.166512] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1997.166525] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1997.166530] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1997.166538] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 1997.166957] ehci_hcd 0000:00:12.2: reused qh ffff8800c75b13c0 schedule
[ 1997.166964] usb 1-2.2: link qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 2002.328990] ehci_hcd 0000:00:13.2: remove, state 4
[ 2002.328996] ehci_hcd 0000:00:13.2: roothub graceful disconnect
[ 2002.329010] usb usb2: USB disconnect, address 1
[ 2002.329014] usb usb2: unregistering device
[ 2002.329019] usb usb2: usb_disable_device nuking all URBs
[ 2002.329026] usb usb2: unregistering interface 2-0:1.0
[ 2002.329116] usb 2-0:1.0: uevent
[ 2002.329429] usb usb2: uevent
[ 2002.329556] ehci_hcd 0000:00:13.2: stop
[ 2002.329574] ehci_hcd 0000:00:13.2: reset command 01000a (park)=0 ithresh=1 period=256 Reset HALT
[ 2002.329607] ehci_hcd 0000:00:13.2: irq normal 0 err 0 reclaim 0 (lost 0)
[ 2002.329612] ehci_hcd 0000:00:13.2: complete 0 unlink 0
[ 2002.329621] ehci_hcd 0000:00:13.2: ehci_stop completed status 1000 Halt
[ 2002.329634] ehci_hcd 0000:00:13.2: USB bus 2 deregistered
[ 2002.329799] ehci_hcd 0000:00:13.2: PCI INT B disabled
[ 2002.329823] ehci_hcd 0000:00:12.2: remove, state 1
[ 2002.329827] ehci_hcd 0000:00:12.2: roothub graceful disconnect
[ 2002.329838] usb usb1: USB disconnect, address 1
[ 2002.329843] usb 1-2: USB disconnect, address 2
[ 2002.329848] usb 1-2.2: USB disconnect, address 3
[ 2002.329852] usb 1-2.2: unregistering device
[ 2002.329856] usb 1-2.2: usb_disable_device nuking all URBs
[ 2002.329869] usb 1-2.2: unlink qh8-0601/ffff8800c75b13c0 start 3 [1/2 us]
[ 2002.329882] ehci_hcd 0000:00:12.2: shutdown urb ffff8801c2462480 ep1in-intr
[ 2002.329891] usb 1-2.2: unlink qh8-0601/ffff8800c75b1300 start 2 [1/2 us]
[ 2002.329900] ehci_hcd 0000:00:12.2: shutdown urb ffff8801cf8f7c00 ep2in-intr
[ 2002.329906] usb 1-2.2: unregistering interface 1-2.2:1.0
[ 2002.359001] usb 1-2.2:1.0: uevent
[ 2002.359076] usb 1-2.2: unregistering interface 1-2.2:1.1
[ 2002.388011] drivers/usb/core/file.c: removing 96 minor
[ 2002.388526] usb 1-2.2:1.1: uevent
[ 2002.388729] usb 1-2.2: uevent
[ 2002.388757] usb 1-2: unregistering device
[ 2002.388762] usb 1-2: usb_disable_device nuking all URBs
[ 2002.388774] usb 1-2: unlink qh256-0001/ffff8800c75b1180 start 1 [1/0 us]
[ 2002.388842] ehci_hcd 0000:00:12.2: shutdown urb ffff8801c6836f00 ep1in-intr
[ 2002.388848] usb 1-2: unregistering interface 1-2:1.0
[ 2002.388925] usb 1-2:1.0: uevent
[ 2002.389085] usb 1-2: uevent
[ 2002.389114] usb usb1: unregistering device
[ 2002.389118] usb usb1: usb_disable_device nuking all URBs
[ 2002.389126] ehci_hcd 0000:00:12.2: shutdown urb ffff8801fb471600 ep1in-intr
[ 2002.389132] usb usb1: unregistering interface 1-0:1.0
[ 2002.389208] usb 1-0:1.0: uevent
[ 2002.389422] usb usb1: uevent
[ 2002.389445] ehci_hcd 0000:00:12.2: stop
[ 2002.390077] ehci_hcd 0000:00:12.2: reset command 01000a (park)=0 ithresh=1 period=256 Reset HALT
[ 2002.390123] ehci_hcd 0000:00:12.2: irq normal 10771 err 2 reclaim 82 (lost 0)
[ 2002.390128] ehci_hcd 0000:00:12.2: complete 10840 unlink 3
[ 2002.390137] ehci_hcd 0000:00:12.2: ehci_stop completed status 1000 Halt
[ 2002.390148] ehci_hcd 0000:00:12.2: USB bus 1 deregistered
[ 2002.390253] ehci_hcd 0000:00:12.2: PCI INT B disabled
[ 2003.454609] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[ 2003.454617] ehci_hcd: block sizes: qh 192 qtd 96 itd 192 sitd 96
[ 2003.454670] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[ 2003.454750] ehci_hcd 0000:00:12.2: EHCI Host Controller
[ 2003.454779] drivers/usb/core/inode.c: creating file 'devices'
[ 2003.454789] drivers/usb/core/inode.c: creating file '001'
[ 2003.454871] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[ 2003.454887] ehci_hcd 0000:00:12.2: reset hcs_params 0x102306 dbg=1 cc=2 pcc=3 ordered !ppc ports=6
[ 2003.454895] ehci_hcd 0000:00:12.2: reset hcc_params a072 thresh 7 uframes 256/512/1024
[ 2003.454932] ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze workaround
[ 2003.454946] ehci_hcd 0000:00:12.2: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[ 2003.454967] ehci_hcd 0000:00:12.2: debug port 1
[ 2003.454974] ehci_hcd 0000:00:12.2: MWI active
[ 2003.454978] ehci_hcd 0000:00:12.2: supports USB remote wakeup
[ 2003.454997] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfddff000
[ 2003.455006] ehci_hcd 0000:00:12.2: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[ 2003.455017] ehci_hcd 0000:00:12.2: init command 010009 (park)=0 ithresh=1 period=256 RUN
[ 2003.464425] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[ 2003.464488] usb usb1: default language 0x0409
[ 2003.464502] usb usb1: udev 1, busnum 1, minor = 0
[ 2003.464507] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[ 2003.464512] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[ 2003.464517] usb usb1: Product: EHCI Host Controller
[ 2003.464521] usb usb1: Manufacturer: Linux 2.6.31r4 ehci_hcd
[ 2003.464525] usb usb1: SerialNumber: 0000:00:12.2
[ 2003.464619] usb usb1: uevent
[ 2003.464750] usb usb1: usb_probe_device
[ 2003.464755] usb usb1: configuration #1 chosen from 1 choice
[ 2003.464771] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[ 2003.464802] usb 1-0:1.0: uevent
[ 2003.464875] hub 1-0:1.0: usb_probe_interface
[ 2003.464880] hub 1-0:1.0: usb_probe_interface - got id
[ 2003.464884] hub 1-0:1.0: USB hub found
[ 2003.464900] hub 1-0:1.0: 6 ports detected
[ 2003.464903] hub 1-0:1.0: standalone hub
[ 2003.464907] hub 1-0:1.0: no power switching (usb 1.0)
[ 2003.464911] hub 1-0:1.0: individual port over-current protection
[ 2003.464916] hub 1-0:1.0: power on to power good time: 20ms
[ 2003.464925] hub 1-0:1.0: local power source is good
[ 2003.464931] hub 1-0:1.0: trying to enable port power on non-switchable hub
[ 2003.464989] drivers/usb/core/inode.c: creating file '001'
[ 2003.465051] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[ 2003.465085] ehci_hcd 0000:00:13.2: EHCI Host Controller
[ 2003.465099] drivers/usb/core/inode.c: creating file '002'
[ 2003.465216] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[ 2003.465231] ehci_hcd 0000:00:13.2: reset hcs_params 0x102306 dbg=1 cc=2 pcc=3 ordered !ppc ports=6
[ 2003.465239] ehci_hcd 0000:00:13.2: reset hcc_params a072 thresh 7 uframes 256/512/1024
[ 2003.465273] ehci_hcd 0000:00:13.2: applying AMD SB600/SB700 USB freeze workaround
[ 2003.465288] ehci_hcd 0000:00:13.2: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[ 2003.465309] ehci_hcd 0000:00:13.2: debug port 1
[ 2003.465317] ehci_hcd 0000:00:13.2: MWI active
[ 2003.465321] ehci_hcd 0000:00:13.2: supports USB remote wakeup
[ 2003.465340] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfddf6800
[ 2003.465350] ehci_hcd 0000:00:13.2: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[ 2003.465362] ehci_hcd 0000:00:13.2: init command 010009 (park)=0 ithresh=1 period=256 RUN
[ 2003.474419] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[ 2003.474467] usb usb2: default language 0x0409
[ 2003.474480] usb usb2: udev 1, busnum 2, minor = 128
[ 2003.474485] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[ 2003.474490] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[ 2003.474495] usb usb2: Product: EHCI Host Controller
[ 2003.474499] usb usb2: Manufacturer: Linux 2.6.31r4 ehci_hcd
[ 2003.474503] usb usb2: SerialNumber: 0000:00:13.2
[ 2003.474593] usb usb2: uevent
[ 2003.474718] usb usb2: usb_probe_device
[ 2003.474724] usb usb2: configuration #1 chosen from 1 choice
[ 2003.474738] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[ 2003.474772] usb 2-0:1.0: uevent
[ 2003.474842] hub 2-0:1.0: usb_probe_interface
[ 2003.474847] hub 2-0:1.0: usb_probe_interface - got id
[ 2003.474852] hub 2-0:1.0: USB hub found
[ 2003.474866] hub 2-0:1.0: 6 ports detected
[ 2003.474870] hub 2-0:1.0: standalone hub
[ 2003.474873] hub 2-0:1.0: no power switching (usb 1.0)
[ 2003.474877] hub 2-0:1.0: individual port over-current protection
[ 2003.474882] hub 2-0:1.0: power on to power good time: 20ms
[ 2003.474891] hub 2-0:1.0: local power source is good
[ 2003.474896] hub 2-0:1.0: trying to enable port power on non-switchable hub
[ 2003.474947] drivers/usb/core/inode.c: creating file '001'
[ 2003.563189] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
[ 2003.563198] hub 1-0:1.0: port 2: status 0501 change 0001
[ 2003.573206] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
[ 2003.663193] hub 1-0:1.0: state 7 ports 6 chg 0004 evt 0000
[ 2003.663209] hub 1-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
[ 2003.716547] ehci_hcd 0000:00:12.2: port 2 high speed
[ 2003.716558] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[ 2003.769860] usb 1-2: new high speed USB device using ehci_hcd and address 2
[ 2003.823216] ehci_hcd 0000:00:12.2: port 2 high speed
[ 2003.823226] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[ 2003.894627] usb 1-2: default language 0x0409
[ 2003.895000] usb 1-2: udev 2, busnum 1, minor = 1
[ 2003.895005] usb 1-2: New USB device found, idVendor=05e3, idProduct=0608
[ 2003.895010] usb 1-2: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[ 2003.895015] usb 1-2: Product: USB2.0 Hub
[ 2003.895126] usb 1-2: uevent
[ 2003.895154] usb 1-2: usb_probe_device
[ 2003.895160] usb 1-2: configuration #1 chosen from 1 choice
[ 2003.895382] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
[ 2003.895417] usb 1-2:1.0: uevent
[ 2003.895444] hub 1-2:1.0: usb_probe_interface
[ 2003.895448] hub 1-2:1.0: usb_probe_interface - got id
[ 2003.895453] hub 1-2:1.0: USB hub found
[ 2003.895751] hub 1-2:1.0: 4 ports detected
[ 2003.895755] hub 1-2:1.0: standalone hub
[ 2003.895759] hub 1-2:1.0: individual port power switching
[ 2003.895763] hub 1-2:1.0: individual port over-current protection
[ 2003.895767] hub 1-2:1.0: Single TT
[ 2003.895772] hub 1-2:1.0: TT requires at most 32 FS bit times (2664 ns)
[ 2003.895776] hub 1-2:1.0: Port indicators are supported
[ 2003.895781] hub 1-2:1.0: power on to power good time: 100ms
[ 2003.896247] hub 1-2:1.0: local power source is good
[ 2003.896252] hub 1-2:1.0: enabling power on all ports
[ 2003.897407] drivers/usb/core/inode.c: creating file '002'
[ 2003.996995] hub 1-2:1.0: port 2: status 0301 change 0001
[ 2004.096515] usb 1-2: link qh256-0001/ffff8800c781f180 start 1 [1/0 us]
[ 2004.096533] hub 1-2:1.0: state 7 ports 4 chg 0004 evt 0000
[ 2004.096870] hub 1-2:1.0: port 2, status 0301, change 0000, 1.5 Mb/s
[ 2004.163907] usb 1-2.2: new low speed USB device using ehci_hcd and address 3
[ 2004.250385] usb 1-2.2: skipped 1 descriptor after interface
[ 2004.250393] usb 1-2.2: skipped 1 descriptor after interface
[ 2004.250873] usb 1-2.2: default language 0x0409
[ 2004.253007] usb 1-2.2: udev 3, busnum 1, minor = 2
[ 2004.253014] usb 1-2.2: New USB device found, idVendor=046d, idProduct=c518
[ 2004.253019] usb 1-2.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[ 2004.253024] usb 1-2.2: Product: USB Receiver
[ 2004.253028] usb 1-2.2: Manufacturer: Logitech
[ 2004.253130] usb 1-2.2: uevent
[ 2004.253156] usb 1-2.2: usb_probe_device
[ 2004.253162] usb 1-2.2: configuration #1 chosen from 1 choice
[ 2004.260502] usb 1-2.2: adding 1-2.2:1.0 (config #1, interface 0)
[ 2004.260550] usb 1-2.2:1.0: uevent
[ 2004.260582] usbhid 1-2.2:1.0: usb_probe_interface
[ 2004.260586] usbhid 1-2.2:1.0: usb_probe_interface - got id
[ 2004.260971] usb 1-2: clear tt buffer port 2, a3 ep0 t80008d42
[ 2004.264198] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.2/1-2.2:1.0/input/input7
[ 2004.264333] generic-usb 0003:046D:C518.0005: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:12.2-2.2/input0
[ 2004.264364] usb 1-2.2: adding 1-2.2:1.1 (config #1, interface 1)
[ 2004.264846] usb 1-2.2:1.1: uevent
[ 2004.264874] usbhid 1-2.2:1.1: usb_probe_interface
[ 2004.264879] usbhid 1-2.2:1.1: usb_probe_interface - got id
[ 2004.265847] usb 1-2: clear tt buffer port 2, a3 ep0 t80008d42
[ 2004.271176] usb 1-2.2:1.0: uevent
[ 2004.271346] usb 1-2.2: uevent
[ 2004.271587] usb 1-2.2:1.0: uevent
[ 2004.271763] usb 1-2.2: uevent
[ 2004.272425] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.2/1-2.2:1.1/input/input8
[ 2004.272448] usb 1-2.2: link qh8-0601/ffff8800c781f300 start 2 [1/2 us]
[ 2004.272514] drivers/usb/core/file.c: looking for a minor, starting at 96
[ 2004.272623] generic-usb 0003:046D:C518.0006: input,hiddev96,hidraw1: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:12.2-2.2/input1
[ 2004.272661] drivers/usb/core/inode.c: creating file '003'
[ 2004.272701] hub 1-2:1.0: state 7 ports 4 chg 0000 evt 0004
[ 2004.277508] usb 1-2.2:1.0: uevent
[ 2004.278882] usb 1-2.2:1.0: uevent
[ 2004.279915] usb 1-2.2:1.1: uevent
[ 2004.280114] usb 1-2.2: uevent
[ 2004.282775] usb 1-2.2:1.1: uevent
[ 2004.293197] usb 1-2.2: link qh8-0601/ffff8800c781f3c0 start 3 [1/2 us]
[ 2006.316528] hub 2-0:1.0: hub_suspend
[ 2006.316544] usb usb2: bus auto-suspend
[ 2006.316550] ehci_hcd 0000:00:13.2: suspend root hub
[ 2335.001466] usb usb2: usb auto-resume
[ 2335.001472] ehci_hcd 0000:00:13.2: resume root hub
[ 2335.027313] hub 2-0:1.0: hub_resume
[ 2335.027376] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
[ 2337.317734] hub 2-0:1.0: hub_suspend
[ 2337.317748] usb usb2: bus auto-suspend
[ 2337.317754] ehci_hcd 0000:00:13.2: suspend root hub
[ 2338.703644] usb usb2: usb auto-resume
[ 2338.703650] ehci_hcd 0000:00:13.2: resume root hub
[ 2338.730218] hub 2-0:1.0: hub_resume
[ 2338.730270] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
[ 2338.736973] usb 1-2: clear tt buffer port 2, a3 ep0 t800a0d42
[ 2338.737589] usb 1-2: clear tt buffer port 2, a3 ep0 t80040d42
[ 2341.336476] hub 2-0:1.0: hub_suspend
[ 2341.336491] usb usb2: bus auto-suspend
[ 2341.336496] ehci_hcd 0000:00:13.2: suspend root hub
[ 2465.282327] usb 1-2.2: unlink qh8-0601/ffff8800c781f3c0 start 3 [1/2 us]
[ 2465.282343] ehci_hcd 0000:00:12.2: reused qh ffff8800c781f3c0 schedule
[ 2465.282350] usb 1-2.2: link qh8-0601/ffff8800c781f3c0 start 3 [1/2 us]
[ 2465.282359] usb 1-2.2: unlink qh8-0601/ffff8800c781f3c0 start 3 [1/2 us]
[ 2465.282793] ehci_hcd 0000:00:12.2: detected XactErr len 0/8 retry 1
[ 2465.283042] ehci_hcd 0000:00:12.2: detected XactErr len 0/8 retry 2
[ 2465.283292] ehci_hcd 0000:00:12.2: detected XactErr len 0/8 retry 3
[ 2465.283542] ehci_hcd 0000:00:12.2: detected XactErr len 0/8 retry 4
[ 2465.283792] ehci_hcd 0000:00:12.2: detected XactErr len 0/8 retry 5
[ 2465.284042] ehci_hcd 0000:00:12.2: detected XactErr len 0/8 retry 6
[ 2465.284292] ehci_hcd 0000:00:12.2: detected XactErr len 0/8 retry 7
[ 2465.284542] ehci_hcd 0000:00:12.2: detected XactErr len 0/8 retry 8
[ 2465.284792] ehci_hcd 0000:00:12.2: detected XactErr len 0/8 retry 9
[ 2465.285042] ehci_hcd 0000:00:12.2: detected XactErr len 0/8 retry 10
[ 2465.285292] ehci_hcd 0000:00:12.2: detected XactErr len 0/8 retry 11
[ 2465.285542] ehci_hcd 0000:00:12.2: detected XactErr len 0/8 retry 12
[ 2465.285792] ehci_hcd 0000:00:12.2: detected XactErr len 0/8 retry 13
[ 2465.286042] ehci_hcd 0000:00:12.2: detected XactErr len 0/8 retry 14
[ 2465.286292] ehci_hcd 0000:00:12.2: detected XactErr len 0/8 retry 15
[ 2465.286542] ehci_hcd 0000:00:12.2: detected XactErr len 0/8 retry 16
[ 2465.286792] ehci_hcd 0000:00:12.2: detected XactErr len 0/8 retry 17
[ 2465.287041] ehci_hcd 0000:00:12.2: detected XactErr len 0/8 retry 18
[ 2465.287292] ehci_hcd 0000:00:12.2: detected XactErr len 0/8 retry 19
[ 2465.287542] ehci_hcd 0000:00:12.2: detected XactErr len 0/8 retry 20
[ 2465.287792] ehci_hcd 0000:00:12.2: detected XactErr len 0/8 retry 21
[ 2465.288042] ehci_hcd 0000:00:12.2: detected XactErr len 0/8 retry 22
[ 2465.288291] ehci_hcd 0000:00:12.2: detected XactErr len 0/8 retry 23
[ 2465.288543] ehci_hcd 0000:00:12.2: detected XactErr len 0/8 retry 24
[ 2465.288791] ehci_hcd 0000:00:12.2: detected XactErr len 0/8 retry 25
[ 2465.289041] ehci_hcd 0000:00:12.2: detected XactErr len 0/8 retry 26
[ 2465.289171] usb 1-2.2: unlink qh8-0601/ffff8800c781f300 start 2 [1/2 us]
[ 2465.289182] ehci_hcd 0000:00:12.2: reused qh ffff8800c781f300 schedule
[ 2465.289189] usb 1-2.2: link qh8-0601/ffff8800c781f300 start 2 [1/2 us]
[ 2465.289196] usb 1-2.2: unlink qh8-0601/ffff8800c781f300 start 2 [1/2 us]
[ 2465.289415] ehci_hcd 0000:00:12.2: detected XactErr len 0/8 retry 27
[ 2465.289664] ehci_hcd 0000:00:12.2: detected XactErr len 0/8 retry 28
[ 2465.289918] ehci_hcd 0000:00:12.2: detected XactErr len 0/8 retry 29
[ 2465.290166] ehci_hcd 0000:00:12.2: detected XactErr len 0/8 retry 30
[ 2465.290416] ehci_hcd 0000:00:12.2: detected XactErr len 0/8 retry 31
[ 2465.290667] ehci_hcd 0000:00:12.2: devpath 2.2 ep0out 3strikes
[ 2465.290673] usb 1-2: clear tt buffer port 2, a3 ep0 t00080248
[ 2465.290698] ehci_hcd 0000:00:12.2: reused qh ffff8800c781f3c0 schedule
[ 2465.290704] usb 1-2.2: link qh8-0601/ffff8800c781f3c0 start 3 [1/2 us]
[ 2465.290711] drivers/hid/usbhid/hid-core.c: can't reset device, 0000:00:12.2-2.2/input0, status -71
[ 2465.298188] usb 1-2.2: unlink qh8-0601/ffff8800c781f3c0 start 3 [1/2 us]
[ 2465.298202] ehci_hcd 0000:00:12.2: reused qh ffff8800c781f3c0 schedule
[ 2465.298208] usb 1-2.2: link qh8-0601/ffff8800c781f3c0 start 3 [1/2 us]
[ 2465.298215] usb 1-2.2: unlink qh8-0601/ffff8800c781f3c0 start 3 [1/2 us]
[ 2465.504072] hub 1-2:1.0: state 7 ports 4 chg 0000 evt 0004
[ 2465.504790] hub 1-2:1.0: port 2, status 0100, change 0001, 12 Mb/s
[ 2465.505035] usb 1-2.2: USB disconnect, address 3
[ 2465.505039] usb 1-2.2: unregistering device
[ 2465.505044] usb 1-2.2: usb_disable_device nuking all URBs
[ 2465.505055] ehci_hcd 0000:00:12.2: shutdown urb ffff8801cb98e840 ep0out
[ 2465.505064] drivers/hid/usbhid/hid-core.c: can't reset device, 0000:00:12.2-2.2/input1, status -108
[ 2465.508116] usb 1-2.2: unregistering interface 1-2.2:1.0
[ 2465.561275] usb 1-2.2:1.0: uevent
[ 2465.561302] usb 1-2.2: unregistering interface 1-2.2:1.1
[ 2465.614528] drivers/usb/core/file.c: removing 96 minor
[ 2465.614702] usb 1-2.2:1.1: uevent
[ 2465.614886] usb 1-2.2: uevent
[ 2465.734061] hub 1-2:1.0: debounce: port 2: total 100ms stable 100ms status 0x100
[ 2468.316484] hub 1-2:1.0: hub_suspend
[ 2468.316501] usb 1-2: unlink qh256-0001/ffff8800c781f180 start 1 [1/0 us]
[ 2468.316862] usb 1-2: usb auto-suspend
[ 2469.403235] usb usb2: usb resume
[ 2469.403245] ehci_hcd 0000:00:13.2: resume root hub
[ 2469.431049] hub 2-0:1.0: hub_resume
[ 2469.431076] ehci_hcd 0000:00:13.2: GetStatus port 3 status 001403 POWER sig=k CSC CONNECT
[ 2469.431084] hub 2-0:1.0: port 3: status 0501 change 0001
[ 2469.533143] hub 2-0:1.0: state 7 ports 6 chg 0008 evt 0000
[ 2469.533159] hub 2-0:1.0: port 3, status 0501, change 0000, 480 Mb/s
[ 2469.533175] ehci_hcd 0000:00:13.2: port 3 low speed --> companion
[ 2469.586476] ehci_hcd 0000:00:13.2: GetStatus port 3 status 003002 POWER OWNER sig=se0 CSC
[ 2469.586510] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0008
[ 2471.316469] hub 1-0:1.0: hub_suspend
[ 2471.316484] usb usb1: bus auto-suspend
[ 2471.316489] ehci_hcd 0000:00:12.2: suspend root hub
[ 2472.316469] hub 2-0:1.0: hub_suspend
[ 2472.316482] usb usb2: bus auto-suspend
[ 2472.316487] ehci_hcd 0000:00:13.2: suspend root hub
[ 2483.117683] usb usb2: usb resume
[ 2483.117693] ehci_hcd 0000:00:13.2: resume root hub
[ 2483.166458] hub 2-0:1.0: hub_resume
[ 2483.166489] ehci_hcd 0000:00:13.2: GetStatus port 4 status 001403 POWER sig=k CSC CONNECT
[ 2483.166497] hub 2-0:1.0: port 4: status 0501 change 0001
[ 2483.271055] hub 2-0:1.0: state 7 ports 6 chg 0010 evt 0000
[ 2483.271072] hub 2-0:1.0: port 4, status 0501, change 0000, 480 Mb/s
[ 2483.271088] ehci_hcd 0000:00:13.2: port 4 low speed --> companion
[ 2483.323142] ehci_hcd 0000:00:13.2: GetStatus port 4 status 003002 POWER OWNER sig=se0 CSC
[ 2483.323177] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0010
[ 2486.316473] hub 2-0:1.0: hub_suspend
[ 2486.316487] usb usb2: bus auto-suspend
[ 2486.316492] ehci_hcd 0000:00:13.2: suspend root hub
[ 2507.269254] usb usb1: usb resume
[ 2507.269263] ehci_hcd 0000:00:12.2: resume root hub
[ 2507.293128] hub 1-0:1.0: hub_resume
[ 2507.293150] hub 1-0:1.0: port 2: status 0507 change 0000
[ 2507.293170] ehci_hcd 0000:00:12.2: GetStatus port 6 status 001403 POWER sig=k CSC CONNECT
[ 2507.293177] hub 1-0:1.0: port 6: status 0501 change 0001
[ 2507.396480] hub 1-0:1.0: state 7 ports 6 chg 0040 evt 0000
[ 2507.396497] hub 1-0:1.0: port 6, status 0501, change 0000, 480 Mb/s
[ 2507.396513] ehci_hcd 0000:00:12.2: port 6 low speed --> companion
[ 2507.451056] ehci_hcd 0000:00:12.2: GetStatus port 6 status 003002 POWER OWNER sig=se0 CSC
[ 2507.451090] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0040
[ 2510.316470] hub 1-0:1.0: hub_suspend
[ 2510.316484] usb usb1: bus auto-suspend
[ 2510.316490] ehci_hcd 0000:00:12.2: suspend root hub
[ 2531.709885] ehci_hcd 0000:00:13.2: remove, state 4
[ 2531.709892] ehci_hcd 0000:00:13.2: roothub graceful disconnect
[ 2531.709907] usb usb2: USB disconnect, address 1
[ 2531.709912] usb usb2: unregistering device
[ 2531.709917] usb usb2: usb_disable_device nuking all URBs
[ 2531.709924] usb usb2: unregistering interface 2-0:1.0
[ 2531.710016] usb 2-0:1.0: uevent
[ 2531.710235] usb usb2: uevent
[ 2531.710263] ehci_hcd 0000:00:13.2: stop
[ 2531.710280] ehci_hcd 0000:00:13.2: reset command 01000a (park)=0 ithresh=1 period=256 Reset HALT
[ 2531.710314] ehci_hcd 0000:00:13.2: irq normal 0 err 0 reclaim 0 (lost 0)
[ 2531.710319] ehci_hcd 0000:00:13.2: complete 0 unlink 0
[ 2531.710327] ehci_hcd 0000:00:13.2: ehci_stop completed status 1000 Halt
[ 2531.710340] ehci_hcd 0000:00:13.2: USB bus 2 deregistered
[ 2531.710440] ehci_hcd 0000:00:13.2: PCI INT B disabled
[ 2531.710456] ehci_hcd 0000:00:12.2: remove, state 4
[ 2531.710460] ehci_hcd 0000:00:12.2: roothub graceful disconnect
[ 2531.710471] usb usb1: USB disconnect, address 1
[ 2531.710475] usb 1-2: USB disconnect, address 2
[ 2531.710479] usb 1-2: unregistering device
[ 2531.710483] usb 1-2: usb_disable_device nuking all URBs
[ 2531.710491] usb 1-2: unregistering interface 1-2:1.0
[ 2531.710570] usb 1-2:1.0: uevent
[ 2531.710729] usb 1-2: uevent
[ 2531.710750] usb usb1: unregistering device
[ 2531.710754] usb usb1: usb_disable_device nuking all URBs
[ 2531.710760] usb usb1: unregistering interface 1-0:1.0
[ 2531.710833] usb 1-0:1.0: uevent
[ 2531.710983] usb usb1: uevent
[ 2531.711004] ehci_hcd 0000:00:12.2: stop
[ 2531.711019] ehci_hcd 0000:00:12.2: reset command 01000a (park)=0 ithresh=1 period=256 Reset HALT
[ 2531.711043] ehci_hcd 0000:00:12.2: irq normal 10312 err 40 reclaim 28 (lost 0)
[ 2531.711047] ehci_hcd 0000:00:12.2: complete 10321 unlink 2
[ 2531.711055] ehci_hcd 0000:00:12.2: ehci_stop completed status 1000 Halt
[ 2531.711064] ehci_hcd 0000:00:12.2: USB bus 1 deregistered
[ 2531.711149] ehci_hcd 0000:00:12.2: PCI INT B disabled
[ 2534.272715] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[ 2534.272724] ehci_hcd: block sizes: qh 192 qtd 96 itd 192 sitd 96
[ 2534.272781] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[ 2534.272848] ehci_hcd 0000:00:12.2: EHCI Host Controller
[ 2534.272881] drivers/usb/core/inode.c: creating file 'devices'
[ 2534.272926] drivers/usb/core/inode.c: creating file '001'
[ 2534.273071] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[ 2534.273089] ehci_hcd 0000:00:12.2: reset hcs_params 0x102306 dbg=1 cc=2 pcc=3 ordered !ppc ports=6
[ 2534.273098] ehci_hcd 0000:00:12.2: reset hcc_params a072 thresh 7 uframes 256/512/1024
[ 2534.273142] ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze workaround
[ 2534.273157] ehci_hcd 0000:00:12.2: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[ 2534.273178] ehci_hcd 0000:00:12.2: debug port 1
[ 2534.273186] ehci_hcd 0000:00:12.2: MWI active
[ 2534.273190] ehci_hcd 0000:00:12.2: supports USB remote wakeup
[ 2534.273210] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfddff000
[ 2534.273220] ehci_hcd 0000:00:12.2: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[ 2534.273232] ehci_hcd 0000:00:12.2: init command 010009 (park)=0 ithresh=1 period=256 RUN
[ 2534.280621] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[ 2534.280676] usb usb1: default language 0x0409
[ 2534.280692] usb usb1: udev 1, busnum 1, minor = 0
[ 2534.280697] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[ 2534.280702] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[ 2534.280707] usb usb1: Product: EHCI Host Controller
[ 2534.280711] usb usb1: Manufacturer: Linux 2.6.31r4 ehci_hcd
[ 2534.280715] usb usb1: SerialNumber: 0000:00:12.2
[ 2534.280810] usb usb1: uevent
[ 2534.280942] usb usb1: usb_probe_device
[ 2534.280948] usb usb1: configuration #1 chosen from 1 choice
[ 2534.280964] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[ 2534.280995] usb 1-0:1.0: uevent
[ 2534.281070] hub 1-0:1.0: usb_probe_interface
[ 2534.281074] hub 1-0:1.0: usb_probe_interface - got id
[ 2534.281079] hub 1-0:1.0: USB hub found
[ 2534.281094] hub 1-0:1.0: 6 ports detected
[ 2534.281098] hub 1-0:1.0: standalone hub
[ 2534.281102] hub 1-0:1.0: no power switching (usb 1.0)
[ 2534.281106] hub 1-0:1.0: individual port over-current protection
[ 2534.281111] hub 1-0:1.0: power on to power good time: 20ms
[ 2534.281121] hub 1-0:1.0: local power source is good
[ 2534.281126] hub 1-0:1.0: trying to enable port power on non-switchable hub
[ 2534.281182] drivers/usb/core/inode.c: creating file '001'
[ 2534.281245] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[ 2534.281280] ehci_hcd 0000:00:13.2: EHCI Host Controller
[ 2534.281295] drivers/usb/core/inode.c: creating file '002'
[ 2534.281417] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[ 2534.281431] ehci_hcd 0000:00:13.2: reset hcs_params 0x102306 dbg=1 cc=2 pcc=3 ordered !ppc ports=6
[ 2534.281441] ehci_hcd 0000:00:13.2: reset hcc_params a072 thresh 7 uframes 256/512/1024
[ 2534.281475] ehci_hcd 0000:00:13.2: applying AMD SB600/SB700 USB freeze workaround
[ 2534.281489] ehci_hcd 0000:00:13.2: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[ 2534.281511] ehci_hcd 0000:00:13.2: debug port 1
[ 2534.281519] ehci_hcd 0000:00:13.2: MWI active
[ 2534.281523] ehci_hcd 0000:00:13.2: supports USB remote wakeup
[ 2534.281541] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfddf6800
[ 2534.281551] ehci_hcd 0000:00:13.2: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[ 2534.281563] ehci_hcd 0000:00:13.2: init command 010009 (park)=0 ithresh=1 period=256 RUN
[ 2534.307281] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[ 2534.307335] usb usb2: default language 0x0409
[ 2534.307350] usb usb2: udev 1, busnum 2, minor = 128
[ 2534.307355] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[ 2534.307360] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[ 2534.307365] usb usb2: Product: EHCI Host Controller
[ 2534.307369] usb usb2: Manufacturer: Linux 2.6.31r4 ehci_hcd
[ 2534.307373] usb usb2: SerialNumber: 0000:00:13.2
[ 2534.307479] usb usb2: uevent
[ 2534.307606] usb usb2: usb_probe_device
[ 2534.307612] usb usb2: configuration #1 chosen from 1 choice
[ 2534.307627] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[ 2534.307668] usb 2-0:1.0: uevent
[ 2534.307740] hub 2-0:1.0: usb_probe_interface
[ 2534.307745] hub 2-0:1.0: usb_probe_interface - got id
[ 2534.307749] hub 2-0:1.0: USB hub found
[ 2534.307766] hub 2-0:1.0: 6 ports detected
[ 2534.307769] hub 2-0:1.0: standalone hub
[ 2534.307773] hub 2-0:1.0: no power switching (usb 1.0)
[ 2534.307777] hub 2-0:1.0: individual port over-current protection
[ 2534.307782] hub 2-0:1.0: power on to power good time: 20ms
[ 2534.307791] hub 2-0:1.0: local power source is good
[ 2534.307797] hub 2-0:1.0: trying to enable port power on non-switchable hub
[ 2534.307853] drivers/usb/core/inode.c: creating file '001'
[ 2534.379809] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
[ 2534.379818] hub 1-0:1.0: port 2: status 0501 change 0001
[ 2534.379840] ehci_hcd 0000:00:12.2: GetStatus port 6 status 001403 POWER sig=k CSC CONNECT
[ 2534.379846] hub 1-0:1.0: port 6: status 0501 change 0001
[ 2534.406514] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
[ 2534.479825] hub 1-0:1.0: state 7 ports 6 chg 0044 evt 0000
[ 2534.479846] hub 1-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
[ 2534.533166] ehci_hcd 0000:00:12.2: port 2 high speed
[ 2534.533178] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[ 2534.586477] usb 1-2: new high speed USB device using ehci_hcd and address 2
[ 2534.639810] ehci_hcd 0000:00:12.2: port 2 high speed
[ 2534.639821] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[ 2534.711224] usb 1-2: default language 0x0409
[ 2534.711597] usb 1-2: udev 2, busnum 1, minor = 1
[ 2534.711601] usb 1-2: New USB device found, idVendor=05e3, idProduct=0608
[ 2534.711607] usb 1-2: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[ 2534.711612] usb 1-2: Product: USB2.0 Hub
[ 2534.711727] usb 1-2: uevent
[ 2534.711758] usb 1-2: usb_probe_device
[ 2534.711764] usb 1-2: configuration #1 chosen from 1 choice
[ 2534.713279] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
[ 2534.713321] usb 1-2:1.0: uevent
[ 2534.713357] hub 1-2:1.0: usb_probe_interface
[ 2534.713361] hub 1-2:1.0: usb_probe_interface - got id
[ 2534.713366] hub 1-2:1.0: USB hub found
[ 2534.714120] hub 1-2:1.0: 4 ports detected
[ 2534.714125] hub 1-2:1.0: standalone hub
[ 2534.714129] hub 1-2:1.0: individual port power switching
[ 2534.714134] hub 1-2:1.0: individual port over-current protection
[ 2534.714137] hub 1-2:1.0: Single TT
[ 2534.714142] hub 1-2:1.0: TT requires at most 32 FS bit times (2664 ns)
[ 2534.714146] hub 1-2:1.0: Port indicators are supported
[ 2534.714150] hub 1-2:1.0: power on to power good time: 100ms
[ 2534.715738] hub 1-2:1.0: local power source is good
[ 2534.715746] hub 1-2:1.0: enabling power on all ports
[ 2534.716888] drivers/usb/core/inode.c: creating file '002'
[ 2534.716930] hub 1-0:1.0: port 6, status 0501, change 0000, 480 Mb/s
[ 2534.716943] ehci_hcd 0000:00:12.2: port 6 low speed --> companion
[ 2534.769802] ehci_hcd 0000:00:12.2: GetStatus port 6 status 003002 POWER OWNER sig=se0 CSC
[ 2534.769835] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0040
[ 2534.817472] usb 1-2: link qh256-0001/ffff8800c75d0180 start 1 [1/0 us]
[ 2534.817489] hub 1-2:1.0: state 7 ports 4 chg 0000 evt 0000
[ 2537.316455] hub 2-0:1.0: hub_suspend
[ 2537.316468] usb usb2: bus auto-suspend
[ 2537.316473] ehci_hcd 0000:00:13.2: suspend root hub
[ 2537.317356] hub 1-2:1.0: hub_suspend
[ 2537.317364] usb 1-2: unlink qh256-0001/ffff8800c75d0180 start 1 [1/0 us]
[ 2537.317913] usb 1-2: usb auto-suspend
[ 2537.953829] usb usb2: usb auto-resume
[ 2537.953834] ehci_hcd 0000:00:13.2: resume root hub
[ 2537.977707] hub 2-0:1.0: hub_resume
[ 2537.977751] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
[ 2537.977880] usb 1-2: usb auto-resume
[ 2538.006480] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[ 2538.019801] usb 1-2: finish resume
[ 2538.020239] hub 1-2:1.0: hub_resume
[ 2538.021249] ehci_hcd 0000:00:12.2: reused qh ffff8800c75d0180 schedule
[ 2538.021257] usb 1-2: link qh256-0001/ffff8800c75d0180 start 1 [1/0 us]
[ 2538.021276] hub 1-2:1.0: state 7 ports 4 chg 0000 evt 0000
[ 2540.316460] hub 2-0:1.0: hub_suspend
[ 2540.316474] usb usb2: bus auto-suspend
[ 2540.316479] ehci_hcd 0000:00:13.2: suspend root hub
[ 2540.316687] hub 1-2:1.0: hub_suspend
[ 2540.316696] usb 1-2: unlink qh256-0001/ffff8800c75d0180 start 1 [1/0 us]
[ 2540.316965] usb 1-2: usb auto-suspend
[ 2543.316458] hub 1-0:1.0: hub_suspend
[ 2543.316471] usb usb1: bus auto-suspend
[ 2543.316475] ehci_hcd 0000:00:12.2: suspend root hub
[ 2566.124481] usb usb1: usb resume
[ 2566.124490] ehci_hcd 0000:00:12.2: resume root hub
[ 2566.173128] hub 1-0:1.0: hub_resume
[ 2566.173148] hub 1-0:1.0: port 2: status 0507 change 0000
[ 2566.173165] ehci_hcd 0000:00:12.2: GetStatus port 5 status 001403 POWER sig=k CSC CONNECT
[ 2566.173172] hub 1-0:1.0: port 5: status 0501 change 0001
[ 2566.276469] hub 1-0:1.0: state 7 ports 6 chg 0020 evt 0000
[ 2566.276486] hub 1-0:1.0: port 5, status 0501, change 0000, 480 Mb/s
[ 2566.276502] ehci_hcd 0000:00:12.2: port 5 low speed --> companion
[ 2566.329801] ehci_hcd 0000:00:12.2: GetStatus port 5 status 003002 POWER OWNER sig=se0 CSC
[ 2566.329836] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0020
[ 2569.316448] hub 1-0:1.0: hub_suspend
[ 2569.316461] usb usb1: bus auto-suspend
[ 2569.316465] ehci_hcd 0000:00:12.2: suspend root hub
[ 2571.555161] usb usb2: usb auto-resume
[ 2571.555165] ehci_hcd 0000:00:13.2: resume root hub
[ 2571.581032] hub 2-0:1.0: hub_resume
[ 2571.581078] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
[ 2571.581205] usb usb1: usb auto-resume
[ 2571.581212] ehci_hcd 0000:00:12.2: resume root hub
[ 2571.629789] hub 1-0:1.0: hub_resume
[ 2571.629809] hub 1-0:1.0: port 2: status 0507 change 0000
[ 2571.629833] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0000
[ 2571.629848] usb 1-2: usb auto-resume
[ 2571.659810] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[ 2571.673132] usb 1-2: finish resume
[ 2571.673599] hub 1-2:1.0: hub_resume
[ 2571.674732] ehci_hcd 0000:00:12.2: reused qh ffff8800c75d0180 schedule
[ 2571.674740] usb 1-2: link qh256-0001/ffff8800c75d0180 start 1 [1/0 us]
[ 2571.674759] hub 1-2:1.0: state 7 ports 4 chg 0000 evt 0000
[ 2574.316452] hub 2-0:1.0: hub_suspend
[ 2574.316467] usb usb2: bus auto-suspend
[ 2574.316471] ehci_hcd 0000:00:13.2: suspend root hub
[ 2574.316985] hub 1-2:1.0: hub_suspend
[ 2574.316994] usb 1-2: unlink qh256-0001/ffff8800c75d0180 start 1 [1/0 us]
[ 2574.317300] usb 1-2: usb auto-suspend
[ 2577.316449] hub 1-0:1.0: hub_suspend
[ 2577.316461] usb usb1: bus auto-suspend
[ 2577.316464] ehci_hcd 0000:00:12.2: suspend root hub
[ 2581.265112] usb usb2: usb auto-resume
[ 2581.265117] ehci_hcd 0000:00:13.2: resume root hub
[ 2581.291031] hub 2-0:1.0: hub_resume
[ 2581.291077] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
[ 2581.291203] usb usb1: usb auto-resume
[ 2581.291209] ehci_hcd 0000:00:12.2: resume root hub
[ 2581.339789] hub 1-0:1.0: hub_resume
[ 2581.339809] hub 1-0:1.0: port 2: status 0507 change 0000
[ 2581.339834] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0000
[ 2581.339850] usb 1-2: usb auto-resume
[ 2581.369809] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[ 2581.383133] usb 1-2: finish resume
[ 2581.383596] hub 1-2:1.0: hub_resume
[ 2581.384729] ehci_hcd 0000:00:12.2: reused qh ffff8800c75d0180 schedule
[ 2581.384737] usb 1-2: link qh256-0001/ffff8800c75d0180 start 1 [1/0 us]
[ 2581.384755] hub 1-2:1.0: state 7 ports 4 chg 0000 evt 0000
[ 2583.316442] hub 2-0:1.0: hub_suspend
[ 2583.316456] usb usb2: bus auto-suspend
[ 2583.316460] ehci_hcd 0000:00:13.2: suspend root hub
[ 2584.316449] hub 1-2:1.0: hub_suspend
[ 2584.316463] usb 1-2: unlink qh256-0001/ffff8800c75d0180 start 1 [1/0 us]
[ 2584.316777] usb 1-2: usb auto-suspend
[ 2587.316448] hub 1-0:1.0: hub_suspend
[ 2587.316461] usb usb1: bus auto-suspend
[ 2587.316465] ehci_hcd 0000:00:12.2: suspend root hub
[ 2591.437720] ehci_hcd 0000:00:12.2: port 2 remote wakeup
[ 2591.437741] usb usb1: usb resume
[ 2591.437747] ehci_hcd 0000:00:12.2: resume root hub
[ 2591.486453] hub 1-0:1.0: hub_resume
[ 2591.486484] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[ 2591.486491] hub 1-0:1.0: port 2: status 0503 change 0004
[ 2591.486516] hub 1-0:1.0: state 7 ports 6 chg 0004 evt 0000
[ 2591.486527] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[ 2591.486537] usb 1-2: usb wakeup-resume
[ 2591.486545] usb 1-2: finish resume
[ 2591.487011] hub 1-2:1.0: hub_resume
[ 2591.487512] hub 1-2:1.0: port 2: status 0301 change 0001
[ 2591.589787] ehci_hcd 0000:00:12.2: reused qh ffff8800c75d0180 schedule
[ 2591.589796] usb 1-2: link qh256-0001/ffff8800c75d0180 start 1 [1/0 us]
[ 2591.589810] hub 1-0:1.0: resume on port 2, status 0
[ 2591.589815] hub 1-0:1.0: port 2, status 0503, change 0004, 480 Mb/s
[ 2591.589823] hub 1-2:1.0: state 7 ports 4 chg 0004 evt 0000
[ 2591.590141] hub 1-2:1.0: port 2, status 0301, change 0000, 1.5 Mb/s
[ 2591.657176] usb 1-2.2: new low speed USB device using ehci_hcd and address 5
[ 2591.743780] usb 1-2.2: skipped 1 descriptor after interface
[ 2591.743788] usb 1-2.2: skipped 1 descriptor after interface
[ 2591.744520] usb 1-2.2: default language 0x0409
[ 2591.746774] usb 1-2.2: udev 5, busnum 1, minor = 4
[ 2591.746780] usb 1-2.2: New USB device found, idVendor=046d, idProduct=c518
[ 2591.746786] usb 1-2.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[ 2591.746790] usb 1-2.2: Product: USB Receiver
[ 2591.746794] usb 1-2.2: Manufacturer: Logitech
[ 2591.746917] usb 1-2.2: uevent
[ 2591.746948] usb 1-2.2: usb_probe_device
[ 2591.746953] usb 1-2.2: configuration #1 chosen from 1 choice
[ 2591.754272] usb 1-2.2: adding 1-2.2:1.0 (config #1, interface 0)
[ 2591.754321] usb 1-2.2:1.0: uevent
[ 2591.754522] usbhid 1-2.2:1.0: usb_probe_interface
[ 2591.754527] usbhid 1-2.2:1.0: usb_probe_interface - got id
[ 2591.755629] usb 1-2: clear tt buffer port 2, a5 ep0 t80008d42
[ 2591.758733] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.2/1-2.2:1.0/input/input9
[ 2591.758873] generic-usb 0003:046D:C518.0007: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:12.2-2.2/input0
[ 2591.758909] usb 1-2.2: adding 1-2.2:1.1 (config #1, interface 1)
[ 2591.758941] usb 1-2.2:1.1: uevent
[ 2591.758967] usbhid 1-2.2:1.1: usb_probe_interface
[ 2591.758971] usbhid 1-2.2:1.1: usb_probe_interface - got id
[ 2591.759617] usb 1-2: clear tt buffer port 2, a5 ep0 t80008d42
[ 2591.762598] usb 1-2.2:1.0: uevent
[ 2591.762643] usb 1-2.2: uevent
[ 2591.763438] usb 1-2.2:1.0: uevent
[ 2591.763617] usb 1-2.2: uevent
[ 2591.763653] usb 1-2.2:1.0: uevent
[ 2591.766698] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.2/1-2.2:1.1/input/input10
[ 2591.766722] usb 1-2.2: link qh8-0601/ffff8800c75d0300 start 2 [1/2 us]
[ 2591.766784] drivers/usb/core/file.c: looking for a minor, starting at 96
[ 2591.766895] generic-usb 0003:046D:C518.0008: input,hiddev96,hidraw1: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:12.2-2.2/input1
[ 2591.766930] drivers/usb/core/inode.c: creating file '005'
[ 2591.768262] usb 1-2.2:1.0: uevent
[ 2591.771104] usb 1-2.2:1.1: uevent
[ 2591.771170] usb 1-2.2: uevent
[ 2591.772181] usb 1-2.2:1.1: uevent
[ 2591.791051] usb 1-2.2: link qh8-0601/ffff8800c75d03c0 start 3 [1/2 us]
[ 2717.490627] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[ 2717.490634] ohci_hcd: block sizes: ed 80 td 96
[ 2717.490684]   alloc irq_desc for 16 on node -1
[ 2717.490689]   alloc kstat_irqs on node -1
[ 2717.490702] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[ 2717.490771] ohci_hcd 0000:00:12.0: OHCI Host Controller
[ 2717.490787] drivers/usb/core/inode.c: creating file '003'
[ 2717.491869] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
[ 2717.491899] ohci_hcd 0000:00:12.0: enabled AMD ISO transfers quirk
[ 2717.491925] ohci_hcd 0000:00:12.0: created debug files
[ 2717.491930] ohci_hcd 0000:00:12.0: supports USB remote wakeup
[ 2717.491960] ohci_hcd 0000:00:12.0: irq 16, io mem 0xfddfe000
[ 2717.547126] ohci_hcd 0000:00:12.0: OHCI controller state
[ 2717.547136] ohci_hcd 0000:00:12.0: OHCI 1.0, NO legacy support registers
[ 2717.547145] ohci_hcd 0000:00:12.0: control 0x283 RWC HCFS=operational CBSR=3
[ 2717.547152] ohci_hcd 0000:00:12.0: cmdstatus 0x00000 SOC=0
[ 2717.547160] ohci_hcd 0000:00:12.0: intrstatus 0x00000004 SF
[ 2717.547167] ohci_hcd 0000:00:12.0: intrenable 0x8000001a MIE UE RD WDH
[ 2717.547179] ohci_hcd 0000:00:12.0: hcca frame #0005
[ 2717.547187] ohci_hcd 0000:00:12.0: roothub.a 02001203 POTPGT=2 NOCP NPS NDP=3(3)
[ 2717.547193] ohci_hcd 0000:00:12.0: roothub.b 00000000 PPCM=0000 DR=0000
[ 2717.547200] ohci_hcd 0000:00:12.0: roothub.status 00008000 DRWE
[ 2717.547208] ohci_hcd 0000:00:12.0: roothub.portstatus [0] 0x00000100 PPS
[ 2717.547215] ohci_hcd 0000:00:12.0: roothub.portstatus [1] 0x00000100 PPS
[ 2717.547222] ohci_hcd 0000:00:12.0: roothub.portstatus [2] 0x00000100 PPS
[ 2717.547248] usb usb3: default language 0x0409
[ 2717.547261] usb usb3: udev 1, busnum 3, minor = 256
[ 2717.547266] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[ 2717.547271] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[ 2717.547276] usb usb3: Product: OHCI Host Controller
[ 2717.547280] usb usb3: Manufacturer: Linux 2.6.31r4 ohci_hcd
[ 2717.547284] usb usb3: SerialNumber: 0000:00:12.0
[ 2717.547389] usb usb3: uevent
[ 2717.547519] usb usb3: usb_probe_device
[ 2717.547525] usb usb3: configuration #1 chosen from 1 choice
[ 2717.547541] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[ 2717.547572] usb 3-0:1.0: uevent
[ 2717.548112] hub 3-0:1.0: usb_probe_interface
[ 2717.548113] hub 3-0:1.0: usb_probe_interface - got id
[ 2717.548115] hub 3-0:1.0: USB hub found
[ 2717.548122] hub 3-0:1.0: 3 ports detected
[ 2717.548123] hub 3-0:1.0: standalone hub
[ 2717.548124] hub 3-0:1.0: no power switching (usb 1.0)
[ 2717.548126] hub 3-0:1.0: no over-current protection
[ 2717.548127] hub 3-0:1.0: power on to power good time: 4ms
[ 2717.548130] hub 3-0:1.0: local power source is good
[ 2717.548132] hub 3-0:1.0: trying to enable port power on non-switchable hub
[ 2717.548143] drivers/usb/core/inode.c: creating file '001'
[ 2717.548171] ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[ 2717.548186] ohci_hcd 0000:00:12.1: OHCI Host Controller
[ 2717.548190] drivers/usb/core/inode.c: creating file '004'
[ 2717.548343] ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 4
[ 2717.548350] ohci_hcd 0000:00:12.1: enabled AMD ISO transfers quirk
[ 2717.548361] ohci_hcd 0000:00:12.1: created debug files
[ 2717.548362] ohci_hcd 0000:00:12.1: supports USB remote wakeup
[ 2717.548367] ohci_hcd 0000:00:12.1: irq 16, io mem 0xfddfd000
[ 2717.605037] ohci_hcd 0000:00:12.1: OHCI controller state
[ 2717.605047] ohci_hcd 0000:00:12.1: OHCI 1.0, NO legacy support registers
[ 2717.605055] ohci_hcd 0000:00:12.1: control 0x283 RWC HCFS=operational CBSR=3
[ 2717.605063] ohci_hcd 0000:00:12.1: cmdstatus 0x00000 SOC=0
[ 2717.605070] ohci_hcd 0000:00:12.1: intrstatus 0x00000004 SF
[ 2717.605077] ohci_hcd 0000:00:12.1: intrenable 0x8000001a MIE UE RD WDH
[ 2717.605089] ohci_hcd 0000:00:12.1: hcca frame #0005
[ 2717.605096] ohci_hcd 0000:00:12.1: roothub.a 02001203 POTPGT=2 NOCP NPS NDP=3(3)
[ 2717.605103] ohci_hcd 0000:00:12.1: roothub.b 00000000 PPCM=0000 DR=0000
[ 2717.605109] ohci_hcd 0000:00:12.1: roothub.status 00008000 DRWE
[ 2717.605117] ohci_hcd 0000:00:12.1: roothub.portstatus [0] 0x00000100 PPS
[ 2717.605124] ohci_hcd 0000:00:12.1: roothub.portstatus [1] 0x00000100 PPS
[ 2717.605131] ohci_hcd 0000:00:12.1: roothub.portstatus [2] 0x00000100 PPS
[ 2717.605157] usb usb4: default language 0x0409
[ 2717.605170] usb usb4: udev 1, busnum 4, minor = 384
[ 2717.605175] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[ 2717.605179] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[ 2717.605185] usb usb4: Product: OHCI Host Controller
[ 2717.605189] usb usb4: Manufacturer: Linux 2.6.31r4 ohci_hcd
[ 2717.605192] usb usb4: SerialNumber: 0000:00:12.1
[ 2717.605300] usb usb4: uevent
[ 2717.606467] usb usb4: usb_probe_device
[ 2717.606474] usb usb4: configuration #1 chosen from 1 choice
[ 2717.606491] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[ 2717.606526] usb 4-0:1.0: uevent
[ 2717.606613] hub 4-0:1.0: usb_probe_interface
[ 2717.606618] hub 4-0:1.0: usb_probe_interface - got id
[ 2717.606623] hub 4-0:1.0: USB hub found
[ 2717.606641] hub 4-0:1.0: 3 ports detected
[ 2717.606645] hub 4-0:1.0: standalone hub
[ 2717.606648] hub 4-0:1.0: no power switching (usb 1.0)
[ 2717.606653] hub 4-0:1.0: no over-current protection
[ 2717.606657] hub 4-0:1.0: power on to power good time: 4ms
[ 2717.606667] hub 4-0:1.0: local power source is good
[ 2717.606672] hub 4-0:1.0: trying to enable port power on non-switchable hub
[ 2717.606713] drivers/usb/core/inode.c: creating file '001'
[ 2717.606788] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[ 2717.606832] ohci_hcd 0000:00:13.0: OHCI Host Controller
[ 2717.606846] drivers/usb/core/inode.c: creating file '005'
[ 2717.607410] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
[ 2717.607431] ohci_hcd 0000:00:13.0: enabled AMD ISO transfers quirk
[ 2717.607457] ohci_hcd 0000:00:13.0: created debug files
[ 2717.607461] ohci_hcd 0000:00:13.0: supports USB remote wakeup
[ 2717.607493] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfddfc000
[ 2717.647706] hub 3-0:1.0: state 7 ports 3 chg 0000 evt 0000
[ 2717.664597] ohci_hcd 0000:00:13.0: OHCI controller state
[ 2717.664607] ohci_hcd 0000:00:13.0: OHCI 1.0, NO legacy support registers
[ 2717.664615] ohci_hcd 0000:00:13.0: control 0x283 RWC HCFS=operational CBSR=3
[ 2717.664622] ohci_hcd 0000:00:13.0: cmdstatus 0x00000 SOC=0
[ 2717.664629] ohci_hcd 0000:00:13.0: intrstatus 0x00000004 SF
[ 2717.664636] ohci_hcd 0000:00:13.0: intrenable 0x8000001a MIE UE RD WDH
[ 2717.664649] ohci_hcd 0000:00:13.0: hcca frame #0005
[ 2717.664656] ohci_hcd 0000:00:13.0: roothub.a 02001203 POTPGT=2 NOCP NPS NDP=3(3)
[ 2717.664662] ohci_hcd 0000:00:13.0: roothub.b 00000000 PPCM=0000 DR=0000
[ 2717.664669] ohci_hcd 0000:00:13.0: roothub.status 00008000 DRWE
[ 2717.664677] ohci_hcd 0000:00:13.0: roothub.portstatus [0] 0x00000100 PPS
[ 2717.664684] ohci_hcd 0000:00:13.0: roothub.portstatus [1] 0x00000100 PPS
[ 2717.664691] ohci_hcd 0000:00:13.0: roothub.portstatus [2] 0x00000100 PPS
[ 2717.664715] usb usb5: default language 0x0409
[ 2717.664728] usb usb5: udev 1, busnum 5, minor = 512
[ 2717.664732] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[ 2717.664737] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[ 2717.664742] usb usb5: Product: OHCI Host Controller
[ 2717.664746] usb usb5: Manufacturer: Linux 2.6.31r4 ohci_hcd
[ 2717.664750] usb usb5: SerialNumber: 0000:00:13.0
[ 2717.664853] usb usb5: uevent
[ 2717.665981] usb usb5: usb_probe_device
[ 2717.665988] usb usb5: configuration #1 chosen from 1 choice
[ 2717.666007] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[ 2717.666044] usb 5-0:1.0: uevent
[ 2717.666132] hub 5-0:1.0: usb_probe_interface
[ 2717.666136] hub 5-0:1.0: usb_probe_interface - got id
[ 2717.666141] hub 5-0:1.0: USB hub found
[ 2717.666159] hub 5-0:1.0: 3 ports detected
[ 2717.666163] hub 5-0:1.0: standalone hub
[ 2717.666166] hub 5-0:1.0: no power switching (usb 1.0)
[ 2717.666170] hub 5-0:1.0: no over-current protection
[ 2717.666175] hub 5-0:1.0: power on to power good time: 4ms
[ 2717.666184] hub 5-0:1.0: local power source is good
[ 2717.666189] hub 5-0:1.0: trying to enable port power on non-switchable hub
[ 2717.666224] drivers/usb/core/inode.c: creating file '001'
[ 2717.666293] ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[ 2717.666335] ohci_hcd 0000:00:13.1: OHCI Host Controller
[ 2717.666349] drivers/usb/core/inode.c: creating file '006'
[ 2717.666892] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 6
[ 2717.666911] ohci_hcd 0000:00:13.1: enabled AMD ISO transfers quirk
[ 2717.666937] ohci_hcd 0000:00:13.1: created debug files
[ 2717.666941] ohci_hcd 0000:00:13.1: supports USB remote wakeup
[ 2717.666954] ohci_hcd 0000:00:13.1: irq 18, io mem 0xfddf7000
[ 2717.707675] hub 4-0:1.0: state 7 ports 3 chg 0000 evt 0000
[ 2717.721716] ohci_hcd 0000:00:13.1: OHCI controller state
[ 2717.721725] ohci_hcd 0000:00:13.1: OHCI 1.0, NO legacy support registers
[ 2717.721735] ohci_hcd 0000:00:13.1: control 0x283 RWC HCFS=operational CBSR=3
[ 2717.721743] ohci_hcd 0000:00:13.1: cmdstatus 0x00000 SOC=0
[ 2717.721751] ohci_hcd 0000:00:13.1: intrstatus 0x00000004 SF
[ 2717.721758] ohci_hcd 0000:00:13.1: intrenable 0x8000001a MIE UE RD WDH
[ 2717.721770] ohci_hcd 0000:00:13.1: hcca frame #0005
[ 2717.721778] ohci_hcd 0000:00:13.1: roothub.a 02001203 POTPGT=2 NOCP NPS NDP=3(3)
[ 2717.721784] ohci_hcd 0000:00:13.1: roothub.b 00000000 PPCM=0000 DR=0000
[ 2717.721791] ohci_hcd 0000:00:13.1: roothub.status 00008000 DRWE
[ 2717.721799] ohci_hcd 0000:00:13.1: roothub.portstatus [0] 0x00000100 PPS
[ 2717.721806] ohci_hcd 0000:00:13.1: roothub.portstatus [1] 0x00000100 PPS
[ 2717.721813] ohci_hcd 0000:00:13.1: roothub.portstatus [2] 0x00000100 PPS
[ 2717.722062] usb usb6: default language 0x0409
[ 2717.722076] usb usb6: udev 1, busnum 6, minor = 640
[ 2717.722080] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[ 2717.722085] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[ 2717.722090] usb usb6: Product: OHCI Host Controller
[ 2717.722094] usb usb6: Manufacturer: Linux 2.6.31r4 ohci_hcd
[ 2717.722098] usb usb6: SerialNumber: 0000:00:13.1
[ 2717.722207] usb usb6: uevent
[ 2717.722330] usb usb6: usb_probe_device
[ 2717.722336] usb usb6: configuration #1 chosen from 1 choice
[ 2717.722350] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[ 2717.722382] usb 6-0:1.0: uevent
[ 2717.722456] hub 6-0:1.0: usb_probe_interface
[ 2717.722461] hub 6-0:1.0: usb_probe_interface - got id
[ 2717.722466] hub 6-0:1.0: USB hub found
[ 2717.722482] hub 6-0:1.0: 3 ports detected
[ 2717.722486] hub 6-0:1.0: standalone hub
[ 2717.722490] hub 6-0:1.0: no power switching (usb 1.0)
[ 2717.722494] hub 6-0:1.0: no over-current protection
[ 2717.722498] hub 6-0:1.0: power on to power good time: 4ms
[ 2717.722508] hub 6-0:1.0: local power source is good
[ 2717.722513] hub 6-0:1.0: trying to enable port power on non-switchable hub
[ 2717.722549] drivers/usb/core/inode.c: creating file '001'
[ 2717.722624] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[ 2717.722666] ohci_hcd 0000:00:14.5: OHCI Host Controller
[ 2717.722680] drivers/usb/core/inode.c: creating file '007'
[ 2717.723236] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 7
[ 2717.723257] ohci_hcd 0000:00:14.5: enabled AMD ISO transfers quirk
[ 2717.723281] ohci_hcd 0000:00:14.5: created debug files
[ 2717.723286] ohci_hcd 0000:00:14.5: supports USB remote wakeup
[ 2717.723301] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfddf5000
[ 2717.764368] hub 5-0:1.0: state 7 ports 3 chg 0000 evt 0000
[ 2717.780468] ohci_hcd 0000:00:14.5: OHCI controller state
[ 2717.780478] ohci_hcd 0000:00:14.5: OHCI 1.0, NO legacy support registers
[ 2717.780487] ohci_hcd 0000:00:14.5: control 0x283 RWC HCFS=operational CBSR=3
[ 2717.780495] ohci_hcd 0000:00:14.5: cmdstatus 0x00000 SOC=0
[ 2717.780503] ohci_hcd 0000:00:14.5: intrstatus 0x00000004 SF
[ 2717.780510] ohci_hcd 0000:00:14.5: intrenable 0x8000001a MIE UE RD WDH
[ 2717.780522] ohci_hcd 0000:00:14.5: hcca frame #0005
[ 2717.780530] ohci_hcd 0000:00:14.5: roothub.a 02001202 POTPGT=2 NOCP NPS NDP=2(2)
[ 2717.780536] ohci_hcd 0000:00:14.5: roothub.b 00000000 PPCM=0000 DR=0000
[ 2717.780543] ohci_hcd 0000:00:14.5: roothub.status 00008000 DRWE
[ 2717.780550] ohci_hcd 0000:00:14.5: roothub.portstatus [0] 0x00000100 PPS
[ 2717.780558] ohci_hcd 0000:00:14.5: roothub.portstatus [1] 0x00000100 PPS
[ 2717.780801] usb usb7: default language 0x0409
[ 2717.780815] usb usb7: udev 1, busnum 7, minor = 768
[ 2717.780820] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[ 2717.780825] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[ 2717.780830] usb usb7: Product: OHCI Host Controller
[ 2717.780835] usb usb7: Manufacturer: Linux 2.6.31r4 ohci_hcd
[ 2717.780839] usb usb7: SerialNumber: 0000:00:14.5
[ 2717.780942] usb usb7: uevent
[ 2717.781960] usb usb7: usb_probe_device
[ 2717.781967] usb usb7: configuration #1 chosen from 1 choice
[ 2717.781982] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[ 2717.782019] usb 7-0:1.0: uevent
[ 2717.782103] hub 7-0:1.0: usb_probe_interface
[ 2717.782108] hub 7-0:1.0: usb_probe_interface - got id
[ 2717.782113] hub 7-0:1.0: USB hub found
[ 2717.782132] hub 7-0:1.0: 2 ports detected
[ 2717.782136] hub 7-0:1.0: standalone hub
[ 2717.782139] hub 7-0:1.0: no power switching (usb 1.0)
[ 2717.782143] hub 7-0:1.0: no over-current protection
[ 2717.782148] hub 7-0:1.0: power on to power good time: 4ms
[ 2717.782157] hub 7-0:1.0: local power source is good
[ 2717.782162] hub 7-0:1.0: trying to enable port power on non-switchable hub
[ 2717.782197] drivers/usb/core/inode.c: creating file '001'
[ 2717.821028] hub 6-0:1.0: state 7 ports 3 chg 0000 evt 0000
[ 2717.880510] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[ 2718.596438] ohci_hcd 0000:00:12.0: auto-stop root hub
[ 2718.846434] ohci_hcd 0000:00:12.1: auto-stop root hub
[ 2718.846455] ohci_hcd 0000:00:13.0: auto-stop root hub
[ 2718.846472] ohci_hcd 0000:00:13.1: auto-stop root hub
[ 2718.846487] ohci_hcd 0000:00:14.5: auto-stop root hub
[ 2720.317668] hub 3-0:1.0: hub_suspend
[ 2720.317676] usb usb3: bus auto-suspend
[ 2720.317681] ohci_hcd 0000:00:12.0: suspend root hub
[ 2720.317687] hub 4-0:1.0: hub_suspend
[ 2720.317689] usb usb4: bus auto-suspend
[ 2720.317692] ohci_hcd 0000:00:12.1: suspend root hub
[ 2720.317697] hub 5-0:1.0: hub_suspend
[ 2720.317700] usb usb5: bus auto-suspend
[ 2720.317702] ohci_hcd 0000:00:13.0: suspend root hub
[ 2720.317707] hub 6-0:1.0: hub_suspend
[ 2720.317709] usb usb6: bus auto-suspend
[ 2720.317712] ohci_hcd 0000:00:13.1: suspend root hub
[ 2720.317716] hub 7-0:1.0: hub_suspend
[ 2720.317718] usb usb7: bus auto-suspend
[ 2720.317721] ohci_hcd 0000:00:14.5: suspend root hub
[ 2725.894611] hub 1-2:1.0: state 7 ports 4 chg 0000 evt 0004
[ 2725.895171] hub 1-2:1.0: port 2, status 0100, change 0001, 12 Mb/s
[ 2725.895421] usb 1-2.2: USB disconnect, address 5
[ 2725.895426] usb 1-2.2: unregistering device
[ 2725.895431] usb 1-2.2: usb_disable_device nuking all URBs
[ 2725.895442] usb 1-2.2: unlink qh8-0601/ffff8800c75d03c0 start 3 [1/2 us]
[ 2725.895454] ehci_hcd 0000:00:12.2: shutdown urb ffff8801c2462600 ep1in-intr
[ 2725.895462] usb 1-2.2: unlink qh8-0601/ffff8800c75d0300 start 2 [1/2 us]
[ 2725.895470] ehci_hcd 0000:00:12.2: shutdown urb ffff8801cb9b2840 ep2in-intr
[ 2725.895477] usb 1-2.2: unregistering interface 1-2.2:1.0
[ 2725.947924] usb 1-2.2:1.0: uevent
[ 2725.947951] usb 1-2.2: unregistering interface 1-2.2:1.1
[ 2725.998084] drivers/usb/core/file.c: removing 96 minor
[ 2725.998257] usb 1-2.2:1.1: uevent
[ 2725.998434] usb 1-2.2: uevent
[ 2727.006453] usb 1-2: khubd timed out on ep0in len=0/4
[ 2728.016454] usb 1-2: khubd timed out on ep0in len=0/4
[ 2729.027685] usb 1-2: khubd timed out on ep0in len=0/4
[ 2730.036453] usb 1-2: khubd timed out on ep0in len=0/4
[ 2731.046453] usb 1-2: khubd timed out on ep0in len=0/4
[ 2731.046461] hub 1-2:1.0: hub_port_status failed (err = -110)
[ 2731.046467] hub 1-2:1.0: connect-debounce failed, port 2 disabled
[ 2733.316494] hub 1-2:1.0: hub_suspend
[ 2733.316512] usb 1-2: unlink qh256-0001/ffff8800c75d0180 start 1 [1/0 us]
[ 2738.327677] usb 1-2: ksuspend_usbd timed out on ep0out len=0/0
[ 2738.327686] usb 1-2: won't remote wakeup, status -110
[ 2738.327699] usb 1-2: usb auto-suspend
[ 2741.316468] hub 1-0:1.0: hub_suspend
[ 2741.316483] usb usb1: bus auto-suspend
[ 2741.316489] ehci_hcd 0000:00:12.2: suspend root hub
[ 2741.323499] ehci_hcd 0000:00:12.2: force halt; handhake ffffc9000007e024 0000c000 00000000 -> -110
[ 2746.023504] usb usb4: usb resume
[ 2746.033105] ohci_hcd 0000:00:12.1: wakeup root hub
[ 2746.103097] hub 4-0:1.0: hub_resume
[ 2746.103123] ohci_hcd 0000:00:12.1: GetStatus roothub.portstatus [2] = 0x00010100 CSC PPS
[ 2746.206460] usb usb1: usb resume
[ 2746.206470] ehci_hcd 0000:00:12.2: resume root hub
[ 2746.206480] hub 4-0:1.0: state 7 ports 3 chg 0000 evt 0000
[ 2746.243109] ehci_hcd 0000:00:12.2: port 6 low speed --> companion
[ 2746.243166] hub 4-0:1.0: state 7 ports 3 chg 0000 evt 0008
[ 2746.243181] ohci_hcd 0000:00:12.1: GetStatus roothub.portstatus [2] = 0x00010301 CSC LSDA PPS CCS
[ 2746.243193] hub 4-0:1.0: port 3, status 0301, change 0001, 1.5 Mb/s
[ 2746.336528] ehci_hcd 0000:00:12.2: GetStatus port 6 status 003002 POWER OWNER sig=se0 CSC
[ 2746.351009] hub 1-0:1.0: hub_resume
[ 2746.351030] hub 1-0:1.0: port 2: status 0507 change 0000
[ 2746.363108] hub 4-0:1.0: debounce: port 3: total 100ms stable 100ms status 0x301
[ 2746.386461] ohci_hcd 0000:00:12.1: port[2] reset timeout, stat 00000311
[ 2746.436443] ohci_hcd 0000:00:12.1: GetStatus roothub.portstatus [2] = 0x00100303 PRSC LSDA PPS PES CCS
[ 2746.489785] usb 4-3: new low speed USB device using ohci_hcd and address 2
[ 2746.513121] ohci_hcd 0000:00:12.1: port[2] reset timeout, stat 00000313
[ 2746.563102] ohci_hcd 0000:00:12.1: GetStatus roothub.portstatus [2] = 0x00100303 PRSC LSDA PPS PES CCS
[ 2746.640868] usb 4-3: skipped 1 descriptor after interface
[ 2746.640876] usb 4-3: skipped 1 descriptor after interface
[ 2746.642863] usb 4-3: default language 0x0409
[ 2746.647867] usb 4-3: udev 2, busnum 4, minor = 385
[ 2746.647873] usb 4-3: New USB device found, idVendor=046d, idProduct=c518
[ 2746.647879] usb 4-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[ 2746.647884] usb 4-3: Product: USB Receiver
[ 2746.647888] usb 4-3: Manufacturer: Logitech
[ 2746.648015] usb 4-3: uevent
[ 2746.648171] usb 4-3: usb_probe_device
[ 2746.648178] usb 4-3: configuration #1 chosen from 1 choice
[ 2746.659091] usb 4-3: adding 4-3:1.0 (config #1, interface 0)
[ 2746.659140] usb 4-3:1.0: uevent
[ 2746.659261] usbhid 4-3:1.0: usb_probe_interface
[ 2746.659266] usbhid 4-3:1.0: usb_probe_interface - got id
[ 2746.666465] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.1/usb4/4-3/4-3:1.0/input/input11
[ 2746.666746] generic-usb 0003:046D:C518.0009: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:12.1-3/input0
[ 2746.666790] usb 4-3: adding 4-3:1.1 (config #1, interface 1)
[ 2746.666838] usb 4-3:1.1: uevent
[ 2746.669134] usbhid 4-3:1.1: usb_probe_interface
[ 2746.669142] usbhid 4-3:1.1: usb_probe_interface - got id
[ 2746.673349] usb 4-3:1.0: uevent
[ 2746.673382] usb 4-3:1.0: uevent
[ 2746.673533] usb 4-3: uevent
[ 2746.673568] usb 4-3: uevent
[ 2746.676248] usb 4-3:1.0: uevent
[ 2746.677338] usb 4-3:1.0: uevent
[ 2746.678036] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.1/usb4/4-3/4-3:1.1/input/input12
[ 2746.678113] drivers/usb/core/file.c: looking for a minor, starting at 96
[ 2746.678224] generic-usb 0003:046D:C518.000A: input,hiddev96,hidraw1: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:12.1-3/input1
[ 2746.678258] drivers/usb/core/inode.c: creating file '002'
[ 2746.678301] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0000
[ 2746.678310] hub 4-0:1.0: state 7 ports 3 chg 0000 evt 0008
[ 2746.686120] usb 4-3:1.1: uevent
[ 2746.686276] usb 4-3: uevent
[ 2746.688542] usb 4-3:1.1: uevent
[ 2749.316440] hub 1-0:1.0: hub_suspend
[ 2749.316454] usb usb1: bus auto-suspend
[ 2749.316460] ehci_hcd 0000:00:12.2: suspend root hub
[ 2749.323504] ehci_hcd 0000:00:12.2: force halt; handhake ffffc9000007e024 0000c000 00000000 -> -110
[ 2761.293777] usb usb7: usb auto-resume
[ 2761.293784] ohci_hcd 0000:00:14.5: resume root hub
[ 2761.363508] hub 7-0:1.0: hub_resume
[ 2761.363559] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[ 2761.363643] usb usb6: usb auto-resume
[ 2761.363652] ohci_hcd 0000:00:13.1: resume root hub
[ 2761.433507] hub 6-0:1.0: hub_resume
[ 2761.433557] hub 6-0:1.0: state 7 ports 3 chg 0000 evt 0000
[ 2761.433641] usb usb5: usb auto-resume
[ 2761.433650] ohci_hcd 0000:00:13.0: resume root hub
[ 2761.503507] hub 5-0:1.0: hub_resume
[ 2761.503557] hub 5-0:1.0: state 7 ports 3 chg 0000 evt 0000
[ 2761.503734] usb usb3: usb auto-resume
[ 2761.503743] ohci_hcd 0000:00:12.0: resume root hub
[ 2761.573507] hub 3-0:1.0: hub_resume
[ 2761.573557] hub 3-0:1.0: state 7 ports 3 chg 0000 evt 0000
[ 2761.573631] usb usb2: usb auto-resume
[ 2761.573638] ehci_hcd 0000:00:13.2: resume root hub
[ 2761.600178] hub 2-0:1.0: hub_resume
[ 2761.600235] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
[ 2761.600311] usb usb1: usb auto-resume
[ 2761.600317] ehci_hcd 0000:00:12.2: resume root hub
[ 2761.650172] hub 1-0:1.0: hub_resume
[ 2761.650192] hub 1-0:1.0: port 2: status 0507 change 0000
[ 2761.650224] usb 1-2: usb auto-resume
[ 2761.650237] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0000
[ 2761.680191] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[ 2761.693514] usb 1-2: finish resume
[ 2762.596422] ohci_hcd 0000:00:14.5: auto-stop root hub
[ 2762.596444] ohci_hcd 0000:00:13.1: auto-stop root hub
[ 2762.596460] ohci_hcd 0000:00:13.0: auto-stop root hub
[ 2762.596476] ohci_hcd 0000:00:12.0: auto-stop root hub
[ 2764.317678] hub 7-0:1.0: hub_suspend
[ 2764.317693] usb usb7: bus auto-suspend
[ 2764.317701] ohci_hcd 0000:00:14.5: suspend root hub
[ 2764.317711] hub 6-0:1.0: hub_suspend
[ 2764.317717] usb usb6: bus auto-suspend
[ 2764.317722] ohci_hcd 0000:00:13.1: suspend root hub
[ 2764.317730] hub 5-0:1.0: hub_suspend
[ 2764.317736] usb usb5: bus auto-suspend
[ 2764.317741] ohci_hcd 0000:00:13.0: suspend root hub
[ 2764.317748] hub 3-0:1.0: hub_suspend
[ 2764.317753] usb usb3: bus auto-suspend
[ 2764.317758] ohci_hcd 0000:00:12.0: suspend root hub
[ 2764.317766] hub 2-0:1.0: hub_suspend
[ 2764.317771] usb usb2: bus auto-suspend
[ 2764.317775] ehci_hcd 0000:00:13.2: suspend root hub
[ 2766.703520] usb 1-2: lsusb timed out on ep0in len=0/2
[ 2766.703529] usb 1-2: retry with reset-resume
[ 2766.756878] ehci_hcd 0000:00:12.2: port 2 high speed
[ 2766.756891] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[ 2766.810184] usb 1-2: reset high speed USB device using ehci_hcd and address 2
[ 2771.819775] usb 1-2: lsusb timed out on ep0in len=0/64
[ 2776.830158] usb 1-2: lsusb timed out on ep0in len=0/64
[ 2781.839773] usb 1-2: lsusb timed out on ep0in len=0/64
[ 2781.893563] ehci_hcd 0000:00:12.2: port 2 high speed
[ 2781.893576] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[ 2781.946445] usb 1-2: device descriptor read/64, error -110
[ 2787.059772] usb 1-2: lsusb timed out on ep0in len=0/64
[ 2792.069779] usb 1-2: lsusb timed out on ep0in len=0/64
[ 2797.079778] usb 1-2: lsusb timed out on ep0in len=0/64
[ 2797.133554] ehci_hcd 0000:00:12.2: port 2 high speed
[ 2797.133567] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[ 2797.186444] usb 1-2: device descriptor read/64, error -110
[ 2797.343527] ehci_hcd 0000:00:12.2: port 2 high speed
[ 2797.343540] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[ 2797.396442] usb 1-2: reset high speed USB device using ehci_hcd and address 2
[ 2802.406446] usb 1-2: lsusb timed out on ep0in len=0/64
[ 2807.416445] usb 1-2: lsusb timed out on ep0in len=0/64
[ 2812.426443] usb 1-2: lsusb timed out on ep0in len=0/64
[ 2812.480192] ehci_hcd 0000:00:12.2: port 2 high speed
[ 2812.480205] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[ 2812.533519] usb 1-2: device descriptor read/64, error -110
[ 2817.646850] usb 1-2: lsusb timed out on ep0in len=0/64
[ 2822.656435] usb 1-2: lsusb timed out on ep0in len=0/64
[ 2827.666846] usb 1-2: lsusb timed out on ep0in len=0/64
[ 2827.720228] ehci_hcd 0000:00:12.2: port 2 high speed
[ 2827.720241] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[ 2827.773106] usb 1-2: device descriptor read/64, error -110
[ 2827.933101] ehci_hcd 0000:00:12.2: port 2 high speed
[ 2827.933112] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[ 2827.986440] usb 1-2: reset high speed USB device using ehci_hcd and address 2
[ 2832.996433] usb 1-2: lsusb timed out on ep0out len=0/0
[ 2838.209767] usb 1-2: lsusb timed out on ep0out len=0/0
[ 2838.413097] usb 1-2: device not accepting address 2, error -110
[ 2838.466481] ehci_hcd 0000:00:12.2: port 2 high speed
[ 2838.466493] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[ 2838.519771] usb 1-2: reset high speed USB device using ehci_hcd and address 2
[ 2843.529770] usb 1-2: lsusb timed out on ep0out len=0/0
[ 2848.743098] usb 1-2: lsusb timed out on ep0out len=0/0
[ 2848.946425] usb 1-2: device not accepting address 2, error -110
[ 2848.946443] hub 1-0:1.0: logical disconnect on port 2
[ 2848.946461] usb 1-2: gone after usb resume? status -19
[ 2848.946466] usb 1-2: can't resume, status -19
[ 2848.946470] hub 1-0:1.0: logical disconnect on port 2
[ 2848.946482] hub 1-0:1.0: state 7 ports 6 chg 0004 evt 0000
[ 2848.946503] hub 1-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
[ 2848.946509] usb 1-2: USB disconnect, address 2
[ 2848.946513] usb 1-2: unregistering device
[ 2848.946518] usb 1-2: usb_disable_device nuking all URBs
[ 2848.946527] usb 1-2: unregistering interface 1-2:1.0
[ 2848.946641] usb 1-2:1.0: uevent
[ 2848.946832] usb 1-2: uevent
[ 2848.999781] ehci_hcd 0000:00:12.2: port 2 high speed
[ 2848.999793] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[ 2849.053098] usb 1-2: new high speed USB device using ehci_hcd and address 6
[ 2854.063108] usb 1-2: khubd timed out on ep0in len=0/64
[ 2859.074696] usb 1-2: khubd timed out on ep0in len=0/64
[ 2864.084319] usb 1-2: khubd timed out on ep0in len=0/64
[ 2864.138091] ehci_hcd 0000:00:12.2: port 2 high speed
[ 2864.138098] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[ 2864.190702] usb 1-2: device descriptor read/64, error -110
[ 2869.304345] usb 1-2: khubd timed out on ep0in len=0/64
[ 2874.314331] usb 1-2: khubd timed out on ep0in len=0/64
[ 2879.324343] usb 1-2: khubd timed out on ep0in len=0/64
[ 2879.376484] ehci_hcd 0000:00:12.2: port 2 high speed
[ 2879.376498] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[ 2879.431014] usb 1-2: device descriptor read/64, error -110
[ 2879.586459] ehci_hcd 0000:00:12.2: port 2 high speed
[ 2879.586470] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[ 2879.640975] usb 1-2: new high speed USB device using ehci_hcd and address 7
[ 2884.651007] usb 1-2: khubd timed out on ep0in len=0/64
[ 2889.661018] usb 1-2: khubd timed out on ep0in len=0/64
[ 2894.669767] usb 1-2: khubd timed out on ep0in len=0/64
[ 2894.724375] ehci_hcd 0000:00:12.2: port 2 high speed
[ 2894.724388] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[ 2894.777659] usb 1-2: device descriptor read/64, error -110
[ 2899.889768] usb 1-2: khubd timed out on ep0in len=0/64
[ 2904.899767] usb 1-2: khubd timed out on ep0in len=0/64
[ 2909.911005] usb 1-2: khubd timed out on ep0in len=0/64
[ 2909.963133] ehci_hcd 0000:00:12.2: port 2 high speed
[ 2909.963146] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[ 2910.017670] usb 1-2: device descriptor read/64, error -110
[ 2910.173112] ehci_hcd 0000:00:12.2: port 2 high speed
[ 2910.173124] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[ 2910.226426] usb 1-2: new high speed USB device using ehci_hcd and address 8
[ 2915.236433] usb 1-2: khubd timed out on ep0out len=0/0
[ 2920.451013] usb 1-2: khubd timed out on ep0out len=0/0
[ 2920.653087] usb 1-2: device not accepting address 8, error -110
[ 2920.706440] ehci_hcd 0000:00:12.2: port 2 high speed
[ 2920.706453] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[ 2920.761014] usb 1-2: new high speed USB device using ehci_hcd and address 9
[ 2925.769756] usb 1-2: khubd timed out on ep0out len=0/0
[ 2930.983089] usb 1-2: khubd timed out on ep0out len=0/0
[ 2931.186418] usb 1-2: device not accepting address 9, error -110
[ 2931.186444] hub 1-0:1.0: unable to enumerate USB device on port 2
[ 2931.189443] usb usb3: usb resume
[ 2931.196413] ohci_hcd 0000:00:12.0: wakeup root hub
[ 2931.196436] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0004
[ 2931.196471] ehci_hcd 0000:00:12.2: GetStatus port 2 status 003002 POWER OWNER sig=se0 CSC
[ 2931.196486] hub 1-0:1.0: port 2, status 0100, change 0001, 12 Mb/s
[ 2931.266413] hub 3-0:1.0: hub_resume
[ 2931.266436] ohci_hcd 0000:00:12.0: GetStatus roothub.portstatus [1] = 0x00010101 CSC PPS CCS
[ 2931.266443] hub 3-0:1.0: port 2: status 0101 change 0001
[ 2931.316428] hub 1-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x100
[ 2931.369762] hub 3-0:1.0: state 7 ports 3 chg 0004 evt 0000
[ 2931.369778] hub 3-0:1.0: port 2, status 0101, change 0000, 12 Mb/s
[ 2931.393105] ohci_hcd 0000:00:12.0: port[1] reset timeout, stat 00000111
[ 2931.443098] ohci_hcd 0000:00:12.0: GetStatus roothub.portstatus [1] = 0x00100103 PRSC PPS PES CCS
[ 2931.496434] usb 3-2: new full speed USB device using ohci_hcd and address 2
[ 2931.519778] ohci_hcd 0000:00:12.0: port[1] reset timeout, stat 00000113
[ 2931.573083] ohci_hcd 0000:00:12.0: GetStatus roothub.portstatus [1] = 0x00100103 PRSC PPS PES CCS
[ 2931.646157] usb 3-2: not running at top speed; connect to a high speed hub
[ 2931.652158] usb 3-2: default language 0x0409
[ 2931.654157] usb 3-2: udev 2, busnum 3, minor = 257
[ 2931.654163] usb 3-2: New USB device found, idVendor=05e3, idProduct=0608
[ 2931.654169] usb 3-2: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[ 2931.654174] usb 3-2: Product: USB2.0 Hub
[ 2931.654647] usb 3-2: uevent
[ 2931.656168] usb 3-2: usb_probe_device
[ 2931.656175] usb 3-2: configuration #1 chosen from 1 choice
[ 2931.657160] usb 3-2: adding 3-2:1.0 (config #1, interface 0)
[ 2931.657207] usb 3-2:1.0: uevent
[ 2931.657319] hub 3-2:1.0: usb_probe_interface
[ 2931.657323] hub 3-2:1.0: usb_probe_interface - got id
[ 2931.657328] hub 3-2:1.0: USB hub found
[ 2931.659154] hub 3-2:1.0: 4 ports detected
[ 2931.659160] hub 3-2:1.0: standalone hub
[ 2931.659164] hub 3-2:1.0: individual port power switching
[ 2931.659168] hub 3-2:1.0: individual port over-current protection
[ 2931.659173] hub 3-2:1.0: TT requires at most 32 FS bit times (2664 ns)
[ 2931.659177] hub 3-2:1.0: Port indicators are supported
[ 2931.659181] hub 3-2:1.0: power on to power good time: 100ms
[ 2931.663153] hub 3-2:1.0: local power source is good
[ 2931.663161] hub 3-2:1.0: enabling power on all ports
[ 2931.676185] drivers/usb/core/inode.c: creating file '002'
[ 2931.676226] hub 3-0:1.0: state 7 ports 3 chg 0000 evt 0004
[ 2931.780180] hub 3-2:1.0: state 7 ports 4 chg 0000 evt 0000

--Boundary-00=_zH1qKILWhFkTdQP
Content-Type: text/plain;
  charset="us-ascii";
  name=".config"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=".config"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.31
# Thu Sep 10 10:45:50 2009
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_HAVE_DYNAMIC_PER_CPU_AREA=y
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_TRAMPOLINE=y
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION="r4"
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set

#
# RCU Subsystem
#
# CONFIG_CLASSIC_RCU is not set
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=64
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_PREEMPT_RCU_TRACE is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=18
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_GROUP_SCHED is not set
# CONFIG_CGROUPS is not set
# CONFIG_SYSFS_DEPRECATED_V2 is not set
CONFIG_RELAY=y
# CONFIG_NAMESPACES is not set
# CONFIG_BLK_DEV_INITRD is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_EMBEDDED=y
# CONFIG_UID16 is not set
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_EXTRA_PASS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_COUNTERS=y

#
# Performance Counters
#
# CONFIG_PERF_COUNTERS is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
# CONFIG_SLUB_DEBUG is not set
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
# CONFIG_MARKERS is not set
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_API_DEBUG=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_SLOW_WORK is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=m
CONFIG_IOSCHED_DEADLINE=m
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_SPARSE_IRQ=y
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
# CONFIG_PARAVIRT_GUEST is not set
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
CONFIG_MK8=y
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_CPU=y
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
# CONFIG_CPU_SUP_INTEL is not set
CONFIG_CPU_SUP_AMD=y
# CONFIG_CPU_SUP_CENTAUR is not set
# CONFIG_X86_DS is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_AMD_IOMMU=y
CONFIG_AMD_IOMMU_STATS=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_IOMMU_API=y
CONFIG_NR_CPUS=4
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_NEW_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_X86_CPU_DEBUG=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y

#
# Memory hotplug is currently incompatible with Software Suspend
#
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_HAVE_MLOCK=y
CONFIG_HAVE_MLOCKED_PAGE_BIT=y
CONFIG_MMU_NOTIFIER=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW_64K=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_VERBOSE is not set
CONFIG_CAN_PM_TRACE=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION_NVS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=m
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_DEBUG=y
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_STAT_DETAILS=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=y
CONFIG_X86_POWERNOW_K8=y
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_DMAR=y
# CONFIG_DMAR_DEFAULT_ON is not set
# CONFIG_DMAR_BROKEN_GFX_WA is not set
CONFIG_DMAR_FLOPPY_WA=y
# CONFIG_INTR_REMAP is not set
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
# CONFIG_PCIEASPM is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_LEGACY is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=m
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
# CONFIG_XFRM_USER is not set
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_IP_MROUTE is not set
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_TCP_CONG_ADVANCED=y
# CONFIG_TCP_CONG_BIC is not set
CONFIG_TCP_CONG_CUBIC=y
# CONFIG_TCP_CONG_WESTWOOD is not set
# CONFIG_TCP_CONG_HTCP is not set
# CONFIG_TCP_CONG_HSTCP is not set
# CONFIG_TCP_CONG_HYBLA is not set
# CONFIG_TCP_CONG_VEGAS is not set
# CONFIG_TCP_CONG_SCALABLE is not set
# CONFIG_TCP_CONG_LP is not set
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
# CONFIG_TCP_CONG_ILLINOIS is not set
# CONFIG_DEFAULT_BIC is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
# CONFIG_IPV6_PRIVACY is not set
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=y
CONFIG_INET6_ESP=y
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=y
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=m
# CONFIG_VLAN_8021Q_GVRP is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=m
CONFIG_BT_L2CAP=m
CONFIG_BT_SCO=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_LL=y
# CONFIG_BT_HCIBCM203X is not set
# CONFIG_BT_HCIBPA10X is not set
# CONFIG_BT_HCIBFUSB is not set
CONFIG_BT_HCIVHCI=m
# CONFIG_AF_RXRPC is not set
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
# CONFIG_RFKILL_INPUT is not set
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=32
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_ISL29003 is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=m
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=m
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
CONFIG_SCSI_AIC7XXX=m
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_LIBFC is not set
# CONFIG_LIBFCOE is not set
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
CONFIG_SCSI_INITIO=m
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_PMP is not set
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
# CONFIG_MD_LINEAR is not set
# CONFIG_MD_RAID0 is not set
CONFIG_MD_RAID1=y
# CONFIG_MD_RAID10 is not set
CONFIG_MD_RAID456=y
CONFIG_MD_RAID6_PQ=y
# CONFIG_MD_MULTIPATH is not set
# CONFIG_MD_FAULTY is not set
# CONFIG_BLK_DEV_DM is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# You can enable one or both FireWire driver stacks.
#

#
# See the help texts for more information.
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
CONFIG_MACVLAN=m
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_NET_ETHERNET is not set
CONFIG_MII=m
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_R8169=m
CONFIG_R8169_VLAN=y
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_JME is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=y
# CONFIG_LIBERTAS is not set
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_HOSTAP is not set
# CONFIG_HERMES is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_USB_HSO is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1680
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=1050
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=m
# CONFIG_JOYSTICK_A3D is not set
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
# CONFIG_JOYSTICK_STINGER is not set
# CONFIG_JOYSTICK_TWIDJOY is not set
# CONFIG_JOYSTICK_ZHENHUA is not set
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_UINPUT is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_GAMEPORT=m
CONFIG_GAMEPORT_NS558=m
# CONFIG_GAMEPORT_L4 is not set
CONFIG_GAMEPORT_EMU10K1=m
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
# CONFIG_DEVKMEM is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set
CONFIG_FIX_EARLYCON_MEM=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=m
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=m
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
CONFIG_I2C_PIIX4=m
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_SIMTEC is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Graphics adapter I2C/DDC channel drivers
#
# CONFIG_I2C_VOODOO3 is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_STUB is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_PCF8575 is not set
# CONFIG_SENSORS_PCA9539 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
CONFIG_SPI=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_BITBANG=m

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_TLE62X0 is not set

#
# PPS support
#
# CONFIG_PPS is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADCXX is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7473 is not set
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_K8TEMP=m
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATK0110 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHER is not set
# CONFIG_SENSORS_FSCPOS is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM70 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_AB3100_CORE is not set
# CONFIG_EZX_PCAP is not set
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
CONFIG_VIDEO_ALLOW_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_DVB_CORE=m
CONFIG_VIDEO_MEDIA=m

#
# Multimedia drivers
#
CONFIG_MEDIA_ATTACH=y
CONFIG_MEDIA_TUNER=m
CONFIG_MEDIA_TUNER_CUSTOMISE=y
CONFIG_MEDIA_TUNER_SIMPLE=m
# CONFIG_MEDIA_TUNER_TDA8290 is not set
# CONFIG_MEDIA_TUNER_TDA827X is not set
# CONFIG_MEDIA_TUNER_TDA18271 is not set
CONFIG_MEDIA_TUNER_TDA9887=m
# CONFIG_MEDIA_TUNER_TEA5761 is not set
# CONFIG_MEDIA_TUNER_TEA5767 is not set
# CONFIG_MEDIA_TUNER_MT20XX is not set
# CONFIG_MEDIA_TUNER_MT2060 is not set
# CONFIG_MEDIA_TUNER_MT2266 is not set
# CONFIG_MEDIA_TUNER_MT2131 is not set
# CONFIG_MEDIA_TUNER_QT1010 is not set
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
# CONFIG_MEDIA_TUNER_MXL5005S is not set
# CONFIG_MEDIA_TUNER_MXL5007T is not set
# CONFIG_MEDIA_TUNER_MC44S803 is not set
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_V4L1=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_VMALLOC=m
CONFIG_VIDEOBUF_DVB=m
CONFIG_VIDEO_BTCX=m
CONFIG_VIDEO_IR=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_VIDEO_IR_I2C=m
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_SAA6588=m
CONFIG_VIDEO_MT9V011=m
CONFIG_VIDEO_SAA711X=m
CONFIG_VIDEO_TVP5150=m
# CONFIG_VIDEO_VIVI is not set
CONFIG_VIDEO_BT848=m
# CONFIG_VIDEO_BT848_DVB is not set
# CONFIG_VIDEO_CPIA is not set
# CONFIG_VIDEO_CPIA2 is not set
# CONFIG_VIDEO_SAA5246A is not set
# CONFIG_VIDEO_SAA5249 is not set
# CONFIG_VIDEO_STRADIS is not set
# CONFIG_VIDEO_ZORAN is not set
# CONFIG_VIDEO_SAA7134 is not set
# CONFIG_VIDEO_MXB is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
# CONFIG_VIDEO_CX88 is not set
# CONFIG_VIDEO_CX23885 is not set
# CONFIG_VIDEO_AU0828 is not set
# CONFIG_VIDEO_IVTV is not set
# CONFIG_VIDEO_CX18 is not set
# CONFIG_VIDEO_CAFE_CCIC is not set
# CONFIG_SOC_CAMERA is not set
CONFIG_V4L_USB_DRIVERS=y
# CONFIG_USB_VIDEO_CLASS is not set
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
# CONFIG_USB_GSPCA is not set
# CONFIG_VIDEO_PVRUSB2 is not set
# CONFIG_VIDEO_HDPVR is not set
CONFIG_VIDEO_EM28XX=m
CONFIG_VIDEO_EM28XX_ALSA=m
CONFIG_VIDEO_EM28XX_DVB=m
# CONFIG_VIDEO_CX231XX is not set
# CONFIG_VIDEO_USBVISION is not set
# CONFIG_USB_VICAM is not set
# CONFIG_USB_IBMCAM is not set
# CONFIG_USB_KONICAWC is not set
# CONFIG_USB_QUICKCAM_MESSENGER is not set
# CONFIG_USB_ET61X251 is not set
# CONFIG_VIDEO_OVCAMCHIP is not set
# CONFIG_USB_OV511 is not set
# CONFIG_USB_SE401 is not set
# CONFIG_USB_SN9C102 is not set
# CONFIG_USB_STV680 is not set
# CONFIG_USB_ZC0301 is not set
# CONFIG_USB_PWC is not set
# CONFIG_USB_PWC_INPUT_EVDEV is not set
# CONFIG_USB_ZR364XX is not set
# CONFIG_USB_STKWEBCAM is not set
# CONFIG_USB_S2255 is not set
# CONFIG_RADIO_ADAPTERS is not set
# CONFIG_DVB_DYNAMIC_MINORS is not set
CONFIG_DVB_CAPTURE_DRIVERS=y

#
# Supported SAA7146 based PCI Adapters
#
# CONFIG_TTPCI_EEPROM is not set
# CONFIG_DVB_AV7110 is not set
# CONFIG_DVB_BUDGET_CORE is not set

#
# Supported USB Adapters
#
# CONFIG_DVB_USB is not set
# CONFIG_DVB_TTUSB_BUDGET is not set
# CONFIG_DVB_TTUSB_DEC is not set
# CONFIG_SMS_SIANO_MDTV is not set

#
# Supported FlexCopII (B2C2) Adapters
#
# CONFIG_DVB_B2C2_FLEXCOP is not set

#
# Supported BT878 Adapters
#
# CONFIG_DVB_BT8XX is not set

#
# Supported Pluto2 Adapters
#
# CONFIG_DVB_PLUTO2 is not set

#
# Supported SDMC DM1105 Adapters
#
# CONFIG_DVB_DM1105 is not set

#
# Supported DVB Frontends
#
# CONFIG_DVB_FE_CUSTOMISE is not set
CONFIG_DVB_ZL10353=m
CONFIG_DVB_LGDT330X=m
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
CONFIG_DRM=m
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_I810 is not set
# CONFIG_DRM_I830 is not set
CONFIG_DRM_I915=m
CONFIG_DRM_I915_KMS=y
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=m
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=m
CONFIG_BACKLIGHT_GENERIC=m
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_MBP_NVIDIA is not set
# CONFIG_BACKLIGHT_SAHARA is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=128
CONFIG_DUMMY_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE is not set
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SND=y
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=m
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_RAWMIDI_SEQ=m
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
CONFIG_SND_EMU10K1_SEQ=m
CONFIG_SND_MPU401_UART=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
# CONFIG_SND_PCSP is not set
# CONFIG_SND_DUMMY is not set
CONFIG_SND_VIRMIDI=m
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
CONFIG_SND_MPU401=m
# CONFIG_SND_AC97_POWER_SAVE is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
CONFIG_SND_EMU10K1=m
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_HWDEP=y
# CONFIG_SND_HDA_RECONFIG is not set
# CONFIG_SND_HDA_INPUT_BEEP is not set
# CONFIG_SND_HDA_INPUT_JACK is not set
CONFIG_SND_HDA_CODEC_REALTEK=y
# CONFIG_SND_HDA_CODEC_ANALOG is not set
# CONFIG_SND_HDA_CODEC_SIGMATEL is not set
# CONFIG_SND_HDA_CODEC_VIA is not set
CONFIG_SND_HDA_CODEC_ATIHDMI=y
# CONFIG_SND_HDA_CODEC_NVHDMI is not set
# CONFIG_SND_HDA_CODEC_INTELHDMI is not set
# CONFIG_SND_HDA_CODEC_CONEXANT is not set
# CONFIG_SND_HDA_CODEC_CA0110 is not set
# CONFIG_SND_HDA_CODEC_CMEDIA is not set
# CONFIG_SND_HDA_CODEC_SI3054 is not set
CONFIG_SND_HDA_GENERIC=y
# CONFIG_SND_HDA_POWER_SAVE is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_HIFIER is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
# CONFIG_SND_SPI is not set
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set
# CONFIG_SND_USB_US122L is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=m
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HID_DEBUG=y
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_APPLE=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
CONFIG_HID_EZKEY=y
# CONFIG_HID_KYE is not set
CONFIG_HID_GYRATION=y
# CONFIG_HID_KENSINGTON is not set
CONFIG_HID_LOGITECH=y
CONFIG_LOGITECH_FF=y
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_NTRIG=y
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
CONFIG_HID_SUNPLUS=y
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
CONFIG_HID_TOPSEED=y
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
# CONFIG_HID_ZEROPLUS is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
CONFIG_USB_DEBUG=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_MON=y
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=m
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_OHCI_HCD=m
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_VST is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_ALIX2 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_BD2802 is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T94 is not set
# CONFIG_RTC_DRV_DS1305 is not set
# CONFIG_RTC_DRV_DS1390 is not set
# CONFIG_RTC_DRV_MAX6902 is not set
# CONFIG_RTC_DRV_R9701 is not set
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_DS3234 is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y

#
# DMA Devices
#
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set

#
# TI VLYNQ
#
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
# CONFIG_EXT3_FS is not set
# CONFIG_EXT4_FS is not set
CONFIG_REISER4_FS=y
# CONFIG_REISER4_DEBUG is not set
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
# CONFIG_REISERFS_FS_XATTR is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=850
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-15"
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_NILFS2_FS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=m
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=m
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=m
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=m
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_KERNEL is not set
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_BUGVERBOSE is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
CONFIG_LATENCYTOP=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_FTRACE_SYSCALLS=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
CONFIG_OPTIMIZE_INLINING=y

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
# CONFIG_IMA is not set
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_WORKQUEUE=y
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
# CONFIG_KVM_INTEL is not set
CONFIG_KVM_AMD=m
# CONFIG_KVM_TRACE is not set
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_NLATTR=y

--Boundary-00=_zH1qKILWhFkTdQP--
