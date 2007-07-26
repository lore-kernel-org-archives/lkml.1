Return-Path: <linux-kernel-owner+w=401wt.eu-S935401AbXGZUHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935401AbXGZUHp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 16:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936185AbXGZUF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 16:05:58 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:42445 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936598AbXGZUF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 16:05:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type;
        b=H595NO+W/5xDcCT8Hi7SXK0e3IABLiFT0CQLnZJbzE/7EnsRzEHcaCxw4atjavrqJLdbA6zTyfUDgrxqCXh4lF2o2eD/kW0VPhmQqMXJekYWRWaHcCvyZrUTU4hZY9+SekCTDJGFkIXz0CUapPtdx4kTOzNEp6g3IGsimNtk/sk=
Message-ID: <86802c440707261305w7af95153rc46b23e950f5216f@mail.gmail.com>
Date: Thu, 26 Jul 2007 13:05:55 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>, "Andi Kleen" <ak@suse.de>,
       "Christoph Lameter" <clameter@sgi.com>
Subject: [PATCH 5/5] dma: use dev_to_node to get node for device in dma_alloc_pages
Cc: linux-kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_205620_22666076.1185480355755"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_205620_22666076.1185480355755
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline



------=_Part_205620_22666076.1185480355755
Content-Type: text/x-patch; name=bus_numa_5.diff; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f4loeqaw
Content-Disposition: attachment; filename="bus_numa_5.diff"

W1BBVENIIDUvNV0gZG1hOiB1c2UgZGV2X3RvX25vZGUgdG8gZ2V0IG5vZGUgZm9yIGRldmljZSBp
biBkbWFfYWxsb2NfcGFnZXMKClNpZ25lZC1vZmYtYnk6IFlpbmdoYWkgTHUgPHlpbmdoYWkubHVA
c3VuLmNvbT4KQWNrZWQtYnk6IENocmlzdG9waCBMYW1ldGVyIDxjbGFtZXRlckBzZ2kuY29tPgoK
ZGlmZiAtLWdpdCBhL2FyY2gveDg2XzY0L2tlcm5lbC9wY2ktZG1hLmMgYi9hcmNoL3g4Nl82NC9r
ZXJuZWwvcGNpLWRtYS5jCmluZGV4IDlmODBhYWQuLjZkYmYxYzkgMTAwNjQ0Ci0tLSBhL2FyY2gv
eDg2XzY0L2tlcm5lbC9wY2ktZG1hLmMKKysrIGIvYXJjaC94ODZfNjQva2VybmVsL3BjaS1kbWEu
YwpAQCAtNTIsMTEgKzUyLDkgQEAgZG1hX2FsbG9jX3BhZ2VzKHN0cnVjdCBkZXZpY2UgKmRldiwg
Z2ZwX3QgZ2ZwLCB1bnNpZ25lZCBvcmRlcikKIHsKIAlzdHJ1Y3QgcGFnZSAqcGFnZTsKIAlpbnQg
bm9kZTsKLSNpZmRlZiBDT05GSUdfUENJCi0JaWYgKGRldi0+YnVzID09ICZwY2lfYnVzX3R5cGUp
Ci0JCW5vZGUgPSBwY2lidXNfdG9fbm9kZSh0b19wY2lfZGV2KGRldiktPmJ1cyk7Ci0JZWxzZQot
I2VuZGlmCisKKwlub2RlID0gZGV2X3RvX25vZGUoZGV2KTsKKwlpZiAobm9kZSA9PSAtMSkKIAkJ
bm9kZSA9IG51bWFfbm9kZV9pZCgpOwogCiAJaWYgKG5vZGUgPCBmaXJzdF9ub2RlKG5vZGVfb25s
aW5lX21hcCkpCg==
------=_Part_205620_22666076.1185480355755--
