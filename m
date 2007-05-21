Return-Path: <linux-kernel-owner+w=401wt.eu-S1759582AbXEUFTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759582AbXEUFTd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 01:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758837AbXEUFTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 01:19:15 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:4919 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758772AbXEUFTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 01:19:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type;
        b=ON4V80N807frzk8u77PSelNtwRNiH4Cx3+mrBBO9d7h08LsOW2HP74u6Bzaj8INox7fAoJa+ZqA/PrUy+ehoEGzNxT1pO9gmXzz/IdfG6EQk1LRJACl/ih4hH64Kox/j/xs0KwH7SnHMEfbwbl3vMuet7Iki6l/tgdpgcqZ5Cy4=
Message-ID: <86802c440705202219o21d11023od1018d253364bf5c@mail.gmail.com>
Date: Sun, 20 May 2007 22:19:13 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, "Greg KH" <gregkh@suse.de>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Vivek Goyal" <vgoyal@in.ibm.com>
Subject: [PATCH 2/3]i386: early init pgt for fix virtual addr in head.S
Cc: "linux kernel mailing list" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_88084_21273204.1179724753442"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_88084_21273204.1179724753442
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

early init pgt for fix virtual addr in head.S, so can use set_fixmap
before setup_arch.
otherwise set_fixmap_nocache will not work for i386

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

------=_Part_88084_21273204.1179724753442
Content-Type: text/x-patch; name=head_s_init_fix_i386.diff; 
	charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f1yhpnsz
Content-Disposition: attachment; filename="head_s_init_fix_i386.diff"

ZGlmZiAtLWdpdCBhL2FyY2gvaTM4Ni9rZXJuZWwvaGVhZC5TIGIvYXJjaC9pMzg2L2tlcm5lbC9o
ZWFkLlMKaW5kZXggZjc0ZGZjNC4uMmQzNzg1MCAxMDA2NDQKLS0tIGEvYXJjaC9pMzg2L2tlcm5l
bC9oZWFkLlMKKysrIGIvYXJjaC9pMzg2L2tlcm5lbC9oZWFkLlMKQEAgLTE2OCw2ICsxNjgsMTIg
QEAgcGFnZV9wZGVfb2Zmc2V0ID0gKF9fUEFHRV9PRkZTRVQgPj4gMjApOwogLnNlY3Rpb24gLmlu
aXQudGV4dCwiYXgiLEBwcm9nYml0cwogI2VuZGlmCiAKKwkvKiBEbyBhbiBlYXJseSBpbml0aWFs
aXphdGlvbiBvZiB0aGUgZml4bWFwIGFyZWEgKi8KKwltb3ZsICQoc3dhcHBlcl9wZ19kaXIgLSBf
X1BBR0VfT0ZGU0VUKSwgJWVkeAorCW1vdmwgJChzd2FwcGVyX3BnX3BtZCAtIF9fUEFHRV9PRkZT
RVQpLCAlZWF4CisJYWRkbCAkMHgwMDcsICVlYXgJCQkvKiAweDAwNyA9IFBSRVNFTlQrUlcrVVNF
UiAqLworCW1vdmwgJWVheCwgNDA5MiglZWR4KQorCiAjaWZkZWYgQ09ORklHX1NNUAogRU5UUlko
c3RhcnR1cF8zMl9zbXApCiAJY2xkCkBAIC01MDcsNiArNTEzLDggQEAgRU5UUlkoX3N0ZXh0KQog
LnNlY3Rpb24gIi5ic3MucGFnZV9hbGlnbmVkIiwidyIKIEVOVFJZKHN3YXBwZXJfcGdfZGlyKQog
CS5maWxsIDEwMjQsNCwwCitFTlRSWShzd2FwcGVyX3BnX3BtZCkKKwkuZmlsbCAxMDI0LDQsMAkK
IEVOVFJZKGVtcHR5X3plcm9fcGFnZSkKIAkuZmlsbCA0MDk2LDEsMAogCg==
------=_Part_88084_21273204.1179724753442--
