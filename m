Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189AbYIBEhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbYIBEhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 00:37:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750982AbYIBEgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 00:36:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:38213 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867AbYIBEgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 00:36:53 -0400
Message-ID: <48BCC28E.5030009@kernel.org>
Date: Tue, 02 Sep 2008 06:35:26 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, lists@ku-gbr.de,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: SATA Cold Boot problems on >2.6.25 with NV
References: <fa.CVrJhjm3R8sjl5Z+EEIzYm7QtW0@ifi.uio.no> <48B80B40.5060002@shaw.ca> <48B80D33.5050806@gmail.com> <20080829212146.GA4321@anita> <48B90F7F.8040308@kernel.org> <20080830205143.GA9726@anita> <48BBCF98.4070003@kernel.org> <20080901174657.GA2114@anita>
In-Reply-To: <20080901174657.GA2114@anita>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------050905010105010201080406"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 02 Sep 2008 04:36:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050905010105010201080406
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

(cc'ing linux-ide)

Konstantin Kletschke wrote:
> Am 2008-09-01 13:18 +0200 schrieb Tejun Heo:
> 
>>> Hmn, to take my pants down entirely: What is this "EH"?
>> libata EH == libatata exception handling.
> 
> Seems this stuff is kinda new since 2.6.25?

I think it's more circa 2.6.22 but in my memory terms, which sucks,
that's a lifetime before so I don't really remember.  :-)

>> Can you please apply the attached patch and post the resulting dmesg?
> 
> Of course. Patch applied, here is dmesg output, looks interesting now -
> but anything works fine so far.

Hmm... someone is scheduling EH incessantly without any error or action
set.  Can you please try the attached patch?

-- 
tejun

--------------050905010105010201080406
Content-Type: text/plain;
 name="debug"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="debug"

LS0tCiBkcml2ZXJzL2F0YS9saWJhdGEtZWguYyB8ICAgMTIgKysrKysrKysrKy0tCiAxIGZp
bGUgY2hhbmdlZCwgMTAgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCkluZGV4OiB0
cmVlMC9kcml2ZXJzL2F0YS9saWJhdGEtZWguYwo9PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSB0cmVlMC5v
cmlnL2RyaXZlcnMvYXRhL2xpYmF0YS1laC5jCisrKyB0cmVlMC9kcml2ZXJzL2F0YS9saWJh
dGEtZWguYwpAQCAtNjcxLDYgKzY3MSw5IEBAIHN0YXRpYyB2b2lkIGF0YV9laF9zZXRfcGVu
ZGluZyhzdHJ1Y3QgYXQKIAogCWFwLT5wZmxhZ3MgfD0gQVRBX1BGTEFHX0VIX1BFTkRJTkc7
CiAKKwlhdGFfcG9ydF9wcmludGsoYXAsIEtFUk5fSU5GTywgIlhYWCBFSF9TRVRfUEVORElO
R1xuIik7CisJZHVtcF9zdGFjaygpOworCiAJaWYgKCFmYXN0ZHJhaW4pCiAJCXJldHVybjsK
IApAQCAtMTA3Nyw2ICsxMDgwLDExIEBAIHZvaWQgYXRhX2VoX2Fib3V0X3RvX2RvKHN0cnVj
dCBhdGFfbGluawogCXN0cnVjdCBhdGFfZWhfY29udGV4dCAqZWhjID0gJmxpbmstPmVoX2Nv
bnRleHQ7CiAJdW5zaWduZWQgbG9uZyBmbGFnczsKIAorCWlmIChsaW5rKQorCQlhdGFfbGlu
a19wcmludGsobGluaywgS0VSTl9JTkZPLCAiWFhYIGFib3V0X3RvX2RvICV4XG4iLCBhY3Rp
b24pOworCWVsc2UgaWYgKGRldikKKwkJYXRhX2Rldl9wcmludGsoZGV2LCBLRVJOX0lORk8s
ICJYWFggYWJvdXRfdG9fZG8gJXhcbiIsIGFjdGlvbik7CisKIAlzcGluX2xvY2tfaXJxc2F2
ZShhcC0+bG9jaywgZmxhZ3MpOwogCiAJYXRhX2VoX2NsZWFyX2FjdGlvbihsaW5rLCBkZXYs
IGVoaSwgYWN0aW9uKTsKQEAgLTE4OTAsOCArMTg5OCw4IEBAIHN0YXRpYyB2b2lkIGF0YV9l
aF9saW5rX3JlcG9ydChzdHJ1Y3QgYXQKIAkJbnJfZmFpbGVkKys7CiAJfQogCi0JaWYgKCFu
cl9mYWlsZWQgJiYgIWVoYy0+aS5lcnJfbWFzaykKLQkJcmV0dXJuOworCS8vaWYgKCFucl9m
YWlsZWQgJiYgIWVoYy0+aS5lcnJfbWFzaykKKwkvLwlyZXR1cm47CiAKIAlmcm96ZW4gPSAi
IjsKIAlpZiAoYXAtPnBmbGFncyAmIEFUQV9QRkxBR19GUk9aRU4pCg==
--------------050905010105010201080406--
