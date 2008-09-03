Return-Path: <linux-kernel-owner+w=401wt.eu-S1756351AbYICUC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351AbYICUC5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 16:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbYICUCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 16:02:46 -0400
Received: from xenotime.net ([66.160.160.81]:51479 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753724AbYICUCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 16:02:43 -0400
Date: Wed, 3 Sep 2008 13:02:42 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: Nir Tzachar <tzachar@grad120a.cs.bgu.ac.il>, linux-kernel@vger.kernel.org,
       zippel@linux-m68k.org, linux-kbuild@vger.kernel.org,
       Nir Tzachar <nir@tzachar.com>
Subject: Re: [PATCH] ncurses based config
In-Reply-To: <200809032138.14651.bzolnier@gmail.com>
Message-ID: <Pine.LNX.4.64.0809031259110.20541@shark.he.net>
References: <1220469076-16487-1-git-send-email-nir@tzachar.com>
 <200809032138.14651.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1606286688-467003182-1220472162=:20541"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1606286688-467003182-1220472162=:20541
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 3 Sep 2008, Bartlomiej Zolnierkiewicz wrote:

>=20
> Hi,
>=20
> On Wednesday 03 September 2008, Nir Tzachar wrote:
> > This patch was inspired by the kernel projects page, where an ncurses
> > replacement for menuconfig was mentioned (by Sam Ravnborg).
> >=20
> > Building on menuconfig, this patch implements a more modern look interf=
ace using
> > ncurses and ncurses' satellite libraries (menu, panel, form). The imple=
mentation
> > does not depend on lxdialog, which is currently distributed with the ke=
rnel.
> >=20
> > The only change outside of nconf.c is due to a name clash: both ncurses=
 and
> > lkc.h define a fucntion named menu_init(). I changed the internal versi=
on's
> > name.=20
> >=20
> > Please consider the patch for merging. Comments are appreciated.
>=20
> Could you please tell what kernel version is it against?

It applies cleanly to 2.6.27-rc5-git4 FWIW.

> I'm getting the following error on make nconfig (and also on make menucon=
fig
> which works fine without this patch) with the current Linus' tree:
>=20
>   HOSTCC  scripts/kconfig/conf.o
>   HOSTCC  scripts/kconfig/kxgettext.o
>   HOSTCC  scripts/kconfig/nconf.o
>   HOSTCC  scripts/kconfig/zconf.tab.o
> scripts/kconfig/zconf.tab.c: In function =FF=FFconf_parse=FF=FF:
> scripts/kconfig/zconf.tab.c:2258: warning: implicit declaration of functi=
on =FF=FFmenu_init=FF=FF
>   HOSTLD  scripts/kconfig/nconf
> scripts/kconfig/nconf arch/x86/Kconfig
> make[1]: *** [nconfig] Segmentation fault
> make: *** [nconfig] Error 2

Need to change all /menu_init/ in zconf.tab.c* to /_menu_init/.

Need to strip trailing whitespace on new source code lines.

I'm seeing cyan (?) foreground on black background.  Is that the colors
that were planned?

Instructions are dark blue on black -- cannot read them.

--=20
~Randy
---1606286688-467003182-1220472162=:20541--
