Return-Path: <linux-kernel-owner+w=401wt.eu-S1756094AbYGCT3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094AbYGCT3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 15:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbYGCT3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 15:29:36 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:56579 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696AbYGCT3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 15:29:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=tyeQeCrKSoki9QhGNC3y0ZCXqSmmx0kfE/JNzvxTqGpZkPbpgxyPaB1BtkThTjqYwm
         kwTEDNgwRZCifTy/j7y+OuBliUCEKJVXY67VpvhLEVcXPODJdm1Ww6VH/KCratGsFzgA
         rhA8AGU2TLaVKQ7mN1g4usJu+S8VMin5LwX28=
Message-ID: <86802c440807031229m4f39139ar961346bc30e4a41e@mail.gmail.com>
Date: Thu, 3 Jul 2008 12:29:34 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>, "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [Xen-devel] Re: [PATCH 00 of 36] x86/paravirt: groundwork for 64-bit Xen support
Cc: "Nick Piggin" <npiggin@suse.de>, "Mark McLoughlin" <markmc@redhat.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       "Eduardo Habkost" <ehabkost@redhat.com>,
       "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Stephen Tweedie" <sct@redhat.com>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440807031219w1355c31axb4daf78f3ec626ed@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_12171_26843270.1215113374916"
References: <486539A3.3030102@goop.org> <486A57C8.3010008@goop.org>
	 <20080701203123.GG4896@elte.hu> <20080703091053.GA1883@elte.hu>
	 <86802c440807031120o6e87459em8c4f239eb1a2507c@mail.gmail.com>
	 <486D19B1.1080402@goop.org>
	 <86802c440807031130keada2fbva256f2efe3c4801@mail.gmail.com>
	 <486D1D40.9050309@goop.org>
	 <86802c440807031151o577d001g3e72bae3aa88df25@mail.gmail.com>
	 <86802c440807031219w1355c31axb4daf78f3ec626ed@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_12171_26843270.1215113374916
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thu, Jul 3, 2008 at 12:19 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Thu, Jul 3, 2008 at 11:51 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>> On Thu, Jul 3, 2008 at 11:41 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> ..
>>> I modified the vmemmap code so it would create 4k mappings if PSE isn't
>>> supported.  Did I get it wrong?  It should have no effect when PSE is
>>> available (which is any time you're not running under Xen).
>>>
>>
>> it could be address continuous checkup for printout in
>> vmemmap_populated has some problem...
>
> you moved p_end = p + PMD_SIZE before...
>
> if (p_end != p || node_start != node) {

Ingo,

please put attached patch after jeremy's xen pv64 patches.

YH

------=_Part_12171_26843270.1215113374916
Content-Type: text/x-patch; name=xen64_vmemmap_printout.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fi7r5te20
Content-Disposition: attachment; filename=xen64_vmemmap_printout.patch

W1BBVENIXSB4ODY6IGZpeCB2bWVtbWFwIHByaW50b3V0IGNoZWNrCgpTaWduZWQtb2ZmLWJ5OiBZ
aW5naGFpIEx1IDx5aGx1Lmtlcm5lbEBnbWFpbC5jb20+CgotLS0KIGFyY2gveDg2L21tL2luaXRf
NjQuYyB8ICAgIDYgKysrLS0tCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAzIGRl
bGV0aW9ucygtKQoKSW5kZXg6IGxpbnV4LTIuNi9hcmNoL3g4Ni9tbS9pbml0XzY0LmMKPT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PQotLS0gbGludXgtMi42Lm9yaWcvYXJjaC94ODYvbW0vaW5pdF82NC5jCisrKyBsaW51eC0y
LjYvYXJjaC94ODYvbW0vaW5pdF82NC5jCkBAIC0xMDU3LDkgKzEwNTcsNiBAQCB2bWVtbWFwX3Bv
cHVsYXRlKHN0cnVjdCBwYWdlICpzdGFydF9wYWdlCiAJCQkJCQlQQUdFX0tFUk5FTF9MQVJHRSk7
CiAJCQkJc2V0X3BtZChwbWQsIF9fcG1kKHB0ZV92YWwoZW50cnkpKSk7CiAKLQkJCQlhZGRyX2Vu
ZCA9IGFkZHIgKyBQTURfU0laRTsKLQkJCQlwX2VuZCA9IHAgKyBQTURfU0laRTsKLQogCQkJCS8q
IGNoZWNrIHRvIHNlZSBpZiB3ZSBoYXZlIGNvbnRpZ3VvdXMgYmxvY2tzICovCiAJCQkJaWYgKHBf
ZW5kICE9IHAgfHwgbm9kZV9zdGFydCAhPSBub2RlKSB7CiAJCQkJCWlmIChwX3N0YXJ0KQpAQCAt
MTA2OSw2ICsxMDY2LDkgQEAgdm1lbW1hcF9wb3B1bGF0ZShzdHJ1Y3QgcGFnZSAqc3RhcnRfcGFn
ZQogCQkJCQlub2RlX3N0YXJ0ID0gbm9kZTsKIAkJCQkJcF9zdGFydCA9IHA7CiAJCQkJfQorCisJ
CQkJYWRkcl9lbmQgPSBhZGRyICsgUE1EX1NJWkU7CisJCQkJcF9lbmQgPSBwICsgUE1EX1NJWkU7
CiAJCQl9IGVsc2UKIAkJCQl2bWVtbWFwX3ZlcmlmeSgocHRlX3QgKilwbWQsIG5vZGUsIGFkZHIs
IG5leHQpOwogCQl9Cg==
------=_Part_12171_26843270.1215113374916--
