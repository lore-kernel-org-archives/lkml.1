Return-Path: <linux-kernel-owner+w=401wt.eu-S1756777AbZKJPsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbZKJPsM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 10:48:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756757AbZKJPsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 10:48:07 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:48885 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346AbZKJPsG (ORCPT
	<rfc822;groupwise-GHaskins@novell.com;0:0>);
	Tue, 10 Nov 2009 10:48:06 -0500
Message-ID: <4AF98B25.3010007@novell.com>
Date: Tue, 10 Nov 2009 10:47:49 -0500
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: alacrityvm-devel@lists.sourceforge.net, herbert.xu@redhat.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH] net: add dataref destructor to sk_buff
References: <20091002141407.30224.54207.stgit@dev.haskins.net> <20091110115335.GC6989@redhat.com> <4AF919020200005A000586A9@sinclair.provo.novell.com> <20091110131722.GA19645@redhat.com> <4AF9747E.8020408@novell.com> <20091110144543.GC19645@redhat.com>
In-Reply-To: <20091110144543.GC19645@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig346508D6DE70921A654D530F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig346508D6DE70921A654D530F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Tue, Nov 10, 2009 at 09:11:10AM -0500, Gregory Haskins wrote:
>>> You are comparing with skb destructors, not skb data destructors :) s=
kb
>>> data destructor is Rusty's patch which he wanted to use for vringfd. =
 I
>>> mean e.g. this:
>>> http://lists.openwall.net/netdev/2008/04/18/7
>> Ah, I wasn't aware.  I believe Anthony Ligouri had pointed me at this
>> same patch earlier this year.  However, more recently when I saw
>> skb->destructor() in mainline (seemingly from Rusty), I thought it had=

>> been accepted and didn't investigate further.
>=20
> skb->destructor seems to be there as far back as 2.2.0
> http://lxr.linux.no/#linux-old+v2.2.0/include/linux/skbuff.h
>=20

Right, I meant recent activity around it for fixing it up related to
leaks, etc.


--------------enig346508D6DE70921A654D530F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkr5iyUACgkQP5K2CMvXmqGHpgCffgjCZLw2XjuAKhYzmDQFD7JR
t0UAn1amKCMsLJ8AdJHEMVMahwKLcGCl
=0IiT
-----END PGP SIGNATURE-----

--------------enig346508D6DE70921A654D530F--
