Return-Path: <linux-kernel-owner+w=401wt.eu-S1762007AbXGXOkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762007AbXGXOkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 10:40:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbXGXOjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 10:39:55 -0400
Received: from cust198-202.dsl.versadsl.be ([62.166.198.202]:60847 "HELO
	idefix.wisa.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750853AbXGXOjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 10:39:55 -0400
Date: Tue, 24 Jul 2007 16:39:52 +0200 (CEST)
From: =?ISO-8859-1?Q?Dani=EBl_Mantione?= <daniel.mantione@freepascal.org>
X-X-Sender: daniel@idefix.wisa.be
To: Helge Hafting <helge.hafting@aitel.hist.no>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Keyboard programming needs root
In-Reply-To: <46A6072D.7020807@aitel.hist.no>
Message-ID: <Pine.LNX.4.61.0707241633020.939@idefix.wisa.be>
References: <f79qnt$rn3$1@sea.gmane.org> <d120d5000707190817t62013ddcg966bd4e8c0ec116f@mail.gmail.com>
 <Pine.LNX.4.61.0707191748340.10291@idefix.wisa.be> <46A6072D.7020807@aitel.hist.no>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="657924-1677778228-1185287992=:939"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--657924-1677778228-1185287992=:939
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE



Op Tue, 24 Jul 2007, schreef Helge Hafting:

> The normal way is to set permissions on the device in
> question - give either root only or the logged-in user
> write access as needed.
>=20
> It seems to me that "loadkeys" uses /dev/tty / /dev/tty0
> So set permissions on that as needed.

This won't work. Under the old behaviour, if you were owner of the tty,=20
you were boss of its keymap. Code was added that checks for explicit root=
=20
permissions (actually CAP_SYS_TTY_CONFIG, but this is root in practise),=20
so, currently, nothing regarding permissions works.

I agree, that setting a permission would be ideal, this way the sysadmin=20
can enforce his prefered policy, rather than having it hardwired into the=
=20
kernel.

Dani=EBl
--657924-1677778228-1185287992=:939--
