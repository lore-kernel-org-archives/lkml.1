Return-Path: <linux-kernel-owner+w=401wt.eu-S1759737AbYEGFs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759737AbYEGFs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 01:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753969AbYEGFsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 01:48:16 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:43113 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723AbYEGFsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 01:48:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=vMa360NJfXpdKFeira2q1rRMEfzHmhfnDysI97X5GSQYsxdgK+TWkdDZ/duFAZ/UXTWhrW6ZY4x6sv1Lt+Y3oovKrMzrJh95vqmUfgZrXejYAwzpbGC9mFIK0YjERnkvt1mkMdD0vzJgDuk1AvaBetL0cPtoNGEliZfL3Jwlzro=
Message-ID: <aa79d98a0805062248o3f8bc639n91f6ea89df2f6cd7@mail.gmail.com>
Date: Wed, 7 May 2008 09:48:13 +0400
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Steve French" <smfrench@gmail.com>
Subject: Re: [patch 2/2] cifs - cifs_find_tcp_session cleanup
Cc: "Steve French" <sfrench@samba.org>, linux-kernel@vger.kernel.org
In-Reply-To: <524f69650805061507h5dab8731odeadb7602e0f38e4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_6124_30335702.1210139294025"
References: <20080501154830.235254575@gmail.com>
	 <4819e79f.0c07560a.5b13.ffff8e6c@mx.google.com>
	 <524f69650805061507h5dab8731odeadb7602e0f38e4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_6124_30335702.1210139294025
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, May 7, 2008 at 2:07 AM, Steve French <smfrench@gmail.com> wrote:
> This looks like it would fail in the ipv6 case - because
>  target_ip_addr (the ipv4 address) would be null and it would exit
>  before checking.
>

Steve, could you check an updated version, please

------=_Part_6124_30335702.1210139294025
Content-Type: application/octet-stream;
 name=cifs-cifs_find_tcp_session-fix-cleanup-v2.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ffxhol470
Content-Disposition: attachment;
 filename=cifs-cifs_find_tcp_session-fix-cleanup-v2.patch

