Return-Path: <linux-kernel-owner+w=401wt.eu-S1759990AbYDBGn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759990AbYDBGn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 02:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbYDBGnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 02:43:20 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:63878 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbYDBGnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 02:43:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:mime-version:content-type:x-google-sender-auth;
        b=YepbAl5ByMbzmyg9Osq3Kk8lP5MqIF1Rwj/z6pZ1O763rf4fQmXKXQJ8ew63041oZ/K61v2JnlktXev2pMpomYWljc69Up/YH1Gq9Ns4jsOI72+qiH0Ava1sCxNfEOaXWMAPaWkGgdFOiyKAJGA2+WJZ2uFK2igw4Ft31N5QWcA=
Message-ID: <76366b180804012343m629320e9p2c76ec0c900a6450@mail.gmail.com>
Date: Wed, 2 Apr 2008 02:43:19 -0400
From: "Andrew Paprocki" <andrew@ishiboo.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] [WATCHDOG] it8712f_wdt Zero MSB timeout byte when disabling watchdog
Cc: "Wim Van Sebroeck" <wim@iguana.be>, "Oliver Schuster" <olivers137@aol.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_227_26663682.1207118599286"
X-Google-Sender-Auth: 158e096e9080682a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_227_26663682.1207118599286
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I noticed this while testing the latest code. I'm not sure if it is required,
but the normal (or LSB) timeout value is set to zero, so the MSB should
be as well to stay consistent.

If the chip revision is >= 8, set MSB of the 16-bit timeout value to zero
when disabling the watchdog in it8712f_wdt_disable().

Signed-off-by: Andrew Paprocki <andrew@ishiboo.com>

------=_Part_227_26663682.1207118599286
Content-Type: text/plain; name=2.6.25-rc8-it8712f_wdt-zero-timeout.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fejj6b6d1
Content-Disposition: attachment;
 filename=2.6.25-rc8-it8712f_wdt-zero-timeout.txt

RGF0ZTogV2VkLCAyIEFwciAyMDA4IDAyOjIzOjMzIC0wNDAwClN1YmplY3Q6IFtQQVRDSF0gW1dB
VENIRE9HXSBpdDg3MTJmX3dkdCBaZXJvIE1TQiB0aW1lb3V0IGJ5dGUgd2hlbiBkaXNhYmxpbmcg
d2F0Y2hkb2cKCklmIHRoZSBjaGlwIHJldmlzaW9uIGlzID49IDgsIHNldCBNU0Igb2YgdGhlIDE2
LWJpdCB0aW1lb3V0IHZhbHVlIHRvIHplcm8Kd2hlbiBkaXNhYmxpbmcgdGhlIHdhdGNoZG9nIGlu
IGl0ODcxMmZfd2R0X2Rpc2FibGUoKS4KClNpZ25lZC1vZmYtYnk6IEFuZHJldyBQYXByb2NraSA8
YW5kcmV3QGlzaGlib28uY29tPgotLS0KIGRyaXZlcnMvd2F0Y2hkb2cvaXQ4NzEyZl93ZHQuYyB8
ICAgIDIgKysKIDEgZmlsZXMgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAwIGRlbGV0aW9ucygt
KQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvd2F0Y2hkb2cvaXQ4NzEyZl93ZHQuYyBiL2RyaXZlcnMv
d2F0Y2hkb2cvaXQ4NzEyZl93ZHQuYwppbmRleCBjYTkwYzUxLi40NDViN2U4IDEwMDY0NAotLS0g
YS9kcml2ZXJzL3dhdGNoZG9nL2l0ODcxMmZfd2R0LmMKKysrIGIvZHJpdmVycy93YXRjaGRvZy9p
dDg3MTJmX3dkdC5jCkBAIC0yMDAsNiArMjAwLDggQEAgaXQ4NzEyZl93ZHRfZGlzYWJsZSh2b2lk
KQogCiAJc3VwZXJpb19vdXRiKDAsIFdEVF9DT05GSUcpOwogCXN1cGVyaW9fb3V0YigwLCBXRFRf
Q09OVFJPTCk7CisJaWYgKHJldmlzaW9uID49IDB4MDgpCisJCXN1cGVyaW9fb3V0YigwLCBXRFRf
VElNRU9VVCArIDEpOwogCXN1cGVyaW9fb3V0YigwLCBXRFRfVElNRU9VVCk7CiAKIAlzdXBlcmlv
X2V4aXQoKTsKLS0gCjEuNC40LjQKCg==
------=_Part_227_26663682.1207118599286--
