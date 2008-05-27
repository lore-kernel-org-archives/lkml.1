Return-Path: <linux-kernel-owner+w=401wt.eu-S1759591AbYE0Wwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759591AbYE0Wwv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 18:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757348AbYE0Wwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 18:52:42 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:34965 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756803AbYE0Wwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 18:52:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=N7SDYNTSay21UM3Xv8ehURFMcUYuc6jJQsxTWLa/Q0f0/ut2ZSAD7K8i9JNv8dsBH7Ooo9sU5t9BDuCDACUYtGqZOTXiKNEQXpveLLm2Wgw0+f4Dv6E4twPG0r8r041eeapfs6RzEsQstsb/TQAviKETK34OigKRpCC6t6VsMVo=
Message-ID: <86802c440805271552k724415a6i66686b9abb8c083f@mail.gmail.com>
Date: Tue, 27 May 2008 15:52:20 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: [PATCH] x86: extend e820 ealy_res support 32bit - fix #2
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <483C8157.7080702@goop.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_10729_24272221.1211928740536"
References: <200805110030.15510.yhlu.kernel@gmail.com>
	 <200805180118.57863.yhlu.kernel@gmail.com>
	 <200805211840.18619.yhlu.kernel@gmail.com>
	 <200805251000.10205.yhlu.kernel@gmail.com>
	 <alpine.LFD.1.10.0805271744080.3295@apollo.tec.linutronix.de>
	 <483C70F9.2030901@goop.org>
	 <86802c440805271406l4348db33r5622c440b494baa2@mail.gmail.com>
	 <483C7BB0.6080901@goop.org>
	 <86802c440805271435l744eab84xe55ac9ce6196c03b@mail.gmail.com>
	 <483C8157.7080702@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_10729_24272221.1211928740536
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tue, May 27, 2008 at 2:47 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Yinghai Lu wrote:
>>
>> thanks for the explanation...
>>
>> method 1 need to be done.
>>
>> BTW, XEN PV only support 32 bit?
>>
>
> At the moment, but 64-bit is being worked on.  Any solution must work for
> both.
>

can you try attached patch?

Thanks

YH

