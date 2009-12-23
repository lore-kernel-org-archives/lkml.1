Return-Path: <linux-kernel-owner+w=401wt.eu-S1756771AbZLWSPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbZLWSPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 13:15:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756740AbZLWSPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 13:15:21 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:45272 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756694AbZLWSPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 13:15:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=KUNQgZ8G/h4ad+K7ZnzMfegogYYAhyPlehWqNvMr4cPvvNl2rtl/KqBadvmwXbilhD
         O9a4KsRduf8ph3Y0GYYDvVB9uiNSAYS3FScdUx+jJMxOeepux5n3cYX/5+Cfa0Tgtofn
         kBAvxQcD2RBQ8Glak1gEl+EKlMff0EdulaYe4=
Message-ID: <4B325E33.8060407@gmail.com>
Date: Wed, 23 Dec 2009 13:15:15 -0500
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>, kvm@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, netdev@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>,
       Anthony Liguori <anthony@codemonkey.ws>, Ingo Molnar <mingo@elte.hu>,
       torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Alacrityvm-devel] [GIT PULL] AlacrityVM guest drivers for 2.6.33
References: <4B1D4F29.8020309@gmail.com> <87637zdy9g.fsf@basil.nowhere.org>	<4B30E654.40702@codemonkey.ws>	<200912221701.56840.bzolnier@gmail.com>	<4B30F214.80206@codemonkey.ws> <20091223065129.GA19600@elte.hu>	<20091223101340.GC20539@basil.fritz.box> <4B31EF65.6070000@redhat.com>
In-Reply-To: <4B31EF65.6070000@redhat.com>
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2680697E9F7A6F0ACA8C1703"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2680697E9F7A6F0ACA8C1703
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12/23/09 5:22 AM, Avi Kivity wrote:

>=20
> There was no attempt by Gregory to improve virtio-net.

If you truly do not understand why your statement is utterly wrong at
this point in the discussion, I feel sorry for you.  If you are trying
to be purposely disingenuous, you should be ashamed of yourself.  In any
case, your statement is demonstrably bogus, but you should already know
this given that we talked about at least several times.

To refresh your memory: http://patchwork.kernel.org/patch/17428/

In case its not blatantly clear, which I would hope it would be to
anyone that understands the problem space:  What that patch would do is
allow an unmodified virtio-net to bridge to a vbus based virtio-net
backend.  (Also note that this predates vhost-net by months (the date in
that thread is 4/9/2009) in case you are next going to try to argue that
it does nothing over vhost-net).

This would mean that virtio-net would gain most of the benefits I have
been advocating (fewer exits, cheaper exits, concurrent execution, etc).
 So this would very much improve virtio-net indeed, given how poorly the
current backend was performing.  I tried to convince the team to help me
build it out to completion on multiple occasions, but that request was
answered with "sorry, we are doing our own thing instead".  You can say
that you didn't like my approach, since that is a subjective opinion.
But to say that I didn't attempt to improve it is a flat out wrong, and
I do not appreciate it.

-Greg




--------------enig2680697E9F7A6F0ACA8C1703
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAksyXjMACgkQP5K2CMvXmqFN1gCeO1NX9PRck/JEQAXNtcnFwFNU
ZOYAn3u08TTjZIbPVuwxNbpoENn28m8J
=Kqr0
-----END PGP SIGNATURE-----

--------------enig2680697E9F7A6F0ACA8C1703--
