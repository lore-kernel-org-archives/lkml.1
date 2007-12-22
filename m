Return-Path: <linux-kernel-owner+w=401wt.eu-S1754876AbXLVUSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbXLVUSQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 15:18:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbXLVUSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 15:18:03 -0500
Received: from turquoise.resot.net ([217.175.160.21]:41421 "EHLO
	turquoise.ool.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbXLVUSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 15:18:01 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Dec 2007 15:18:00 EST
From: "werner" <werner@copaya.yi.org>
Subject: Problems on booting
To: linux-kernel@vger.kernel.org
X-Originating-IP: 192.168.1.1
X-Mailer: Usermin 1.310
Message-Id: <1198354230.6569@copaya.yi.org>
Date: Sat, 22 Dec 2007 17:10:30 -0300 (GFT)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bound1198354230"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--bound1198354230
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

There seems to have two regressions between the kernels from yesterday and before-yesterday
On the kernel -git7 what didnt happened on -git6

1) My hard disk is /dev/hda, but when I have an usb key sticked in /dev/sba, and run lilo then, then it dont boot but give L99 99 99 99 ... error.  When I remove the usb stick from /dev/sba , and run then #lilo ,  then the result boots.  This problem was not present at the -git6 kernel

2) The boot stops / hangs on hardware detection of SCSI.  I have an Initio INI-9X00U/UW. The last messages during boot are, that it's verifying i91u scsi2 , then the boot hangs.  When I put the pci=3Doff kernel option, then the boot process continues (but with this, by other reasons, my computer works only half, so that this is unpracticable).      This problem also didnt happens with the -git6 kernel    This problem happens only on one of my two computers, because the other has no SCSI card inside, that computer boots normally.

werner@copaya.yi.org 
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
*** www.copaya.yi.org / www.monkey.is-a-geek.net ***
O =FAnico servidor comunit=E1rio na Guiana-Francesa.  Situado no local, r=E1pido, imuno contra guerras / desastres na Europa.   Servi=E7o n=E3o-comercial e gratuito de:  http (forum, p=E1gina web), irc (chat), ftp (download), name (subdomain) .

--bound1198354230--

