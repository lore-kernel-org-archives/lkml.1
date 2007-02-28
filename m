Return-Path: <linux-kernel-owner+w=401wt.eu-S932195AbXB1SQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195AbXB1SQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 13:16:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932194AbXB1SQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 13:16:59 -0500
Received: from mga02.intel.com ([134.134.136.20]:15388 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932184AbXB1SQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 13:16:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,231,1170662400"; 
   d="scan'208"; a="202431449:sNHT24330474"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C75B64.9D3198F5"
Subject: RE: 2.6.21-rc1: known regressions (part 1)
Date: Wed, 28 Feb 2007 21:16:48 +0300
Message-ID: <E3C0BCA40296C347AF7142161DB9FC82B2EDB2@mssmsx411>
In-Reply-To: <20070225175247.GB12392@stusta.de>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.21-rc1: known regressions (part 1)
Thread-Index: AcdZBcaY92Pp2FIdT8Cy6HIJPC5wRACXhn7A
From: "Karasyov, Konstantin A" <konstantin.a.karasyov@intel.com>
To: "Adrian Bunk" <bunk@stusta.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Pavel Machek" <pavel@ucw.cz>, <linux-pm@lists.osdl.org>,
       "Ingo Molnar" <mingo@elte.hu>, <lenb@kernel.org>,
       <linux-acpi@vger.kernel.org>, "Arkadiusz Miskiewicz" <arekm@maven.pl>,
       <linux-usb-devel@lists.sourceforge.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
X-OriginalArrivalTime: 28 Feb 2007 18:16:52.0210 (UTC) FILETIME=[9EC7CD20:01C75B64]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C75B64.9D3198F5
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Arkadiusz,

Could try the attached patch to see if it solves the problem?
If not, please send the output of acpidump command and log.

Regards.
Konstantin.

>-----Original Message-----
>From: Adrian Bunk [mailto:bunk@stusta.de]
>Sent: Sunday, February 25, 2007 8:53 PM
>To: Linus Torvalds; Andrew Morton
>Cc: Linux Kernel Mailing List; Pavel Machek; Marcel Holtmann; linux-
>pm@lists.osdl.org; Michael S. Tsirkin; Ingo Molnar; lenb@kernel.org;
linux-
>acpi@vger.kernel.org; Yu, Luming; Arkadiusz Miskiewicz; Karasyov,
>Konstantin A; linux-usb-devel@lists.sourceforge.net; Thomas Meyer;
Andrew;
>Janosch Machowinski; Lebedev, Vladimir P; Lukas Hejtmanek;
>jgarzik@pobox.com; linux-ide@vger.kernel.org; Meelis Roos; Alan Cox;
Fabio
>Comolli; Jean-Luc Coulon; Markus Trippelsdorf; Tejun Heo; Rafael J.
Wysocki
>Subject: 2.6.21-rc1: known regressions (part 1)
>
>This email lists some known regressions in 2.6.21-rc1 compared to
2.6.20
>that are not yet fixed in Linus' tree.
>
>If you find your name in the Cc header, you are either submitter of one
>of the bugs, maintainer of an affectected subsystem or driver, a patch
>of you caused a breakage or I'm considering you in any other way
possibly
>involved with one or more of these issues.
>
>Due to the huge amount of recipients, please trim the Cc when
answering.
>
>
>Subject    : HP nx6325 notebook: usb mouse stops working after suspend
to
>ram
>References : http://lkml.org/lkml/2007/2/21/413
>Submitter  : Arkadiusz Miskiewicz <arekm@maven.pl>
>Caused-By  : Konstantin Karasyov <konstantin.a.karasyov@intel.com>
>             commit 0a6139027f3986162233adc17285151e78b39cac
>Status     : unknown
>
>


------_=_NextPart_001_01C75B64.9D3198F5
Content-Type: application/octet-stream;
	name="usb_power.patch"
Content-Transfer-Encoding: base64
Content-Description: usb_power.patch
Content-Disposition: attachment;
	filename="usb_power.patch"

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvYWNwaS9wb3dlci5jIGIvZHJpdmVycy9hY3BpL3Bvd2VyLmMK
aW5kZXggMWVmMzM4NS4uODY2YzhlNyAxMDA2NDQKLS0tIGEvZHJpdmVycy9hY3BpL3Bvd2VyLmMK
KysrIGIvZHJpdmVycy9hY3BpL3Bvd2VyLmMKQEAgLTQzNiw4ICs0MzYsNiBAQCBpbnQgYWNwaV9w
b3dlcl90cmFuc2l0aW9uKHN0cnVjdCBhY3BpX2RldmljZSAqZGV2aWNlLCBpbnQgc3RhdGUpCiAJ
Y2wgPSAmZGV2aWNlLT5wb3dlci5zdGF0ZXNbZGV2aWNlLT5wb3dlci5zdGF0ZV0ucmVzb3VyY2Vz
OwogCXRsID0gJmRldmljZS0+cG93ZXIuc3RhdGVzW3N0YXRlXS5yZXNvdXJjZXM7CiAKLQlkZXZp
Y2UtPnBvd2VyLnN0YXRlID0gQUNQSV9TVEFURV9VTktOT1dOOwotCiAJaWYgKCFjbC0+Y291bnQg
JiYgIXRsLT5jb3VudCkgewogCQlyZXN1bHQgPSAtRU5PREVWOwogCQlnb3RvIGVuZDsKQEAgLTQ2
OCwxMiArNDY2LDE1IEBAIGludCBhY3BpX3Bvd2VyX3RyYW5zaXRpb24oc3RydWN0IGFjcGlfZGV2
aWNlICpkZXZpY2UsIGludCBzdGF0ZSkKIAkJCWdvdG8gZW5kOwogCX0KIAotCS8qIFdlIHNob3Vs
ZG4ndCBjaGFuZ2UgdGhlIHN0YXRlIHRpbGwgYWxsIGFib3ZlIG9wZXJhdGlvbnMgc3VjY2VlZCAq
LwotCWRldmljZS0+cG93ZXIuc3RhdGUgPSBzdGF0ZTsKLSAgICAgIGVuZDoKLQlpZiAocmVzdWx0
KQorICAgICBlbmQ6CisJaWYgKHJlc3VsdCkgeworCQlkZXZpY2UtPnBvd2VyLnN0YXRlID0gQUNQ
SV9TVEFURV9VTktOT1dOOwogCQlwcmludGsoS0VSTl9XQVJOSU5HIFBSRUZJWCAiVHJhbnNpdGlv
bmluZyBkZXZpY2UgWyVzXSB0byBEJWRcbiIsCiAJCQkgICAgICBkZXZpY2UtPnBucC5idXNfaWQs
IHN0YXRlKTsKKwl9IGVsc2UgeworCS8qIFdlIHNob3VsZG4ndCBjaGFuZ2UgdGhlIHN0YXRlIHRp
bGwgYWxsIGFib3ZlIG9wZXJhdGlvbnMgc3VjY2VlZCAqLworIAkJZGV2aWNlLT5wb3dlci5zdGF0
ZSA9IHN0YXRlOworCX0KIAogCXJldHVybiByZXN1bHQ7CiB9CkBAIC02OTAsNyArNjkxLDggQEAg
c3RhdGljIGludCBhY3BpX3Bvd2VyX3Jlc3VtZShzdHJ1Y3QgYWNwaV9kZXZpY2UgKmRldmljZSkK
IAlpZiAoKHJlc291cmNlLT5zdGF0ZSA9PSBBQ1BJX1BPV0VSX1JFU09VUkNFX1NUQVRFX09OKSAm
JgogCSAgICBsaXN0X2VtcHR5KCZyZXNvdXJjZS0+cmVmZXJlbmNlKSkgewogCQltdXRleF91bmxv
Y2soJnJlc291cmNlLT5yZXNvdXJjZV9sb2NrKTsKLQkJcmVzdWx0ID0gYWNwaV9wb3dlcl9vZmZf
ZGV2aWNlKGRldmljZS0+aGFuZGxlLCBOVUxMKTsKKy8vCQlyZXN1bHQgPSBhY3BpX3Bvd2VyX29m
Zl9kZXZpY2UoZGV2aWNlLT5oYW5kbGUsIE5VTEwpOworcHJpbnRrKCJSRVNVTUU6IHBvd2VyIHJl
c291cmNlICVzIGZvdW5kIHRvIGJlIE9GRlxuIiwgZGV2aWNlLT5wbnAuYnVzX2lkKTsKIAkJcmV0
dXJuIHJlc3VsdDsKIAl9CiAK

------_=_NextPart_001_01C75B64.9D3198F5--
