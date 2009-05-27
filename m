Return-Path: <linux-kernel-owner+w=401wt.eu-S1764514AbZE0PHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764514AbZE0PHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 11:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759652AbZE0PHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 11:07:40 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:46780 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758727AbZE0PHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 11:07:39 -0400
Message-ID: <4A1D5702.5020102@novell.com>
Date: Wed, 27 May 2009 11:06:42 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: avi@redhat.com
CC: mst@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       davidel@xmailserver.org, mtosatti@redhat.com
Subject: Re: [PATCH 0/2] kvm: validate irqfd type
References: <4A1D48FA.9080403@novell.com> <20090527143251.14024.89090.stgit@dev.haskins.net>
In-Reply-To: <20090527143251.14024.89090.stgit@dev.haskins.net>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD80969D33F2EAB2463168700"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD80969D33F2EAB2463168700
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Gregory Haskins wrote:
> Michael Tsirkin pointed out an issue in kvm.git w.r.t. malicious usersp=
ace
> configuring irqfd objects:
>
> http://lkml.org/lkml/2009/5/27/341
>
> This series applies to kvm.git/master:1a6a35a1 to attempt to close the
> vulnerability.
>  =20

Avi,

FYI: This is also available as a git-pull:

git pull
git://git.kernel.org/pub/scm/linux/kernel/git/ghaskins/linux-2.6-hacks.gi=
t
for-avi

> ---
>
> Gregory Haskins (2):
>       kvm: validate irqfd type
>       eventfd: export eventfd interfaces for module use
>
>
>  fs/eventfd.c       |    3 +++
>  virt/kvm/eventfd.c |    3 ++-
>  2 files changed, 5 insertions(+), 1 deletions(-)
>
>  =20



--------------enigD80969D33F2EAB2463168700
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkodVwYACgkQlOSOBdgZUxlucgCZAZfQTFF8grJgRJtbCtPO+tkl
4FcAn3uFlv8HUw3Wb22M48+5EzoDLhVO
=BuR9
-----END PGP SIGNATURE-----

--------------enigD80969D33F2EAB2463168700--
