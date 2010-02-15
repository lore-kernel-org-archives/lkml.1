Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab0BOA6v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 19:58:51 -0500
Received: from mail-pz0-f197.google.com ([209.85.222.197]:49086 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332Ab0BOA6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 19:58:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=fwGDA5ouGioNvYoN0qUlHaXEASuJin/aU1bsR63PAdxt9RzfbaQFnhHWO/F/v2EHIO
         IzLJGcTYgpv1D/JQtrmHqS8RdCCItUzGoU9jbEDGj7rWMbaapgvWFbAll5Q4ODB38IDL
         JdomcpR14lypFuLsWXkvWcTkQMHVe9GlqrzOY=
MIME-Version: 1.0
In-Reply-To: <20100214194046.GA11315@n2100.arm.linux.org.uk>
References: <d4d4c7ef1002140814x5c406afaq7f60dc584e389348@mail.gmail.com> 
	<20100214194046.GA11315@n2100.arm.linux.org.uk>
From: =?UTF-8?B?5p2o5Z+O?= <gump.yang@gmail.com>
Date: Mon, 15 Feb 2010 08:58:28 +0800
Message-ID: <d4d4c7ef1002141658x789730b8naaf38b04811559dd@mail.gmail.com>
Subject: Re: apply chip ID
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Nicolas Pitre <nico@marvell.com>, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=001636e0ad2cac3792047f991eef
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636e0ad2cac3792047f991eef
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

2010/2/15 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> On Mon, Feb 15, 2010 at 12:14:08AM +0800, =E6=9D=A8=E5=9F=8E wrote:
>> diff --git a/arch/arm/tools/mach-types b/arch/arm/tools/mach-types
>> index 07b976d..629b858 100644
>> --- a/arch/arm/tools/mach-types
>> +++ b/arch/arm/tools/mach-types
>> @@ -2635,3 +2635,4 @@ hw90240                 MACH_HW90240            HW=
90240                 2648
>> dm365_leopard         MACH_DM365_LEOPARD      DM365_LEOPARD           26=
49
>> mityomapl138          MACH_MITYOMAPL138       MITYOMAPL138            26=
50
>> scat110                       MACH_SCAT110            SCAT110           =
      2651
>> +ak780x                       MACH_AK780X             AK780X            =
      2557
>> +ak880x                       MACH_AK880X             AK880X            =
      2558
>
> This file is periodically replaced; as such taking patches for the file i=
s
> senseless.
>
> Moreover, your two additions refer to a number which is already allocated
> and in use for bcmring_evm_jazz and bcmring_sp - you can not use these
> numbers.
>

Hello Russell, sorry, i mean that get to obtain two ID. so I modify the pat=
ch.

>From 5986e814ba1745b9371de943ce18e29147361bac Mon Sep 17 00:00:00 2001
From: Gump Yang <gump.yang@gmail.com>
Date: Fri, 12 Feb 2010 23:12:21 +0800
Subject: [PATCH 05/10] apply anyka chip ID
MIME-Version: 1.0
Content-Type: text/plain; charset=3Dgbk
Content-Transfer-Encoding: 8bit

Signed-off-by: Gump Yang <gump.yang@gmail.com>
---
 arch/arm/tools/mach-types |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/tools/mach-types b/arch/arm/tools/mach-types
index 07b976d..629b858 100644
--- a/arch/arm/tools/mach-types
+++ b/arch/arm/tools/mach-types
@@ -2635,3 +2635,4 @@ hw90240			MACH_HW90240		HW90240			2648
dm365_leopard		MACH_DM365_LEOPARD	DM365_LEOPARD		2649
mityomapl138		MACH_MITYOMAPL138	MITYOMAPL138		2650
scat110			MACH_SCAT110		SCAT110			2651
+ak780x			MACH_AK780X		AK780X			2652
+ak880x			MACH_AK880X		AK880X			2653
\ No newline at end of file
--=20
1.6.6.1

--001636e0ad2cac3792047f991eef
Content-Type: application/octet-stream; name="0005-CPU.patch"
Content-Disposition: attachment; filename="0005-CPU.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g5ok3qv60

RnJvbSA1OTg2ZTgxNGJhMTc0NWI5MzcxZGU5NDNjZTE4ZTI5MTQ3MzYxYmFjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBHdW1wIFlhbmcgPGd1bXAueWFuZ0BnbWFpbC5jb20+CkRhdGU6
IEZyaSwgMTIgRmViIDIwMTAgMjM6MTI6MjEgKzA4MDAKU3ViamVjdDogW1BBVENIIDA1LzEwXSBh
cHBseSBhbnlrYSBjaGlwIElECk1JTUUtVmVyc2lvbjogMS4wCkNvbnRlbnQtVHlwZTogdGV4dC9w
bGFpbjsgY2hhcnNldD1nYmsKQ29udGVudC1UcmFuc2Zlci1FbmNvZGluZzogOGJpdAoKU2lnbmVk
LW9mZi1ieTogR3VtcCBZYW5nIDxndW1wLnlhbmdAZ21haWwuY29tPgotLS0KIGFyY2gvYXJtL3Rv
b2xzL21hY2gtdHlwZXMgfCAgICAxICsKIDEgZmlsZXMgY2hhbmdlZCwgMSBpbnNlcnRpb25zKCsp
LCAwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2FyY2gvYXJtL3Rvb2xzL21hY2gtdHlwZXMg
Yi9hcmNoL2FybS90b29scy9tYWNoLXR5cGVzCmluZGV4IDA3Yjk3NmQuLjYyOWI4NTggMTAwNjQ0
Ci0tLSBhL2FyY2gvYXJtL3Rvb2xzL21hY2gtdHlwZXMKKysrIGIvYXJjaC9hcm0vdG9vbHMvbWFj
aC10eXBlcwpAQCAtMjYzNSwzICsyNjM1LDQgQEAgaHc5MDI0MAkJCU1BQ0hfSFc5MDI0MAkJSFc5
MDI0MAkJCTI2NDgKZG0zNjVfbGVvcGFyZAkJTUFDSF9ETTM2NV9MRU9QQVJECURNMzY1X0xFT1BB
UkQJCTI2NDkKbWl0eW9tYXBsMTM4CQlNQUNIX01JVFlPTUFQTDEzOAlNSVRZT01BUEwxMzgJCTI2
NTAKc2NhdDExMAkJCU1BQ0hfU0NBVDExMAkJU0NBVDExMAkJCTI2NTEKK2FrNzgweAkJCU1BQ0hf
QUs3ODBYCQlBSzc4MFgJCQkyNjUyCithazg4MHgJCQlNQUNIX0FLODgwWAkJQUs4ODBYCQkJMjY1
MwpcIE5vIG5ld2xpbmUgYXQgZW5kIG9mIGZpbGUKLS0gCjEuNi42LjEKCg==
--001636e0ad2cac3792047f991eef--
