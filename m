Return-Path: <linux-kernel-owner+w=401wt.eu-S1751605AbXDDVRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605AbXDDVRA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 17:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751723AbXDDVQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 17:16:59 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:32628 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbXDDVQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 17:16:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=hCMFcp0+1tgPDpuZmo8jVFDNmR1WYZBm95QDOv2bKbhATz5p1XHJJZeQkXerlBjcNNvI1Kv4e38RGj+1NGvnKrBeNNdqER4Hrf/4lTpjNOVCD4lUXFwDkB3ZldIUffzBhjyqeGowTT1cWIhjRFoCwGfGhaKTUPleECaVIANQW2A=
Message-ID: <65258a580704041416v61c6f1a5qfd54cc98bd4e8300@mail.gmail.com>
Date: Wed, 4 Apr 2007 23:16:56 +0200
From: "Vincent Vanackere" <vincent.vanackere@gmail.com>
To: "=?ISO-8859-1?Q?=C9ric_Piel?=" <Eric.Piel@tremplin-utc.net>
Subject: Re: [PATCH] Make ati_remote button repeat sensitivity soft-configurable
Cc: "Karl Pickett" <karl.pickett@gmail.com>, linux-kernel@vger.kernel.org,
       inux-input@atrey.karlin.mff.cuni.cz
In-Reply-To: <461412C2.8090201@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_44576_14838512.1175721416181"
References: <f9be06770704031734k11ec894fpdf1afe385108aece@mail.gmail.com>
	 <461357D8.8060608@tremplin-utc.net>
	 <65258a580704040145m6eb7108frfa8197d3b88e207a@mail.gmail.com>
	 <f9be06770704040637k419a7fd7t2cdd52186d91ad5f@mail.gmail.com>
	 <f9be06770704040821h6d96e703hf405335fa73f289b@mail.gmail.com>
	 <65258a580704041352q664f5da2xeaeec1a82819d9ef@mail.gmail.com>
	 <461412C2.8090201@tremplin-utc.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_44576_14838512.1175721416181
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 4/4/07, =C9ric Piel <Eric.Piel@tremplin-utc.net> wrote:
> 04/04/2007 10:52 PM, Vincent Vanackere wrote/a =E9crit:
> > +        unsigned long first_jiffies;
>     ^^^^^^^^ space warning!
>
> Sorry for being annoying ;-)
> Eric
>

Indeed you are    8-)
... new version attached ...

Best regards,

Vincent

------=_Part_44576_14838512.1175721416181
Content-Type: text/x-patch; name=atiremote.diff; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f04a3k4y
Content-Disposition: attachment; filename="atiremote.diff"

