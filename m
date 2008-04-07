Return-Path: <linux-kernel-owner+w=401wt.eu-S1753175AbYDGR73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbYDGR73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 13:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbYDGR7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 13:59:22 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:30450 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbYDGR7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 13:59:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=WQ5jsW2ER5quPSmyvi5LGDj+k9dk/0gSFLxvuHMgSBDCh9ZQ8JzgSK+xQyMlAy7cd0qCciPVfwwlN3D5zXfXiazOr5zKmEO+yPV0yLbluZVhIl48PJgE6tDBAYBy/iICoJUmQZH3FSEXJmUMAaeyxPU+/GpS860cnNFnSzqqqQY=
Message-ID: <86802c440804071059j6d8ca312m44faeb3395881f71@mail.gmail.com>
Date: Mon, 7 Apr 2008 10:59:19 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: + acpi-fix-bug-10124.patch added to -mm tree
Cc: "Zhao Yakui" <yakui.zhao@intel.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, "Greg KH" <greg@kroah.com>,
       lenb@kernel.org, stian@jordet.net,
       "Linux Kernel ML" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080407075624.GE2368@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_4195_30355701.1207591159336"
References: <200804032127.m33LRHxl023552@imap1.linux-foundation.org>
	 <20080403233701.GA13357@kroah.com>
	 <20080403170009.baa2b446.akpm@linux-foundation.org>
	 <1207492303.13675.4.camel@yakui_zhao.sh.intel.com>
	 <86802c440804060026o43507775icb4456c0a9f86e07@mail.gmail.com>
	 <20080407075624.GE2368@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_4195_30355701.1207591159336
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Mon, Apr 7, 2008 at 12:56 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>  > Ingo,
>  >
>  > A: - in x86.git/latest
>  > commit 3dab95bd91b6061a887b8a199261c1d92074da85
>  > Author: Yinghai Lu <yhlu.kernel@gmail.com>
>  > Date:   Tue Mar 4 11:34:23 2008 -0800
>  >
>  >     ACPI: Unneccessary to scan the PCI bus already scanned.
>  >
>  >     http://bugzilla.kernel.org/show_bug.cgi?id=10124
>  >
>  > is the one Yakui mentioned, but it is after
>  >
>  > B: - in x86.git/latest
>  > commit e5491e8eb56d2e4bb0e4a6795bf0662c6703d5ac
>  > Author: Yinghai Lu <Yinghai.Lu@Sun.COM>
>  > Date:   Tue Feb 19 03:20:09 2008 -0800
>  >
>  >     x86: get mp_bus_to_node early
>  >
>  > C: - in x86.git/latest
>  > commit c0f03f8c4c8dc0aa5fb5d0b791e76f6dff84a288
>  > Author: Yinghai Lu <Yinghai.Lu@Sun.COM>
>  > Date:   Wed Feb 20 12:41:52 2008 -0800
>  >
>  >     x86/acpi: make dev_to_node return online node
>  >
>  > if the A kind patch is merged to Linus tree via Andrew, we may need
>  > update B and C. to make sure pci/acpi.c is same between B+C+A with new
>  > A + new B + new C
>
>  ok. Do you have a link/attachment for 'new A' that i could pick up into
>  x86.git/latest, so that i can update to 'new B' too that you sent? While
>  ACPI patches go via the ACPI tree, i'd like to track this topic
>  nevertheless.

please check the attached one with changelog update.

YH

------=_Part_4195_30355701.1207591159336
Content-Type: text/x-patch; name=acpi_pci_scan.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fercovza0
Content-Disposition: attachment; filename=acpi_pci_scan.patch

