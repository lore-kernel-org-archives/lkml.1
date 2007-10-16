Return-Path: <linux-kernel-owner+w=401wt.eu-S933958AbXJPOp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933958AbXJPOp3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 10:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932412AbXJPOpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 10:45:16 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:59899 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932330AbXJPOpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 10:45:15 -0400
Date: Tue, 16 Oct 2007 16:45:10 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Arnd Bergmann <arnd@arndb.de>, Jens Axboe <jens.axboe@oracle.com>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>
Subject: ioctl32: Unknown cmd
Message-ID: <Pine.LNX.4.62.0710161642200.20196@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-1372420395-1192545910=:20196"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-1372420395-1192545910=:20196
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

	Hi Arnd, Jens,

The recent (post 2.6.23) changes to compat_ioctl made the reporting of
unsupported ioctls more verbose. E.g. on the PS3 I get:

| ioctl32(cdrom_id:608): Unknown cmd fd(3) cmd(00005331){t:'S';sz:0} arg(00000000) on /dev/.tmp-11-0
| ioctl32(hdparm:1427): Unknown cmd fd(3) cmd(0000031f){t:03;sz:0} arg(00000000) on /dev/ps3da
| ioctl32(hdparm:1427): Unknown cmd fd(3) cmd(0000031f){t:03;sz:0} arg(00000000) on /dev/ps3da

The first one is triggered by the detection of the CD/DVD/BD-ROM driver,
The others are triggered by me running hdparm.

Was this intentional?

With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584337861-1372420395-1192545910=:20196--
