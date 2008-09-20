Return-Path: <linux-kernel-owner+w=401wt.eu-S1753854AbYITVf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbYITVf6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 17:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbYITVfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 17:35:50 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:7100 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbYITVfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 17:35:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=P0KlUaiu/mjTlhfNsbYN4hyN9oByGg1mGSu51hgPkyu3meXIKyQyO5pX0pzNn3bNRh
         8Dgy7wAoJE4qsHIv/LYub9GvKPG4S7f4LlmR4ZOgHAYxoBN/5l7+gCJC+mX7/Gzy6dCa
         BuaNMEGYBBCoQYuZsnw6EX5j78/U/EJryKEOM=
Message-ID: <86802c440809201435l6fdb7c90u59b6b816efb7f2f6@mail.gmail.com>
Date: Sat, 20 Sep 2008 14:35:48 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Chris Li" <lkml@chrisli.org>
Subject: Re: irq 19: nobody cared
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <70318cbf0809191532n6ebaa122v7d98815c8a65850b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_57638_33051216.1221946548309"
References: <70318cbf0809191340t4e9d4caft6656713576cd2084@mail.gmail.com>
	 <86802c440809191350h21327c76l55d2134d7667f5d0@mail.gmail.com>
	 <70318cbf0809191413v70c49eccq9ed16ae50864a1a5@mail.gmail.com>
	 <86802c440809191457g19e2cbbeo26aa3dff613b057f@mail.gmail.com>
	 <70318cbf0809191532n6ebaa122v7d98815c8a65850b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_57638_33051216.1221946548309
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Fri, Sep 19, 2008 at 3:32 PM, Chris Li <lkml@chrisli.org> wrote:
> On Fri, Sep 19, 2008 at 2:57 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>>
>> 0x1a.2
>> 0x1d.1
>> 0x1f.2
>> 0x1f.5
>>
>> are sharing pin 0x19...
>>
>> but early dump can not find 0x1a.2, 0x1f.2, 0x1f.5
>
> But later kernel does able to find those devices. Do you mean
> there is a bug in the early PCI scanning?
>

please apply attached patch and boot with pci=dump

YH

------=_Part_57638_33051216.1221946548309
Content-Type: text/x-patch;
 name=0006-pci-dump-pci-config-space-before-loading-driver.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_flcrbwjq0
Content-Disposition: attachment;
 filename=0006-pci-dump-pci-config-space-before-loading-driver.patch

