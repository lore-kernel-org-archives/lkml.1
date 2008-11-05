Return-Path: <linux-kernel-owner+w=401wt.eu-S1757728AbYKEUS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757728AbYKEUS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 15:18:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756994AbYKEUSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 15:18:45 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:64364 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755487AbYKEUSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 15:18:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type;
        b=H8x1msFX527NWSalxWvkjLyrkbvQ5UGTQzLm5hFtgm7alsEtZcS6F9HosiXsZZQPIH
         85mA5AzoLbSCC2j1DT75WRG0Iu99EjKSXctOEH0Ckqex+THzseX86IjoaZX00nFs/buk
         V7YYjPH/OrbaaJJH4IZiJ4aPHcR/ikiTAPyu0=
Message-ID: <cd73a99e0811051218w77c4f9cagb76a51695b3ce0dc@mail.gmail.com>
Date: Wed, 5 Nov 2008 22:18:41 +0200
From: "Andrew Victor" <avictor.za@gmail.com>
To: wim@iguana.be, "Andrew Morton" <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] SAM9 watchdog - update for moved headers
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_32329_5720762.1225916321390"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_32329_5720762.1225916321390
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

The architecture header files were recently moved from
include/asm-arm/mach-at91/ to arch/arm/mach-at91/include/mach/.
The SAM9 watchdog driver still includes a header from the old location.

Signed-off-by: Andrew Victor <linux@maxim.org.za>

------=_Part_32329_5720762.1225916321390
Content-Type: text/x-patch; name=sam9_wdt_headerfix.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fn6eiorq0
Content-Disposition: attachment; filename=sam9_wdt_headerfix.patch

ZGlmZiAtdXJOIC14IENWUyBsaW51eC0yLjYuMjgtcmMzL2RyaXZlcnMvd2F0Y2hkb2cvYXQ5MXNh
bTlfd2R0LmMgbGludXgtMi42L2RyaXZlcnMvd2F0Y2hkb2cvYXQ5MXNhbTlfd2R0LmMKLS0tIGxp
bnV4LTIuNi4yOC1yYzMvZHJpdmVycy93YXRjaGRvZy9hdDkxc2FtOV93ZHQuYwkyMDA4LTExLTA1
IDIxOjM1OjQ5LjAwMDAwMDAwMCArMDIwMAorKysgbGludXgtMi42L2RyaXZlcnMvd2F0Y2hkb2cv
YXQ5MXNhbTlfd2R0LmMJMjAwOC0xMS0wNSAyMTowOTo1OS4wMDAwMDAwMDAgKzAyMDAKQEAgLTMw
LDcgKzMwLDcgQEAKICNpbmNsdWRlIDxsaW51eC9iaXRvcHMuaD4KICNpbmNsdWRlIDxsaW51eC91
YWNjZXNzLmg+CiAKLSNpbmNsdWRlIDxhc20vYXJjaC9hdDkxX3dkdC5oPgorI2luY2x1ZGUgPG1h
Y2gvYXQ5MV93ZHQuaD4KIAogI2RlZmluZSBEUlZfTkFNRSAiQVQ5MVNBTTkgV2F0Y2hkb2ciCiAK

------=_Part_32329_5720762.1225916321390--