LS0tIGRyaXZlcnMvdXNiL2lucHV0L2F0aV9yZW1vdGUuYy5vcmlnCTIwMDctMDQtMDQgMjI6MDU6
MTAuMDAwMDAwMDAwICswMjAwCisrKyBkcml2ZXJzL3VzYi9pbnB1dC9hdGlfcmVtb3RlLmMJMjAw
Ny0wNC0wNCAyMzowNjozMy4wMDAwMDAwMDAgKzAyMDAKQEAgLTEyMCw2ICsxMjAsNyBAQAogICog
YmVoYXZpb3VyLgogICovCiAjZGVmaW5lIEZJTFRFUl9USU1FCTYwIC8qIG1zZWMgKi8KKyNkZWZp
bmUgUkVQRUFUX0RFTEFZICAgIDUwMCAvKiBtc2VjICovCiAKIHN0YXRpYyB1bnNpZ25lZCBsb25n
IGNoYW5uZWxfbWFzazsKIG1vZHVsZV9wYXJhbShjaGFubmVsX21hc2ssIHVsb25nLCAwNjQ0KTsK
QEAgLTEzMyw2ICsxMzQsMTAgQEAKIG1vZHVsZV9wYXJhbShyZXBlYXRfZmlsdGVyLCBpbnQsIDA2
NDQpOwogTU9EVUxFX1BBUk1fREVTQyhyZXBlYXRfZmlsdGVyLCAiUmVwZWF0IGZpbHRlciB0aW1l
LCBkZWZhdWx0ID0gNjAgbXNlYyIpOwogCitzdGF0aWMgaW50IHJlcGVhdF9kZWxheSA9IFJFUEVB
VF9ERUxBWTsKK21vZHVsZV9wYXJhbShyZXBlYXRfZGVsYXksIGludCwgMDY0NCk7CitNT0RVTEVf
UEFSTV9ERVNDKHJlcGVhdF9kZWxheSwgIkRlbGF5IGJlZm9yZSBzZW5kaW5nIHJlcGVhdHMsIGRl
ZmF1bHQgPSA1MDAgbXNlYyIpOworCiAjZGVmaW5lIGRiZ2luZm8oZGV2LCBmb3JtYXQsIGFyZy4u
LikgZG8geyBpZiAoZGVidWcpIGRldl9pbmZvKGRldiAsIGZvcm1hdCAsICMjIGFyZyk7IH0gd2hp
bGUgKDApCiAjdW5kZWYgZXJyCiAjZGVmaW5lIGVycihmb3JtYXQsIGFyZy4uLikgcHJpbnRrKEtF
Uk5fRVJSIGZvcm1hdCAsICMjIGFyZykKQEAgLTE3NCw2ICsxNzksOCBAQAogCXVuc2lnbmVkIGNo
YXIgb2xkX2RhdGFbMl07ICAvKiBEZXRlY3QgZHVwbGljYXRlIGV2ZW50cyAqLwogCXVuc2lnbmVk
IGxvbmcgb2xkX2ppZmZpZXM7CiAJdW5zaWduZWQgbG9uZyBhY2NfamlmZmllczsgIC8qIGhhbmRs
ZSBhY2NlbGVyYXRpb24gKi8KKwl1bnNpZ25lZCBsb25nIGZpcnN0X2ppZmZpZXM7CisKIAl1bnNp
Z25lZCBpbnQgcmVwZWF0X2NvdW50OwogCiAJY2hhciBuYW1lW05BTUVfQlVGU0laRV07CkBAIC01
MDEsMjEgKzUwOCwzMSBAQAogCX0KIAogCWlmIChhdGlfcmVtb3RlX3RibFtpbmRleF0ua2luZCA9
PSBLSU5EX0ZJTFRFUkVEKSB7CisJCXVuc2lnbmVkIGxvbmcgbm93ID0gamlmZmllczsKKwogCQkv
KiBGaWx0ZXIgZHVwbGljYXRlIGV2ZW50cyB3aGljaCBoYXBwZW4gInRvbyBjbG9zZSIgdG9nZXRo
ZXIuICovCiAJCWlmIChhdGlfcmVtb3RlLT5vbGRfZGF0YVswXSA9PSBkYXRhWzFdICYmCiAJCSAg
ICBhdGlfcmVtb3RlLT5vbGRfZGF0YVsxXSA9PSBkYXRhWzJdICYmCi0JCSAgICB0aW1lX2JlZm9y
ZShqaWZmaWVzLCBhdGlfcmVtb3RlLT5vbGRfamlmZmllcyArIG1zZWNzX3RvX2ppZmZpZXMocmVw
ZWF0X2ZpbHRlcikpKSB7CisJCSAgICB0aW1lX2JlZm9yZShub3csIGF0aV9yZW1vdGUtPm9sZF9q
aWZmaWVzICsgCisJCQkJICAgICBtc2Vjc190b19qaWZmaWVzKHJlcGVhdF9maWx0ZXIpKSkgewog
CQkJYXRpX3JlbW90ZS0+cmVwZWF0X2NvdW50Kys7CiAJCX0gZWxzZSB7CiAJCQlhdGlfcmVtb3Rl
LT5yZXBlYXRfY291bnQgPSAwOworCQkJYXRpX3JlbW90ZS0+Zmlyc3RfamlmZmllcyA9IG5vdzsK
IAkJfQogCiAJCWF0aV9yZW1vdGUtPm9sZF9kYXRhWzBdID0gZGF0YVsxXTsKIAkJYXRpX3JlbW90
ZS0+b2xkX2RhdGFbMV0gPSBkYXRhWzJdOwotCQlhdGlfcmVtb3RlLT5vbGRfamlmZmllcyA9IGpp
ZmZpZXM7CisJCWF0aV9yZW1vdGUtPm9sZF9qaWZmaWVzID0gbm93OwogCisJCS8qIEVuc3VyZSB3
ZSBza2lwIGF0IGxlYXN0IHRoZSA0IGZpcnN0IGR1cGxpY2F0ZSBldmVudHMgKGdlbmVyYXRlZAor
CQkgKiBieSBhIHNpbmdsZSBrZXlwcmVzcyksIGFuZCBjb250aW51ZSBza2lwcGluZyB1bnRpbCBy
ZXBlYXRfZGVsYXkKKwkJICogbXNlY3MgaGF2ZSBwYXNzZWQgCisJCSAqLwogCQlpZiAoYXRpX3Jl
bW90ZS0+cmVwZWF0X2NvdW50ID4gMCAmJgotCQkgICAgYXRpX3JlbW90ZS0+cmVwZWF0X2NvdW50
IDwgNSkKKwkJICAgIChhdGlfcmVtb3RlLT5yZXBlYXRfY291bnQgPCA1IHx8CisJCSAgICAgdGlt
ZV9iZWZvcmUobm93LCBhdGlfcmVtb3RlLT5maXJzdF9qaWZmaWVzICsgCisJCQkJICAgICAgbXNl
Y3NfdG9famlmZmllcyhyZXBlYXRfZGVsYXkpKSkpCiAJCQlyZXR1cm47CiAKIAo=
------=_Part_44576_14838512.1175721416181--
