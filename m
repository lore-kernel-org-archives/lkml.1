Return-Path: <linux-kernel-owner+w=401wt.eu-S1757243AbZAGGrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243AbZAGGrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 01:47:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbZAGGrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 01:47:43 -0500
Received: from mail.lang.hm ([64.81.33.126]:53621 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443AbZAGGrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 01:47:42 -0500
Date: Tue, 6 Jan 2009 23:49:55 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Jiri Slaby <jirislaby@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: early exception error
In-Reply-To: <86802c440901052209k6785a2f6i755a758d087892f@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0901062348000.31038@asgard.lang.hm>
References: <20090102174845.GD5372@localhost>  <alpine.DEB.1.10.0901051520210.27641@asgard.lang.hm>  <alpine.DEB.1.10.0901051649250.28400@asgard.lang.hm>  <alpine.DEB.1.10.0901051653290.28400@asgard.lang.hm>  <49629FAF.6060709@kernel.org> 
 <alpine.DEB.1.10.0901051717440.28514@asgard.lang.hm>  <4962A4F0.7030201@kernel.org>  <alpine.DEB.1.10.0901051802320.28514@asgard.lang.hm>  <4962AE82.6050905@kernel.org>  <alpine.DEB.1.10.0901052126360.27565@asgard.lang.hm>
 <86802c440901052209k6785a2f6i755a758d087892f@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/Mixed; BOUNDARY="----=_Part_74637_3362945.1231222143888"
Content-ID: <alpine.DEB.1.10.0901062348001.31038@asgard.lang.hm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

------=_Part_74637_3362945.1231222143888
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; format=flowed
Content-ID: <alpine.DEB.1.10.0901062348002.31038@asgard.lang.hm>
Content-Disposition: INLINE

On Mon, 5 Jan 2009, Yinghai Lu wrote:

>> this seems to have solved the problem
>
> can you post boot log and lspci -vvxxx ?

I will do this tomorrow

>>
>> I do have another of these systems if there is any desire to do any more
>> troubleshooting (it would be really nice if things died with a better error
>> message for example)
>
> good,
> 0. setup serial cable between your two system. use minicom in your
> first system to capture serial message from second system
> 1. apply attached patch
> 2. we need full boot log of your second system. please boot with "
> debug console=uart8250,io,0x3f8,115200n8 pci=earlydump"

it will take me a little bit of time to do this. the one I've been working 
with is now my desktop at work, now that the holidays are over I need to 
work with it instead of rebooting it, the other boxes are in a stack at 
home. getting at them is easy compared to figuring out where to set them 
up. I should have something setup within a couple of days.

David Lang
------=_Part_74637_3362945.1231222143888
Content-Type: TEXT/X-PATCH; NAME=mminit_loglevel_2.patch
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.1.10.0901062348003.31038@asgard.lang.hm>
Content-Description: 
Content-Disposition: ATTACHMENT; FILENAME=mminit_loglevel_2.patch

RnJvbTogWWluZ2hhaSBMdSA8eWhsdS5rZXJuZWxAZ21haWwuY29tPgpTdWJqZWN0OiBbUEFUQ0hd
IG1tOiBwcmludCBvdXQgaW5mbyBhYm91dCBhZGRpbmcvcmVtb3ZpbmcgYWN0aXZlIHJlZ2lvbgoK
U2lnbmVkLW9mZi1ieTogWWluZ2hhaSBMdSA8eWhsdS5rZXJuZWxAZ21haWwuY29tPgoKLS0tCiBt
bS9wYWdlX2FsbG9jLmMgfCAgICA1ICsrLS0tCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25z
KCspLCAzIGRlbGV0aW9ucygtKQoKSW5kZXg6IGxpbnV4LTIuNi9tbS9wYWdlX2FsbG9jLmMKPT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvbW0vcGFnZV9hbGxvYy5jCisrKyBsaW51eC0yLjYv
bW0vcGFnZV9hbGxvYy5jCkBAIC0zNjI2LDggKzM2MjYsNyBAQCB2b2lkIF9faW5pdCBhZGRfYWN0
aXZlX3JhbmdlKHVuc2lnbmVkIGluCiB7CiAJaW50IGk7CiAKLQltbWluaXRfZHByaW50ayhNTUlO
SVRfVFJBQ0UsICJtZW1vcnlfcmVnaXN0ZXIiLAotCQkJIkVudGVyaW5nIGFkZF9hY3RpdmVfcmFu
Z2UoJWQsICUjbHgsICUjbHgpICIKKwlwcmludGsoS0VSTl9ERUJVRyAiQWRkaW5nIGFjdGl2ZSBy
YW5nZSAoJWQsICUjbHgsICUjbHgpICIKIAkJCSIlZCBlbnRyaWVzIG9mICVkIHVzZWRcbiIsCiAJ
CQluaWQsIHN0YXJ0X3BmbiwgZW5kX3BmbiwKIAkJCW5yX25vZGVtYXBfZW50cmllcywgTUFYX0FD
VElWRV9SRUdJT05TKTsKQEAgLTM2ODksNyArMzY4OCw3IEBAIHZvaWQgX19pbml0IHJlbW92ZV9h
Y3RpdmVfcmFuZ2UodW5zaWduZWQKIAlpbnQgaSwgajsKIAlpbnQgcmVtb3ZlZCA9IDA7CiAKLQlw
cmludGsoS0VSTl9ERUJVRyAicmVtb3ZlX2FjdGl2ZV9yYW5nZSAoJWQsICVsdSwgJWx1KVxuIiwK
KwlwcmludGsoS0VSTl9ERUJVRyAiUmVtb3ZpbmcgYWN0aXZlIHJhbmdlICglZCwgJSNseCwgJSNs
eClcbiIsCiAJCQkgIG5pZCwgc3RhcnRfcGZuLCBlbmRfcGZuKTsKIAogCS8qIEZpbmQgdGhlIG9s
ZCBhY3RpdmUgcmVnaW9uIGVuZCBhbmQgc2hyaW5rICovCg==
------=_Part_74637_3362945.1231222143888--
