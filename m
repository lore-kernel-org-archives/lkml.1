Return-Path: <linux-kernel-owner+w=401wt.eu-S1752565AbZFXBnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbZFXBnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 21:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbZFXBnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 21:43:45 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:58615 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbZFXBno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 21:43:44 -0400
Message-ID: <4A4184C3.6060503@novell.com>
Date: Tue, 23 Jun 2009 21:43:31 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       mtosatti@redhat.com, paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [PATCH] kvm: remove in_range from kvm_io_device
References: <20090623150008.GA21059@redhat.com>
In-Reply-To: <20090623150008.GA21059@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA03B4605AE98452441E3A8E6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA03B4605AE98452441E3A8E6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> Remove in_range from kvm_io_device and ask read/write callbacks, if
> supplied, to perform range checks internally. This allows aliasing
> (mostly for in-kernel virtio), as well as better error handling by
> making it possible to pass errors up to userspace. And it's enough to
> look at the diffstat to see that it's a better API anyway.
>
> While we are at it, document locking rules for kvm_io_device.
>  =20

Hi Michael,

I just tried to apply this to kvm.git/master, and it blew up really
badly.  What tree should I be using?

-Greg



--------------enigA03B4605AE98452441E3A8E6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpBhMQACgkQlOSOBdgZUxnoFwCfRpPI0T2154qXstuSDF1XtWRd
+G0AnApL7cAmbe3BXkTT39ez1mWuIg1e
=aQvv
-----END PGP SIGNATURE-----

--------------enigA03B4605AE98452441E3A8E6--
