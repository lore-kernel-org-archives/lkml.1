Return-Path: <linux-kernel-owner+w=401wt.eu-S1753648AbZHTJfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbZHTJfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 05:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbZHTJfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 05:35:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:20244 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779AbZHTJfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 05:35:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,413,1246863600"; 
   d="scan'208";a="441055960"
From: "Wang, Shane" <shane.wang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "Cihula, Joseph" <joseph.cihula@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>,
       "Wei, Gang" <gang.wei@intel.com>
Date: Thu, 20 Aug 2009 17:33:50 +0800
Subject: RE: [RFC v6][PATCH 2/4] intel_txt: Intel(R) TXT reboot/halt
	shutdown support
Thread-Topic: [RFC v6][PATCH 2/4] intel_txt: Intel(R) TXT reboot/halt
	shutdown support
Thread-Index: AcofUwTtL5NsmDyTSqG7F9pk8g5YJACIV/vw
Message-ID: <037F493892196B458CD3E193E8EBAD4F01EC3AB3B2@pdsmsx502.ccr.corp.intel.com>
References: <4A4ACA66.2000706@intel.com> <20090817154055.GA12985@elte.hu>
 <20090817155348.GA2254@elte.hu>
In-Reply-To: <20090817155348.GA2254@elte.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: multipart/mixed;
	boundary="_002_037F493892196B458CD3E193E8EBAD4F01EC3AB3B2pdsmsx502ccrc_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_037F493892196B458CD3E193E8EBAD4F01EC3AB3B2pdsmsx502ccrc_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Ingo & hpa,

I have made some change on the previous tboot patch to fix the build errors=
.
Please comment.

Thanks.
Shane

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
>=20
>>> +	tboot_create_trampoline();
>>> +
>>>  	/* Do the rest non-__init'ed, we're now alive */
>>>  	rest_init();
>>>  }
>>=20
>> hm, this breaks the kernel build on every non-x86 architecture -
>> none of which has asm/tboot.h.
>=20
> also, tboot modifies kernel/cpu.c (and that too breaks the build) -
> why? I've excluded x86/txt from tip:master for now.
>=20
> 	Ingo


--_002_037F493892196B458CD3E193E8EBAD4F01EC3AB3B2pdsmsx502ccrc_
Content-Type: application/octet-stream; name="tboot_fix.patch"
Content-Description: tboot_fix.patch
Content-Disposition: attachment; filename="tboot_fix.patch"; size=2319;
	creation-date="Thu, 20 Aug 2009 08:55:00 GMT";
	modification-date="Thu, 20 Aug 2009 08:55:00 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtciAwNGYyNDlmMDAzMDMgZHJpdmVycy9hY3BpL2FjcGljYS9od3NsZWVwLmMKLS0tIGEv
