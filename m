Return-Path: <linux-kernel-owner+w=401wt.eu-S1755066AbXEUFTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066AbXEUFTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 01:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbXEUFTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 01:19:09 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:2814 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbXEUFTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 01:19:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type;
        b=YwOXlbmlZ8quvfrh3w65ezOP1GzRaifd46ILNSTCOsHtmHFGQcSlOBzcwKMW9A2/+PHqJbOeL9gnaHohDTfBMD0Wexs4/OV7FzgaNsOAGww+wp3DqYIT+eH+V9RxwU6akx1aqBvqr18T9a//BKCaEUpr39LPQLVQ9uvDygIZsTI=
Message-ID: <86802c440705202219w2adc73a0r34716f7daaf596b5@mail.gmail.com>
Date: Sun, 20 May 2007 22:19:06 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, "Greg KH" <gregkh@suse.de>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Vivek Goyal" <vgoyal@in.ibm.com>
Subject: [PATCH 1/3]x86_64: early init pgt for fix virtual addr in head.S
Cc: "linux kernel mailing list" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_88080_2770622.1179724746426"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_88080_2770622.1179724746426
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

early init pgt for fix virtual addr in head.S, so can use set_fixmap
before setup_arch.
otherwise set_fixmap_nocache will not work for x86_64

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

------=_Part_88080_2770622.1179724746426
Content-Type: text/x-patch; name=head_s_init_fix_x86_64.diff; 
	charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f1yhsq31
Content-Disposition: attachment; filename="head_s_init_fix_x86_64.diff"

ZGlmZiAtLWdpdCBhL2FyY2gveDg2XzY0L2tlcm5lbC9oZWFkLlMgYi9hcmNoL3g4Nl82NC9rZXJu
ZWwvaGVhZC5TCmluZGV4IDFmYWI0ODcuLjJkYTMwYWQgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2XzY0
L2tlcm5lbC9oZWFkLlMKKysrIGIvYXJjaC94ODZfNjQva2VybmVsL2hlYWQuUwpAQCAtNzMsNyAr
NzMsMTEgQEAgc3RhcnR1cF82NDoKIAlhZGRxCSVyYnAsIGluaXRfbGV2ZWw0X3BndCArICg1MTEq
OCkoJXJpcCkKIAogCWFkZHEJJXJicCwgbGV2ZWwzX2lkZW50X3BndCArIDAoJXJpcCkKKwkKIAlh
ZGRxCSVyYnAsIGxldmVsM19rZXJuZWxfcGd0ICsgKDUxMCo4KSglcmlwKQorCWFkZHEJJXJicCwg
bGV2ZWwzX2tlcm5lbF9wZ3QgKyAoNTExKjgpKCVyaXApCisKKwlhZGRxCSVyYnAsIGxldmVsMl9m
aXhtYXBfcGd0ICsgKDUwNio4KSglcmlwKQogCiAJLyogQWRkIGFuIElkZW50aXR5IG1hcHBpbmcg
aWYgSSBhbSBhYm92ZSAxRyAqLwogCWxlYXEJX3RleHQoJXJpcCksICVyZGkKQEAgLTMxNCw3ICsz
MTgsMTYgQEAgTkVYVF9QQUdFKGxldmVsM19rZXJuZWxfcGd0KQogCS5maWxsCTUxMCw4LDAKIAkv
KiAoMl40OC0oMioxMDI0KjEwMjQqMTAyNCktKCgyXjM5KSo1MTEpKS8oMl4zMCkgPSA1MTAgKi8K
IAkucXVhZAlsZXZlbDJfa2VybmVsX3BndCAtIF9fU1RBUlRfS0VSTkVMX21hcCArIF9LRVJOUEdf
VEFCTEUKLQkuZmlsbAkxLDgsMAorIAkucXVhZAlsZXZlbDJfZml4bWFwX3BndCAtIF9fU1RBUlRf
S0VSTkVMX21hcCArIF9QQUdFX1RBQkxFCisKK05FWFRfUEFHRShsZXZlbDJfZml4bWFwX3BndCkK
KwkuZmlsbAk1MDYsOCwwCisJLnF1YWQJbGV2ZWwxX2ZpeG1hcF9wZ3QgLSBfX1NUQVJUX0tFUk5F
TF9tYXAgKyBfS0VSTlBHX1RBQkxFCisJLyogOE1CIHJlc2VydmVkIGZvciB2c3lzY2FsbHMgKyBh
IDJNQiBob2xlID0gNCArIDEgZW50cmllcyAqLworCS5maWxsCTUsOCwwCisKK05FWFRfUEFHRShs
ZXZlbDFfZml4bWFwX3BndCkKKwkuZmlsbAk1MTIsOCwwCiAKIE5FWFRfUEFHRShsZXZlbDJfaWRl
bnRfcGd0KQogCS8qIFNpbmNlIEkgZWFzaWx5IGNhbiwgbWFwIHRoZSBmaXJzdCAxRy4K
------=_Part_88080_2770622.1179724746426--
