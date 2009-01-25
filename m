Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbZAYPso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbZAYPso (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 10:48:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbZAYPsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 10:48:36 -0500
Received: from mail-gx0-f24.google.com ([209.85.217.24]:46637 "EHLO
	mail-gx0-f24.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbZAYPsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 10:48:36 -0500
MIME-Version: 1.0
Date: Sun, 25 Jan 2009 18:48:34 +0300
Message-ID: <4c57f5990901250748j7fffc4fv3150821156ce47a2@mail.gmail.com>
Subject: GSPCA PAC207 patch to support genius ilook 111 webcam
From: Lierdakil <root@livid.pp.ru>
To: hdegoede@redhat.com
Cc: linux-kernel@vger.kernel.org, video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It figures, that GSPCA PAC207 driver does not "know", that it can
support genius i-look 111 webcam.
The following patch simply adds usb ID of Genius iLook 111 to usb_de
list of GSPCA PAC207 subdriver.
=================

Index: linux-2.6.28.2/Documentation/video4linux/gspca.txt
===================================================================
--- linux-2.6.28.2.orig/Documentation/video4linux/gspca.txt
+++ linux-2.6.28.2/Documentation/video4linux/gspca.txt
@@ -206,6 +206,7 @@ pac207		093a:2468	PAC207
 pac207		093a:2470	Genius GF112
 pac207		093a:2471	Genius VideoCam ge111
 pac207		093a:2472	Genius VideoCam ge110
+pac207		093a:2474	Genius iLook 111
 pac207		093a:2476	Genius e-Messenger 112
 pac7311		093a:2600	PAC7311 Typhoon
 pac7311		093a:2601	Philips SPC 610 NC
Index: linux-2.6.28.2/drivers/media/video/gspca/pac207.c
===================================================================
--- linux-2.6.28.2.orig/drivers/media/video/gspca/pac207.c
+++ linux-2.6.28.2/drivers/media/video/gspca/pac207.c
@@ -535,6 +535,7 @@ static const __devinitdata struct usb_de
 	{USB_DEVICE(0x093a, 0x2470)},
 	{USB_DEVICE(0x093a, 0x2471)},
 	{USB_DEVICE(0x093a, 0x2472)},
+	{USB_DEVICE(0x093a, 0x2474)},
 	{USB_DEVICE(0x093a, 0x2476)},
 	{USB_DEVICE(0x2001, 0xf115)},
 	{}
