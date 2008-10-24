Return-Path: <linux-kernel-owner+w=401wt.eu-S1756356AbYJXLpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356AbYJXLpk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 07:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980AbYJXLpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 07:45:00 -0400
Received: from cinke.fazekas.hu ([195.199.244.225]:41837 "EHLO
	cinke.fazekas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbYJXLo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 07:44:59 -0400
X-Greylist: delayed 775 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Oct 2008 07:44:58 EDT
Date: Fri, 24 Oct 2008 13:31:53 +0200 (CEST)
From: Marton Balint <cus@fazekas.hu>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] block:do_mounts - add device info to mount message
Message-ID: <Pine.LNX.4.64.0810241309190.31107@cinke.fazekas.hu>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-943463948-1483685215-1224847913=:31107"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---943463948-1483685215-1224847913=:31107
Content-Type: TEXT/PLAIN; charset=US-ASCII

Printing the minor and major number of the successfully mounted root 
device can be quite useful, the patch adds this piece of information 
to the "VFS: Mounted root..." message.

Signed-off-by: Marton Balint <cus@fazekas.hu>
---943463948-1483685215-1224847913=:31107
Content-Type: TEXT/x-patch; charset=US-ASCII; name=block-do-mounts-device-info.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0810241331530.31107@cinke.fazekas.hu>
Content-Description: 
Content-Disposition: attachment; filename=block-do-mounts-device-info.patch

LS0tIGxpbnV4L2luaXQvZG9fbW91bnRzLmMub3JpZwkyMDA4LTEwLTI0IDEy
OjQ3OjIxLjAwMDAwMDAwMCArMDIwMA0KKysrIGxpbnV4L2luaXQvZG9fbW91
bnRzLmMJMjAwOC0xMC0yNCAxMjo0OTowNS4wMDAwMDAwMDAgKzAyMDANCkBA
IC0yMjAsMTAgKzIyMCwxMCBAQA0KIA0KIAlzeXNfY2hkaXIoIi9yb290Iik7
DQogCVJPT1RfREVWID0gY3VycmVudC0+ZnMtPnB3ZC5tbnQtPm1udF9zYi0+
c19kZXY7DQotCXByaW50aygiVkZTOiBNb3VudGVkIHJvb3QgKCVzIGZpbGVz
eXN0ZW0pJXMuXG4iLA0KKwlwcmludGsoIlZGUzogTW91bnRlZCByb290ICgl
cyBmaWxlc3lzdGVtKSVzIG9uIGRldmljZSAldToldS5cbiIsDQogCSAgICAg
ICBjdXJyZW50LT5mcy0+cHdkLm1udC0+bW50X3NiLT5zX3R5cGUtPm5hbWUs
DQogCSAgICAgICBjdXJyZW50LT5mcy0+cHdkLm1udC0+bW50X3NiLT5zX2Zs
YWdzICYgTVNfUkRPTkxZID8NCi0JICAgICAgICIgcmVhZG9ubHkiIDogIiIp
Ow0KKwkgICAgICAgIiByZWFkb25seSIgOiAiIiwgTUFKT1IoUk9PVF9ERVYp
LCBNSU5PUihST09UX0RFVikpOw0KIAlyZXR1cm4gMDsNCiB9DQogDQo=

---943463948-1483685215-1224847913=:31107--
