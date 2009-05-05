Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbZEEOVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbZEEOVj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 10:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752912AbZEEOV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 10:21:28 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:46535 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbZEEOV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 10:21:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=USQDmpqlbaJ9xb+VXurafK1JC4+bSxfNE8YX0hT4OT+uix4jiy22DyXy5wHDz9iXGD
         wokQ8/ray43xoypbdQeg1NKlxNGhzPkHeT1l73csXtNstBWBST9wuKpXnpqWGC5J2J3V
         0Xud/xS/hoSVO9LwG+bHc4TIQ1r16P3AxyEds=
Message-ID: <4A004B62.1080801@gmail.com>
Date: Tue, 05 May 2009 10:21:22 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com>
In-Reply-To: <4A0049CD.3080003@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8C30C3C40E64130130BA0FA7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8C30C3C40E64130130BA0FA7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Gregory Haskins wrote:
> So rather than allocate a top-level vector, I will add "KVM_HC_DYNAMIC"=

> to kvm_para.h, and I will change the interface to follow suit (somethin=
g
> like s/hypercall/dynhc).  Sound good?
>  =20

A small ramification of this change will be that I will need to do
something like add a feature-bit to cpuid for detecting if HC_DYNAMIC is
supported on the backend or not.  The current v1 design doesn't suffer
from this requirement because the presence of the dynamic vector itself
is enough to know its supported.  I like Avi's proposal enough to say
that its worth this minor inconvenience, but FYI I will have to
additionally submit a userspace patch for v2 if we go this route.

-Greg




--------------enig8C30C3C40E64130130BA0FA7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoAS2IACgkQP5K2CMvXmqFuogCfY13vIZBbCww35+GreZzhbGQh
El0AnAp4yKPhudwhw1ZOVaJZcErO+5ta
=Tm9w
-----END PGP SIGNATURE-----

--------------enig8C30C3C40E64130130BA0FA7--
