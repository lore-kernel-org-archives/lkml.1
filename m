Return-Path: <linux-kernel-owner+w=401wt.eu-S1760896AbXIRRA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760896AbXIRRA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 13:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759719AbXIRRAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 13:00:47 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:42215 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759645AbXIRRAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 13:00:46 -0400
Message-ID: <e6c711510709181000n5817895n753124f6bae45ed3@mail.gmail.com>
Date: Tue, 18 Sep 2007 10:00:45 -0700
From: "Ed Swierk" <eswierk@arastra.com>
To: netdev@vger.kernel.org
Subject: [PATCH] forcedeth: "no link" is informational
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_6491_10467721.1190134846116"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_6491_10467721.1190134846116
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Log "no link during initialization" at KERN_INFO as it's not an error,
and occurs every time the interface comes up (when the
forcedeth-phy-power-down patch is applied).

Signed-off-by: Ed Swierk <eswierk@arastra.com>

------=_Part_6491_10467721.1190134846116
Content-Type: application/octet-stream;
 name="forcedeth-open-no-link-printk.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="forcedeth-open-no-link-printk.patch"
X-Attachment-Id: f_f6qni7ed

TG9nICJubyBsaW5rIGR1cmluZyBpbml0aWFsaXphdGlvbiIgYXQgS0VSTl9JTkZPIGFzIGl0J3Mg
bm90IGFuIGVycm9yLAphbmQgb2NjdXJzIGV2ZXJ5IHRpbWUgdGhlIGludGVyZmFjZSBjb21lcyB1
cCAod2hlbiB0aGUKZm9yY2VkZXRoLXBoeS1wb3dlci1kb3duIHBhdGNoIGlzIGFwcGxpZWQpLgoK
U2lnbmVkLW9mZi1ieTogRWQgU3dpZXJrIDxlc3dpZXJrQGFyYXN0cmEuY29tPgoKSW5kZXg6IGxp
bnV4LTIuNi4yMi42L2RyaXZlcnMvbmV0L2ZvcmNlZGV0aC5jCj09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4
LTIuNi4yMi42Lm9yaWcvZHJpdmVycy9uZXQvZm9yY2VkZXRoLmMKKysrIGxpbnV4LTIuNi4yMi42
L2RyaXZlcnMvbmV0L2ZvcmNlZGV0aC5jCkBAIC00OTIwLDcgKzQ5MjAsNyBAQCBzdGF0aWMgaW50
IG52X29wZW4oc3RydWN0IG5ldF9kZXZpY2UgKmRlCiAJaWYgKHJldCkgewogCQluZXRpZl9jYXJy
aWVyX29uKGRldik7CiAJfSBlbHNlIHsKLQkJcHJpbnRrKCIlczogbm8gbGluayBkdXJpbmcgaW5p
dGlhbGl6YXRpb24uXG4iLCBkZXYtPm5hbWUpOworCQlwcmludGsoS0VSTl9JTkZPICIlczogbm8g
bGluayBkdXJpbmcgaW5pdGlhbGl6YXRpb24uXG4iLCBkZXYtPm5hbWUpOwogCQluZXRpZl9jYXJy
aWVyX29mZihkZXYpOwogCX0KIAlpZiAob29tKQo=
------=_Part_6491_10467721.1190134846116--
