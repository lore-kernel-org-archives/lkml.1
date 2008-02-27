Return-Path: <linux-kernel-owner+w=401wt.eu-S1755206AbYB0Qhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbYB0Qhj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 11:37:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754189AbYB0Qh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 11:37:26 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:51777 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753444AbYB0QhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 11:37:25 -0500
X-Sasl-enc: 9b/nBwu7/2mzdEhX2W4EdjEs0IwxJKMSI+7PjSRLkm/m 1204130244
Message-ID: <47C591B4.7090302@imap.cc>
Date: Wed, 27 Feb 2008 17:37:08 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.12) Gecko/20080201 SeaMonkey/1.1.8 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Patrick McHardy <kaber@trash.net>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: nf_conntrack fix smp_processor_id() in preemptible code (was: 2.6.25-rc2-mm1
 - several bugs and a crash)
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <47BC982C.7050402@imap.cc> <47BD6072.4000407@trash.net>
In-Reply-To: <47BD6072.4000407@trash.net>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig54E544DF1BAECDDE8F3BACEA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig54E544DF1BAECDDE8F3BACEA
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 21.02.2008 12:28 schrieb Patrick McHardy:
>>
>> Feb 20 17:22:40 xenon kernel: [   48.180297] BUG: using smp_processor_=
id() in preemptible [00000000] code: ntpdate/3562
>> Feb 20 17:22:40 xenon kernel: [   48.180297] caller is __nf_conntrack_=
find+0x9b/0xeb [nf_conntrack]
>> Feb 20 17:22:40 xenon kernel: [   48.180297] Pid: 3562, comm: ntpdate =
Not tainted 2.6.25-rc2-mm1-testing #1
>> Feb 20 17:22:40 xenon kernel: [   48.180297]  [<c02015b9>] debug_smp_p=
rocessor_id+0x99/0xb0
>=20
> Could you test whether this patch fixes the netfilter
> warnings please?

Bad news: With 2.6.25-rc3, that bug has made it into mainline.
Good news: Your patch fixes it there, too.

So I suggest you forward it there as soon as possible.

Thanks,
Tilman

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig54E544DF1BAECDDE8F3BACEA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHxZG+MdB4Whm86/kRAmQ4AJ0SkuP5Rt7VuMAca3i4GB8FXIfqDgCbBwEV
Vj880Vu32Sg9FSKCWzNQvkM=
=XFi+
-----END PGP SIGNATURE-----

--------------enig54E544DF1BAECDDE8F3BACEA--
