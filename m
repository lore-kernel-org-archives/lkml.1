Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbZILSbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbZILSbL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 14:31:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754670AbZILSbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 14:31:09 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:60295 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645AbZILSbH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 14:31:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=IunE1rxHJXl23NEi7wKJ+JqTGVCtZs/eRMLJrnV4zNz1Nq0dJ+xFVuD6Qo9Vco2MFL
         Vprvcokiz6dc3EMkLvvLSUNaU24k+CvehPiFkvDRZaoB3k/YwXA0H2cjfbp+5LEuNdGo
         dNVofLjVlT1vXazESqTEDZqonHPdTs8d4PkhE=
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31 ehci problem - mouse dead on scroll
From: Volker Armin Hemmann <volkerarmin@googlemail.com>
Date: Sat, 12 Sep 2009 20:31:05 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <200909122031.06082.volkerarmin@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Samstag 12 September 2009, you wrote:
> Hi,
> 
> I have a nice logitech wireless mouse. With 2.6.30 and earlier it works
>  well.
> 
> With 2.6.31 it sometimes kills the ehci bus, if I scroll too fast. Very
>  slow scrolling is ok, not scrolling is ok. Fast scrolling, bus is dead and
>  dmesg looks like this:
> 
> [  879.193292] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.193308] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  879.193316] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.193325] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.193774] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  879.193780] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.253291] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.253306] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  879.253312] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.253319] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.253770] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  879.253776] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.267040] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.267055] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  879.267063] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.267071] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.267666] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  879.267675] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.280372] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.280386] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  879.280392] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.280400] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.281539] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  879.281548] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.341202] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.341216] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  879.341222] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.341229] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.341788] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  879.341797] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.401202] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.401216] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  879.401222] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.401230] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.402035] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  879.402043] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.461202] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.461216] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  879.461222] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.461229] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.461778] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  879.461786] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.521203] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.521217] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  879.521223] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.521230] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.522027] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  879.522035] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.581204] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.581218] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  879.581224] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.581232] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.581765] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  879.581773] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.641198] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.641212] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  879.641218] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.641226] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.642018] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  879.642027] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.701202] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.701216] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  879.701222] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.701230] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.701762] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  879.701770] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.761201] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.761215] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  879.761221] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.761229] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.762010] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  879.762018] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.821206] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.821220] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  879.821226] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.821234] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.821763] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  879.821771] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.881203] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.881217] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  879.881223] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.881230] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.882001] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  879.882010] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.941205] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.941219] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  879.941225] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.941233] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  879.941721] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  879.941727] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.000665] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.000679] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  880.000686] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.000694] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.001243] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  880.001251] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.061201] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.061215] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  880.061221] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.061228] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.061712] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  880.061718] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.121200] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.121213] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  880.121219] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.121226] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.121982] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  880.121990] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.181204] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.181217] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  880.181223] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.181231] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.181704] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  880.181710] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.241202] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.241216] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  880.241222] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.241229] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.241973] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  880.241982] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.301205] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.301218] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  880.301224] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.301232] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.301696] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  880.301702] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.361202] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.361216] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  880.361222] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.361229] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.361965] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  880.361973] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.421204] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.421218] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  880.421224] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.421231] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.421687] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  880.421693] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.481202] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.481216] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  880.481222] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.481229] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.481957] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  880.481965] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.541204] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.541218] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  880.541224] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.541231] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.541827] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  880.541835] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.600584] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.600597] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  880.600603] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.600611] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.601210] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  880.601218] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.661204] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.661218] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  880.661224] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.661231] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.661670] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  880.661676] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.721202] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.721215] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  880.721221] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.721229] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.721940] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  880.721948] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.781204] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.781217] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  880.781223] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.781231] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.781662] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  880.781668] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.841202] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.841215] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  880.841221] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.841229] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.841931] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  880.841939] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.901204] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.901217] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  880.901223] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.901230] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.901653] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  880.901659] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.959949] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.959963] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  880.959969] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.959977] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  880.960400] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  880.960406] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.019964] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.019979] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  881.019987] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.019995] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.021057] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  881.021066] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.080653] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.080667] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  881.080673] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.080681] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.081143] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  881.081149] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.140567] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.140581] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  881.140587] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.140594] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.141652] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  881.141661] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.200516] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.200529] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  881.200535] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.200543] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.201156] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  881.201165] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.260490] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.260504] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  881.260510] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.260517] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.261049] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  881.261057] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.319954] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.319969] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  881.319976] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.319984] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.320387] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  881.320394] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.380653] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.380666] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  881.380672] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.380680] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.381627] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  881.381633] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.440598] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.440611] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  881.440618] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.440625] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.441159] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  881.441167] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.500563] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.500577] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  881.500583] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.500590] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.501625] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  881.501634] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.560402] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.560415] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  881.560421] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.560428] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.561132] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  881.561140] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.619961] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.619974] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  881.619980] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.619988] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  881.620877] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
> [  881.620885] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> 
> 
> and the only thing to get the mouse back is rmmod ehci_hcd modprobe
>  ehci_hcd.
> 
> It does not happen everytime - of course always if it is most annoying and
> never when I really don't care ;)
> 
> mouse is attached to a 4port revoltec disk usb 2.0 hub with an external
>  power brick.
> 
> 
> When I want to attach the mouse directly, I have to load ohci_hcd FIRST.
>  AND after that lsusb just hangs, but I seem to be able to scroll as much
>  as I want.
> 
>  2762.596422] ohci_hcd 0000:00:14.5: auto-stop root hub
> [ 2762.596444] ohci_hcd 0000:00:13.1: auto-stop root hub
> [ 2762.596460] ohci_hcd 0000:00:13.0: auto-stop root hub
> [ 2762.596476] ohci_hcd 0000:00:12.0: auto-stop root hub
> [ 2764.317678] hub 7-0:1.0: hub_suspend
> [ 2764.317693] usb usb7: bus auto-suspend
> [ 2764.317701] ohci_hcd 0000:00:14.5: suspend root hub
> [ 2764.317711] hub 6-0:1.0: hub_suspend
> [ 2764.317717] usb usb6: bus auto-suspend
> [ 2764.317722] ohci_hcd 0000:00:13.1: suspend root hub
> [ 2764.317730] hub 5-0:1.0: hub_suspend
> [ 2764.317736] usb usb5: bus auto-suspend
> [ 2764.317741] ohci_hcd 0000:00:13.0: suspend root hub
> [ 2764.317748] hub 3-0:1.0: hub_suspend
> [ 2764.317753] usb usb3: bus auto-suspend
> [ 2764.317758] ohci_hcd 0000:00:12.0: suspend root hub
> [ 2764.317766] hub 2-0:1.0: hub_suspend
> [ 2764.317771] usb usb2: bus auto-suspend
> [ 2764.317775] ehci_hcd 0000:00:13.2: suspend root hub
> [ 2766.703520] usb 1-2: lsusb timed out on ep0in len=0/2
> [ 2766.703529] usb 1-2: retry with reset-resume
> [ 2766.756878] ehci_hcd 0000:00:12.2: port 2 high speed
> [ 2766.756891] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER
> sig=se0 PE CONNECT
> [ 2766.810184] usb 1-2: reset high speed USB device using ehci_hcd and
>  address 2
> [ 2771.819775] usb 1-2: lsusb timed out on ep0in len=0/64
> [ 2776.830158] usb 1-2: lsusb timed out on ep0in len=0/64
> [ 2781.839773] usb 1-2: lsusb timed out on ep0in len=0/64
> [ 2781.893563] ehci_hcd 0000:00:12.2: port 2 high speed
> [ 2781.893576] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER
> sig=se0 PE CONNECT
> [ 2781.946445] usb 1-2: device descriptor read/64, error -110
> [ 2787.059772] usb 1-2: lsusb timed out on ep0in len=0/64
> [ 2792.069779] usb 1-2: lsusb timed out on ep0in len=0/64
> [ 2797.079778] usb 1-2: lsusb timed out on ep0in len=0/64
> [ 2797.133554] ehci_hcd 0000:00:12.2: port 2 high speed
> [ 2797.133567] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER
> sig=se0 PE CONNECT
> [ 2797.186444] usb 1-2: device descriptor read/64, error -110
> [ 2797.343527] ehci_hcd 0000:00:12.2: port 2 high speed
> [ 2797.343540] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER
> sig=se0 PE CONNECT
> [ 2797.396442] usb 1-2: reset high speed USB device using ehci_hcd and
>  address 2
> [ 2802.406446] usb 1-2: lsusb timed out on ep0in len=0/64
> [ 2807.416445] usb 1-2: lsusb timed out on ep0in len=0/64
> [ 2812.426443] usb 1-2: lsusb timed out on ep0in len=0/64
> [ 2812.480192] ehci_hcd 0000:00:12.2: port 2 high speed
> [ 2812.480205] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER
> sig=se0 PE CONNECT
> [ 2812.533519] usb 1-2: device descriptor read/64, error -110
> [ 2817.646850] usb 1-2: lsusb timed out on ep0in len=0/64
> 
> 
> Here is lspci:
> 
> lspci -v
> 00:00.0 Host bridge: ATI Technologies Inc RX780/RX790 Chipset Host Bridge
>         Subsystem: ASRock Incorporation A770CrossFire Motherboard
>         Flags: bus master, 66MHz, medium devsel, latency 0
>         Memory at <ignored> (64-bit, non-prefetchable)
>         Capabilities: [c4] HyperTransport: Slave or Primary Interface
>         Capabilities: [40] HyperTransport: Retry Mode
>         Capabilities: [54] HyperTransport: UnitID Clumping
>         Capabilities: [9c] HyperTransport: #1a
> 
> 00:02.0 PCI bridge: ATI Technologies Inc RD790 PCI to PCI bridge (external
> gfx0 port A) (prog-if 00 [Normal decode])
>         Flags: bus master, fast devsel, latency 0
>         Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
>         I/O behind bridge: 0000c000-0000cfff
>         Memory behind bridge: fdf00000-fdffffff
>         Prefetchable memory behind bridge:
>  00000000d0000000-00000000dfffffff Capabilities: [50] Power Management
>  version 3
>         Capabilities: [58] Express Root Port (Slot-), MSI 00
>         Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit-
>         Capabilities: [b0] Subsystem: ASRock Incorporation A770CrossFire
> Motherboard
>         Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
>         Capabilities: [100] Vendor Specific Information <?>
>         Capabilities: [110] Virtual Channel <?>
>         Kernel driver in use: pcieport-driver
> 
> 00:09.0 PCI bridge: ATI Technologies Inc RD790 PCI to PCI bridge (PCI
>  express gpp port E) (prog-if 00 [Normal decode])
>         Flags: bus master, fast devsel, latency 0
>         Bus: primary=00, secondary=03, subordinate=04, sec-latency=0
>         I/O behind bridge: 0000d000-0000dfff
>         Memory behind bridge: fe000000-febfffff
>         Prefetchable memory behind bridge:
>  00000000fa000000-00000000fcefffff Capabilities: [50] Power Management
>  version 3
>         Capabilities: [58] Express Root Port (Slot-), MSI 00
>         Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit-
>         Capabilities: [b0] Subsystem: ASRock Incorporation A770CrossFire
> Motherboard
>         Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
>         Capabilities: [100] Vendor Specific Information <?>
>         Capabilities: [110] Virtual Channel <?>
>         Kernel driver in use: pcieport-driver
> 
> 00:0a.0 PCI bridge: ATI Technologies Inc RD790 PCI to PCI bridge (PCI
>  express gpp port F) (prog-if 00 [Normal decode])
>         Flags: bus master, fast devsel, latency 0
>         Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
>         I/O behind bridge: 0000b000-0000bfff
>         Memory behind bridge: fde00000-fdefffff
>         Prefetchable memory behind bridge:
>  00000000cff00000-00000000cfffffff Capabilities: [50] Power Management
>  version 3
>         Capabilities: [58] Express Root Port (Slot-), MSI 00
>         Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit-
>         Capabilities: [b0] Subsystem: ASRock Incorporation A770CrossFire
> Motherboard
>         Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
>         Capabilities: [100] Vendor Specific Information <?>
>         Capabilities: [110] Virtual Channel <?>
>         Kernel driver in use: pcieport-driver
> 
> 00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA Controller
> [AHCI mode] (prog-if 01 [AHCI 1.0])
>         Subsystem: ASRock Incorporation Device 4391
>         Flags: bus master, 66MHz, medium devsel, latency 128, IRQ 22
>         I/O ports at a000 [size=8]
>         I/O ports at 9000 [size=4]
>         I/O ports at 8000 [size=8]
>         I/O ports at 7000 [size=4]
>         I/O ports at 6000 [size=16]
>         Memory at fddff800 (32-bit, non-prefetchable) [size=1K]
>         Capabilities: [60] Power Management version 2
>         Capabilities: [70] SATA HBA <?>
>         Kernel driver in use: ahci
> 
> 00:12.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0
>  Controller (prog-if 10 [OHCI])
>         Subsystem: ASRock Incorporation Device 4397
>         Flags: bus master, 66MHz, medium devsel, latency 128, IRQ 7
>         Memory at fddfe000 (32-bit, non-prefetchable) [size=4K]
>         Kernel modules: ohci-hcd
> 
> 00:12.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller
>  (prog- if 10 [OHCI])
>         Subsystem: ASRock Incorporation Device 4398
>         Flags: bus master, 66MHz, medium devsel, latency 128, IRQ 7
>         Memory at fddfd000 (32-bit, non-prefetchable) [size=4K]
>         Kernel modules: ohci-hcd
> 
> 00:12.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI
>  Controller (prog-if 20 [EHCI])
>         Subsystem: ASRock Incorporation Device 4396
>         Flags: bus master, 66MHz, medium devsel, latency 128, IRQ 17
>         Memory at fddff000 (32-bit, non-prefetchable) [size=256]
>         Capabilities: [c0] Power Management version 2
>         Capabilities: [e4] Debug port: BAR=1 offset=00e0
>         Kernel driver in use: ehci_hcd
>         Kernel modules: ehci-hcd
> 
> 00:13.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0
>  Controller (prog-if 10 [OHCI])
>         Subsystem: ASRock Incorporation Device 4397
>         Flags: bus master, 66MHz, medium devsel, latency 128, IRQ 10
>         Memory at fddfc000 (32-bit, non-prefetchable) [size=4K]
>         Kernel modules: ohci-hcd
> 
> 00:13.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller
>  (prog- if 10 [OHCI])
>         Subsystem: ASRock Incorporation Device 4398
>         Flags: bus master, 66MHz, medium devsel, latency 128, IRQ 10
>         Memory at fddf7000 (32-bit, non-prefetchable) [size=4K]
>         Kernel modules: ohci-hcd
> 
> 00:13.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI
>  Controller (prog-if 20 [EHCI])
>         Subsystem: ASRock Incorporation Device 4396
>         Flags: bus master, 66MHz, medium devsel, latency 128, IRQ 19
>         Memory at fddf6800 (32-bit, non-prefetchable) [size=256]
>         Capabilities: [c0] Power Management version 2
>         Capabilities: [e4] Debug port: BAR=1 offset=00e0
>         Kernel driver in use: ehci_hcd
>         Kernel modules: ehci-hcd
> 
> 00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 3a)
>         Subsystem: ASRock Incorporation Device 4385
>         Flags: 66MHz, medium devsel
>         Capabilities: [b0] HyperTransport: MSI Mapping Enable- Fixed+
>         Kernel modules: i2c-piix4
> 
> 00:14.1 IDE interface: ATI Technologies Inc SB700/SB800 IDE Controller
>  (prog- if 8a [Master SecP PriP])
>         Subsystem: ASRock Incorporation Device 439c
>         Flags: bus master, 66MHz, medium devsel, latency 0
>         I/O ports at 01f0 [size=8]
>         I/O ports at 03f4 [size=1]
>         I/O ports at 0170 [size=8]
>         I/O ports at 0374 [size=1]
>         I/O ports at ff00 [size=16]
>         Capabilities: [70] MSI: Enable- Count=1/1 Maskable- 64bit-
> 
> 00:14.3 ISA bridge: ATI Technologies Inc SB700/SB800 LPC host controller
>         Subsystem: ASRock Incorporation Device 439d
>         Flags: bus master, 66MHz, medium devsel, latency 0
> 
> 00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge (prog-if
>  01 [Subtractive decode])
>         Flags: bus master, 66MHz, medium devsel, latency 64
>         Bus: primary=00, secondary=05, subordinate=05, sec-latency=64
>         I/O behind bridge: 0000e000-0000efff
>         Prefetchable memory behind bridge: fcf00000-fcffffff
> 
> 00:14.5 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI2
>  Controller (prog-if 10 [OHCI])
>         Subsystem: ASRock Incorporation Device 4399
>         Flags: bus master, 66MHz, medium devsel, latency 128, IRQ 10
>         Memory at fddf5000 (32-bit, non-prefetchable) [size=4K]
>         Kernel modules: ohci-hcd
> 
> 00:18.0 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64,
> Sempron] HyperTransport Configuration
>         Flags: fast devsel
>         Capabilities: [80] HyperTransport: Host or Secondary Interface
> 
> 00:18.1 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64,
> Sempron] Address Map
>         Flags: fast devsel
> 
> 00:18.2 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64,
> Sempron] DRAM Controller
>         Flags: fast devsel
> 
> 00:18.3 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64,
> Sempron] Miscellaneous Control
>         Flags: fast devsel
>         Capabilities: [f0] Secure device <?>
> 
> 00:18.4 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64,
> Sempron] Link Control
>         Flags: fast devsel
> 
> 01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B
>  PCI Express Gigabit Ethernet controller (rev 02)
>         Subsystem: ASRock Incorporation Motherboard (one of many)
>         Flags: bus master, fast devsel, latency 0, IRQ 28
>         I/O ports at b800 [size=256]
>         Memory at cffff000 (64-bit, prefetchable) [size=4K]
>         Memory at cffe0000 (64-bit, prefetchable) [size=64K]
>         Expansion ROM at fdef0000 [disabled] [size=64K]
>         Capabilities: [40] Power Management version 3
>         Capabilities: [50] MSI: Enable+ Count=1/2 Maskable- 64bit+
>         Capabilities: [70] Express Endpoint, MSI 01
>         Capabilities: [b0] MSI-X: Enable- Count=2 Masked-
>         Capabilities: [d0] Vital Product Data
>         Capabilities: [100] Advanced Error Reporting
>         Capabilities: [140] Virtual Channel <?>
>         Capabilities: [160] Device Serial Number 78-56-34-12-68-4c-e0-00
>         Kernel driver in use: r8169
>         Kernel modules: r8169
> 
> 02:00.0 VGA compatible controller: ATI Technologies Inc Radeon HD 3870
>  (prog- if 00 [VGA controller])
>         Subsystem: Info-Tek Corp. Device 4070
>         Flags: bus master, fast devsel, latency 0, IRQ 29
>         Memory at d0000000 (64-bit, prefetchable) [size=256M]
>         Memory at fdff0000 (64-bit, non-prefetchable) [size=64K]
>         I/O ports at c000 [size=256]
>         Expansion ROM at fdfc0000 [disabled] [size=128K]
>         Capabilities: [50] Power Management version 3
>         Capabilities: [58] Express Legacy Endpoint, MSI 00
>         Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
>         Capabilities: [100] Vendor Specific Information <?>
>         Kernel driver in use: fglrx_pci
>         Kernel modules: fglrx
> 
> 02:00.1 Audio device: ATI Technologies Inc Radeon HD 3870 Audio device
>         Subsystem: Info-Tek Corp. Device aa18
>         Flags: bus master, fast devsel, latency 0, IRQ 10
>         Memory at fdfec000 (64-bit, non-prefetchable) [size=16K]
>         Capabilities: [50] Power Management version 3
>         Capabilities: [58] Express Legacy Endpoint, MSI 00
>         Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
>         Capabilities: [100] Vendor Specific Information <?>
>         Kernel modules: snd-hda-intel
> 
> 05:06.0 Multimedia video controller: Brooktree Corporation Bt848 Video
>  Capture (rev 12)
>         Flags: bus master, medium devsel, latency 128, IRQ 21
>         Memory at fcfff000 (32-bit, prefetchable) [size=4K]
>         Kernel driver in use: bttv
>         Kernel modules: bttv
> 
> 05:08.0 Multimedia audio controller: Creative Labs SB0400 Audigy2 Value
>         Subsystem: Creative Labs Device 1001
>         Flags: bus master, medium devsel, latency 128, IRQ 23
>         I/O ports at e800 [size=64]
>         Capabilities: [dc] Power Management version 2
>         Kernel driver in use: EMU10K1_Audigy
>         Kernel modules: snd-emu10k1
> 
> lsusb:
> lsusb -v
> 
> Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass            9 Hub
>   bDeviceSubClass         0 Unused
>   bDeviceProtocol         0 Full speed (or root) hub
>   bMaxPacketSize0        64
>   idVendor           0x1d6b Linux Foundation
>   idProduct          0x0002 2.0 root hub
>   bcdDevice            2.06
>   iManufacturer           3 Linux 2.6.31r4 ehci_hcd
>   iProduct                2 EHCI Host Controller
>   iSerial                 1 0000:00:13.2
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength           25
>     bNumInterfaces          1
>     bConfigurationValue     1
>     iConfiguration          0
>     bmAttributes         0xe0
>       Self Powered
>       Remote Wakeup
>     MaxPower                0mA
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           1
>       bInterfaceClass         9 Hub
>       bInterfaceSubClass      0 Unused
>       bInterfaceProtocol      0 Full speed (or root) hub
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0004  1x 4 bytes
>         bInterval              12
> Hub Descriptor:
>   bLength               9
>   bDescriptorType      41
>   nNbrPorts             6
>   wHubCharacteristic 0x000a
>     No power switching (usb 1.0)
>     Per-port overcurrent protection
>   bPwrOn2PwrGood       10 * 2 milli seconds
>   bHubContrCurrent      0 milli Ampere
>   DeviceRemovable    0x00
>   PortPwrCtrlMask    0xff
>  Hub Port Status:
>    Port 1: 0000.0100 power
>    Port 2: 0000.0100 power
>    Port 3: 0000.0100 power
>    Port 4: 0000.0100 power
>    Port 5: 0000.0100 power
>    Port 6: 0000.0100 power
> Device Status:     0x0003
>   Self Powered
>   Remote Wakeup Enabled
> 
> Bus 001 Device 003: ID 046d:c518 Logitech, Inc. MX610 Laser Cordless Mouse
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0
>   bDeviceProtocol         0
>   bMaxPacketSize0         8
>   idVendor           0x046d Logitech, Inc.
>   idProduct          0xc518 MX610 Laser Cordless Mouse
>   bcdDevice           42.03
>   iManufacturer           1 Logitech
>   iProduct                2 USB Receiver
>   iSerial                 0
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength           59
>     bNumInterfaces          2
>     bConfigurationValue     1
>     iConfiguration          4 RR42.03_B0039
>     bmAttributes         0xa0
>       (Bus Powered)
>       Remote Wakeup
>     MaxPower               98mA
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           1
>       bInterfaceClass         3 Human Interface Device
>       bInterfaceSubClass      1 Boot Interface Subclass
>       bInterfaceProtocol      2 Mouse
>       iInterface              0
>       ** UNRECOGNIZED:  09 21 11 01 00 01 22 43 00
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0008  1x 8 bytes
>         bInterval              10
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        1
>       bAlternateSetting       0
>       bNumEndpoints           1
>       bInterfaceClass         3 Human Interface Device
>       bInterfaceSubClass      0 No Subclass
>       bInterfaceProtocol      0 None
>       iInterface              0
>       ** UNRECOGNIZED:  09 21 11 01 00 01 22 4f 00
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0008  1x 8 bytes
>         bInterval              10
> Device Status:     0x0000
>   (Bus Powered)
> 
> Bus 001 Device 002: ID 05e3:0608 Genesys Logic, Inc. USB-2.0 4-Port HUB
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass            9 Hub
>   bDeviceSubClass         0 Unused
>   bDeviceProtocol         1 Single TT
>   bMaxPacketSize0        64
>   idVendor           0x05e3 Genesys Logic, Inc.
>   idProduct          0x0608 USB-2.0 4-Port HUB
>   bcdDevice            7.02
>   iManufacturer           0
>   iProduct                1 USB2.0 Hub
>   iSerial                 0
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength           25
>     bNumInterfaces          1
>     bConfigurationValue     1
>     iConfiguration          0
>     bmAttributes         0xe0
>       Self Powered
>       Remote Wakeup
>     MaxPower              100mA
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           1
>       bInterfaceClass         9 Hub
>       bInterfaceSubClass      0 Unused
>       bInterfaceProtocol      0 Full speed (or root) hub
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0001  1x 1 bytes
>         bInterval              12
> Hub Descriptor:
>   bLength               9
>   bDescriptorType      41
>   nNbrPorts             4
>   wHubCharacteristic 0x00e9
>     Per-port power switching
>     Per-port overcurrent protection
>     TT think time 32 FS bits
>     Port indicators
>   bPwrOn2PwrGood       50 * 2 milli seconds
>   bHubContrCurrent    100 milli Ampere
>   DeviceRemovable    0x00
>   PortPwrCtrlMask    0xff
>  Hub Port Status:
>    Port 1: 0000.0100 power
>    Port 2: 0000.0303 lowspeed power enable connect
>    Port 3: 0000.0100 power
>    Port 4: 0000.0100 power
> Device Qualifier (for other device speed):
>   bLength                10
>   bDescriptorType         6
>   bcdUSB               2.00
>   bDeviceClass            9 Hub
>   bDeviceSubClass         0 Unused
>   bDeviceProtocol         0 Full speed (or root) hub
>   bMaxPacketSize0        64
>   bNumConfigurations      1
> Device Status:     0x0003
>   Self Powered
>   Remote Wakeup Enabled
> 
> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass            9 Hub
>   bDeviceSubClass         0 Unused
>   bDeviceProtocol         0 Full speed (or root) hub
>   bMaxPacketSize0        64
>   idVendor           0x1d6b Linux Foundation
>   idProduct          0x0002 2.0 root hub
>   bcdDevice            2.06
>   iManufacturer           3 Linux 2.6.31r4 ehci_hcd
>   iProduct                2 EHCI Host Controller
>   iSerial                 1 0000:00:12.2
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength           25
>     bNumInterfaces          1
>     bConfigurationValue     1
>     iConfiguration          0
>     bmAttributes         0xe0
>       Self Powered
>       Remote Wakeup
>     MaxPower                0mA
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           1
>       bInterfaceClass         9 Hub
>       bInterfaceSubClass      0 Unused
>       bInterfaceProtocol      0 Full speed (or root) hub
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0004  1x 4 bytes
>         bInterval              12
> Hub Descriptor:
>   bLength               9
>   bDescriptorType      41
>   nNbrPorts             6
>   wHubCharacteristic 0x000a
>     No power switching (usb 1.0)
>     Per-port overcurrent protection
>   bPwrOn2PwrGood       10 * 2 milli seconds
>   bHubContrCurrent      0 milli Ampere
>   DeviceRemovable    0x00
>   PortPwrCtrlMask    0xff
>  Hub Port Status:
>    Port 1: 0000.0100 power
>    Port 2: 0000.0503 highspeed power enable connect
>    Port 3: 0000.0100 power
>    Port 4: 0000.0100 power
>    Port 5: 0000.0100 power
>    Port 6: 0000.0100 power
> Device Status:     0x0003
>   Self Powered
>   Remote Wakeup Enabled
> 
> config&dmesg are attached.
> 
> Glück Auf,
> Volker
> 
> 
> ps. if you think it makes a difference I can redo it without fglrx.
> 
> pps. please cc me, not subscribed.
> 

one more thing:
when I use ohci for the mouse, mouse is very jerky. 
when I attach the mouse receiver to the hub and unload ohci, mouse is smooth, 
but fast scrolling might lock it up


