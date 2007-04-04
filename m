Return-Path: <linux-kernel-owner+w=401wt.eu-S1751288AbXDDUxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751288AbXDDUxB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 16:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbXDDUxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 16:53:01 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:17114 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbXDDUw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 16:52:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=eN5oFMIgRaylQ8dLkGzMeLo4BWHBV29hos+UXc/KTSiuhJj1ZZqXqt114YKWb9edtszBCxSTD5/a3ZzZfWpY8pahYAkV/xFJZl84rrB74GFeSlAS2/N3N5uHtXcaa5NbFHyZpOFxwWvP93Rcqcpt2PQX6QXPbfka4Px9D8B0T/I=
Message-ID: <65258a580704041352q664f5da2xeaeec1a82819d9ef@mail.gmail.com>
Date: Wed, 4 Apr 2007 22:52:55 +0200
From: "Vincent Vanackere" <vincent.vanackere@gmail.com>
To: "Karl Pickett" <karl.pickett@gmail.com>
Subject: Re: [PATCH] Make ati_remote button repeat sensitivity soft-configurable
Cc: Eric.Piel@tremplin-utc.net, linux-kernel@vger.kernel.org,
       inux-input@atrey.karlin.mff.cuni.cz
In-Reply-To: <f9be06770704040821h6d96e703hf405335fa73f289b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_44240_26711677.1175719975719"
References: <f9be06770704031734k11ec894fpdf1afe385108aece@mail.gmail.com>
	 <461357D8.8060608@tremplin-utc.net>
	 <65258a580704040145m6eb7108frfa8197d3b88e207a@mail.gmail.com>
	 <f9be06770704040637k419a7fd7t2cdd52186d91ad5f@mail.gmail.com>
	 <f9be06770704040821h6d96e703hf405335fa73f289b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_44240_26711677.1175719975719
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 4/4/07, Karl Pickett <karl.pickett@gmail.com> wrote:
> Would this be more acceptable?  I haven't compiled or tested yet..but
> you can see what I'm trying to do.. make the delay time based instead
> of implementation/count based...

Well, I was going to submit a similar patch so I'd say that's the
right approach ;-)
(I just think the check on repeat_count < 5 must be kept as is
prevents the user to get the spurious events even if repeat_delay is
set too low).

I'm attaching a very small adaptation of your patch (re-added the
repeat_count check and a small comment, compile & run-time tested).
Works fine for me...

Best regards,

Vincent

------=_Part_44240_26711677.1175719975719
Content-Type: text/x-patch; name=atiremote.diff; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f0492ifc
Content-Disposition: attachment; filename="atiremote.diff"

LS0tIGRyaXZlcnMvdXNiL2lucHV0L2F0aV9yZW1vdGUuYy5vcmlnCTIwMDctMDQtMDQgMjI6MDU6
MTAuMDAwMDAwMDAwICswMjAwCisrKyBkcml2ZXJzL3VzYi9pbnB1dC9hdGlfcmVtb3RlLmMJMjAw
Ny0wNC0wNCAyMjozNTo1OS4wMDAwMDAwMDAgKzAyMDAKQEAgLTEyMCw2ICsxMjAsNyBAQAogICog
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
ZSBhY2NlbGVyYXRpb24gKi8KKyAgICAgICAgdW5zaWduZWQgbG9uZyBmaXJzdF9qaWZmaWVzOwor
CiAJdW5zaWduZWQgaW50IHJlcGVhdF9jb3VudDsKIAogCWNoYXIgbmFtZVtOQU1FX0JVRlNJWkVd
OwpAQCAtNTAxLDIxICs1MDgsMzEgQEAKIAl9CiAKIAlpZiAoYXRpX3JlbW90ZV90YmxbaW5kZXhd
LmtpbmQgPT0gS0lORF9GSUxURVJFRCkgeworCQl1bnNpZ25lZCBsb25nIG5vdyA9IGppZmZpZXM7
CisKIAkJLyogRmlsdGVyIGR1cGxpY2F0ZSBldmVudHMgd2hpY2ggaGFwcGVuICJ0b28gY2xvc2Ui
IHRvZ2V0aGVyLiAqLwogCQlpZiAoYXRpX3JlbW90ZS0+b2xkX2RhdGFbMF0gPT0gZGF0YVsxXSAm
JgogCQkgICAgYXRpX3JlbW90ZS0+b2xkX2RhdGFbMV0gPT0gZGF0YVsyXSAmJgotCQkgICAgdGlt
ZV9iZWZvcmUoamlmZmllcywgYXRpX3JlbW90ZS0+b2xkX2ppZmZpZXMgKyBtc2Vjc190b19qaWZm
aWVzKHJlcGVhdF9maWx0ZXIpKSkgeworCQkgICAgdGltZV9iZWZvcmUobm93LCBhdGlfcmVtb3Rl
LT5vbGRfamlmZmllcyArIAorCQkJCSAgICAgbXNlY3NfdG9famlmZmllcyhyZXBlYXRfZmlsdGVy
KSkpIHsKIAkJCWF0aV9yZW1vdGUtPnJlcGVhdF9jb3VudCsrOwogCQl9IGVsc2UgewogCQkJYXRp
X3JlbW90ZS0+cmVwZWF0X2NvdW50ID0gMDsKKwkJCWF0aV9yZW1vdGUtPmZpcnN0X2ppZmZpZXMg
PSBub3c7CiAJCX0KIAogCQlhdGlfcmVtb3RlLT5vbGRfZGF0YVswXSA9IGRhdGFbMV07CiAJCWF0
aV9yZW1vdGUtPm9sZF9kYXRhWzFdID0gZGF0YVsyXTsKLQkJYXRpX3JlbW90ZS0+b2xkX2ppZmZp
ZXMgPSBqaWZmaWVzOworCQlhdGlfcmVtb3RlLT5vbGRfamlmZmllcyA9IG5vdzsKIAorCQkvKiBF
bnN1cmUgd2Ugc2tpcCBhdCBsZWFzdCB0aGUgNCBmaXJzdCBkdXBsaWNhdGUgZXZlbnRzIChnZW5l
cmF0ZWQKKwkJICogYnkgYSBzaW5nbGUga2V5cHJlc3MpLCBhbmQgY29udGludWUgc2tpcHBpbmcg
dW50aWwgcmVwZWF0X2RlbGF5CisJCSAqIG1zZWNzIGhhdmUgcGFzc2VkIAorCQkgKi8KIAkJaWYg
KGF0aV9yZW1vdGUtPnJlcGVhdF9jb3VudCA+IDAgJiYKLQkJICAgIGF0aV9yZW1vdGUtPnJlcGVh
dF9jb3VudCA8IDUpCisJCSAgICAoYXRpX3JlbW90ZS0+cmVwZWF0X2NvdW50IDwgNSB8fAorCQkg
ICAgIHRpbWVfYmVmb3JlKG5vdywgYXRpX3JlbW90ZS0+Zmlyc3RfamlmZmllcyArIAorCQkJCSAg
ICAgIG1zZWNzX3RvX2ppZmZpZXMocmVwZWF0X2RlbGF5KSkpKQogCQkJcmV0dXJuOwogCiAK
------=_Part_44240_26711677.1175719975719--
