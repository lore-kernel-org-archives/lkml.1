Return-Path: <linux-kernel-owner+w=401wt.eu-S1754189AbYJURAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbYJURAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 13:00:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbYJUQ77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 12:59:59 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:15037 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbYJUQ76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 12:59:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding:sender;
        b=hxcLlTlS5hzzCmh4Nwk3PALLK+06vxkRXFsqQAO4IRkSGySGPrU037XRc5LuttIRw9
         uOg8mx6SbQJAl+3gzvHn/Mjp0kF+R1aHkHBsmX2DXukSXyRdOOgo5BRb6zy6CKBfZUYS
         g1beRsiTn3woFDlD2tFevZqFMh8hmVR6R5LRs=
Message-ID: <48FE0A89.2040107@mimas.ru>
Date: Tue, 21 Oct 2008 21:59:53 +0500
From: "damir@mimas.ru" <damir@mimas.ru>
User-Agent: Thunderbird 2.0.0.17 (X11/20081005)
MIME-Version: 1.0
To: trivial@kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27 1/1] cp2101: added Enfora GSM2228
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enfora GSM2228 based on Cygnal Integrated Products chip uses the same 
cp2101 driver.

Signed-off-by: Damir N Abdullin <damir@mimas.ru <mailto:damir@mimas.ru>>


--- a/drivers/usb/serial/cp2101.c    2008-10-10 03:13:53.000000000 +0500
+++ b/drivers/usb/serial/cp2101.c    2008-10-20 18:27:45.000000000 +0500
@@ -67,6 +67,7 @@ static struct usb_device_id id_table []
     { USB_DEVICE(0x10C4, 0x800A) }, /* SPORTident BSM7-D-USB main 
station */
     { USB_DEVICE(0x10C4, 0x803B) }, /* Pololu USB-serial converter */
     { USB_DEVICE(0x10C4, 0x8053) }, /* Enfora EDG1228 */
+    { USB_DEVICE(0x10C4, 0x8054) }, /* Enfora GSM2228 */
     { USB_DEVICE(0x10C4, 0x8066) }, /* Argussoft In-System Programmer */
     { USB_DEVICE(0x10C4, 0x807A) }, /* Crumb128 board */
     { USB_DEVICE(0x10C4, 0x80CA) }, /* Degree Controls Inc */