U3ViamVjdDogYWNwaTogdW5uZWNjZXNzYXJ5IHRvIHNjYW4gdGhlIFBDSSBidXMgYWxyZWFkeSBz
Y2FubmVkCkZyb206IFlha3VpIFpoYW8gPHlha3VpLnpoYW9AaW50ZWwuY29tPgoKaHR0cDovL2J1
Z3ppbGxhLmtlcm5lbC5vcmcvc2hvd19idWcuY2dpP2lkPTEwMTI0Cgp0aGlzIGNoYW5nZToKCiAg
ICAgY29tbWl0IDA4ZjFjMTkyYzNjMzI3OTcwNjhiZmU5NzczOGJhYmIzMjk1YmJmNDIKICAgICBB
dXRob3I6IE11bGkgQmVuLVllaHVkYSA8bXVsaUBpbC5pYm0uY29tPgogICAgIERhdGU6ICAgU3Vu
IEp1bCAyMiAwMDoyMzozOSAyMDA3ICswMzAwCgogICAgICAgIHg4Ni02NDogaW50cm9kdWNlIHN0
cnVjdCBwY2lfc3lzZGF0YSB0byBmYWNpbGl0YXRlIHNoYXJpbmcgb2YgLT5zeXNkYXRhCgogICAg
ICAgIFRoaXMgcGF0Y2ggaW50cm9kdWNlcyBzdHJ1Y3QgcGNpX3N5c2RhdGEgdG8geDg2IGFuZCB4
ODYtNjQsIGFuZAogICAgICAgIGNvbnZlcnRzIHRoZSBleGlzdGluZyB0d28gdXNlcnMgKE5VTUEs
IENhbGdhcnkpIHRvIHVzZSBpdC4KCiAgICAgICAgVGhpcyBsYXlzIHRoZSBncm91bmR3b3JrIGZv
ciBoYXZpbmcgb3RoZXIgdXNlcnMgb2Ygc3lzZGF0YSwgc3VjaCBhcwogICAgICAgIHRoZSBQQ0kg
ZG9tYWlucyB3b3JrLgoKICAgICAgICBUaGUgQ2FsZ2FyeSBiaXRzIGFyZSB0ZXN0ZWQsIHRoZSBO
VU1BIGJpdHMganVzdCBsb29rIG9rLgoKcmVwbGFjZXMgcGNpYmlvc19zY2FuX3Jvb3QgYnkgcGNp
X3NjYW5fYnVzX3BhcmVudGVkLi4uCgpidXQgaW4gcGNpYmlvc19zY2FuX3Jvb3Qgd2UgaGF2ZSBh
IGNoZWNrIGFib3V0IHNjYW5uZWQgYnVzc2VzLgoKWWluZ2hhaSB1cGRhdGVkIHRoZSBjaGFuZ2Vs
b2cuCgpDYzogPHlha3VpLnpoYW9AaW50ZWwuY29tPgpDYzogU3RpYW4gSm9yZGV0IDxzdGlhbkBq
b3JkZXQubmV0PgpDYzogTGVuIEJyb3duIDxsZW5iQGtlcm5lbC5vcmc+CkNjOiBHcmVnIEtIIDxn
cmVnQGtyb2FoLmNvbT4KQ2M6IEluZ28gTW9sbmFyIDxtaW5nb0BlbHRlLmh1PgpBY2tlZC1ieTog
WWluZ2hhaSBMdSA8eWhsdS5rZXJuZWxAZ21haWwuY29tPgpTaWduZWQtb2ZmLWJ5OiBBbmRyZXcg
TW9ydG9uIDxha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnPgoKSW5kZXg6IGxpbnV4LTIuNi9hcmNo
L3g4Ni9wY2kvYWNwaS5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2FyY2gveDg2L3Bj
aS9hY3BpLmMKKysrIGxpbnV4LTIuNi9hcmNoL3g4Ni9wY2kvYWNwaS5jCkBAIC0yMTksOCArMjE5
LDIxIEBAIHN0cnVjdCBwY2lfYnVzICogX19kZXZpbml0IHBjaV9hY3BpX3NjYW4KIAlpZiAocHht
ID49IDApCiAJCXNkLT5ub2RlID0gcHhtX3RvX25vZGUocHhtKTsKICNlbmRpZgorCS8qCisJICog
TWF5YmUgdGhlIGRlc2lyZWQgcGNpIGJ1cyBoYXMgYmVlbiBhbHJlYWR5IHNjYW5uZWQuIEluIHN1
Y2ggY2FzZQorCSAqIGl0IGlzIHVubmVjZXNzYXJ5IHRvIHNjYW4gdGhlIHBjaSBidXMgd2l0aCB0
aGUgZ2l2ZW4gZG9tYWluLGJ1c251bS4KKwkgKi8KKwlidXMgPSBwY2lfZmluZF9idXMoZG9tYWlu
LCBidXNudW0pOworCWlmIChidXMpIHsKKwkJLyoKKwkJICogSWYgdGhlIGRlc2lyZWQgYnVzIGV4
aXRzLCB0aGUgY29udGVudCBvZiBidXMtPnN5c2RhdGEgd2lsbAorCQkgKiBiZSByZXBsYWNlZCBi
eSBzZC4KKwkJICovCisJCW1lbWNweShidXMtPnN5c2RhdGEsIHNkLCBzaXplb2YoKnNkKSk7CisJ
CWtmcmVlKHNkKTsKKwl9IGVsc2UKKwkJYnVzID0gcGNpX3NjYW5fYnVzX3BhcmVudGVkKE5VTEws
IGJ1c251bSwgJnBjaV9yb290X29wcywgc2QpOwogCi0JYnVzID0gcGNpX3NjYW5fYnVzX3BhcmVu
dGVkKE5VTEwsIGJ1c251bSwgJnBjaV9yb290X29wcywgc2QpOwogCWlmICghYnVzKQogCQlrZnJl
ZShzZCk7CiAKQEAgLTIyOCw3ICsyNDEsNyBAQCBzdHJ1Y3QgcGNpX2J1cyAqIF9fZGV2aW5pdCBw
Y2lfYWNwaV9zY2FuCiAJaWYgKGJ1cyAhPSBOVUxMKSB7CiAJCWlmIChweG0gPj0gMCkgewogCQkJ
cHJpbnRrKCJidXMgJWQgLT4gcHhtICVkIC0+IG5vZGUgJWRcbiIsCi0JCQkJYnVzbnVtLCBweG0s
IHNkLT5ub2RlKTsKKwkJCQlidXNudW0sIHB4bSwgcHhtX3RvX25vZGUocHhtKSk7CiAJCX0KIAl9
CiAjZW5kaWYKSW5kZXg6IGxpbnV4LTIuNi9hcmNoL2lhNjQvcGNpL3BjaS5jCj09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0K
LS0tIGxpbnV4LTIuNi5vcmlnL2FyY2gvaWE2NC9wY2kvcGNpLmMKKysrIGxpbnV4LTIuNi9hcmNo
L2lhNjQvcGNpL3BjaS5jCkBAIC0zNjIsNyArMzYyLDEyIEBAIHBjaV9hY3BpX3NjYW5fcm9vdChz
dHJ1Y3QgYWNwaV9kZXZpY2UgKmQKIAlpbmZvLm5hbWUgPSBuYW1lOwogCWFjcGlfd2Fsa19yZXNv
dXJjZXMoZGV2aWNlLT5oYW5kbGUsIE1FVEhPRF9OQU1FX19DUlMsIGFkZF93aW5kb3csCiAJCQkm
aW5mbyk7Ci0KKwkvKgorCSAqIFNlZSBhcmNoL3g4Ni9wY2kvYWNwaS5jLgorCSAqIFRoZSBkZXNp
cmVkIHBjaSBidXMgbWlnaHQgYWxyZWFkeSBiZSBzY2FubmVkIGluIGEgcXVpcmsuIFdlCisJICog
c2hvdWxkIGhhbmRsZSB0aGUgY2FzZSBoZXJlLCBidXQgaXQgYXBwZWFycyB0aGF0IElBNjQgaGFz
bid0CisJICogc3VjaCBxdWlyay4gU28gd2UganVzdCBpZ25vcmUgdGhlIGNhc2Ugbm93LgorCSAq
LwogCXBidXMgPSBwY2lfc2Nhbl9idXNfcGFyZW50ZWQoTlVMTCwgYnVzLCAmcGNpX3Jvb3Rfb3Bz
LCBjb250cm9sbGVyKTsKIAlpZiAocGJ1cykKIAkJcGNpYmlvc19zZXR1cF9yb290X3dpbmRvd3Mo
cGJ1cywgY29udHJvbGxlcik7Cg==
------=_Part_4195_30355701.1207591159336--
