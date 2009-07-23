Return-Path: <linux-kernel-owner+w=401wt.eu-S1753634AbZGWGu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbZGWGu0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 02:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbZGWGu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 02:50:26 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:48607 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbZGWGuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 02:50:25 -0400
MIME-Version: 1.0
In-Reply-To: <20090722232259.d0ff3495.akpm@linux-foundation.org>
References: <20090714153601.6dfe70ff@mjolnir.ossman.eu> <20090722151744.fffd7bf5.akpm@linux-foundation.org> 
	<4A67A9E8.5080002@mnementh.co.uk> <20090723055447.GA12211@console-pimps.org> 
	<20090722232259.d0ff3495.akpm@linux-foundation.org>
From: Ohad Ben-Cohen <ohad@bencohen.org>
Date: Thu, 23 Jul 2009 09:50:03 +0300
Message-ID: <bd5b16740907222350w54ca7b21w6b47ed94c1d7d16e@mail.gmail.com>
Subject: Re: New MMC maintainer needed
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matt Fleming <matt@console-pimps.org>, Ian Molton <ian@mnementh.co.uk>,
       Pierre Ossman <pierre@ossman.eu>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, nico@cam.org,
       nicolas.ferre@rfo.atmel.com, hskinnemoen@atmel.com, tony@atomide.com,
       david-b@pacbell.net, manuel.lauss@gmail.com, mirq-linux@rere.qmqm.pl,
       ppisa@pikron.com, jarkko.lavinen@nokia.com, ben@fluff.org,
       saschasommer@freenet.de, avorontsov@ru.mvista.com, oakad@yahoo.com,
       HaraldWelte@viatech.com, JosephChan@via.com.tw, adrian.hunter@nokia.com
Content-Type: multipart/mixed; boundary=001636c5b3ffe0d7e6046f59e643
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636c5b3ffe0d7e6046f59e643
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Andrew,

On Thu, Jul 23, 2009 at 9:22 AM, Andrew Morton<akpm@linux-foundation.org> wrote:
> I actually already have a little pile of MMC things queued:

Please also consider queuing up the attached patch as well.

The patch is removing the current SDIO cards 1.8V limit, which is
needed for embedded
SDIO devices like TI 127x WLAN devices (with 1.8V MMC controllers like we
have on the ZOOM2 boards for example).

Thank you,
Ohad.

--001636c5b3ffe0d7e6046f59e643
Content-Type: text/x-diff; charset=US-ASCII; 
	name="0001-sdio-do-not-ignore-MMC_VDD_165_195.patch"
Content-Disposition: attachment; 
	filename="0001-sdio-do-not-ignore-MMC_VDD_165_195.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fxh4mr990

RnJvbSBmOWJhNDViNTM3ZGQxMmZjMDk0NDNlZTI5YzQ4ODYwNjY1ZjhhYzgyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBPaGFkIEJlbi1Db2hlbiA8b2hhZEBiZW5jb2hlbi5vcmc+CkRh
dGU6IFdlZCwgMTUgSnVsIDIwMDkgMDk6MjE6NDEgKzAzMDAKU3ViamVjdDogW1BBVENIXSBzZGlv
OiBkbyBub3QgaWdub3JlIE1NQ19WRERfMTY1XzE5NQoKVGhpcyBpcyBuZWVkZWQgZm9yIDEuOFYg
ZW1iZWRkZWQgU0RJTyBkZXZpY2VzIGFuZCBzdXBwb3J0aW5nIGhvc3QgY29udHJvbGxlcnMKKGUu
Zy4gVEkgMTI3eCBhbmQgWk9PTTIgYm9hcmRzKQoKU2lnbmVkLW9mZi1ieTogT2hhZCBCZW4tQ29o
ZW4gPG9oYWRAYmVuY29oZW4ub3JnPgotLS0KIGRyaXZlcnMvbW1jL2NvcmUvc2Rpby5jIHwgICAg
NyAtLS0tLS0tCiAxIGZpbGVzIGNoYW5nZWQsIDAgaW5zZXJ0aW9ucygrKSwgNyBkZWxldGlvbnMo
LSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL21tYy9jb3JlL3NkaW8uYyBiL2RyaXZlcnMvbW1jL2Nv
cmUvc2Rpby5jCmluZGV4IGZiOTljY2YuLjZmMjIxZGMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbW1j
L2NvcmUvc2Rpby5jCisrKyBiL2RyaXZlcnMvbW1jL2NvcmUvc2Rpby5jCkBAIC0yNzUsMTMgKzI3
NSw2IEBAIGludCBtbWNfYXR0YWNoX3NkaW8oc3RydWN0IG1tY19ob3N0ICpob3N0LCB1MzIgb2Ny
KQogCQlvY3IgJj0gfjB4N0Y7CiAJfQogCi0JaWYgKG9jciAmIE1NQ19WRERfMTY1XzE5NSkgewot
CQlwcmludGsoS0VSTl9XQVJOSU5HICIlczogU0RJTyBjYXJkIGNsYWltcyB0byBzdXBwb3J0IHRo
ZSAiCi0JCSAgICAgICAiaW5jb21wbGV0ZWx5IGRlZmluZWQgJ2xvdyB2b2x0YWdlIHJhbmdlJy4g
VGhpcyAiCi0JCSAgICAgICAid2lsbCBiZSBpZ25vcmVkLlxuIiwgbW1jX2hvc3RuYW1lKGhvc3Qp
KTsKLQkJb2NyICY9IH5NTUNfVkREXzE2NV8xOTU7Ci0JfQotCiAJaG9zdC0+b2NyID0gbW1jX3Nl
bGVjdF92b2x0YWdlKGhvc3QsIG9jcik7CiAKIAkvKgotLSAKMS41LjQuMwoK
--001636c5b3ffe0d7e6046f59e643--
