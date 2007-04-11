Return-Path: <linux-kernel-owner+w=401wt.eu-S1030748AbXDKBwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030748AbXDKBwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 21:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030752AbXDKBwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 21:52:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:15170 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030748AbXDKBwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 21:52:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,392,1170662400"; 
   d="scan'208"; a="71674749:sNHT25082478"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C77BDC.1205E65B"
Subject: RE: Build error : 2.6.21-rc6-mm1 for arm
Date: Tue, 10 Apr 2007 18:52:32 -0700
Message-ID: <0C7297FA1D2D244A9C7F6959C0BF1E5201AE1CF1@azsmsx413.amr.corp.intel.com>
In-Reply-To: <20070410182502.a09632b2.akpm@linux-foundation.org>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: Build error : 2.6.21-rc6-mm1 for arm
Thread-Index: Acd72D1UOIMexLaoS8ibEBD/rbJ9mgAAL/gQ
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>
Cc: <linux-kernel@vger.kernel.org>, "Gary Zambrano" <zambrano@broadcom.com>
X-OriginalArrivalTime: 11 Apr 2007 01:52:33.0524 (UTC) FILETIME=[1268FB40:01C77BDC]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C77BDC.1205E65B
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> From: Andrew Morton [mailto:akpm@linux-foundation.org]
> On Tue, 10 Apr 2007 20:54:20 -0400
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
>=20
> > I get the following build error when compiling 2.6.21-rc6-mm1 for
arm
> > "footbridge" :
> >
> > ...
> >
> > make -f /home/compudj/git/linux-2.6-lttng/scripts/Makefile.build
obj=3Dinit
> >
/opt/crosstool/gcc-4.0.2-glibc-2.3.6/arm-unknown-linux-gnu/bin/arm-
> unknown-linux-gnu-gcc -Wp,-MD,init/.main.o.d  -nostdinc -isystem
>
/opt/crosstool/gcc-4.0.2-glibc-2.3.6/arm-unknown-linux-gnu/lib/gcc/arm-
> unknown-linux-gnu/4.0.2/include -D__KERNEL__ -Iinclude -Iinclude2 -
> I/home/compudj/git/linux-2.6-lttng/include -include
include/linux/autoconf.h -
> mlittle-endian -I/home/compudj/git/linux-2.6-lttng/init -Iinit -Wall
-Wundef -
> Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Os
-marm -
> fno-omit-frame-pointer -mapcs -mno-sched-prolog -mabi=3Dapcs-gnu
-mno-thumb-
> interwork -D__LINUX_ARM_ARCH__=3D4 -march=3Darmv4 =
-mtune=3Dstrongarm110
-msoft-float
> -Uarm -fno-omit-frame-pointer -fno-optimize-sibling-calls
-Wdeclaration-after-
> statement -Wno-pointer-sign  -D"KBUILD_STR(s)=3D#s" -
> D"KBUILD_BASENAME=3DKBUILD_STR(main)"
-D"KBUILD_MODNAME=3DKBUILD_STR(main)" -c -o
> init/main.o /home/compudj/git/linux-2.6-lttng/init/main.c
> > In file included from
/home/compudj/git/linux-2.6-lttng/include/linux/dma-
> mapping.h:34,
> >                  from /home/compudj/git/linux-2.6-
> lttng/include/linux/dmaengine.h:29,
> >                  from /home/compudj/git/linux-2.6-
> lttng/include/linux/skbuff.h:30,
> >                  from /home/compudj/git/linux-2.6-
> lttng/include/linux/netlink.h:140,
> >                  from /home/compudj/git/linux-2.6-
> lttng/include/linux/genetlink.h:4,
> >                  from /home/compudj/git/linux-2.6-
> lttng/include/net/genetlink.h:4,
> >                  from /home/compudj/git/linux-2.6-
> lttng/include/linux/taskstats_kern.h:12,
> >                  from
/home/compudj/git/linux-2.6-lttng/init/main.c:45:
> > include2/asm/dma-mapping.h: In function
'dma_sync_single_range_for_cpu':
> > include2/asm/dma-mapping.h:320: warning: implicit declaration of
function
> 'dma_sync_single_for_cpu'
> > include2/asm/dma-mapping.h: In function
'dma_sync_single_range_for_device':
> > include2/asm/dma-mapping.h:329: warning: implicit declaration of
function
> 'dma_sync_single_for_device'
> > include2/asm/dma-mapping.h: At top level:
> > include2/asm/dma-mapping.h:352: warning: conflicting types for
> 'dma_sync_single_for_cpu'
> > include2/asm/dma-mapping.h:352: error: static declaration of
> 'dma_sync_single_for_cpu' follows non-static declaration
> > include2/asm/dma-mapping.h:320: error: previous implicit declaration
of
> 'dma_sync_single_for_cpu' was here
> > include2/asm/dma-mapping.h:360: warning: conflicting types for
> 'dma_sync_single_for_device'
> > include2/asm/dma-mapping.h:360: error: static declaration of
> 'dma_sync_single_for_device' follows non-static declaration
> > include2/asm/dma-mapping.h:329: error: previous implicit declaration
of
> 'dma_sync_single_for_device' was here
> > make[2]: *** [init/main.o] Error 1
> > make[1]: *** [init] Error 2
> > make: *** [_all] Error 2
>=20
> Dan, this is caused by git-md-accel.patch
>=20

