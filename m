Return-Path: <linux-kernel-owner+w=401wt.eu-S1757783AbYAVTSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757783AbYAVTSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 14:18:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbYAVTSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 14:18:34 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:6849 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbYAVTSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 14:18:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=LlDLapGUBoq+vuXp7j2tYjVS1qtt0Y2ndx9VQrZTMMAMWCaAeJyUMv8Ftyf/CJtyXhf9bd7wIQOn28+/WCRXZnBOmVaJwFybRKlcgPW7xuUNlevpXCaNjA+moW5iozJU2xZAH9UNJuMqFlbmaSQT48q6V0fMkKEZ1Usy54K6yg4=
Message-ID: <6c4c86470801221118x530ee074qedb1da5eac1ca473@mail.gmail.com>
Date: Tue, 22 Jan 2008 20:18:32 +0100
From: "Wilco Beekhuizen" <wilcobeekhuizen@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Missing usb_find_device symbol from usb.c
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-rc8 (possibly lower rc's too) has usb_find_device removed from
usb.c. This causes problems when compiling modules that need
usb_find_device.
This patch puts the symbol back in place. Unless someone has a good
reason not to include usb_find_device?

--- linux-2.6.24-rc8/drivers/usb/core/usb.c.bak 2008-01-22
20:12:37.000000000 +0100
+++ linux-2.6.24-rc8/drivers/usb/core/usb.c     2008-01-22
20:12:52.000000000 +0100
@@ -1007,6 +1007,7 @@

 EXPORT_SYMBOL(__usb_get_extra_descriptor);

+EXPORT_SYMBOL(usb_find_device);
 EXPORT_SYMBOL(usb_get_current_frame_number);

 EXPORT_SYMBOL(usb_buffer_alloc);
