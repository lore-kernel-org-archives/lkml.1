Return-Path: <linux-kernel-owner+w=401wt.eu-S1760190AbYEXCaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760190AbYEXCaG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 22:30:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757288AbYEXC3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 22:29:53 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:34057 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756955AbYEXC3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 22:29:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=p40C57+aYR8nzGd6exKbhXMQHV2E4eWfAkKfuRkIcmbzTd/yBpQnQ5IYdoim6bHeacPEcKcIFvB8csZTwwCqPY3uzW9JvKoz+0HsblUpbMI1ev0kFFIefWaFe2FyQCtcOcjlCehyUFT3LSRa/wKFMIgycy3HkK4nkwDi0N7zybY=
Message-ID: <86802c440805231929p71c28320w272f4f19cfc45e34@mail.gmail.com>
Date: Fri, 23 May 2008 19:29:50 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ciaran McCreesh" <ciaran.mccreesh@googlemail.com>
Subject: Re: kernel boot hangs after x86: insert_resorce for lapic addr after e820_reserve_resources
Cc: "Bjorn Helgaas" <bjorn.helgaas@hp.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
In-Reply-To: <86802c440805231851t12a83e54w78d2c120ed3d6b20@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_14326_10578434.1211596190096"
References: <20080518014111.4f32298b@googlemail.com>
	 <86802c440805191822v5b572d03t1568b27eb2defa4a@mail.gmail.com>
	 <20080520022446.3b9c335a@googlemail.com>
	 <86802c440805191948h29769798qecc93b7aa5c9cd91@mail.gmail.com>
	 <20080520041655.0552236d@googlemail.com>
	 <86802c440805192022n29e191dfped3ee5afa7894288@mail.gmail.com>
	 <20080524005021.67b98674@snowcone>
	 <86802c440805231705g534e9245oc359dc316ae5b1cd@mail.gmail.com>
	 <20080524020950.1538624a@snowcone>
	 <86802c440805231851t12a83e54w78d2c120ed3d6b20@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_14326_10578434.1211596190096
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Fri, May 23, 2008 at 6:51 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Fri, May 23, 2008 at 6:09 PM, Ciaran McCreesh
> <ciaran.mccreesh@googlemail.com> wrote:
>> On Fri, 23 May 2008 17:05:34 -0700
>> "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
>>> > Without the ram_reserve
>>> > patch, /proc/iomem is as it was earlier in the discussion.
>>> >
>>> >> can you boot with pnpacpi=off ?
>>> >
>>> > No, that doesn't help either.
>>>
>>> how about /proc/iomem with pnpacpi=off?
>>
>> I've attached /proc/iomem from current head minus the original patch,
>> with and without pnpacpi=off.
>
> it's weird,
>
> you should have
>
> 00000 - 9f400: System RAM  ===> is not showing up
> 100000 - d7ff0000: System RAM ===> is not showing up
> 100000000-11fffffff : System RAM

please try to revert attached commit...

it seems that your compiler is not happy...

YH

------=_Part_14326_10578434.1211596190096
Content-Type: application/octet-stream; name=commit-0156126
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fgll2o0y0
Content-Disposition: attachment; filename=commit-0156126

Y29tbWl0IDAxNTYxMjY0YmQxZWExZDY1NGQwOWJhYmUwMmQ3ODRhNWIxNTAxMjQKQXV0aG9yOiBZ
aW5naGFpIEx1IDx5aGx1Lmtlcm5lbC5zZW5kQGdtYWlsLmNvbT4KRGF0ZTogICBUaHUgTWFyIDIw
IDIzOjU3OjIxIDIwMDggLTA3MDAKCiAgICB4ODY6IGFsbG9jYXRlIGU4MjAgcmVzb3VyY2Ugc3Ry
dWN0IGFsbCB0b2dldGhlcgogICAgCiAgICBkb24ndCBuZWVkIHRvIGFsbG9jYXRlIHRoYXQgb25l
IGJ5IG9uZQogICAgCiAgICBTaWduZWQtb2ZmLWJ5OiBZaW5naGFpIEx1IDx5aGx1Lmtlcm5lbEBn
bWFpbC5jb20+CiAgICBTaWduZWQtb2ZmLWJ5OiBJbmdvIE1vbG5hciA8bWluZ29AZWx0ZS5odT4K
CmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvZTgyMF82NC5jIGIvYXJjaC94ODYva2VybmVs
L2U4MjBfNjQuYwppbmRleCA0NTA5NzU3Li45MTg0ZTY0IDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9r
ZXJuZWwvZTgyMF82NC5jCisrKyBiL2FyY2gveDg2L2tlcm5lbC9lODIwXzY0LmMKQEAgLTMwMCw5
ICszMDAsMTAgQEAgdW5zaWduZWQgbG9uZyBfX2luaXQgZTgyMF9lbmRfb2ZfcmFtKHZvaWQpCiB2
b2lkIF9faW5pdCBlODIwX3Jlc2VydmVfcmVzb3VyY2VzKHZvaWQpCiB7CiAJaW50IGk7CisJc3Ry
dWN0IHJlc291cmNlICpyZXM7CisKKwlyZXMgPSBhbGxvY19ib290bWVtX2xvdyhzaXplb2Yoc3Ry
dWN0IHJlc291cmNlKSAqIGU4MjAubnJfbWFwKTsKIAlmb3IgKGkgPSAwOyBpIDwgZTgyMC5ucl9t
YXA7IGkrKykgewotCQlzdHJ1Y3QgcmVzb3VyY2UgKnJlczsKLQkJcmVzID0gYWxsb2NfYm9vdG1l
bV9sb3coc2l6ZW9mKHN0cnVjdCByZXNvdXJjZSkpOwogCQlzd2l0Y2ggKGU4MjAubWFwW2ldLnR5
cGUpIHsKIAkJY2FzZSBFODIwX1JBTToJcmVzLT5uYW1lID0gIlN5c3RlbSBSQU0iOyBicmVhazsK
IAkJY2FzZSBFODIwX0FDUEk6CXJlcy0+bmFtZSA9ICJBQ1BJIFRhYmxlcyI7IGJyZWFrOwpAQCAt
MzEzLDYgKzMxNCw3IEBAIHZvaWQgX19pbml0IGU4MjBfcmVzZXJ2ZV9yZXNvdXJjZXModm9pZCkK
IAkJcmVzLT5lbmQgPSByZXMtPnN0YXJ0ICsgZTgyMC5tYXBbaV0uc2l6ZSAtIDE7CiAJCXJlcy0+
ZmxhZ3MgPSBJT1JFU09VUkNFX01FTSB8IElPUkVTT1VSQ0VfQlVTWTsKIAkJaW5zZXJ0X3Jlc291
cmNlKCZpb21lbV9yZXNvdXJjZSwgcmVzKTsKKwkJcmVzKys7CiAJfQogfQogCg==
------=_Part_14326_10578434.1211596190096--
