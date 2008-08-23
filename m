Return-Path: <linux-kernel-owner+w=401wt.eu-S1755376AbYHWUvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbYHWUvt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 16:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752981AbYHWUvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 16:51:42 -0400
Received: from po-out-1718.google.com ([72.14.252.157]:42342 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbYHWUvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 16:51:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=VdA/NegpYVJxgm0pZv+g6RDNS2UFCTLthNJS6k0ahyqvVWqLvg+DAZ93XWqzi12W16
         O0JfvSD4yAE8oGkICCwhEkFBm6WgMTh9YFapey5tRA0IJcp/FhiTwe7Ib1ncVqARzC2f
         ymi9o+2P+KTmbW0AFrk7jzyb1fxHO9ZkDb7Sk=
Message-ID: <86802c440808231351w491dc6acjec0590eb5f8d09fb@mail.gmail.com>
Date: Sat, 23 Aug 2008 13:51:37 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "David Witbrodt" <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user with the same regression
Cc: "Rufus & Azrael" <rufus-azrael@numericable.fr>,
       "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Yinghai Lu" <yhlu.kenrel@gmail.com>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <772766.85250.qm@web82102.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_34965_13641378.1219524697599"
References: <772766.85250.qm@web82102.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_34965_13641378.1219524697599
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sat, Aug 23, 2008 at 12:47 PM, David Witbrodt <dawitbro@sbcglobal.net> wrote:
>
>
>> please check v2.
>
> Thanks Yinghai.  This still applies to a different line number in
> v2.6.27-rc4 than what the patch indicates.  I also get a warning
> about unused variable "i" (I commented it out in my previous fix,
> but not this time).
>
> At any rate, I still produces a kernel that hangs at the typical
> location.
>
David,

please check v3

deviceid should be 0x4385 instead.

YH

------=_Part_34965_13641378.1219524697599
Content-Type: text/x-patch; name=hpet_in_bar1_v3.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fk8pgu1z0
Content-Disposition: attachment; filename=hpet_in_bar1_v3.patch

W1BBVENIXSB4ODY6IHByb3RlY3QgaHBldCBpbiBCQVIgZm9yIG9uZSBBVEkgY2hpcHNldCB2MwoK
c28gYXZvaWQga2VybmVsIGRvbid0IGFsbG9jYXRlIG5yZSByZXNvdXJjZSBmb3IgaXQgYmVjYXVz
ZSBpdCBjYW4gbm90IGFsbG9jYXRlIHRoZSBvbGQKYWRkcmVzcyBmcm9tIEJJT1MuCgp0aGUgc2Ft
ZSB3YXkgbGlrZSBzb21lIElPIEFQSUMgYWRkcmVzcyBpbiBCQVIgaGFuZGxpbmcKClNpZ25lZC1v
ZmYtYnk6IFlpbmdoYWkgTHUgPHlobHUua2VybmVsQGdtYWlsLmNvbT4KCi0tLQogZHJpdmVycy9w
Y2kvcXVpcmtzLmMgfCAgIDE2ICsrKysrKysrKysrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCAxNiBp
bnNlcnRpb25zKCspCgpJbmRleDogbGludXgtMi42L2RyaXZlcnMvcGNpL3F1aXJrcy5jCj09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2RyaXZlcnMvcGNpL3F1aXJrcy5jCisrKyBsaW51eC0y
LjYvZHJpdmVycy9wY2kvcXVpcmtzLmMKQEAgLTE5MTgsNiArMTkxOCwyMiBAQCBERUNMQVJFX1BD
SV9GSVhVUF9IRUFERVIoUENJX1ZFTkRPUl9JRF9CCiAJCQkgUENJX0RFVklDRV9JRF9OWDJfNTcw
OVMsCiAJCQkgcXVpcmtfYnJjbV81NzB4X2xpbWl0X3ZwZCk7CiAKK3N0YXRpYyB2b2lkIF9faW5p
dCBxdWlya19ocGV0X2luX2JhcihzdHJ1Y3QgcGNpX2RldiAqcGRldikKK3sKKwlpbnQgaTsKKwl1
NjQgYmFzZSwgc2l6ZTsKKworCS8qIHRoZSBCQVIxIGlzIHRoZSBsb2NhdGlvbiBvZiB0aGUgSFBF
VC4uLndlIG11c3QKKwkgKiBub3QgdG91Y2ggdGhpcywgc28gZm9yY2libHkgaW5zZXJ0IGl0IGlu
dG8gdGhlIHJlc291cmNlIHRyZWUgKi8KKwliYXNlID0gcGNpX3Jlc291cmNlX3N0YXJ0KHBkZXYs
IDEpOworCXNpemUgPSBwY2lfcmVzb3VyY2VfbGVuKHBkZXYsIDEpOworCWlmIChiYXNlICYmIHNp
emUpIHsKKwkJaW5zZXJ0X3Jlc291cmNlKCZpb21lbV9yZXNvdXJjZSwgJnBkZXYtPnJlc291cmNl
WzFdKTsKKwkJZGV2X2luZm8oJnBkZXYtPmRldiwgIkhQRVQgYXQgJTA4bGx4LSUwOGxseFxuIiwg
YmFzZSwgYmFzZSArIHNpemUgLSAxKTsKKwl9Cit9CitERUNMQVJFX1BDSV9GSVhVUF9IRUFERVIo
UENJX1ZFTkRPUl9JRF9BVEksIDB4NDM4NSwgcXVpcmtfaHBldF9pbl9iYXIpOworCiAjaWZkZWYg
Q09ORklHX1BDSV9NU0kKIC8qIFNvbWUgY2hpcHNldHMgZG8gbm90IHN1cHBvcnQgTVNJLiBXZSBj
YW5ub3QgZWFzaWx5IHJlbHkgb24gc2V0dGluZwogICogUENJX0JVU19GTEFHU19OT19NU0kgaW4g
aXRzIGJ1cyBmbGFncyBiZWNhdXNlIHRoZXJlIGFyZSBhY3R1YWxseQo=
------=_Part_34965_13641378.1219524697599--
