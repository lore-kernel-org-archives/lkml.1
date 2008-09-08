Return-Path: <linux-kernel-owner+w=401wt.eu-S1753261AbYIHEST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbYIHEST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 00:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751126AbYIHESG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 00:18:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:2099 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbYIHESF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 00:18:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=g2qBpMAwGgZtUeRwUC9IZpZjbGih3DPQJesGh/Wp7nKRBG7aaoFgGMrrNRqyW9D2YH
         UoVF33AGoE6TVtTmf0V5HLliH1RfBuXfdTwFj8lnChKQV0YKJ93lm+Bs0EByCD0o8b9m
         1p/gBtsI0Xx67LMjw5EcNNEIr1wn4TjWtbqCY=
Message-ID: <aa79d98a0809072118o11f175d0g6ca02799e91f0508@mail.gmail.com>
Date: Mon, 8 Sep 2008 08:18:04 +0400
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [patch 3/3] x86: io-apic - code style cleaning for setup_IO_APIC_irqs
Cc: "Ingo Molnar" <mingo@elte.hu>, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, macro@linux-mips.org
In-Reply-To: <86802c440809071724i35a1e26frb01c401bee693ad@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_60208_11521770.1220847484770"
References: <20080904183748.950151853@gmail.com>
	 <48c02b6a.0637560a.15e9.ffffa39d@mx.google.com>
	 <20080905080447.GC12409@elte.hu> <20080905180126.GA19334@lenovo>
	 <20080905181111.GG27395@elte.hu> <20080905183347.GB19334@lenovo>
	 <20080905183835.GA19215@elte.hu> <20080906101533.GA7273@lenovo>
	 <20080906131217.GA4910@elte.hu>
	 <86802c440809071724i35a1e26frb01c401bee693ad@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_60208_11521770.1220847484770
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Mon, Sep 8, 2008 at 4:24 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Sat, Sep 6, 2008 at 6:12 AM, Ingo Molnar <mingo@elte.hu> wrote:
>>
>> * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>>
>>> By changing printout form we are able to shrink code a bit.
>>>
>>> Former printout example:
>>>
>>>       init IO_APIC IRQs
>>>        IO-APIC (apicid-pin) 1-1, 1-2, 1-3 not connected.
>>>        IO-APIC (apicid-pin) 2-1, 2-2, 2-3 not connected.
>>>
>>> New printout example:
>>>
>>>       init IO_APIC IRQs
>>>        1-1 1-2 1-3 (apicid-pin) not connected
>>>        2-1 2-2 2-3 (apicid-pin) not connected
>>
>> applied to tip/irq/sparseirq - thanks Cyrill.
>
> got
>  0-16<7> 0-17<7> 0-18<7> 0-19<7> 0-20<7> 0-21<7> 0-22<7> 0-23<7>
> (apicid-pin) not connected
>  1-0<7> 1-1<7> 1-2<7> 1-3<7> 1-4<7> 1-5<7> 1-6<7> 1-7<7> 1-8<7> 1-9<7>
> 1-10<7> 1-11<7> 1-12<7> 1-13<7> 1-14<7> 1-15<7> 1-16<7> 1-17<7>
> 1-18<7> 1-19<7> 1-20<7> 1-21<7> 1-22<7> 1-23<7> (apicid-pin) not
> connected
>
> can you remove the extra <7>?
>
> YH
>

Thanks Yinghai! The patch enveloped.
I'm overzealous with KERN_DEBUG marker. Sorry.
(Can't send it inlined - hope it's not a big problem)

Cyrill

------=_Part_60208_11521770.1220847484770
Content-Type: application/octet-stream; name=io-apic.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fkul26dl0
Content-Disposition: attachment; filename=io-apic.patch

