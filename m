Return-Path: <linux-kernel-owner+w=401wt.eu-S964971AbXGZUGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964971AbXGZUGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 16:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936558AbXGZUFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 16:05:44 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:42445 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936087AbXGZUFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 16:05:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type;
        b=rwZkGFQwOzDtY58eJrTHGdd5gi2ydCyfhYjEllglDi+5rmgT2MsspNumEWpSXKkcQO7OBR4XYUfB0UcW/SOIxZOcQHK94hqUTvlCdQYkmPJEswbSJJ+/hxdRexat/cG87bOCq70OGfCx97eNpobcdd2SABWYLxTKkI2p77b/89E=
Message-ID: <86802c440707261305r6cc798c5idad88d04d9eeff83@mail.gmail.com>
Date: Thu, 26 Jul 2007 13:05:40 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>, "Andi Kleen" <ak@suse.de>,
       "Christoph Lameter" <clameter@sgi.com>
Subject: [PATCH 4/5] net: use numa_node in net_devcice->dev instead of parent
Cc: linux-kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_205616_3411760.1185480340593"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_205616_3411760.1185480340593
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline



------=_Part_205616_3411760.1185480340593
Content-Type: text/x-patch; name=bus_numa_4.diff; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f4lodaig
Content-Disposition: attachment; filename="bus_numa_4.diff"

W1BBVENIIDQvNV0gbmV0OiB1c2UgbnVtYV9ub2RlIGluIG5ldF9kZXZjaWNlLT5kZXYgaW5zdGVh
ZCBvZiBwYXJlbnQKClNpZ25lZC1vZmYtYnk6IFlpbmdoYWkgTHUgPHlpbmdoYWkubHVAc3VuLmNv
bT4KCmRpZmYgLS1naXQgYS9uZXQvY29yZS9za2J1ZmYuYyBiL25ldC9jb3JlL3NrYnVmZi5jCmlu
ZGV4IDI3Y2ZlNWYuLjAwNWNjMWMgMTAwNjQ0Ci0tLSBhL25ldC9jb3JlL3NrYnVmZi5jCisrKyBi
L25ldC9jb3JlL3NrYnVmZi5jCkBAIC0yMTcsNyArMjE3LDcgQEAgbm9kYXRhOgogc3RydWN0IHNr
X2J1ZmYgKl9fbmV0ZGV2X2FsbG9jX3NrYihzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LAogCQl1bnNp
Z25lZCBpbnQgbGVuZ3RoLCBnZnBfdCBnZnBfbWFzaykKIHsKLQlpbnQgbm9kZSA9IGRldi0+ZGV2
LnBhcmVudCA/IGRldl90b19ub2RlKGRldi0+ZGV2LnBhcmVudCkgOiAtMTsKKwlpbnQgbm9kZSA9
IGRldl90b19ub2RlKCZkZXYtPmRldik7CiAJc3RydWN0IHNrX2J1ZmYgKnNrYjsKIAogCXNrYiA9
IF9fYWxsb2Nfc2tiKGxlbmd0aCArIE5FVF9TS0JfUEFELCBnZnBfbWFzaywgMCwgbm9kZSk7Cg==

------=_Part_205616_3411760.1185480340593--
