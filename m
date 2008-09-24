Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbYIXVNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbYIXVNn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 17:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbYIXVNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 17:13:35 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:4652 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbYIXVNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 17:13:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type;
        b=JWG0/7V2aks0Nf6DdGLfpgExDcutlxaLAcFKalVPHcca9CO+1gxaY+m2d6bKt+daFU
         SW0v6wuewdCQPtdMlC80joYISW9fl+MGl+OK2VQeRf0QSNHkiNkOOUqdmGVEp7aFTbgG
         kuWNvsYUN9yIuYyPyOhtkahtF0umVSLDVLAxY=
Message-ID: <cd73a99e0809241413j240f84b3hb58c7c089fb15896@mail.gmail.com>
Date: Wed, 24 Sep 2008 23:13:32 +0200
From: "Andrew Victor" <avictor.za@gmail.com>
To: "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: AT91: atmel_pwm only available for certain AT91 processors
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_10598_26733640.1222290812443"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_10598_26733640.1222290812443
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Only three of Atmel's AT91 processors (SAM9263, SAM9RL and CAP9)
include a PWM controller.
It should therefore only be possible to enable the misc/atmel_pwm.c
driver on those processors (and not all AT91 processors).

Signed-off-by: Andrew Victor <linux@maxim.org.za>

------=_Part_10598_26733640.1222290812443
Content-Type: text/x-patch; name=15-pwm.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_flig49jx0
Content-Disposition: attachment; filename=15-pwm.patch

ZGlmZiAtdXJOIC14IENWUyBsaW51eC0yLjYuMjctcmM3L2RyaXZlcnMvbWlzYy9LY29uZmlnIGxp
bnV4LTIuNi9kcml2ZXJzL21pc2MvS2NvbmZpZwotLS0gbGludXgtMi42LjI3LXJjNy9kcml2ZXJz
L21pc2MvS2NvbmZpZwkyMDA4LTA5LTI0IDIyOjM3OjQwLjAwMDAwMDAwMCArMDIwMAorKysgbGlu
dXgtMi42L2RyaXZlcnMvbWlzYy9LY29uZmlnCTIwMDgtMDktMjQgMTY6MjM6MDYuMDAwMDAwMDAw
ICswMjAwCkBAIC0xNSw3ICsxNSw3IEBACiAKIGNvbmZpZyBBVE1FTF9QV00KIAl0cmlzdGF0ZSAi
QXRtZWwgQVQzMi9BVDkxIFBXTSBzdXBwb3J0IgotCWRlcGVuZHMgb24gQVZSMzIgfHwgQVJDSF9B
VDkxCisJZGVwZW5kcyBvbiBBVlIzMiB8fCBBUkNIX0FUOTFTQU05MjYzIHx8IEFSQ0hfQVQ5MVNB
TTlSTCB8fCBBUkNIX0FUOTFDQVA5CiAJaGVscAogCSAgVGhpcyBvcHRpb24gZW5hYmxlcyBkZXZp
Y2UgZHJpdmVyIHN1cHBvcnQgZm9yIHRoZSBQV00gY2hhbm5lbHMKIAkgIG9uIGNlcnRhaW4gQXRt
ZWwgcHJjb2Vzc29ycy4gIFB1bHNlIFdpZHRoIE1vZHVsYXRpb24gaXMgdXNlZCBmb3IK
------=_Part_10598_26733640.1222290812443--