ZHJpdmVycy9hY3BpL2FjcGljYS9od3NsZWVwLmMJVHVlIEF1ZyAxOCAxMjowNjo1NyAyMDA5IC0w
NzAwCisrKyBiL2RyaXZlcnMvYWNwaS9hY3BpY2EvaHdzbGVlcC5jCVdlZCBBdWcgMTkgMTU6MjM6
NDQgMjAwOSAtMDcwMApAQCAtNDUsNyArNDUsMTIgQEAKICNpbmNsdWRlIDxhY3BpL2FjcGkuaD4K
ICNpbmNsdWRlICJhY2NvbW1vbi5oIgogI2luY2x1ZGUgImFjdGFibGVzLmgiCisKKyNpZmRlZiBD
T05GSUdfWDg2CiAjaW5jbHVkZSA8YXNtL3Rib290Lmg+CisjZWxzZQorI2RlZmluZSB0Ym9vdF9z
bGVlcChzbGVlcF9zdGF0ZSwgcG0xYV9jb250cm9sLCBwbTFiX2NvbnRyb2wpIGRvIHsgfSB3aGls
ZSAoMCkKKyNlbmRpZgogCiAjZGVmaW5lIF9DT01QT05FTlQgICAgICAgICAgQUNQSV9IQVJEV0FS
RQogQUNQSV9NT0RVTEVfTkFNRSgiaHdzbGVlcCIpCmRpZmYgLXIgMDRmMjQ5ZjAwMzAzIGRyaXZl
cnMvcGNpL2RtYXIuYwotLS0gYS9kcml2ZXJzL3BjaS9kbWFyLmMJVHVlIEF1ZyAxOCAxMjowNjo1
NyAyMDA5IC0wNzAwCisrKyBiL2RyaXZlcnMvcGNpL2RtYXIuYwlXZWQgQXVnIDE5IDE1OjIzOjQ0
IDIwMDkgLTA3MDAKQEAgLTMzLDcgKzMzLDEyIEBACiAjaW5jbHVkZSA8bGludXgvdGltZXIuaD4K
ICNpbmNsdWRlIDxsaW51eC9pcnEuaD4KICNpbmNsdWRlIDxsaW51eC9pbnRlcnJ1cHQuaD4KKwor
I2lmZGVmIENPTkZJR19YODYKICNpbmNsdWRlIDxhc20vdGJvb3QuaD4KKyNlbHNlCisjZGVmaW5l
IHRib290X2dldF9kbWFyX3RhYmxlKHgpICh4KQorI2VuZGlmCiAKICN1bmRlZiBQUkVGSVgKICNk
ZWZpbmUgUFJFRklYICJETUFSOiIKZGlmZiAtciAwNGYyNDlmMDAzMDMgZHJpdmVycy9wY2kvaW50
ZWwtaW9tbXUuYwotLS0gYS9kcml2ZXJzL3BjaS9pbnRlbC1pb21tdS5jCVR1ZSBBdWcgMTggMTI6
MDY6NTcgMjAwOSAtMDcwMAorKysgYi9kcml2ZXJzL3BjaS9pbnRlbC1pb21tdS5jCVdlZCBBdWcg
MTkgMTU6MjM6NDQgMjAwOSAtMDcwMApAQCAtMzgsOSArMzgsMTQgQEAKICNpbmNsdWRlIDxsaW51
eC9pbnRlbC1pb21tdS5oPgogI2luY2x1ZGUgPGxpbnV4L3N5c2Rldi5oPgogI2luY2x1ZGUgPGFz
bS9jYWNoZWZsdXNoLmg+Ci0jaW5jbHVkZSA8YXNtL3Rib290Lmg+CiAjaW5jbHVkZSA8YXNtL2lv
bW11Lmg+CiAjaW5jbHVkZSAicGNpLmgiCisKKyNpZmRlZiBDT05GSUdfWDg2CisjaW5jbHVkZSA8
YXNtL3Rib290Lmg+CisjZWxzZQorI2RlZmluZSB0Ym9vdF9mb3JjZV9pb21tdSgpIDAKKyNlbmRp
ZgogCiAjZGVmaW5lIFJPT1RfU0laRQkJVlREX1BBR0VfU0laRQogI2RlZmluZSBDT05URVhUX1NJ
WkUJCVZURF9QQUdFX1NJWkUKZGlmZiAtciAwNGYyNDlmMDAzMDMgaW5pdC9tYWluLmMKLS0tIGEv
aW5pdC9tYWluLmMJVHVlIEF1ZyAxOCAxMjowNjo1NyAyMDA5IC0wNzAwCisrKyBiL2luaXQvbWFp
bi5jCVdlZCBBdWcgMTkgMTU6MjM6NDQgMjAwOSAtMDcwMApAQCAtNzMsMTMgKzczLDE5IEBACiAj
aW5jbHVkZSA8YXNtL2lvLmg+CiAjaW5jbHVkZSA8YXNtL2J1Z3MuaD4KICNpbmNsdWRlIDxhc20v
c2V0dXAuaD4KLSNpbmNsdWRlIDxhc20vdGJvb3QuaD4KICNpbmNsdWRlIDxhc20vc2VjdGlvbnMu
aD4KICNpbmNsdWRlIDxhc20vY2FjaGVmbHVzaC5oPgogCiAjaWZkZWYgQ09ORklHX1g4Nl9MT0NB
TF9BUElDCiAjaW5jbHVkZSA8YXNtL3NtcC5oPgogI2VuZGlmCisKKyNpZmRlZiBDT05GSUdfWDg2
CisjaW5jbHVkZSA8YXNtL3Rib290Lmg+CisjZWxzZQorI2RlZmluZSB0Ym9vdF9jcmVhdGVfdHJh
bXBvbGluZSgpIGRvIHsgfSB3aGlsZSAoMCkKKyNlbmRpZgorCiAKIHN0YXRpYyBpbnQga2VybmVs
X2luaXQodm9pZCAqKTsKIApkaWZmIC1yIDA0ZjI0OWYwMDMwMyBrZXJuZWwvY3B1LmMKLS0tIGEv
a2VybmVsL2NwdS5jCVR1ZSBBdWcgMTggMTI6MDY6NTcgMjAwOSAtMDcwMAorKysgYi9rZXJuZWwv
Y3B1LmMJV2VkIEF1ZyAxOSAxNToyMzo0NCAyMDA5IC0wNzAwCkBAIC0xNCw3ICsxNCwxMiBAQAog
I2luY2x1ZGUgPGxpbnV4L2t0aHJlYWQuaD4KICNpbmNsdWRlIDxsaW51eC9zdG9wX21hY2hpbmUu
aD4KICNpbmNsdWRlIDxsaW51eC9tdXRleC5oPgorCisjaWZkZWYgQ09ORklHX1g4NgogI2luY2x1
ZGUgPGFzbS90Ym9vdC5oPgorI2Vsc2UKKyNkZWZpbmUgdGJvb3Rfd2FpdF9mb3JfYXBzKHgpIDAK
KyNlbmRpZgogCiAjaWZkZWYgQ09ORklHX1NNUAogLyogU2VyaWFsaXplcyB0aGUgdXBkYXRlcyB0
byBjcHVfb25saW5lX21hc2ssIGNwdV9wcmVzZW50X21hc2sgKi8K

--_002_037F493892196B458CD3E193E8EBAD4F01EC3AB3B2pdsmsx502ccrc_--
