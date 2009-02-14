Return-Path: <linux-kernel-owner+w=401wt.eu-S1752581AbZBNIDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbZBNIDt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 03:03:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbZBNIDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 03:03:39 -0500
Received: from mx40.mail.ru ([94.100.176.54]:55621 "EHLO mx40.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbZBNIDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 03:03:38 -0500
X-Greylist: delayed 153354 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Feb 2009 03:03:38 EST
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: linux-kbuild@vger.kernel.org
Subject: Unable to make xconfig with Qt 4.5
Date: Sat, 14 Feb 2009 11:03:23 +0300
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc4-1avb; KDE/4.2.0; i686; ; )
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       cooker@mandrivalinux.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3752896.iQ7sLfzbjd";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200902141103.32358.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3752896.iQ7sLfzbjd
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

It seems that distribution started to ship Qt 4.5 with KDE4. I am lucky=20
one running Mandriva cooker:

{pts/2}% LC_ALL=3DC make -C ~/src/linux-git O=3D$HOME/build/linux-2.6.29=20
xconfig
make: Entering directory `/home/bor/src/linux-git'                         =
=20
  GEN     /home/bor/build/linux-2.6.29/Makefile                            =
=20
Package qt-mt was not found in the pkg-config search path.                 =
=20
Perhaps you should add the directory containing `qt-mt.pc'                 =
=20
to the PKG_CONFIG_PATH environment variable                                =
=20
No package 'qt-mt' found                                                   =
=20
Package qt-mt was not found in the pkg-config search path.                 =
=20
Perhaps you should add the directory containing `qt-mt.pc'                 =
=20
to the PKG_CONFIG_PATH environment variable                                =
=20
No package 'qt-mt' found                                                   =
=20
Package qt-mt was not found in the pkg-config search path.                 =
=20
Perhaps you should add the directory containing `qt-mt.pc'                 =
=20
to the PKG_CONFIG_PATH environment variable                                =
=20
No package 'qt-mt' found                                                   =
=20
Package qt-mt was not found in the pkg-config search path.                 =
=20
Perhaps you should add the directory containing `qt-mt.pc'                 =
=20
to the PKG_CONFIG_PATH environment variable                                =
=20
No package 'qt-mt' found                                                   =
=20
  HOSTCXX scripts/kconfig/qconf.o                                          =
=20
/home/bor/src/linux-git/scripts/kconfig/qconf.cc:6:26: error:=20
qapplication.h: No such file or directory                                  =
                      =20
/home/bor/src/linux-git/scripts/kconfig/qconf.cc:7:25: error:=20
qmainwindow.h: No such file or directory                                   =
                      =20

List of packages available in qt4 devel:

{pts/3}% rpm -ql libqt4-devel-4.5.0-0.rc1.4mdv2009.1 | grep pkgc
/usr/lib/pkgconfig/Qt3Support.pc
/usr/lib/pkgconfig/QtAssistantClient.pc
/usr/lib/pkgconfig/QtCLucene.pc
/usr/lib/pkgconfig/QtCore.pc
/usr/lib/pkgconfig/QtDBus.pc
/usr/lib/pkgconfig/QtDesigner.pc
/usr/lib/pkgconfig/QtDesignerComponents.pc
/usr/lib/pkgconfig/QtGui.pc
/usr/lib/pkgconfig/QtHelp.pc
/usr/lib/pkgconfig/QtNetwork.pc
/usr/lib/pkgconfig/QtOpenGL.pc
/usr/lib/pkgconfig/QtScript.pc
/usr/lib/pkgconfig/QtScriptTools.pc
/usr/lib/pkgconfig/QtSql.pc
/usr/lib/pkgconfig/QtSvg.pc
/usr/lib/pkgconfig/QtTest.pc
/usr/lib/pkgconfig/QtUiTools.pc
/usr/lib/pkgconfig/QtWebKit.pc
/usr/lib/pkgconfig/QtXml.pc
/usr/lib/pkgconfig/QtXmlPatterns.pc

this was straight update so either this is local packaging issue or Qt=20
4.5 change package structure.

--nextPart3752896.iQ7sLfzbjd
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmWes0ACgkQR6LMutpd94wvcQCgioCk4rrs8MWj8JcS91FL7OfB
0UIAoIk+CrZ6ozU7thJf7eFQ/ZEJoPE/
=/2dd
-----END PGP SIGNATURE-----

--nextPart3752896.iQ7sLfzbjd--
