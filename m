Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379Ab0ATRbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab0ATRbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 12:31:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870Ab0ATRbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 12:31:11 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:34391 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab0ATRbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 12:31:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type;
        b=VpFGtWXTQfcJJpPuNpTobqe1yVVfSXUWLAlhtcUFfXDzm8wYg5rqJ3CcPRzj+n6nW+
         rFqtdpyQY9WalOeUUfVSoKwpeYkGkENewurEkUtcAALrIqhJLm0S0v+IFd4+CbwX6x3Q
         6sHPLBoMbY1cq02uR797snMwjAsCY3pyDM0Gs=
MIME-Version: 1.0
Date: Thu, 21 Jan 2010 02:31:09 +0900
X-Google-Sender-Auth: b9db0377a8bdd6fc
Message-ID: <49c17ca71001200931p76e945d1g360d2cb5f9d7e72a@mail.gmail.com>
Subject: [PATCH] SIS USB2VGA DRIVER: support KAIREN's USB VGA adaptor 
	USB20SVGA-MB-PLUS
From: Tanaka Akira <akr@fsij.org>
To: Thomas Winischhofer <thomas@winischhofer.net>
Cc: Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the USB product ID of KAIREN's USB VGA Adaptor,
USB20SVGA-MB-PLUS, to sisusbvga work with it.

Signed-off-by: Tanaka Akira <akr@fsij.org>

--- linux-2.6.33-rc4/drivers/usb/misc/sisusbvga/sisusb.c.orig
+++ linux-2.6.33-rc4/drivers/usb/misc/sisusbvga/sisusb.c
@@ -3245,6 +3245,7 @@ static struct usb_device_id sisusb_table
 	{ USB_DEVICE(0x0711, 0x0902) },
 	{ USB_DEVICE(0x0711, 0x0903) },
 	{ USB_DEVICE(0x0711, 0x0918) },
+	{ USB_DEVICE(0x0711, 0x0920) },
 	{ USB_DEVICE(0x182d, 0x021c) },
 	{ USB_DEVICE(0x182d, 0x0269) },
 	{ }

-- 
Tanaka Akira
