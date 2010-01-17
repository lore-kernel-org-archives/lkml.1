Return-Path: <linux-kernel-owner+w=401wt.eu-S1753958Ab0AQPp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab0AQPp2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 10:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174Ab0AQPp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 10:45:27 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:41694 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab0AQPp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 10:45:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=Z3etRTxA7xThzq/7XJ0eEZ9DmLvirmtnKx34wTRXHR4a1WujZqujXakM0+dTdTosoS
         GLUyAOCmpMvqnJMmoRnY09WbklZE+th3Hcprd+TaTVqtZjgFc9t8nIkIDJkJVbmeofpZ
         3MS+smD5AxU/Ki/MVeZCEA1v99S+dVtjsgBW8=
Message-ID: <4B5331B2.8010604@gmail.com>
Date: Sun, 17 Jan 2010 16:50:10 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Bill Pemberton <wfp5p@virginia.edu>
Subject: [PATCH] serqt_usb2: Two branches the same in qt_set_termios()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regardless of the condition, the branches executed the same code

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Is this right?

diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
index 060e9de..5401169 100644
--- a/drivers/staging/serqt_usb2/serqt_usb2.c
+++ b/drivers/staging/serqt_usb2/serqt_usb2.c
@@ -1277,7 +1277,7 @@ static void qt_set_termios(struct tty_struct *tty,
 	if (cflag & CSTOPB)
 		new_LCR |= SERIAL_TWO_STOPB;
 	else
-		new_LCR |= SERIAL_TWO_STOPB;
+		new_LCR |= SERIAL_ONE_STOPB;
 
 	dbg("%s - 4\n", __func__);
 
