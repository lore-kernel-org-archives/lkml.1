Return-Path: <linux-kernel-owner+w=401wt.eu-S932750AbYBBBiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750AbYBBBiz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 20:38:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764181AbYBBBek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 20:34:40 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:28811 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764232AbYBBBej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 20:34:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=Q9wKZAdvhUgE+gihMeaGHmDtYJM0b1FUsonHJpbvrERXXrUQP4hNBJ6Aif/wIO4u4SOsXN0gBIXtKbtcz9fz7qTEq2vO0hj2ujooMZumn3eaoSRkudYkZvYFB5FuiJzG0nft0PXuthoL3oisViCgae6zsJ0uaYs09wMWHuqt3cI=
Message-ID: <6101e8c40802011734q30246d66jcd08d17f9a541af3@mail.gmail.com>
Date: Sat, 2 Feb 2008 02:34:38 +0100
From: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: [2.6.22.y] {15/17} - nfs-unmount-leak.patch - series for stable kernel #2
Cc: "chrisw@sous-sol.org" <chrisw@sous-sol.org>, "Greg KH" <gregkh@suse.de>,
       "Willy Tarreau" <w@1wt.eu>, "Adrian Bunk" <bunk@kernel.org>,
       "Trond Myklebust" <Trond.Myklebust@netapp.com>,
       "Neil Brown" <neilb@suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_26281_17415319.1201916078322"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_26281_17415319.1201916078322
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

mainline: 13ef7b69b54aa8ae4ed264d0bf41339737f8543a


-- 
Thanks,
Oliver

------=_Part_26281_17415319.1201916078322
Content-Type: text/x-diff; name=nfs-unmount-leak.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: file0
Content-Disposition: attachment; filename=nfs-unmount-leak.patch

RnJvbTogVHJvbmQgTXlrbGVidXN0IDxUcm9uZC5NeWtsZWJ1c3RAbmV0YXBwLmNvbT4KRGF0ZTog
VHVlIERlYyAxMSAxMTowNToxOSAyMDA3IC0wNTAwClN1YmplY3Q6IE5GU3YyL3YzOiBGaXggYSBt
ZW1vcnkgbGVhayB3aGVuIHVzaW5nIC1vbm9sb2NrClBhdGNoLW1haW5saW5lOiAyLjYuMjQKUmVm
ZXJlbmNlczogMzM2MjUzCgogICAgCiAgICAKICAgIE5laWwgQnJvd24gc2FpZDoKICAgID4gSGkg
VHJvbmQsCiAgICA+CiAgICA+IFdlIGZvdW5kIHRoYXQgYSBtYWNoaW5lIHdoaWNoIG1hZGUgbW9k
ZXJhdGVseSBoZWF2eSB1c2Ugb2YKICAgID4gJ2F1dG9tb3VudCcgd2FzIGxlYWtpbmcgc29tZSBu
ZnMgZGF0YSBzdHJ1Y3R1cmVzIC0gcGFydGljdWxhcmx5IHRoZQogICAgPiA0SyBhbGxvY2F0ZWQg
YnkgcnBjX2FsbG9jX2lvc3RhdHMuCiAgICA+IEl0IHR1cm5zIG91dCB0aGF0IHRoaXMgb25seSBo
YXBwZW5zIHdpdGggZmlsZXN5c3RlbXMgd2l0aCAtb25vbG9jawogICAgPiBzZXQuCiAgICAKICAg
ID4gVGhlIHByb2JsZW0gaXMgdGhhdCBpZiBORlNfTU9VTlRfTk9OTE0gaXMgc2V0LCBuZnNfc3Rh
cnRfbG9ja2QgZG9lc24ndAogICAgPiBzZXQgc2VydmVyLT5kZXN0cm95LCBzbyB3aGVuIHRoZSBm
aWxlc3lzdGVtIGlzIHVubW91bnRlZCwgdGhlCiAgICA+IC0+Y2xpZW50X2FjbCBpcyBub3Qgc2h1
dGRvd24sIGFuZCBzbyBzZXZlcmFsIHJlc291cmNlcyBhcmUgc3RpbGwKICAgID4gaGVsZC4gIE11
bHRpcGxlIG1vdW50L3Vtb3VudCBjeWNsZXMgd2lsbCBzbG93bHkgZWF0IGF3YXkgbWVtb3J5CiAg
ICA+IHNldmVyYWwgcGFnZXMgYXQgYSB0aW1lLgogICAgCiAgICBTaWduZWQtb2ZmLWJ5OiBUcm9u
ZCBNeWtsZWJ1c3QgPFRyb25kLk15a2xlYnVzdEBuZXRhcHAuY29tPgoKQWNrZWQtYnk6IE5laWwg
QnJvd24gPG5laWxiQHN1c2UuZGU+ClNpZ25lZC1vZmYtYnk6IE5laWwgQnJvd24gPG5laWxiQHN1
c2UuZGU+CgotLS0KIGZzL25mcy9jbGllbnQuYyB8ICAgIDYgKysrLS0tCiAxIGZpbGUgY2hhbmdl
ZCwgMyBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQoKLS0tIGxpbnV4LTIuNi4yMi1TTDEw
M19CUkFOQ0gub3JpZy9mcy9uZnMvY2xpZW50LmMKKysrIGxpbnV4LTIuNi4yMi1TTDEwM19CUkFO
Q0gvZnMvbmZzL2NsaWVudC5jCkBAIC00MzMsOSArNDMzLDYgQEAgc3RhdGljIGludCBuZnNfY3Jl
YXRlX3JwY19jbGllbnQoc3RydWN0IAogICovCiBzdGF0aWMgdm9pZCBuZnNfZGVzdHJveV9zZXJ2
ZXIoc3RydWN0IG5mc19zZXJ2ZXIgKnNlcnZlcikKIHsKLQlpZiAoIUlTX0VSUihzZXJ2ZXItPmNs
aWVudF9hY2wpKQotCQlycGNfc2h1dGRvd25fY2xpZW50KHNlcnZlci0+Y2xpZW50X2FjbCk7Ci0K
IAlpZiAoIShzZXJ2ZXItPmZsYWdzICYgTkZTX01PVU5UX05PTkxNKSkKIAkJbG9ja2RfZG93bigp
OwkvKiByZWxlYXNlIHJwYy5sb2NrZCAqLwogfQpAQCAtNzcxLDYgKzc2OCw5IEBAIHZvaWQgbmZz
X2ZyZWVfc2VydmVyKHN0cnVjdCBuZnNfc2VydmVyICoKIAogCWlmIChzZXJ2ZXItPmRlc3Ryb3kg
IT0gTlVMTCkKIAkJc2VydmVyLT5kZXN0cm95KHNlcnZlcik7CisKKwlpZiAoIUlTX0VSUihzZXJ2
ZXItPmNsaWVudF9hY2wpKQorCQlycGNfc2h1dGRvd25fY2xpZW50KHNlcnZlci0+Y2xpZW50X2Fj
bCk7CiAJaWYgKCFJU19FUlIoc2VydmVyLT5jbGllbnQpKQogCQlycGNfc2h1dGRvd25fY2xpZW50
KHNlcnZlci0+Y2xpZW50KTsKIAo=
------=_Part_26281_17415319.1201916078322--
