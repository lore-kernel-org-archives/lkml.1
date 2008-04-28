Return-Path: <linux-kernel-owner+w=401wt.eu-S935353AbYD1PIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935353AbYD1PIq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 11:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934013AbYD1PIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:08:05 -0400
Received: from gv-out-0910.google.com ([216.239.58.188]:30057 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934654AbYD1PIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:08:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type;
        b=uMxpNbUhCmv9Jb42jodpEkVC4UIzWtgRh2gQc81YsdWNLiZkgF2jsZ7TBgLvofShXGr/+OC8x1p/l0or2LDEpmTa19Y4E8TRtbYGkHJDcfDCfnmVLUP/fKqfptbEp7wg2Xr9YfugivycBylmQZyVmBFQRAib7bQBdogpPYrTa/s=
Message-ID: <87a5b0800804280807g30895902na3691f52208fb75e@mail.gmail.com>
Date: Mon, 28 Apr 2008 16:07:59 +0100
From: "Will Newton" <will.newton@gmail.com>
To: "Linux Kernel list" <linux-kernel@vger.kernel.org>, i2c@lm-sensors.org,
       "eric miao" <eric.miao@marvell.com>
Subject: [PATCH] pca953x: Add support for pca9555 I2C I/O expander.
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_666_26590464.1209395279240"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_666_26590464.1209395279240
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Add support for pca9555 I2C I/O expander. As the comment suggests this
part is software compatible with the pca9539.

Signed-off-by: Will Newton <will.newton@imgtec.com>
---
 drivers/gpio/pca953x.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
index 6e72fd3..4ff274f 100644
--- a/drivers/gpio/pca953x.c
+++ b/drivers/gpio/pca953x.c
@@ -36,6 +36,7 @@ static const struct pca953x_desc pca953x_descs[] = {
 	{ "pca9537", 4, },
 	{ "pca9538", 8, },
 	{ "pca9539", 16, },
+	{ "pca9555", 16, },
 	/* REVISIT several pca955x parts should work here too */
 };

-- 
1.5.5.1

------=_Part_666_26590464.1209395279240
Content-Type: text/x-patch; name=0001-pca953x.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ffl6ouab0
Content-Disposition: attachment; filename=0001-pca953x.patch

RnJvbSA5ZGUxNDZhYjlmN2ZiM2I4MWVmYWViMjIzZmUzY2U5MDlhYTg3MDgyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBXaWxsIE5ld3RvbiA8d2lsbC5uZXd0b25AaW1ndGVjLmNvbT4K
RGF0ZTogTW9uLCAyOCBBcHIgMjAwOCAxNjowMzoyOSArMDEwMApTdWJqZWN0OiBbUEFUQ0hdIHBj
YTk1M3g6IEFkZCBzdXBwb3J0IGZvciBwY2E5NTU1IEkyQyBJL08gZXhwYW5kZXIuCgpBZGQgc3Vw
cG9ydCBmb3IgcGNhOTU1NSBJMkMgSS9PIGV4cGFuZGVyLgoKU2lnbmVkLW9mZi1ieTogV2lsbCBO
ZXd0b24gPHdpbGwubmV3dG9uQGltZ3RlYy5jb20+Ci0tLQogZHJpdmVycy9ncGlvL3BjYTk1M3gu
YyB8ICAgIDEgKwogMSBmaWxlcyBjaGFuZ2VkLCAxIGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25z
KC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncGlvL3BjYTk1M3guYyBiL2RyaXZlcnMvZ3Bpby9w
Y2E5NTN4LmMKaW5kZXggNmU3MmZkMy4uNGZmMjc0ZiAxMDA2NDQKLS0tIGEvZHJpdmVycy9ncGlv
L3BjYTk1M3guYworKysgYi9kcml2ZXJzL2dwaW8vcGNhOTUzeC5jCkBAIC0zNiw2ICszNiw3IEBA
IHN0YXRpYyBjb25zdCBzdHJ1Y3QgcGNhOTUzeF9kZXNjIHBjYTk1M3hfZGVzY3NbXSA9IHsKIAl7
ICJwY2E5NTM3IiwgNCwgfSwKIAl7ICJwY2E5NTM4IiwgOCwgfSwKIAl7ICJwY2E5NTM5IiwgMTYs
IH0sCisJeyAicGNhOTU1NSIsIDE2LCB9LAogCS8qIFJFVklTSVQgc2V2ZXJhbCBwY2E5NTV4IHBh
cnRzIHNob3VsZCB3b3JrIGhlcmUgdG9vICovCiB9OwogCi0tIAoxLjUuNS4xCgo=
------=_Part_666_26590464.1209395279240--
