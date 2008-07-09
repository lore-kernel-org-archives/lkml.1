Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbYGIKBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbYGIKBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 06:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbYGIKBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 06:01:16 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:40917 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbYGIKBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 06:01:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=YPYkw9LwCxgEJxxrJ7Sy/Z3jqyNQhOVNyCljEpwBM4tjiQzmi8J54f2PnU2QJJE5tK
         C8N9M0njtLYXBNfyqj4EIjIBR0wx7oYqYIZWdbSevwg34lvq1WfAx2VYVl4/2kHb6p1n
         H4sqiP19mDMPh0uthUOuyDQ4mXIp44XvTLzr8=
Message-ID: <86802c440807090301k774d15cdj9aab256bae0ffe7@mail.gmail.com>
Date: Wed, 9 Jul 2008 03:01:14 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: not overmap than end in init_memory_mapping - 64bit
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080709084600.GA4919@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_29640_8144260.1215597674968"
References: <200807080141.05436.yhlu.kernel@gmail.com>
	 <200807080143.27997.yhlu.kernel@gmail.com>
	 <20080709073844.GB30428@elte.hu> <20080709083425.GA23952@elte.hu>
	 <86802c440807090137t41734ac3l25f565cf5efb3e7b@mail.gmail.com>
	 <20080709084600.GA4919@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_29640_8144260.1215597674968
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, Jul 9, 2008 at 1:46 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> > reverting the commit solves the crash. The crash seems to be because
>> > ACPI is unable to access that memory range. (perhaps early_ioremap
>> > fails?)
>>
>> system with less than 4g?
>
> yeah.
>
>> please test attached patch
>> [PATCH] x86: make max_pfn cover acpi table below 4g
>
> that fixed it, thanks.

please check fix for 32 bit too.

YH

------=_Part_29640_8144260.1215597674968
Content-Type: text/x-patch; name=e820_end_32.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fifrfeie0
Content-Disposition: attachment; filename=e820_end_32.patch

W1BBVENIXSB4ODY6IG1ha2UgZTgyMF9lbmQgcmV0dXJuIG1heCByYW0gdHlwZSBvbmx5IGZvciAz
MiBiaXQKCnRvIGF2b2lkIHdhcm5pbmcgZnJvbSBmaW5kX2xvd19wZm5fcmFuZ2UgZm9yIGhpZ2gg
cGFnZXMgc2l6ZSBldGMKClNpZ25lZC1vZmYtYnk6IFlpbmdoYWkgTHUgPHlobHUua2VybmVsQGdt
YWlsLmNvbT4KCi0tLQogYXJjaC94ODYva2VybmVsL2U4MjAuYyB8ICAgIDUgKysrKysKIDEgZmls
ZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKykKCkluZGV4OiBsaW51eC0yLjYvYXJjaC94ODYva2Vy
bmVsL2U4MjAuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3JpZy9hcmNoL3g4Ni9rZXJuZWwv
ZTgyMC5jCisrKyBsaW51eC0yLjYvYXJjaC94ODYva2VybmVsL2U4MjAuYwpAQCAtMTA2Niw2ICsx
MDY2LDExIEBAIHVuc2lnbmVkIGxvbmcgX19pbml0IGU4MjBfZW5kKHZvaWQpCiAJCXN0cnVjdCBl
ODIwZW50cnkgKmVpID0gJmU4MjAubWFwW2ldOwogCQl1bnNpZ25lZCBsb25nIGVuZF9wZm47CiAK
KyNpZmRlZiBDT05GSUdfWDg2XzMyCisJCWlmIChlaS0+dHlwZSAhPSBFODIwX1JBTSkKKwkJCWNv
bnRpbnVlOworI2VuZGlmCisKIAkJZW5kX3BmbiA9IChlaS0+YWRkciArIGVpLT5zaXplKSA+PiBQ
QUdFX1NISUZUOwogCQlpZiAoZW5kX3BmbiA+IGxhc3RfcGZuKQogCQkJbGFzdF9wZm4gPSBlbmRf
cGZuOwo=
------=_Part_29640_8144260.1215597674968--
