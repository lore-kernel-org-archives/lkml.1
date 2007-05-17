Return-Path: <linux-kernel-owner+w=401wt.eu-S1757448AbXEQOBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbXEQOBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 10:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755572AbXEQOBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 10:01:25 -0400
Received: from neopsis.com ([213.239.204.14]:38201 "EHLO
	matterhorn.dbservice.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754761AbXEQOBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 10:01:25 -0400
X-Greylist: delayed 1521 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 May 2007 10:01:24 EDT
Message-ID: <464C5FAC.8060609@dbservice.com>
Date: Thu, 17 May 2007 15:59:08 +0200
From: Tomas Carnecky <tom@dbservice.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: SideWinder GameVoice driver
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------050708020904060901010409"
X-Neopsis-MailScanner-Information: Neopsis MailScanner using ClamAV and Spaassassin
X-Neopsis-MailScanner: Found to be clean
X-Neopsis-MailScanner-SpamCheck: not spam, SpamAssassin (score=-2.364,
	required 5, autolearn=spam, AWL 0.23, BAYES_00 -2.60)
X-MailScanner-From: tom@dbservice.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050708020904060901010409
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Despite it's a Microsoft product, it's actually very nice and useful. A
little pad with a few buttons and connectors for a headset. It's an USB
device, but it doesn't represent itself as an input/HID device:
   HID device not claimed by input or hiddev

I plugged it into a windows box and the USB protocol it uses looks very
simple (see attachment): everytime I press one of the eight buttons, it
sends one byte, a bitmap of the pressed buttons.

What would be the best way to have this device appear in the system?
Having a separate driver/device node? Or is it possible to have a small
driver that would translate the gamevoice commands into evdev messages
and have a new /dev/input/eventX device appear?

I could write something like that myself, my C skills are good enough
for that, I'd just need some advice how to use the kernel USB/evdev
interfaces.

tom

--------------050708020904060901010409
Content-Type: text/plain;
 name="gamevoice.txt"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="gamevoice.txt"

Wzg4MzY1MCBtc10gVXNiU25vb3AgLSBNeURpc3BhdGNoSW50ZXJuYWxJT0NUTChmNTZiOGU4
MCkgOiBmZG89ODJhZGI5OTgsIElycD04NDhlMDAwOCwgSVJRTD0yDQpbODgzNjUwIG1zXSAg
Pj4+ICBVUkIgNjggZ29pbmcgZG93biAgPj4+IA0KLS0gVVJCX0ZVTkNUSU9OX0JVTEtfT1Jf
SU5URVJSVVBUX1RSQU5TRkVSOg0KICBQaXBlSGFuZGxlICAgICAgICAgICA9IDgzYTM4ZmRj
IFtlbmRwb2ludCAweDAwMDAwMDgxXQ0KICBUcmFuc2ZlckZsYWdzICAgICAgICA9IDAwMDAw
MDAzIChVU0JEX1RSQU5TRkVSX0RJUkVDVElPTl9JTiwgVVNCRF9TSE9SVF9UUkFOU0ZFUl9P
SykNCiAgVHJhbnNmZXJCdWZmZXJMZW5ndGggPSAwMDAwMDAwMQ0KICBUcmFuc2ZlckJ1ZmZl
ciAgICAgICA9IDg1N2ZjMDc4DQogIFRyYW5zZmVyQnVmZmVyTURMICAgID0gMDAwMDAwMDAN
CiAgVXJiTGluayAgICAgICAgICAgICAgPSAwMDAwMDAwMA0KWzg4Mzk3MCBtc10gVXNiU25v
b3AgLSBNeUludGVybmFsSU9DVExDb21wbGV0aW9uKGY1NmI4ZGIwKSA6IGZpZG89ODQ4ZGI1
NzgsIElycD04MmFlOWE3OCwgQ29udGV4dD04NTVjOTZkMCwgSVJRTD0yDQpbODgzOTcwIG1z
XSAgPDw8ICBVUkIgNjcgY29taW5nIGJhY2sgIDw8PCANCi0tIFVSQl9GVU5DVElPTl9CVUxL
X09SX0lOVEVSUlVQVF9UUkFOU0ZFUjoNCiAgUGlwZUhhbmRsZSAgICAgICAgICAgPSA4M2Ez
OGZkYyBbZW5kcG9pbnQgMHgwMDAwMDA4MV0NCiAgVHJhbnNmZXJGbGFncyAgICAgICAgPSAw
MDAwMDAwMyAoVVNCRF9UUkFOU0ZFUl9ESVJFQ1RJT05fSU4sIFVTQkRfU0hPUlRfVFJBTlNG
RVJfT0spDQogIFRyYW5zZmVyQnVmZmVyTGVuZ3RoID0gMDAwMDAwMDENCiAgVHJhbnNmZXJC
dWZmZXIgICAgICAgPSA4NTc2ODM3MA0KICBUcmFuc2ZlckJ1ZmZlck1ETCAgICA9IDgzMWYx
M2Q4DQogICAgMDAwMDAwMDA6IDBjDQogIFVyYkxpbmsgICAgICAgICAgICAgID0gMDAwMDAw
MDANCls4ODM5NzAgbXNdIFVzYlNub29wIC0gRGlzcGF0Y2hBbnkoZjU2Yjc2MTApIDogSVJQ
X01KX0lOVEVSTkFMX0RFVklDRV9DT05UUk9MDQpbODgzOTcwIG1zXSBVc2JTbm9vcCAtIE15
RGlzcGF0Y2hJbnRlcm5hbElPQ1RMKGY1NmI4ZTgwKSA6IGZkbz04MmFkYjk5OCwgSXJwPTgy
YWU5YTc4LCBJUlFMPTINCls4ODM5NzAgbXNdICA+Pj4gIFVSQiA2OSBnb2luZyBkb3duICA+
Pj4gDQotLSBVUkJfRlVOQ1RJT05fQlVMS19PUl9JTlRFUlJVUFRfVFJBTlNGRVI6DQogIFBp
cGVIYW5kbGUgICAgICAgICAgID0gODNhMzhmZGMgW2VuZHBvaW50IDB4MDAwMDAwODFdDQog
IFRyYW5zZmVyRmxhZ3MgICAgICAgID0gMDAwMDAwMDMgKFVTQkRfVFJBTlNGRVJfRElSRUNU
SU9OX0lOLCBVU0JEX1NIT1JUX1RSQU5TRkVSX09LKQ0KICBUcmFuc2ZlckJ1ZmZlckxlbmd0
aCA9IDAwMDAwMDAxDQogIFRyYW5zZmVyQnVmZmVyICAgICAgID0gODU3NjgzNzANCiAgVHJh
bnNmZXJCdWZmZXJNREwgICAgPSAwMDAwMDAwMA0KICBVcmJMaW5rICAgICAgICAgICAgICA9
IDAwMDAwMDAwDQo=
--------------050708020904060901010409--