LS0tCkZyb206IEN5cmlsbCBHb3JjdW5vdiA8Z29yY3Vub3ZAZ21haWwuY29tPgpTdWJqZWN0OiBb
UEFUQ0hdIGNpZnMgLSBjaWZzX2ZpbmRfdGNwX3Nlc3Npb24gZml4L2NsZWFudXAgdjIKClRoaXMg
cGF0Y2ggY2xlYW5zIHVwIGNpZnNfZmluZF90Y3Bfc2Vzc2lvbiBzbyBpdCBiZWNvbWUKbGVzcyBp
bmRlbnRlZC4gQWxzbyB0aGUgZXJyb3Igb2Ygc2tpcHBpbmcgSVB2NiBtYXRjaGVkCmFkZHJlc3Nl
cyBmaXhlZC4KClNpZ25lZC1vZmYtYnk6IEN5cmlsbCBHb3JjdW5vdiA8Z29yY3Vub3ZAZ21haWwu
Y29tPgotLS0KCi0tLSBhL2ZzL2NpZnMvY29ubmVjdC5jCVN1biBNYXkgMDQgMDA6NTE6MTAgMjAw
OAorKysgYS9mcy9jaWZzL2Nvbm5lY3QuYwlXZWQgTWF5IDA3IDA4OjQ5OjEyIDIwMDgKQEAgLTEz
MTgsNDIgKzEzMTgsNDMgQEAgY2lmc19wYXJzZV9tb3VudF9vcHRpb25zKGNoYXIgKm9wdGlvbnMs
IAogCiBzdGF0aWMgc3RydWN0IGNpZnNTZXNJbmZvICoKIGNpZnNfZmluZF90Y3Bfc2Vzc2lvbihz
dHJ1Y3QgaW5fYWRkciAqdGFyZ2V0X2lwX2FkZHIsCi0JCXN0cnVjdCBpbjZfYWRkciAqdGFyZ2V0
X2lwNl9hZGRyLAotCQkgY2hhciAqdXNlck5hbWUsIHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKipw
c3J2VGNwKQorCQkgICAgICBzdHJ1Y3QgaW42X2FkZHIgKnRhcmdldF9pcDZfYWRkciwKKwkJICAg
ICAgY2hhciAqdXNlck5hbWUsIHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKipwc3J2VGNwKQogewog
CXN0cnVjdCBsaXN0X2hlYWQgKnRtcDsKIAlzdHJ1Y3QgY2lmc1Nlc0luZm8gKnNlczsKKwogCSpw
c3J2VGNwID0gTlVMTDsKLQlyZWFkX2xvY2soJkdsb2JhbFNNQlNlc2xvY2spOwogCisJcmVhZF9s
b2NrKCZHbG9iYWxTTUJTZXNsb2NrKTsKIAlsaXN0X2Zvcl9lYWNoKHRtcCwgJkdsb2JhbFNNQlNl
c3Npb25MaXN0KSB7CiAJCXNlcyA9IGxpc3RfZW50cnkodG1wLCBzdHJ1Y3QgY2lmc1Nlc0luZm8s
IGNpZnNTZXNzaW9uTGlzdCk7Ci0JCWlmIChzZXMtPnNlcnZlcikgewotCQkJaWYgKCh0YXJnZXRf
aXBfYWRkciAmJgotCQkJCShzZXMtPnNlcnZlci0+YWRkci5zb2NrQWRkci5zaW5fYWRkci5zX2Fk
ZHIKLQkJCQkgID09IHRhcmdldF9pcF9hZGRyLT5zX2FkZHIpKSB8fCAodGFyZ2V0X2lwNl9hZGRy
Ci0JCQkJJiYgbWVtY21wKCZzZXMtPnNlcnZlci0+YWRkci5zb2NrQWRkcjYuc2luNl9hZGRyLAot
CQkJCQl0YXJnZXRfaXA2X2FkZHIsIHNpemVvZigqdGFyZ2V0X2lwNl9hZGRyKSkpKSB7Ci0JCQkJ
LyogQkIgbG9jayBzZXJ2ZXIgYW5kIHRjcCBzZXNzaW9uIGFuZCBpbmNyZW1lbnQKLQkJCQkgICAg
ICB1c2UgY291bnQgaGVyZT8/ICovCi0KLQkJCQkvKiBmb3VuZCBhIG1hdGNoIG9uIHRoZSBUQ1Ag
c2Vzc2lvbiAqLwotCQkJCSpwc3J2VGNwID0gc2VzLT5zZXJ2ZXI7Ci0KLQkJCQkvKiBCQiBjaGVj
ayBpZiByZWNvbm5lY3Rpb24gbmVlZGVkICovCi0JCQkJaWYgKHN0cm5jbXAKLQkJCQkgICAgKHNl
cy0+dXNlck5hbWUsIHVzZXJOYW1lLAotCQkJCSAgICAgTUFYX1VTRVJOQU1FX1NJWkUpID09IDAp
ewotCQkJCQlyZWFkX3VubG9jaygmR2xvYmFsU01CU2VzbG9jayk7Ci0JCQkJCS8qIEZvdW5kIGV4
YWN0IG1hdGNoIG9uIGJvdGggVENQIGFuZAotCQkJCQkgICBTTUIgc2Vzc2lvbnMgKi8KLQkJCQkJ
cmV0dXJuIHNlczsKLQkJCQl9Ci0JCQl9CisJCWlmICghc2VzLT5zZXJ2ZXIpCisJCQljb250aW51
ZTsKKworCQlpZiAodGFyZ2V0X2lwX2FkZHIgJiYKKwkJICAgIHNlcy0+c2VydmVyLT5hZGRyLnNv
Y2tBZGRyLnNpbl9hZGRyLnNfYWRkciAhPSB0YXJnZXRfaXBfYWRkci0+c19hZGRyKQorCQkJCWNv
bnRpbnVlOworCQllbHNlIGlmICh0YXJnZXRfaXA2X2FkZHIgJiYKKwkJCSBtZW1jbXAoJnNlcy0+
c2VydmVyLT5hZGRyLnNvY2tBZGRyNi5zaW42X2FkZHIsCisJCQkJdGFyZ2V0X2lwNl9hZGRyLCBz
aXplb2YoKnRhcmdldF9pcDZfYWRkcikpKQorCQkJCWNvbnRpbnVlOworCQkvKiBCQiBsb2NrIHNl
cnZlciBhbmQgdGNwIHNlc3Npb24gYW5kIGluY3JlbWVudCB1c2UgY291bnQgaGVyZT8/ICovCisK
KwkJLyogZm91bmQgYSBtYXRjaCBvbiB0aGUgVENQIHNlc3Npb24gKi8KKwkJKnBzcnZUY3AgPSBz
ZXMtPnNlcnZlcjsKKworCQkvKiBCQiBjaGVjayBpZiByZWNvbm5lY3Rpb24gbmVlZGVkICovCisJ
CWlmIChzdHJuY21wKHNlcy0+dXNlck5hbWUsIHVzZXJOYW1lLCBNQVhfVVNFUk5BTUVfU0laRSkg
PT0gMCkgeworCQkJcmVhZF91bmxvY2soJkdsb2JhbFNNQlNlc2xvY2spOworCQkJLyogRm91bmQg
ZXhhY3QgbWF0Y2ggb24gYm90aCBUQ1AgYW5kCisJCQkgICBTTUIgc2Vzc2lvbnMgKi8KKwkJCXJl
dHVybiBzZXM7CiAJCX0KIAkJLyogZWxzZSB0Y3AgYW5kIHNtYiBzZXNzaW9ucyBuZWVkIHJlY29u
bmVjdGlvbiAqLwogCX0KIAlyZWFkX3VubG9jaygmR2xvYmFsU01CU2VzbG9jayk7CisKIAlyZXR1
cm4gTlVMTDsKIH0KIAo=
------=_Part_6124_30335702.1210139294025--