------=_Part_10729_24272221.1211928740536
Content-Type: text/x-patch; name=init_pg_table_32.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fgr2uok60
Content-Disposition: attachment; filename=init_pg_table_32.patch

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9oZWFkMzIuYyBiL2FyY2gveDg2L2tlcm5lbC9o
ZWFkMzIuYwppbmRleCBjMjE2ZDNjLi4zNmFmMDAzIDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9rZXJu
ZWwvaGVhZDMyLmMKKysrIGIvYXJjaC94ODYva2VybmVsL2hlYWQzMi5jCkBAIC03Niw3ICs3Niw3
IEBAIHZvaWQgX19pbml0IGkzODZfc3RhcnRfa2VybmVsKHZvaWQpCiAJCXJlc2VydmVfZWFybHko
cmFtZGlza19pbWFnZSwgcmFtZGlza19lbmQsICJSQU1ESVNLIik7CiAJfQogI2VuZGlmCi0JcmVz
ZXJ2ZV9lYXJseShfX3BhX3N5bWJvbCgmX2VuZCksIGluaXRfcGdfdGFibGVzX2VuZCwgIklOSVRf
UEdfVEFCTEUiKTsKKwlyZXNlcnZlX2Vhcmx5KGluaXRfcGdfdGFibGVzX3N0YXJ0LCBpbml0X3Bn
X3RhYmxlc19lbmQsICJJTklUX1BHX1RBQkxFIik7CiAKIAlyZXNlcnZlX2ViZGFfcmVnaW9uKCk7
CiAKZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9oZWFkXzMyLlMgYi9hcmNoL3g4Ni9rZXJu
ZWwvaGVhZF8zMi5TCmluZGV4IGIyY2M3MzcuLmJlZjQ2MTggMTAwNjQ0Ci0tLSBhL2FyY2gveDg2
L2tlcm5lbC9oZWFkXzMyLlMKKysrIGIvYXJjaC94ODYva2VybmVsL2hlYWRfMzIuUwpAQCAtMTk0
LDYgKzE5NCw3IEBAIGRlZmF1bHRfZW50cnk6CiAJeG9ybCAlZWJ4LCVlYngJCQkJLyogJWVieCBp
cyBrZXB0IGF0IHplcm8gKi8KIAogCW1vdmwgJHBhKHBnMCksICVlZGkKKwltb3ZsICVlZGksIHBh
KGluaXRfcGdfdGFibGVzX3N0YXJ0KQogCW1vdmwgJHBhKHN3YXBwZXJfcGdfcG1kKSwgJWVkeAog
CW1vdmwgJFBURV9BVFRSLCAlZWF4CiAxMDoKQEAgLTIyOCw2ICsyMjksNyBAQCBkZWZhdWx0X2Vu
dHJ5OgogcGFnZV9wZGVfb2Zmc2V0ID0gKF9fUEFHRV9PRkZTRVQgPj4gMjApOwogCiAJbW92bCAk
cGEocGcwKSwgJWVkaQorCW1vdmwgJWVkaSwgcGEoaW5pdF9wZ190YWJsZXNfc3RhcnQpCiAJbW92
bCAkcGEoc3dhcHBlcl9wZ19kaXIpLCAlZWR4CiAJbW92bCAkUFRFX0FUVFIsICVlYXgKIDEwOgpk
aWZmIC0tZ2l0IGEvYXJjaC94ODYva2VybmVsL3NldHVwXzMyLmMgYi9hcmNoL3g4Ni9rZXJuZWwv
c2V0dXBfMzIuYwppbmRleCA4OTZlYzU5Li4zNDBjMTUzIDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9r
ZXJuZWwvc2V0dXBfMzIuYworKysgYi9hcmNoL3g4Ni9rZXJuZWwvc2V0dXBfMzIuYwpAQCAtNzEs
NiArNzEsNyBAQAogLyogVGhpcyB2YWx1ZSBpcyBzZXQgdXAgYnkgdGhlIGVhcmx5IGJvb3QgY29k
ZSB0byBwb2ludCB0byB0aGUgdmFsdWUKICAgIGltbWVkaWF0ZWx5IGFmdGVyIHRoZSBib290IHRp
bWUgcGFnZSB0YWJsZXMuICBJdCBjb250YWlucyBhICpwaHlzaWNhbCoKICAgIGFkZHJlc3MsIGFu
ZCBtdXN0IG5vdCBiZSBpbiB0aGUgLmJzcyBzZWdtZW50ISAqLwordW5zaWduZWQgbG9uZyBpbml0
X3BnX3RhYmxlc19zdGFydCBfX2luaXRkYXRhID0gfjBVTDsKIHVuc2lnbmVkIGxvbmcgaW5pdF9w
Z190YWJsZXNfZW5kIF9faW5pdGRhdGEgPSB+MFVMOwogCiAvKgpkaWZmIC0tZ2l0IGEvYXJjaC94
ODYvbGd1ZXN0L2Jvb3QuYyBiL2FyY2gveDg2L2xndWVzdC9ib290LmMKaW5kZXggZjVjYmI3NC4u
YzNhZjZjNiAxMDA2NDQKLS0tIGEvYXJjaC94ODYvbGd1ZXN0L2Jvb3QuYworKysgYi9hcmNoL3g4
Ni9sZ3Vlc3QvYm9vdC5jCkBAIC0xMDEyLDYgKzEwMTIsNyBAQCBfX2luaXQgdm9pZCBsZ3Vlc3Rf
aW5pdCh2b2lkKQogCSAqIGNsb2JiZXJlZC4gIFRoZSBMYXVuY2hlciBwbGFjZXMgb3VyIGluaXRp
YWwgcGFnZXRhYmxlcyBzb21ld2hlcmUgYXQKIAkgKiB0aGUgdG9wIG9mIG91ciBwaHlzaWNhbCBt
ZW1vcnksIHNvIHdlIGRvbid0IG5lZWQgZXh0cmEgc3BhY2U6IHNldAogCSAqIGluaXRfcGdfdGFi
bGVzX2VuZCB0byB0aGUgZW5kIG9mIHRoZSBrZXJuZWwuICovCisJaW5pdF9wZ190YWJsZXNfc3Rh
cnQgPSBfX3BhKHBnMCk7CiAJaW5pdF9wZ190YWJsZXNfZW5kID0gX19wYShwZzApOwogCiAJLyog
TG9hZCB0aGUgJWZzIHNlZ21lbnQgcmVnaXN0ZXIgKHRoZSBwZXItY3B1IHNlZ21lbnQgcmVnaXN0
ZXIpIHdpdGgKQEAgLTEwNjUsOSArMTA2Niw5IEBAIF9faW5pdCB2b2lkIGxndWVzdF9pbml0KHZv
aWQpCiAJcG1fcG93ZXJfb2ZmID0gbGd1ZXN0X3Bvd2VyX29mZjsKIAltYWNoaW5lX29wcy5yZXN0
YXJ0ID0gbGd1ZXN0X3Jlc3RhcnQ7CiAKLQkvKiBOb3cgd2UncmUgc2V0IHVwLCBjYWxsIHN0YXJ0
X2tlcm5lbCgpIGluIGluaXQvbWFpbi5jIGFuZCB3ZSBwcm9jZWVkCisJLyogTm93IHdlJ3JlIHNl
dCB1cCwgY2FsbCBpMzg2X3N0YXJ0X2tlcm5lbCgpIGluIGhlYWQzMi5jIGFuZCB3ZSBwcm9jZWVk
CiAJICogdG8gYm9vdCBhcyBub3JtYWwuICBJdCBuZXZlciByZXR1cm5zLiAqLwotCXN0YXJ0X2tl
cm5lbCgpOworCWkzODZfc3RhcnRfa2VybmVsKCk7CiB9CiAvKgogICogVGhpcyBtYXJrcyB0aGUg
ZW5kIG9mIHN0YWdlIElJIG9mIG91ciBqb3VybmV5LCBUaGUgR3Vlc3QuCmRpZmYgLS1naXQgYS9h
cmNoL3g4Ni94ZW4vZW5saWdodGVuLmMgYi9hcmNoL3g4Ni94ZW4vZW5saWdodGVuLmMKaW5kZXgg
NjkxZDI4Mi4uNTdlOTZhNiAxMDA2NDQKLS0tIGEvYXJjaC94ODYveGVuL2VubGlnaHRlbi5jCisr
KyBiL2FyY2gveDg2L3hlbi9lbmxpZ2h0ZW4uYwpAQCAtMTIyOCw2ICsxMjI4LDcgQEAgYXNtbGlu
a2FnZSB2b2lkIF9faW5pdCB4ZW5fc3RhcnRfa2VybmVsKHZvaWQpCiAKIAlwZ2QgPSAocGdkX3Qg
Kil4ZW5fc3RhcnRfaW5mby0+cHRfYmFzZTsKIAorCWluaXRfcGdfdGFibGVzX3N0YXJ0ID0gX19w
YShwZ2QpOwogCWluaXRfcGdfdGFibGVzX2VuZCA9IF9fcGEocGdkKSArIHhlbl9zdGFydF9pbmZv
LT5ucl9wdF9mcmFtZXMqUEFHRV9TSVpFOwogCiAJaW5pdF9tbS5wZ2QgPSBwZ2Q7IC8qIHVzZSB0
aGUgWGVuIHBhZ2V0YWJsZXMgdG8gc3RhcnQgKi8KQEAgLTEyNjYsNSArMTI2Nyw1IEBAIGFzbWxp
bmthZ2Ugdm9pZCBfX2luaXQgeGVuX3N0YXJ0X2tlcm5lbCh2b2lkKQogCX0KIAogCS8qIFN0YXJ0
IHRoZSB3b3JsZCAqLwotCXN0YXJ0X2tlcm5lbCgpOworCWkzODZfc3RhcnRfa2VybmVsKCk7CiB9
CmRpZmYgLS1naXQgYS9pbmNsdWRlL2FzbS14ODYvc2V0dXAuaCBiL2luY2x1ZGUvYXNtLXg4Ni9z
ZXR1cC5oCmluZGV4IGZmYTBmNTQuLjkyMDMwN2UgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvYXNtLXg4
Ni9zZXR1cC5oCisrKyBiL2luY2x1ZGUvYXNtLXg4Ni9zZXR1cC5oCkBAIC01OSw2ICs1OSw3IEBA
IGludCBfX2luaXQgY29weV9lODIwX21hcChzdHJ1Y3QgZTgyMGVudHJ5ICpiaW9zbWFwLCBpbnQg
bnJfbWFwKTsKIHZvaWQgX19pbml0IGFkZF9tZW1vcnlfcmVnaW9uKHVuc2lnbmVkIGxvbmcgbG9u
ZyBzdGFydCwKIAkJCSAgICAgIHVuc2lnbmVkIGxvbmcgbG9uZyBzaXplLCBpbnQgdHlwZSk7CiAK
K2V4dGVybiB1bnNpZ25lZCBsb25nIGluaXRfcGdfdGFibGVzX3N0YXJ0OwogZXh0ZXJuIHVuc2ln
bmVkIGxvbmcgaW5pdF9wZ190YWJsZXNfZW5kOwogCiAK
------=_Part_10729_24272221.1211928740536--
