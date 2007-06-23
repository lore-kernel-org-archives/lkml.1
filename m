Return-Path: <linux-kernel-owner+w=401wt.eu-S1754671AbXFWSpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbXFWSpm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 14:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbXFWSpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 14:45:35 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:11415 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbXFWSpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 14:45:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:x-enigmail-version:openpgp:content-type:content-transfer-encoding;
        b=bhn1Ly2ywPqGVw8fuOGpmjPRWmI47kwD7lrCL3C5LGcRCaErtrbfeJccon+vA4rRwgV78Xd3dDz1dgo6PAga8Ov35Jp01vqibUOhWm7RpMHaeruH9UrxampSNLe/XNX11pWe4LwqdxH9yMzi+gIrtNjPYeOJbcdd+aS4olOyv4s=
Message-ID: <467D6A21.8020507@gmail.com>
Date: Sun, 24 Jun 2007 00:14:49 +0530
From: jimmy bahuleyan <knight.camelot@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, sam@ravnborg.org, zippel@linux-m68k.org
Subject: make xconfig failure on 2.6.21.5
X-Enigmail-Version: 0.95.1
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I have a Kubuntu 7.04 distro with Qt4 development packages installed.
Trying to do a 'make xconfig' fails with:

  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/basic/docproc
  CHECK   qt
*
* Unable to find the QT installation. Please make sure that
* the QT development package is correctly installed and
* either install pkg-config or set the QTDIR environment
* variable to the correct location.
*
  HOSTCC  scripts/kconfig/conf.o
sed < scripts/kconfig/lkc_proto.h > scripts/kconfig/lkc_defs.h
's/P(\([^,]*\),.*/#define \1 (\*\1_p)/'
  HOSTCC  scripts/kconfig/kconfig_load.o
  HOSTCC  scripts/kconfig/kxgettext.o
  SHIPPED scripts/kconfig/zconf.tab.c
  SHIPPED scripts/kconfig/lex.zconf.c
  SHIPPED scripts/kconfig/zconf.hash.c
  HOSTCC  scripts/kconfig/zconf.tab.o
make[1]: *** No rule to make target `scripts/kconfig/.tmp_qtcheck',
needed by `scripts/kconfig/qconf.o'.  Stop.
make: *** [xconfig] Error 2


Is this a problem with my setup or that kbuild/kconfig can't handle Qt4?
I noticed that scripts/kconfig/Makefile checks for:

pkg-config --exists qt
pkg-config --exists qt-mt

whereas the Qt4 installation I have the *.pc files are:

Qt3Support.pc
QtCore.pc
QtGui.pc

and also the places where kconfig checks for qconfig.h doesn't seem to
be where Qt4 keeps it (in my installation),

/usr/share/qt4/include/QtCore/qconfig.h
/usr/share/qt4/include/Qt/qconfig.h


Anyone else run into the same problem?


-jb
-- 
Tact is the art of making a point without making an enemy.
