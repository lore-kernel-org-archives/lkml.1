Return-Path: <linux-kernel-owner+w=401wt.eu-S932199AbZHKXtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199AbZHKXtq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 19:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754892AbZHKXtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 19:49:45 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:43220 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803AbZHKXto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 19:49:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=UbNCDOqYLsemTlGkbfpYX0jRp0hLdVvUdYpQeGN6HvICGDnmGF35eo/wl6POHhND6n
         vRd487lwF9uLGrHYrQQzZKzRO99QGgSB37sqFhs49OhsXDCjLd8Nk0GtmtpUNhtPuX+r
         w++L/590VLdaGkUbqPa6un8uNJRfaiZ5h5VS8=
Message-ID: <4A820391.1090404@gmail.com>
Date: Tue, 11 Aug 2009 19:49:37 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-mm@kvack.org, akpm@linux-foundation.org, hpa@zytor.com
Subject: Re: [PATCHv2 0/2] vhost: a kernel-level virtio server
References: <20090811212743.GA26309@redhat.com>
In-Reply-To: <20090811212743.GA26309@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA223C963729B04B1689E60E6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA223C963729B04B1689E60E6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> This implements vhost: a kernel-level backend for virtio,
> The main motivation for this work is to reduce virtualization
> overhead for virtio by removing system calls on data path,
> without guest changes. For virtio-net, this removes up to
> 4 system calls per packet: vm exit for kick, reentry for kick,
> iothread wakeup for packet, interrupt injection for packet.
>=20
> Some more detailed description attached to the patch itself.
>=20
> The patches are against 2.6.31-rc4.  I'd like them to go into linux-nex=
t
> and down the road 2.6.32 if possible.  Please comment.

I will add this series to my benchmark run in the next day or so.  Any
specific instructions on how to set it up and run?

Regards,
-Greg


--------------enigA223C963729B04B1689E60E6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkqCA5EACgkQP5K2CMvXmqHIvQCfYcoxCyKZvGg3C6EAOrpAEwIH
JmkAnRmvb/eJZIoYNF9JHmDPGvTAdvT/
=dirP
-----END PGP SIGNATURE-----

--------------enigA223C963729B04B1689E60E6--