Looks like arm-dma-mappingh.patch is the culprit.  Fix attached.

--
Dan

------_=_NextPart_001_01C77BDC.1205E65B
Content-Type: application/octet-stream;
	name="fix-arm-dma-mappingh.patch"
Content-Transfer-Encoding: base64
Content-Description: fix-arm-dma-mappingh.patch
Content-Disposition: attachment;
	filename="fix-arm-dma-mappingh.patch"

Zml4IGNvbXBpbGUgZXJyb3IgY2F1c2VkIGJ5IGFybS1kbWEtbWFwcGluZ2gucGF0Y2gKCkZyb206
IERhbiBXaWxsaWFtcyA8ZGFuLmoud2lsbGlhbXNAaW50ZWwuY29tPgoKaW5jbHVkZS9hc20vZG1h
LW1hcHBpbmcuaDozNTI6IGVycm9yOiBjb25mbGljdGluZyB0eXBlcyBmb3IgJ2RtYV9zeW5jX3Np
bmdsZV9mb3JfY3B1JwppbmNsdWRlL2FzbS9kbWEtbWFwcGluZy5oOjMyMDogZXJyb3I6IHByZXZp
b3VzIGltcGxpY2l0IGRlY2xhcmF0aW9uIG9mICdkbWFfc3luY19zaW5nbGVfZm9yX2NwdScgd2Fz
CmhlcmUgaW5jbHVkZS9hc20vZG1hLW1hcHBpbmcuaDozNjA6IGVycm9yOiBjb25mbGljdGluZyB0
eXBlcyBmb3IgJ2RtYV9zeW5jX3NpbmdsZV9mb3JfZGV2aWNlJwppbmNsdWRlL2FzbS9kbWEtbWFw
cGluZy5oOjMyOTogZXJyb3I6IHByZXZpb3VzIGltcGxpY2l0IGRlY2xhcmF0aW9uIG9mICdkbWFf
c3luY19zaW5nbGVfZm9yX2RldmljZScKd2FzIGhlcmUKClNpZ25lZC1vZmYtYnk6IERhbiBXaWxs
aWFtcyA8ZGFuLmoud2lsbGlhbXNAaW50ZWwuY29tPgotLS0KCiBpbmNsdWRlL2FzbS1hcm0vZG1h
LW1hcHBpbmcuaCB8ICAgMzYgKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tCiAx
IGZpbGVzIGNoYW5nZWQsIDE4IGluc2VydGlvbnMoKyksIDE4IGRlbGV0aW9ucygtKQoKZGlmZiAt
LWdpdCBhL2luY2x1ZGUvYXNtLWFybS9kbWEtbWFwcGluZy5oIGIvaW5jbHVkZS9hc20tYXJtL2Rt
YS1tYXBwaW5nLmgKaW5kZXggZmQ4MjdjZC4uYWMxOWQ1MyAxMDA2NDQKLS0tIGEvaW5jbHVkZS9h
c20tYXJtL2RtYS1tYXBwaW5nLmgKKysrIGIvaW5jbHVkZS9hc20tYXJtL2RtYS1tYXBwaW5nLmgK
QEAgLTMxMSwyNCArMzExLDYgQEAgZXh0ZXJuIHZvaWQgZG1hX3VubWFwX3NnKHN0cnVjdCBkZXZp
Y2UgKiwgc3RydWN0IHNjYXR0ZXJsaXN0ICosIGludCwgZW51bSBkbWFfZGEKICNlbmRpZgogCiAj
aWZuZGVmIENPTkZJR19ETUFCT1VOQ0UKLXN0YXRpYyBpbmxpbmUgdm9pZAotZG1hX3N5bmNfc2lu
Z2xlX3JhbmdlX2Zvcl9jcHUoc3RydWN0IGRldmljZSAqZGV2LCBkbWFfYWRkcl90IGRtYV9oYW5k
bGUsCi0JCQkgICAgICB1bnNpZ25lZCBsb25nIG9mZnNldCwgc2l6ZV90IHNpemUsCi0JCQkgICAg
ICBlbnVtIGRtYV9kYXRhX2RpcmVjdGlvbiBkaXJlY3Rpb24pCi17Ci0JLyoganVzdCBzeW5jIGV2
ZXJ5dGhpbmcsIHRoYXQncyBhbGwgdGhlIHBjaSBBUEkgY2FuIGRvICovCi0JZG1hX3N5bmNfc2lu
Z2xlX2Zvcl9jcHUoZGV2LCBkbWFfaGFuZGxlLCBvZmZzZXQrc2l6ZSwgZGlyZWN0aW9uKTsKLX0K
LQotc3RhdGljIGlubGluZSB2b2lkCi1kbWFfc3luY19zaW5nbGVfcmFuZ2VfZm9yX2RldmljZShz
dHJ1Y3QgZGV2aWNlICpkZXYsIGRtYV9hZGRyX3QgZG1hX2hhbmRsZSwKLQkJCQkgdW5zaWduZWQg
bG9uZyBvZmZzZXQsIHNpemVfdCBzaXplLAotCQkJCSBlbnVtIGRtYV9kYXRhX2RpcmVjdGlvbiBk
aXJlY3Rpb24pCi17Ci0JLyoganVzdCBzeW5jIGV2ZXJ5dGhpbmcsIHRoYXQncyBhbGwgdGhlIHBj
aSBBUEkgY2FuIGRvICovCi0JZG1hX3N5bmNfc2luZ2xlX2Zvcl9kZXZpY2UoZGV2LCBkbWFfaGFu
ZGxlLCBvZmZzZXQrc2l6ZSwgZGlyZWN0aW9uKTsKLX0KLQogLyoqCiAgKiBkbWFfc3luY19zaW5n
bGVfZm9yX2NwdQogICogQGRldjogdmFsaWQgc3RydWN0IGRldmljZSBwb2ludGVyLCBvciBOVUxM
IGZvciBJU0EgYW5kIEVJU0EtbGlrZSBkZXZpY2VzCkBAIC0zNjEsNiArMzQzLDI0IEBAIGRtYV9z
eW5jX3NpbmdsZV9mb3JfZGV2aWNlKHN0cnVjdCBkZXZpY2UgKmRldiwgZG1hX2FkZHJfdCBoYW5k
bGUsIHNpemVfdCBzaXplLAogCWlmICghYXJjaF9pc19jb2hlcmVudCgpKQogCQljb25zaXN0ZW50
X3N5bmMoKHZvaWQgKilkbWFfdG9fdmlydChkZXYsIGhhbmRsZSksIHNpemUsIGRpcik7CiB9CisK
K3N0YXRpYyBpbmxpbmUgdm9pZAorZG1hX3N5bmNfc2luZ2xlX3JhbmdlX2Zvcl9jcHUoc3RydWN0
IGRldmljZSAqZGV2LCBkbWFfYWRkcl90IGRtYV9oYW5kbGUsCisJCQkgICAgICB1bnNpZ25lZCBs
b25nIG9mZnNldCwgc2l6ZV90IHNpemUsCisJCQkgICAgICBlbnVtIGRtYV9kYXRhX2RpcmVjdGlv
biBkaXJlY3Rpb24pCit7CisJLyoganVzdCBzeW5jIGV2ZXJ5dGhpbmcsIHRoYXQncyBhbGwgdGhl
IHBjaSBBUEkgY2FuIGRvICovCisJZG1hX3N5bmNfc2luZ2xlX2Zvcl9jcHUoZGV2LCBkbWFfaGFu
ZGxlLCBvZmZzZXQrc2l6ZSwgZGlyZWN0aW9uKTsKK30KKworc3RhdGljIGlubGluZSB2b2lkCitk
bWFfc3luY19zaW5nbGVfcmFuZ2VfZm9yX2RldmljZShzdHJ1Y3QgZGV2aWNlICpkZXYsIGRtYV9h
ZGRyX3QgZG1hX2hhbmRsZSwKKwkJCQkgdW5zaWduZWQgbG9uZyBvZmZzZXQsIHNpemVfdCBzaXpl
LAorCQkJCSBlbnVtIGRtYV9kYXRhX2RpcmVjdGlvbiBkaXJlY3Rpb24pCit7CisJLyoganVzdCBz
eW5jIGV2ZXJ5dGhpbmcsIHRoYXQncyBhbGwgdGhlIHBjaSBBUEkgY2FuIGRvICovCisJZG1hX3N5
bmNfc2luZ2xlX2Zvcl9kZXZpY2UoZGV2LCBkbWFfaGFuZGxlLCBvZmZzZXQrc2l6ZSwgZGlyZWN0
aW9uKTsKK30KICNlbHNlCiBleHRlcm4gdm9pZCBkbWFfc3luY19zaW5nbGVfcmFuZ2VfZm9yX2Nw
dShzdHJ1Y3QgZGV2aWNlKiwgZG1hX2FkZHJfdCwgdW5zaWduZWQgbG9uZywgc2l6ZV90LCBlbnVt
IGRtYV9kYXRhX2RpcmVjdGlvbik7CiBleHRlcm4gdm9pZCBkbWFfc3luY19zaW5nbGVfcmFuZ2Vf
Zm9yX2RldmljZShzdHJ1Y3QgZGV2aWNlKiwgZG1hX2FkZHJfdCwgdW5zaWduZWQgbG9uZywgc2l6
ZV90LCBlbnVtIGRtYV9kYXRhX2RpcmVjdGlvbik7Cg==

------_=_NextPart_001_01C77BDC.1205E65B--
