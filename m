Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab0CBWWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 17:22:43 -0500
Received: from mail-qy0-f179.google.com ([209.85.221.179]:47846 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab0CBWWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 17:22:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type;
        b=gsXsNPAIVVh4X7lTNhsN2+zoDC7ti3uxV836qgbS22u+P7A0yEdDbCA6NsyQulbvvJ
         EuZKyccRUzzx9sNlotMIX/ApkFWhXZFEgjv2rUG9cEhwhhVGGOSqpyKp/ZLekvFzWrgY
         4P+epTLbO2zWGZrJ11IX0CVMSNqdJAMTSNQ0E=
Date: Tue, 2 Mar 2010 16:22:28 -0600
From: Chris Largret <largret@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Lin <paul_lin@ralinktech.com>
Subject: 2.6.33 staging rt2870 += Belkin F5D8055 Wireless-N USB Dongle
Message-ID: <20100302162228.3eeda8f3@shogun.epicvoyage.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i486-slackware-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/XLfK5DHlK9TV8xN/XegNO7m"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/XLfK5DHlK9TV8xN/XegNO7m
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: base64
Content-Disposition: inline

LS0tLS1CRUdJTiBQR1AgU0lHTkVEIE1FU1NBR0UtLS0tLQ0KSGFzaDogU0hBMQ0KDQpIZXksDQoN
CkkgYm91Z2h0IGEgQmVsa2luIEY1RDgwNTUgV2lyZWxlc3MtTiBVU0IgRG9uZ2xlIHJlY2VudGx5
LiBUaGUgZHJpdmVyDQpDRCBob2xkcyBmaWxlcyB3aXRoIG5hbWVzIGxpa2UgInJ0Mjg3MC5pbmYu
Ig0KDQpUaGUgY3VycmVudCAoa2VybmVsIDIuNi4zMykgUmFsaW5rIHN0YWdpbmcgbW9kdWxlIHdv
cmtzIHdpdGggaXQgYWZ0ZXIgYQ0Kc2xpZ2h0IHR3ZWFrIHRvIGFkZCB0aGUgQmVsa2luIFVTQiBk
ZXZpY2UgaW5mb3JtYXRpb24uIFRoZSBhdHRhY2hlZA0KcGF0Y2ggaXMgZGVzaWduZWQgdG8gZG8g
dGhhdC4NCg0KSXQgbW9kaWZpZXMgdGhlIHJ0Mjg2MCB0cmVlIGJ1dCBpcyB0YXJnZXRlZCBhdCB0
aGUgcnQyODcwIGRyaXZlci4NCg0KRmVlbCBmcmVlIHRvIGUtbWFpbCBtZSBpZiB5b3UgaGF2ZSBh
bnkgcXVlc3Rpb25zLg0KDQpDaHJpcw0KLS0tLS1CRUdJTiBQR1AgU0lHTkFUVVJFLS0tLS0NClZl
cnNpb246IEdudVBHIHYxLjQuOSAoR05VL0xpbnV4KQ0KDQppRVlFQVJFQ0FBWUZBa3VOajZRQUNn
a1F5QnJEWlVxYWQ1SE03Z0NmYjFEd3hUMVdRdldXOERoUHlaOVRNemhJDQpDeklBbmlxeGM3T21F
QWYvY0ttVGtqRXVEckkveERPNg0KPWJhUXQNCi0tLS0tRU5EIFBHUCBTSUdOQVRVUkUtLS0tLQ0K

--MP_/XLfK5DHlK9TV8xN/XegNO7m
Content-Type: text/x-patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=2.6.33-belkin-F5D8055-rt2870.patch

diff -ur linux-2.6.33-orig/drivers/staging/rt2860/usb_main_dev.c linux-2.6.=
33/drivers/staging/rt2860/usb_main_dev.c
--- linux-2.6.33-orig/drivers/staging/rt2860/usb_main_dev.c	2010-02-24 12:5=
2:17.000000000 -0600
+++ linux-2.6.33/drivers/staging/rt2860/usb_main_dev.c	2010-03-02 12:13:05.=
000000000 -0600
@@ -63,6 +63,7 @@
 	{USB_DEVICE(0x07D1, 0x3C11)},	/* D-Link */
 	{USB_DEVICE(0x14B2, 0x3C07)},	/* AL */
 	{USB_DEVICE(0x050D, 0x8053)},	/* Belkin */
+	{USB_DEVICE(0x050D, 0x825B)},	/* Belkin */
 	{USB_DEVICE(0x14B2, 0x3C23)},	/* Airlink */
 	{USB_DEVICE(0x14B2, 0x3C27)},	/* Airlink */
 	{USB_DEVICE(0x07AA, 0x002F)},	/* Corega */


--MP_/XLfK5DHlK9TV8xN/XegNO7m--
