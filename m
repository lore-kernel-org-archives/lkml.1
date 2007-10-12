Return-Path: <linux-kernel-owner+w=401wt.eu-S1760827AbXJLM5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760827AbXJLM5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 08:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbXJLM5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 08:57:09 -0400
Received: from n1.cetrtapot.si ([89.212.80.162]:56510 "EHLO n1.cetrtapot.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400AbXJLM5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 08:57:08 -0400
X-Greylist: delayed 1187 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Oct 2007 08:57:07 EDT
Message-ID: <470F6EFB.6010704@cetrtapot.si>
Date: Fri, 12 Oct 2007 14:56:27 +0200
From: "hinko.kocevar@cetrtapot.si" <hinko.kocevar@cetrtapot.si>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: irda-users@lists.sourceforge.net
Cc: Samuel Ortiz <samuel@sortiz.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] irlmp_unregister_link needs to free lsaps hashbin
Content-Type: multipart/mixed;
 boundary="------------010705050709040507050405"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010705050709040507050405
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

While testing the mcs7780 based IrDA USB dongle I've stumbled upon
memory leak in irlmp_unregister_link(). Hashbin for lsaps is created in
irlmp_register_link and should probably be freed in irlmp_unregister_link().

Signed-off-by: Hinko Kocevar <hinko.kocevar@cetrtapot.si>

Best regards,
Hinko

----



--------------010705050709040507050405
Content-Type: text/plain;
 name="irlmp-delete-lsaps-hashbin.diff"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="irlmp-delete-lsaps-hashbin.diff"

LS0tIGxpbnV4LTIuNi4yMy9uZXQvaXJkYS9pcmxtcC5jLm9yaWcJMjAwNy0xMC0xMiAxNDow
NToxNy4wMDAwMDAwMDAgKzAyMDAKKysrIGxpbnV4LTIuNi4yMy9uZXQvaXJkYS9pcmxtcC5j
CTIwMDctMTAtMTIgMTQ6MDU6NDEuMDAwMDAwMDAwICswMjAwCkBAIC0zNTMsNiArMzUzLDcg
QEAgdm9pZCBpcmxtcF91bnJlZ2lzdGVyX2xpbmsoX191MzIgc2FkZHIpCiAJCS8qIEZpbmFs
IGNsZWFudXAgKi8KIAkJZGVsX3RpbWVyKCZsaW5rLT5pZGxlX3RpbWVyKTsKIAkJbGluay0+
bWFnaWMgPSAwOworCQloYXNoYmluX2RlbGV0ZShsaW5rLT5sc2FwcywgKEZSRUVfRlVOQykg
a2ZyZWUpOwogCQlrZnJlZShsaW5rKTsKIAl9CiB9Cg==
--------------010705050709040507050405--
