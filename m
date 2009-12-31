Return-Path: <linux-kernel-owner+w=401wt.eu-S1752533AbZLaOc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533AbZLaOc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 09:32:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbZLaOcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 09:32:25 -0500
Received: from exprod6og112.obsmtp.com ([64.18.1.29]:56348 "HELO
	exprod6og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752392AbZLaOcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 09:32:25 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01CA8A26.10EA3996"
Subject: RE: [PATCH] amso1100/c2_provider.c: use %pM to shown MAC address
Date: Thu, 31 Dec 2009 09:32:21 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200F6BA@mi8nycmail19.Mi8.com>
In-Reply-To: <20091230.215926.226788191.davem@davemloft.net>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] amso1100/c2_provider.c: use %pM to shown MAC address
Thread-Index: AcqJ3mgaZ52ovXURS/aSdgcoZm2+wgARSfQg
References: <BD79186B4FD85F4B8E60E381CAEE19090200F533@mi8nycmail19.Mi8.com> <20091230.215926.226788191.davem@davemloft.net>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "David Miller" <davem@davemloft.net>
Cc: <linux-kernel@vger.kernel.org>, <tom@opengridcomputing.com>,
       "H Hartley Sweeten" <hartleys@visionengravers.com>
X-OriginalArrivalTime: 31 Dec 2009 14:32:23.0392 (UTC) FILETIME=[111C0600:01CA8A26]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01CA8A26.10EA3996
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wednesday, December 30, 2009 10:59 PM, David Miller wrote:
> From: "H Hartley Sweeten" <hartleys@visionengravers.com>
> Date: Tue, 29 Dec 2009 11:22:42 -0500
>
>> Use the %pM kernel extension to display the MAC address.
>>=20
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>
> Hartley, I was going to mention this for your previous
> series, and now that you've sent another huge set of
> patches I must make a note of this.
>
> Every single one of your patches applies with one-line of
> patch 'fuzz', like this:
>
> davem@sunset:~/src/GIT/linux-2.6$ patch -p1 <diff
> patching file drivers/infiniband/hw/amso1100/c2_provider.c
> Hunk #1 succeeded at 760 with fuzz 1.
>
> And GIT rejects such patches entirely:
>
> davem@sunset:~/src/GIT/linux-2.6$ git apply --check =
--whitespace=3Derror-all diff
> error: patch failed: drivers/infiniband/hw/amso1100/c2_provider.c:760
> error: drivers/infiniband/hw/amso1100/c2_provider.c: patch does not =
apply
>
> So I had to add all of your patches to my tree by hand, one by one,
> yesterday.
>
> I refuse to do this for so many more patches.  Could you generate
> patches that apply accurately?

Hi David,

Sorry for the problem with the patches.  I really don't understand why =
they are
producing a 'fuzz' issue.  I'm still a bit new with git, maybe you can =
provide
me a bit of insight?

To create all of the patches I did the following:

1) 'git pull' of Linus' tree to make sure I had the most recent source.
2) opened the file I want to patch, i.e .../c2_provider.c
3) made the edit and saved the file
4) 'git diff > ~/patches/c2_provider_MAC.patch'
5) restored the original file
6) verified the patch applies
bigguiness@etch ~/src/git/linux-2.6 $ patch -p1 < =
~/patches/c2_provider_MAC.patch=20
patching file drivers/infiniband/hw/amso1100/c2_provider.c

I have never tried the 'git apply ...' before so I just did with this =
patch:

bigguiness@etch ~/src/git/linux-2.6 $ git apply --check =
--whitespace=3Derror-all /mnt/hgfs/share/c2_provider_MAC.patch
bigguiness@etch ~/src/git/linux-2.6 $=20

I assume no messages means that the patch applies ok?

I have attached the original patch that I sent in the email.  Could you
please see if you still have problems with it?  If you don't it might be
something in my email configuration.

Thanks and sorry for the troubles,
Hartley

------_=_NextPart_001_01CA8A26.10EA3996
Content-Type: application/octet-stream;
	name="c2_provider_MAC.patch"
Content-Transfer-Encoding: base64
Content-Description: c2_provider_MAC.patch
Content-Disposition: attachment;
	filename="c2_provider_MAC.patch"

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW5maW5pYmFuZC9ody9hbXNvMTEwMC9jMl9wcm92aWRlci5j
IGIvZHJpdmVycy9pbmZpbmliYW5kL2h3L2Ftc28xMTAwL2MyX3Byb3ZpZGVyLmMKaW5kZXggYWQ3
MjNiZC4uNzEyMzE0YSAxMDA2NDQKLS0tIGEvZHJpdmVycy9pbmZpbmliYW5kL2h3L2Ftc28xMTAw
L2MyX3Byb3ZpZGVyLmMKKysrIGIvZHJpdmVycy9pbmZpbmliYW5kL2h3L2Ftc28xMTAwL2MyX3By
b3ZpZGVyLmMKQEAgLTc2MCwxMCArNzYwLDcgQEAgc3RhdGljIHN0cnVjdCBuZXRfZGV2aWNlICpj
Ml9wc2V1ZG9fbmV0ZGV2X2luaXQoc3RydWN0IGMyX2RldiAqYzJkZXYpCiAJbWVtY3B5X2Zyb21p
byhuZXRkZXYtPmRldl9hZGRyLCBjMmRldi0+a3ZhICsgQzJfUkVHU19SRE1BX0VOQUREUiwgNik7
CiAKIAkvKiBQcmludCBvdXQgdGhlIE1BQyBhZGRyZXNzICovCi0JcHJfZGVidWcoIiVzOiBNQUMg
JTAyWDolMDJYOiUwMlg6JTAyWDolMDJYOiUwMlhcbiIsCi0JCW5ldGRldi0+bmFtZSwKLQkJbmV0
ZGV2LT5kZXZfYWRkclswXSwgbmV0ZGV2LT5kZXZfYWRkclsxXSwgbmV0ZGV2LT5kZXZfYWRkclsy
XSwKLQkJbmV0ZGV2LT5kZXZfYWRkclszXSwgbmV0ZGV2LT5kZXZfYWRkcls0XSwgbmV0ZGV2LT5k
ZXZfYWRkcls1XSk7CisJcHJfZGVidWcoIiVzOiBNQUMgJXBNXG4iLCBuZXRkZXYtPm5hbWUsIG5l
dGRldi0+ZGV2X2FkZHIpOwogCiAjaWYgMAogCS8qIERpc2FibGUgbmV0d29yayBwYWNrZXRzICov
Cg==

------_=_NextPart_001_01CA8A26.10EA3996--
