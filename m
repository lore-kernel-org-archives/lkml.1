Return-Path: <linux-kernel-owner+w=401wt.eu-S1756298AbYIALUD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298AbYIALUD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 07:20:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbYIALTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 07:19:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:58734 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbYIALTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 07:19:53 -0400
Message-ID: <48BBCF98.4070003@kernel.org>
Date: Mon, 01 Sep 2008 13:18:48 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: SATA Cold Boot problems on >2.6.25 with NV
References: <fa.CVrJhjm3R8sjl5Z+EEIzYm7QtW0@ifi.uio.no> <48B80B40.5060002@shaw.ca> <48B80D33.5050806@gmail.com> <20080829212146.GA4321@anita> <48B90F7F.8040308@kernel.org> <20080830205143.GA9726@anita>
In-Reply-To: <20080830205143.GA9726@anita>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------040007080304060402050603"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 01 Sep 2008 11:19:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040007080304060402050603
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Konstantin Kletschke wrote:
>> when ATAPI CHECK SENSE handling somehow failed to tell EH that it was an
>> exception not worth whining about.  Maybe EH action mask is not being
>> cleared properly?
> 
> Hmn, to take my pants down entirely: What is this "EH"?

libata EH == libatata exception handling.

> And how does the change of the .reset function affect this? May be, I
> will take a look onto this.

Your controller is raising exception continuously for some reason.
Have no idea yet.

Can you please apply the attached patch and post the resulting dmesg?

-- 
tejun

--------------040007080304060402050603
Content-Type: text/plain;
 name="debug"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="debug"

LS0tCiBkcml2ZXJzL2F0YS9saWJhdGEtZWguYyB8ICAgIDQgKystLQogMSBmaWxlIGNoYW5n
ZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCkluZGV4OiB0cmVlMC9kcml2
ZXJzL2F0YS9saWJhdGEtZWguYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSB0cmVlMC5vcmlnL2RyaXZl
cnMvYXRhL2xpYmF0YS1laC5jCisrKyB0cmVlMC9kcml2ZXJzL2F0YS9saWJhdGEtZWguYwpA
QCAtMTg5MCw4ICsxODkwLDggQEAgc3RhdGljIHZvaWQgYXRhX2VoX2xpbmtfcmVwb3J0KHN0
cnVjdCBhdAogCQlucl9mYWlsZWQrKzsKIAl9CiAKLQlpZiAoIW5yX2ZhaWxlZCAmJiAhZWhj
LT5pLmVycl9tYXNrKQotCQlyZXR1cm47CisJLy9pZiAoIW5yX2ZhaWxlZCAmJiAhZWhjLT5p
LmVycl9tYXNrKQorCS8vCXJldHVybjsKIAogCWZyb3plbiA9ICIiOwogCWlmIChhcC0+cGZs
YWdzICYgQVRBX1BGTEFHX0ZST1pFTikK
--------------040007080304060402050603--
