Return-Path: <linux-kernel-owner+w=401wt.eu-S1758920AbZHRNTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920AbZHRNTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 09:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758879AbZHRNTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 09:19:39 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:57309 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758865AbZHRNTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 09:19:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=uUC5IUYjWGMtm9m4m7yvcdl7HHKEpmNiW3gbfpeDPi3A6nnXZNwiQA+Hz81xn0vRwE
         cu/iPI0JLTZ5sCoKqZ4PUGbDjRUH4j1QPBDjGlzTYSD5Iju7AQVM1/c38NkwNhlNMErr
         g2ZgbgwecscXFWs2mBq3hREsCAH1yWDaPOUmM=
Message-ID: <4A8AAA67.8060602@gmail.com>
Date: Tue, 18 Aug 2009 09:19:35 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Gregory Haskins <GHaskins@novell.com>, mingo@elte.hu,
       alacrityvm-devel@lists.sourceforge.net, mst@redhat.com,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH v3 3/6] vbus: add a "vbus-proxy" bus model
References: <4A8A67ED0200005A000528F5@sinclair.provo.novell.com> <4A8A67F70200005A000528F8@sinclair.provo.novell.com> <4A8A67F70200005A000528F8@sinclair.provo.novell.com> <4A8AA0C6.805@redhat.com>
In-Reply-To: <4A8AA0C6.805@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD249D2F1B3945978A4677231"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD249D2F1B3945978A4677231
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> On 08/18/2009 03:36 PM, Gregory Haskins wrote:
>> Yeah, I agree.  I am not advocating we expend energy on this now.  But=

>> my thoughts at the time were that that particular problem can be
>> solved at io-setup time with some kind of call to qualify the address.=

>>
>> Iow: a slow path call with the address would return flags on whether
>> iowrite() should do a real io, or a IOoHC.
>>   =20
>=20
> Yes, it could work, though we'd need somewhere to stow this
> information.  IIRC Arnd suggested a bit from the address itself.
>=20

Yeah, exactly.  I think MMIO is particularly challenging because I don't
know if there are any bits left to use.  But like I said, its a problem
for another day IMO.

-Greg


--------------enigD249D2F1B3945978A4677231
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkqKqmcACgkQP5K2CMvXmqFNrQCdEsgJJ5do/n7SewSSSI7fleak
iqEAni6IUvmvR1VpOsMQp4jM3/KI02XZ
=snOs
-----END PGP SIGNATURE-----

--------------enigD249D2F1B3945978A4677231--