RnJvbSAxNGY4ZGU5YjM5ODVmMWI1OGY5OWRlZTNlMzJiNDk2OWFmOGM2NjkzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBZaW5naGFpIEx1IDx5aGx1Lmtlcm5lbEBnbWFpbC5jb20+CkRh
dGU6IFNhdCwgMjAgU2VwIDIwMDggMTM6NTE6MDEgLTA3MDAKU3ViamVjdDogW1BBVENIIDA2LzI1
XSBwY2k6IGR1bXAgcGNpIGNvbmZpZyBzcGFjZSBiZWZvcmUgbG9hZGluZyBkcml2ZXIKCnRyeSB0
byBmaWd1cmUgb3V0IHdoeSBnZXQgZXh0cmEgaXJxIHRoYXQgY29uZnVzaW5nIHRoZSBkcml2ZXJz
LgoKYW5kIHNvbWV0aW1lIHBjaT1lYXJseWR1bXAgZG9lc24ndCBkdW1wIHNvbWUgZGV2aWNlLCBi
ZWNhdXNlIGxhdGUgcXVpcmtzCnVuaGlkZSBzb21lIHBjaSBkZXZpY2VzLi4uCgpTaWduZWQtb2Zm
LWJ5OiBZaW5naGFpIEx1IDx5aGx1Lmtlcm5lbEBnbWFpbC5jb20+Ci0tLQogZHJpdmVycy9wY2kv
cGNpLmMgfCAgIDQ0ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
CiAxIGZpbGVzIGNoYW5nZWQsIDQ0IGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0pCgpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9wY2kvcGNpLmMgYi9kcml2ZXJzL3BjaS9wY2kuYwppbmRleCBhOTMw
MWEyLi45ZWQwMTg3IDEwMDY0NAotLS0gYS9kcml2ZXJzL3BjaS9wY2kuYworKysgYi9kcml2ZXJz
L3BjaS9wY2kuYwpAQCAtMjcsNiArMjcsOCBAQCB1bnNpZ25lZCBpbnQgcGNpX3BtX2QzX2RlbGF5
ID0gMTA7CiBpbnQgcGNpX2RvbWFpbnNfc3VwcG9ydGVkID0gMTsKICNlbmRpZgogCitzdGF0aWMg
aW50IHBjaV9kdW1wX3JlZ3MgPSAwOworCiAjZGVmaW5lIERFRkFVTFRfQ0FSREJVU19JT19TSVpF
CQkoMjU2KQogI2RlZmluZSBERUZBVUxUX0NBUkRCVVNfTUVNX1NJWkUJKDY0KjEwMjQqMTAyNCkK
IC8qIHBjaT1jYm1lbXNpemU9bm5NLGNiaW9zaXplPW5uIGNhbiBvdmVycmlkZSB0aGlzICovCkBA
IC0xODcxLDYgKzE4NzMsNDMgQEAgc3RhdGljIHZvaWQgX19kZXZpbml0IHBjaV9ub19kb21haW5z
KHZvaWQpCiAjZW5kaWYKIH0KIAorc3RhdGljIHZvaWQgX19kZXZpbml0IHBjaV9kdW1wKHZvaWQp
Cit7CisJcGNpX2R1bXBfcmVncyA9IDE7Cit9CisKK3N0YXRpYyB2b2lkIGR1bXBfcGNpX2Rldmlj
ZV9yYW5nZShzdHJ1Y3QgcGNpX2RldiAqZGV2LCB1bnNpZ25lZCBzdGFydF9yZWcsIHVuc2lnbmVk
IHNpemUpCit7CisgICAgICAgIGludCBpOworICAgICAgICBpbnQgajsKKwl1MzIgdmFsOworICAg
ICAgICBpbnQgZW5kID0gc3RhcnRfcmVnICsgc2l6ZTsKKworCXByaW50aygiUENJOiAlcyIsIHBj
aV9uYW1lKGRldikpOworCisgICAgICAgIGZvciAoaSA9IHN0YXJ0X3JlZzsgaSA8IGVuZDsgaSAr
PSA0KSB7CisgICAgICAgICAgICAgICAgaWYgKCEoaSAmIDB4MGYpKQorICAgICAgICAgICAgICAg
ICAgICAgICAgcHJpbnRrKCJcbiUwNHg6IixpKTsKKworICAgICAgICAgICAgICAgIHBjaV9yZWFk
X2NvbmZpZ19kd29yZChkZXYsIGksICZ2YWwpOworICAgICAgICAgICAgICAgIGZvciAoaiA9IDA7
IGogPCA0OyBqKyspIHsKKyAgICAgICAgICAgICAgICAgICAgICAgIHByaW50aygiICUwMngiLCB2
YWwgJiAweGZmKTsKKyAgICAgICAgICAgICAgICAgICAgICAgIHZhbCA+Pj0gODsKKyAgICAgICAg
ICAgICAgICB9CisgICAgICAgIH0KKyAgICAgICAgcHJpbnRrKCJcbiIpOworfQorCitzdGF0aWMg
aW50IGR1bXBfcGNpX2RldmljZXModm9pZCkKK3sKKwlzdHJ1Y3QgcGNpX2RldiAqZGV2ID0gTlVM
TDsKKworCXdoaWxlICgoZGV2ID0gcGNpX2dldF9kZXZpY2UoUENJX0FOWV9JRCwgUENJX0FOWV9J
RCwgZGV2KSkgIT0gTlVMTCkgeworCQlkdW1wX3BjaV9kZXZpY2VfcmFuZ2UoZGV2LCAwLCBkZXYt
PmNmZ19zaXplKTsKKwl9CisJcmV0dXJuIDA7Cit9CisKIHN0YXRpYyBpbnQgX19kZXZpbml0IHBj
aV9pbml0KHZvaWQpCiB7CiAJc3RydWN0IHBjaV9kZXYgKmRldiA9IE5VTEw7CkBAIC0xODc4LDYg
KzE5MTcsOSBAQCBzdGF0aWMgaW50IF9fZGV2aW5pdCBwY2lfaW5pdCh2b2lkKQogCXdoaWxlICgo
ZGV2ID0gcGNpX2dldF9kZXZpY2UoUENJX0FOWV9JRCwgUENJX0FOWV9JRCwgZGV2KSkgIT0gTlVM
TCkgewogCQlwY2lfZml4dXBfZGV2aWNlKHBjaV9maXh1cF9maW5hbCwgZGV2KTsKIAl9CisKKwlp
ZiAocGNpX2R1bXBfcmVncykKKwkJZHVtcF9wY2lfZGV2aWNlcygpOwogCXJldHVybiAwOwogfQog
CkBAIC0xODk0LDYgKzE5MzYsOCBAQCBzdGF0aWMgaW50IF9fZGV2aW5pdCBwY2lfc2V0dXAoY2hh
ciAqc3RyKQogCQkJCXBjaV9ub19hZXIoKTsKIAkJCX0gZWxzZSBpZiAoIXN0cmNtcChzdHIsICJu
b2RvbWFpbnMiKSkgewogCQkJCXBjaV9ub19kb21haW5zKCk7CisJCQl9IGVsc2UgaWYgKCFzdHJj
bXAoc3RyLCAiZHVtcCIpKSB7CisJCQkJcGNpX2R1bXAoKTsKIAkJCX0gZWxzZSBpZiAoIXN0cm5j
bXAoc3RyLCAiY2Jpb3NpemU9IiwgOSkpIHsKIAkJCQlwY2lfY2FyZGJ1c19pb19zaXplID0gbWVt
cGFyc2Uoc3RyICsgOSwgJnN0cik7CiAJCQl9IGVsc2UgaWYgKCFzdHJuY21wKHN0ciwgImNibWVt
c2l6ZT0iLCAxMCkpIHsKLS0gCjEuNS42Cgo=
------=_Part_57638_33051216.1221946548309--
