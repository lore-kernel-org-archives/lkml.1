Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbYDUHLH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbYDUHLH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 03:11:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbYDUHKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 03:10:54 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:49803 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbYDUHKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 03:10:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:mime-version:content-type:x-google-sender-auth;
        b=fObGGrNbJwuXifLPZOjIP4NmyLzBk/wr5w9cbKHyeuBO3+KBDfByLghnWEoLskCDCnYzZiuom4lhC0bN0stwtsZeG93Y4wVFjHrdAtjIr4M39G5bk12EN+NhKn42MZJ/W2yLbFY9e9T1YZZ2tPaJBjIEmhmTX51Uvj4LuIK1tnU=
Message-ID: <ed10ee420804210010g228aa4b7j9383e5417b7dcb8c@mail.gmail.com>
Date: Mon, 21 Apr 2008 00:10:52 -0700
From: "SL Baur" <steve@xemacs.org>
To: yi.zhu@intel.com
Subject: [PATCH] iwlwifi 3945 debug parameter should be writable via sysfs
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_19401_21967273.1208761852931"
X-Google-Sender-Auth: db7a0ff7601d7445
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_19401_21967273.1208761852931
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Is there any reason why the debug parameter in the iwlwifi driver
should be read-only?

(Patch inlined and attached since I'm sure it will get whitespace
broken).


The debug parameter of the Intel 3945ABG driver should be writable
via sysfs.

Signed-off-by: SL Baur <steve@xemacs.org>
---
This patch is against Linus' 2.6.25 release.

--- linux-2.6/drivers/net/wireless/iwlwifi/iwl3945-base.c~	2008-04-17
10:15:33.000000000 -0700
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-04-20
23:49:35.000000000 -0700
@@ -8855,7 +8855,7 @@ MODULE_PARM_DESC(disable, "manually disa
 module_param_named(hwcrypto, iwl3945_param_hwcrypto, int, 0444);
 MODULE_PARM_DESC(hwcrypto,
 		 "using hardware crypto engine (default 0 [software])\n");
-module_param_named(debug, iwl3945_param_debug, int, 0444);
+module_param_named(debug, iwl3945_param_debug, int, 0644);
 MODULE_PARM_DESC(debug, "debug output mask");
 module_param_named(disable_hw_scan, iwl3945_param_disable_hw_scan, int, 0444);
 MODULE_PARM_DESC(disable_hw_scan, "disable hardware scanning (default 0)");

-sb

------=_Part_19401_21967273.1208761852931
Content-Type: application/octet-stream; name=iwl3945-debug.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ffapekiu
Content-Disposition: attachment; filename=iwl3945-debug.patch

ClRoZSBkZWJ1ZyBwYXJhbWV0ZXIgb2YgdGhlIEludGVsIDM5NDVBQkYgZHJpdmVyIHNob3VsZCBi
ZSB3cml0YWJsZQp2aWEgc3lzZnMuCgpTaWduZWQtb2ZmLWJ5OiBTTCBCYXVyIDxzdGV2ZUB4ZW1h
Y3Mub3JnPgotLS0KVGhpcyBwYXRjaCBpcyBhZ2FpbnN0IExpbnVzJyAyLjYuMjUgcmVsZWFzZS4g
IEkndmUgb25seSBzdGFydGVkIHRvIHB1c2gKb24gaXQsIGJ1dCB0aGlzIGRyaXZlciB3b3JrcyBi
ZXR0ZXIgb24gdGhlIHNhbWUgYm94IHRoYW4gdGhlIE1pY3Jvc29mdApXaW5kb3dzIFhQIGRyaXZl
ci4KCi0tLSBsaW51eC0yLjYvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wzOTQ1LWJh
c2UuY34JMjAwOC0wNC0xNyAxMDoxNTozMy4wMDAwMDAwMDAgLTA3MDAKKysrIGxpbnV4LTIuNi9k
cml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bDM5NDUtYmFzZS5jCTIwMDgtMDQtMjAgMjM6
NDk6MzUuMDAwMDAwMDAwIC0wNzAwCkBAIC04ODU1LDcgKzg4NTUsNyBAQCBNT0RVTEVfUEFSTV9E
RVNDKGRpc2FibGUsICJtYW51YWxseSBkaXNhCiBtb2R1bGVfcGFyYW1fbmFtZWQoaHdjcnlwdG8s
IGl3bDM5NDVfcGFyYW1faHdjcnlwdG8sIGludCwgMDQ0NCk7CiBNT0RVTEVfUEFSTV9ERVNDKGh3
Y3J5cHRvLAogCQkgInVzaW5nIGhhcmR3YXJlIGNyeXB0byBlbmdpbmUgKGRlZmF1bHQgMCBbc29m
dHdhcmVdKVxuIik7Ci1tb2R1bGVfcGFyYW1fbmFtZWQoZGVidWcsIGl3bDM5NDVfcGFyYW1fZGVi
dWcsIGludCwgMDQ0NCk7Cittb2R1bGVfcGFyYW1fbmFtZWQoZGVidWcsIGl3bDM5NDVfcGFyYW1f
ZGVidWcsIGludCwgMDY0NCk7CiBNT0RVTEVfUEFSTV9ERVNDKGRlYnVnLCAiZGVidWcgb3V0cHV0
IG1hc2siKTsKIG1vZHVsZV9wYXJhbV9uYW1lZChkaXNhYmxlX2h3X3NjYW4sIGl3bDM5NDVfcGFy
YW1fZGlzYWJsZV9od19zY2FuLCBpbnQsIDA0NDQpOwogTU9EVUxFX1BBUk1fREVTQyhkaXNhYmxl
X2h3X3NjYW4sICJkaXNhYmxlIGhhcmR3YXJlIHNjYW5uaW5nIChkZWZhdWx0IDApIik7Cg==
------=_Part_19401_21967273.1208761852931--
