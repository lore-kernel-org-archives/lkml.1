Return-Path: <linux-kernel-owner+w=401wt.eu-S1758002AbZFVT1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002AbZFVT1W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 15:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754294AbZFVT1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 15:27:15 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:42529 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427AbZFVT1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 15:27:14 -0400
Message-ID: <4A3FDAF1.6010700@novell.com>
Date: Mon, 22 Jun 2009 15:26:41 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Davide Libenzi <davidel@xmailserver.org>, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 3/3] eventfd: add internal reference counting to fix	notifier
 race conditions
References: <4A3D895C.7020605@novell.com> <alpine.DEB.1.10.0906210946560.18205@makko.or.mcafeemobile.com> <4A3E7E63.1070407@novell.com> <alpine.DEB.1.10.0906211613200.8816@makko.or.mcafeemobile.com> <4A3FABD9.7080108@novell.com> <alpine.DEB.1.10.0906220952090.10952@makko.or.mcafeemobile.com> <4A3FC2B1.4050107@novell.com> <alpine.DEB.1.10.0906221055480.10952@makko.or.mcafeemobile.com> <20090622184139.GG15228@redhat.com> <alpine.DEB.1.10.0906221146210.10952@makko.or.mcafeemobile.com> <20090622190537.GI15228@redhat.com>
In-Reply-To: <20090622190537.GI15228@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4FB972CC3DEBD05729B7D291"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4FB972CC3DEBD05729B7D291
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Mon, Jun 22, 2009 at 11:51:42AM -0700, Davide Libenzi wrote:
>  =20
>> A file* based kernel-to-kernel interface is rather wrong IMO.
>>    =20
>
> But eventfd_ctx should work fine.
>  =20

Yeah, and I guess we can always just say that qemu can't close the fd or
something.  Seems hacky, but it might work if Davide insists we need his
change.

-Greg


--------------enig4FB972CC3DEBD05729B7D291
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko/2vEACgkQlOSOBdgZUxnW/QCgiquVFMSHNbMvtFfEEuhD32Yu
K/QAn08XEfUG3c5JrABiKNVsPuu1yoMG
=UnRU
-----END PGP SIGNATURE-----

--------------enig4FB972CC3DEBD05729B7D291--