RnJvbTogQ3lyaWxsIEdvcmN1bm92IDxnb3JjdW5vdkBnbWFpbC5jb20+DQpTdWJqZWN0OiBbUEFU
Q0hdIHg4NjogaW8tYXBpYyAtIGRvIG5vdCB1c2UgS0VSTl9ERUJVRyBtYXJrZXIgdG9vIG11Y2gN
Cg0KRG8gbm90IHVzZSBLRVJOX0RFQlVHIHNldmVyYWwgdGltZXMgb24gdGhlIHNhbWUgbGluZSBi
ZWluZyBwcmludGVkLg0KSW50cm9kdWNlZCBieSBtaW5lIHByZXZpb3VzIHBhdGNoLCBzb3JyeS4N
Cg0KUmVwb3J0ZWQtYnk6IFlpbmdoYWkgTHUgPHlobHUua2VybmVsQGdtYWlsLmNvbT4NClNpZ25l
ZC1vZmYtYnk6IEN5cmlsbCBHb3JjdW5vdiA8Z29yY3Vub3ZAZ21haWwuY29tPg0KLS0tDQoNCi0t
LSBhL2FyY2gveDg2L2tlcm5lbC9pb19hcGljLmMJTW9uIFNlcCAwOCAwNzozNDoxNiAyMDA4DQor
KysgYi9hcmNoL3g4Ni9rZXJuZWwvaW9fYXBpYy5jCU1vbiBTZXAgMDggMDg6MDY6MzAgMjAwOA0K
QEAgLTE1MjYsMTEgKzE1MjYsMTYgQEAgc3RhdGljIHZvaWQgX19pbml0IHNldHVwX0lPX0FQSUNf
aXJxcyh2bw0KIA0KIAkJCWlkeCA9IGZpbmRfaXJxX2VudHJ5KGFwaWMsIHBpbiwgbXBfSU5UKTsN
CiAJCQlpZiAoaWR4ID09IC0xKSB7DQotCQkJCWFwaWNfcHJpbnRrKEFQSUNfVkVSQk9TRSwNCi0J
CQkJCUtFUk5fREVCVUcgIiAlZC0lZCIsDQotCQkJCQltcF9pb2FwaWNzW2FwaWNdLm1wX2FwaWNp
ZCwgcGluKTsNCi0JCQkJaWYgKCFub3Rjb24pDQorCQkJCWlmICghbm90Y29uKSB7DQogCQkJCQlu
b3Rjb24gPSAxOw0KKwkJCQkJYXBpY19wcmludGsoQVBJQ19WRVJCT1NFLA0KKwkJCQkJCUtFUk5f
REVCVUcgIiAlZC0lZCIsDQorCQkJCQkJbXBfaW9hcGljc1thcGljXS5tcF9hcGljaWQsDQorCQkJ
CQkJcGluKTsNCisJCQkJfSBlbHNlDQorCQkJCQlhcGljX3ByaW50ayhBUElDX1ZFUkJPU0UsICIg
JWQtJWQiLA0KKwkJCQkJCW1wX2lvYXBpY3NbYXBpY10ubXBfYXBpY2lkLA0KKwkJCQkJCXBpbik7
DQogCQkJCWNvbnRpbnVlOw0KIAkJCX0NCiANCkBAIC0xNTQ2LDE0ICsxNTUxLDE0IEBAIHN0YXRp
YyB2b2lkIF9faW5pdCBzZXR1cF9JT19BUElDX2lycXModm8NCiAJCX0NCiAJCWlmIChub3Rjb24p
IHsNCiAJCQlhcGljX3ByaW50ayhBUElDX1ZFUkJPU0UsDQotCQkJCUtFUk5fREVCVUcgIiAoYXBp
Y2lkLXBpbikgbm90IGNvbm5lY3RlZFxuIik7DQorCQkJCSIgKGFwaWNpZC1waW4pIG5vdCBjb25u
ZWN0ZWRcbiIpOw0KIAkJCW5vdGNvbiA9IDA7DQogCQl9DQogCX0NCiANCiAJaWYgKG5vdGNvbikN
CiAJCWFwaWNfcHJpbnRrKEFQSUNfVkVSQk9TRSwNCi0JCQlLRVJOX0RFQlVHICIgKGFwaWNpZC1w
aW4pIG5vdCBjb25uZWN0ZWRcbiIpOw0KKwkJCSIgKGFwaWNpZC1waW4pIG5vdCBjb25uZWN0ZWRc
biIpOw0KIH0NCiANCiAvKg0K
------=_Part_60208_11521770.1220847484770--
