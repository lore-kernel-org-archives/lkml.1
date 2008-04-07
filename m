Return-Path: <linux-kernel-owner+w=401wt.eu-S1757876AbYDGMIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876AbYDGMIb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 08:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753842AbYDGMIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 08:08:23 -0400
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:60337 "EHLO
	QMTA09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753131AbYDGMIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 08:08:23 -0400
X-Authority-Analysis: v=1.0 c=1 a=YDB0LWfh7ZDC7dLnGoEA:9
 a=0EiM3Gg3qjBtRUiFyjMSOK1N2m4A:4 a=gi0PWCVxevcA:10
Subject: Build Error - 2.6.25-rc8-git5
From: Chris Holvenstot <cholvenstot@comcast.net>
To: Kernel List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 07 Apr 2008 07:08:29 -0500
Message-Id: <1207570109.6218.67.camel@popeye>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I received this error while building the x86 version of the rc8-git-6
kernel.

root@popeye:/build/linux# make modules -j2

  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CALL    scripts/checksyscalls.sh
  LD [M]  drivers/media/video/zr36067.o
  CC [M]  drivers/media/video/pvrusb2/pvrusb2-devattr.o
drivers/media/video/pvrusb2/pvrusb2-devattr.c:178: error: unknown field
‘flag_has_analogtuner’ specified in initializer
drivers/media/video/pvrusb2/pvrusb2-devattr.c:179: error: unknown field
‘flag_has_composite’ specified in initializer
drivers/media/video/pvrusb2/pvrusb2-devattr.c:180: error: unknown field
‘flag_has_svideo’ specified in initializer
drivers/media/video/pvrusb2/pvrusb2-devattr.c:182: error: unknown field
‘digital_control_scheme’ specified in initializer
drivers/media/video/pvrusb2/pvrusb2-devattr.c:182: error:
‘PVR2_DIGITAL_SCHEME_HAUPPAUGE’ undeclared here (not in a function)
drivers/media/video/pvrusb2/pvrusb2-devattr.c:183: error: unknown field
‘led_scheme’ specified in initializer
drivers/media/video/pvrusb2/pvrusb2-devattr.c:183: error:
‘PVR2_LED_SCHEME_HAUPPAUGE’ undeclared here (not in a function)
make[4]: *** [drivers/media/video/pvrusb2/pvrusb2-devattr.o] Error 1
make[3]: *** [drivers/media/video/pvrusb2] Error 2
make[2]: *** [drivers/media/video] Error 2
make[1]: *** [drivers/media] Error 2
make: *** [drivers] Error 2
make: *** Waiting for unfinished jobs....


