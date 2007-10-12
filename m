Return-Path: <linux-kernel-owner+w=401wt.eu-S1757647AbXJLNDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647AbXJLNDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 09:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755291AbXJLNDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 09:03:13 -0400
Received: from n1.cetrtapot.si ([89.212.80.162]:52444 "EHLO n1.cetrtapot.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755205AbXJLNDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 09:03:12 -0400
Message-ID: <470F6A5E.9050703@cetrtapot.si>
Date: Fri, 12 Oct 2007 14:36:46 +0200
From: "hinko.kocevar@cetrtapot.si" <hinko.kocevar@cetrtapot.si>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: irda-users@lists.sourceforge.net
Cc: Samuel Ortiz <samuel@sortiz.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] mcs7780 needs to free allocated rx buffer
Content-Type: multipart/mixed;
 boundary="------------090204090307020908060809"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090204090307020908060809
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

While testing the mcs7780 based IrDA USB dongle I've stumbled upon
memory leak in mcs_net_close(). Patch below fixes it.

Signed-off-by: Hinko Kocevar <hinko.kocevar@cetrtapot.si>

Best regards,
Hinko

----



--------------090204090307020908060809
Content-Type: text/plain;
 name="mcs7780-free-rx_buff.diff"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="mcs7780-free-rx_buff.diff"

LS0tIGxpbnV4LTIuNi4yMy9kcml2ZXJzL25ldC9pcmRhL21jczc3ODAuYy5vcmlnCTIwMDct
MTAtMTIgMTQ6MDI6NTUuMDAwMDAwMDAwICswMjAwCisrKyBsaW51eC0yLjYuMjMvZHJpdmVy
cy9uZXQvaXJkYS9tY3M3NzgwLmMJMjAwNy0xMC0xMiAxNDowNTowMy4wMDAwMDAwMDAgKzAy
MDAKQEAgLTY3OCw2ICs2NzgsOCBAQCBzdGF0aWMgaW50IG1jc19uZXRfY2xvc2Uoc3RydWN0
IG5ldF9kZXZpCiAJLyogU3RvcCB0cmFuc21pdCBwcm9jZXNzaW5nICovCiAJbmV0aWZfc3Rv
cF9xdWV1ZShuZXRkZXYpOwogCisJa2ZyZWVfc2tiKG1jcy0+cnhfYnVmZi5za2IpOworCiAJ
Lyoga2lsbCBhbmQgZnJlZSB0aGUgcmVjZWl2ZSBhbmQgdHJhbnNtaXQgVVJCcyAqLwogCXVz
Yl9raWxsX3VyYihtY3MtPnJ4X3VyYik7CiAJdXNiX2ZyZWVfdXJiKG1jcy0+cnhfdXJiKTsK

--------------090204090307020908060809--
