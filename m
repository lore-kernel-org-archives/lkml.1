Return-Path: <linux-kernel-owner+w=401wt.eu-S1755866AbZKNC16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbZKNC16 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 21:27:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753507AbZKNC14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 21:27:56 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:39752 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbZKNC1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 21:27:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=maYGP+i0Pq7amLoetwin31SmWgvKq30x2EO7F5vAI58xX5X/TbDTTNY49NicMxwC9z
         60JPmgXlj8YONRzFKrclkKx+mfvS1CAv2sixKpocjWaw4k+IpvZ9gZu2uckukwMEzun6
         8vqm7vzMtF5hZbPPldrYpnWhbJbkpf9rLKZLE=
Message-ID: <4AFE15AD.6000208@gmail.com>
Date: Fri, 13 Nov 2009 21:27:57 -0500
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Gregory Haskins <ghaskins@novell.com>,
       "Michael S. Tsirkin" <mst@redhat.com>,
       alacrityvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [RFC PATCH] net: add dataref destructor to sk_buff
References: <20091002141407.30224.54207.stgit@dev.haskins.net> <20091110115335.GC6989@redhat.com> <4AF919020200005A000586A9@sinclair.provo.novell.com> <20091110131722.GA19645@redhat.com> <4AF9747E.8020408@novell.com> <20091110143652.GB19645@redhat.com> <4AF98A8C.9040201@novell.com> <20091114011229.GA18580@gondor.apana.org.au> <4AFE08EF.2030308@gmail.com> <20091114022103.GA19020@gondor.apana.org.au>
In-Reply-To: <20091114022103.GA19020@gondor.apana.org.au>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig21C582F9350111BA33D27FDF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig21C582F9350111BA33D27FDF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Herbert Xu wrote:
> On Fri, Nov 13, 2009 at 08:33:35PM -0500, Gregory Haskins wrote:
>> Well, not with respect to the overall protocol, of course not.  But wi=
th
>> respect to the buffer in question, it _has_ to be.  Or am I missing
>> something?
>=20
> sendfile() has never guaranteed that the kernel is finished with
> the underlying pages when it returns.
>=20
> Cheers,

Clearly there must be _some_ mechanism to synchronize (e.g.
flush/barrier) though, right?  Otherwise, that interface would seem to
be quite prone to races and would likely be unusable.   So what does
said flush use to know when the buffer is free?

-Greg


--------------enig21C582F9350111BA33D27FDF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkr+Fa0ACgkQP5K2CMvXmqHxCQCfeOSNrB4WUUHJlHAgXDuzEkVt
q4oAn2Pc2/fD9iDBVXk6RcD6RRj+q28H
=9nPK
-----END PGP SIGNATURE-----

--------------enig21C582F9350111BA33D27FDF--
