Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486AbXLCKuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbXLCKuu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 05:50:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbXLCKul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 05:50:41 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:24883 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbXLCKuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 05:50:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type;
        b=OFIeBE74+dIVCfM1hPQb8kto3eLRjhWOJNWq9GY2mgrAAyF4oIlYr28Gj179Ug/gsXymc0xCgqzadJq3t9tzgzCUloWEs8v+w3QsbFhestDXUEjOgehjojP6QPm5NskPdl/9z9tKZzjXoY7Ipxa3S1xeBER6BU4ymzk/RP/7GfQ=
Message-ID: <aa79d98a0712030250s748bb7dfjb50f3fe5fed67fa7@mail.gmail.com>
Date: Mon, 3 Dec 2007 13:50:38 +0300
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Michael Wu" <flamingice@sourmilk.net>
Subject: [PATCH] NET: mac80211 - fix missed mutex unlock
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_9679_805667.1196679038971"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_9679_805667.1196679038971
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This patch does fix missed mutex unlock. Please see it attached.
(Can't send it as a plain text patch - have only IE based mail access)

Cyrill

------=_Part_9679_805667.1196679038971
Content-Type: text/plain; name=NET-mac80211-fix-missed-mutex-unlock.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f9qvlrnz
Content-Disposition: attachment;
 filename=NET-mac80211-fix-missed-mutex-unlock.patch

RnJvbTogQ3lyaWxsIEdvcmN1bm92IDxnb3JjdW5vdkBnbWFpbC5jb20+CkRhdGU6IE1vbiwgMyBE
ZWMgMjAwNyAxMzozNjo1OCArMDMwMApTdWJqZWN0OiBbUEFUQ0hdIE5FVDogbWFjODAyMTEgLSBm
aXggbWlzc2VkIG11dGV4IHVubG9jawoKU2lnbmVkLW9mZi1ieTogQ3lyaWxsIEdvcmN1bm92IDxn
b3JjdW5vdkBnbWFpbC5jb20+Ci0tLQogbmV0L21hYzgwMjExL2llZWU4MDIxMV9yYXRlLmMgfCAg
ICAxICsKIDEgZmlsZXMgY2hhbmdlZCwgMSBpbnNlcnRpb25zKCspLCAwIGRlbGV0aW9ucygtKQoK
ZGlmZiAtLWdpdCBhL25ldC9tYWM4MDIxMS9pZWVlODAyMTFfcmF0ZS5jIGIvbmV0L21hYzgwMjEx
L2llZWU4MDIxMV9yYXRlLmMKaW5kZXggNzI1NGJkNi4uMzI2MGE0YSAxMDA2NDQKLS0tIGEvbmV0
L21hYzgwMjExL2llZWU4MDIxMV9yYXRlLmMKKysrIGIvbmV0L21hYzgwMjExL2llZWU4MDIxMV9y
YXRlLmMKQEAgLTMzLDYgKzMzLDcgQEAgaW50IGllZWU4MDIxMV9yYXRlX2NvbnRyb2xfcmVnaXN0
ZXIoc3RydWN0IHJhdGVfY29udHJvbF9vcHMgKm9wcykKIAkJaWYgKCFzdHJjbXAoYWxnLT5vcHMt
Pm5hbWUsIG9wcy0+bmFtZSkpIHsKIAkJCS8qIGRvbid0IHJlZ2lzdGVyIGFuIGFsZ29yaXRobSB0
d2ljZSAqLwogCQkJV0FSTl9PTigxKTsKKwkJCW11dGV4X3VubG9jaygmcmF0ZV9jdHJsX211dGV4
KTsKIAkJCXJldHVybiAtRUFMUkVBRFk7CiAJCX0KIAl9Ci0tIAoxLjUuMy41LjE0ODEuZzlkY2YK

------=_Part_9679_805667.1196679038971--
