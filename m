Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1755704AbYJOTJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704AbYJOTJG (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 15 Oct 2008 15:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755025AbYJOTIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 15:08:53 -0400
Received: from f145.mail.ru ([194.67.57.138]:54855 "EHLO f145.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237AbYJOTIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 15:08:52 -0400
From: =?koi8-r?Q?=E5=D7=C7=C5=CE=C9=CA_=ED=C1=CE=C1=DE=CB=C9=CE?= 
	<sfstudio@mail.ru>
To: elendil@planet.nl, linux-kernel@vger.kernel.org
Subject: =?koi8-r?Q?Re=3A_Re=3A_Re=3A_Re=3A_patch_to_2.6.27_fix_build_rpm?=
Mime-Version: 1.0
X-Mailer: mPOP Web-Mail 2.19
X-Originating-IP: 127.0.0.1 via proxy [207.226.47.244]
Date: Thu, 16 Oct 2008 01:08:49 +0600
References: <200810152053.13629.elendil@planet.nl>
In-Reply-To: <200810152053.13629.elendil@planet.nl>
Reply-To: =?koi8-r?Q?=E5=D7=C7=C5=CE=C9=CA_=ED=C1=CE=C1=DE=CB=C9=CE?= 
	  <sfstudio@mail.ru>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <E1KqBjl-0009a2-00.sfstudio-mail-ru@f145.mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ooops... You say true. Fix It.

--- linux-2.6.27/scripts/package/mkspec.orig    2008-10-11 00:00:38.000000000 +0700
+++ linux-2.6.27/scripts/package/mkspec 2008-10-16 02:02:19.000000000 +0700
@@ -63,9 +63,9 @@ fi

 echo "%install"
 echo "%ifarch ia64"
-echo 'mkdir -p $RPM_BUILD_ROOT/boot/efi $RPM_BUILD_ROOT/lib/modules'
+echo 'mkdir -p $RPM_BUILD_ROOT/boot/efi $RPM_BUILD_ROOT/lib/modules $RPM_BUILD_ROOT/lib/firmware'
 echo "%else"
-echo 'mkdir -p $RPM_BUILD_ROOT/boot $RPM_BUILD_ROOT/lib/modules'
+echo 'mkdir -p $RPM_BUILD_ROOT/boot $RPM_BUILD_ROOT/lib/modules $RPM_BUILD_ROOT/lib/firmware'
 echo "%endif"

 echo 'INSTALL_MOD_PATH=$RPM_BUILD_ROOT make %{_smp_mflags} modules_install'
@@ -92,5 +92,6 @@ echo "%files"
 echo '%defattr (-, root, root)'
 echo "%dir /lib/modules"
 echo "/lib/modules/$KERNELRELEASE"
+echo "/lib/firmware"
 echo "/boot/*"
 echo ""
