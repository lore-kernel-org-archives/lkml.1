Return-Path: <linux-kernel-owner+w=401wt.eu-S1752002AbZL0NSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbZL0NSp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 08:18:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751875AbZL0NSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 08:18:44 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:3514 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbZL0NSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 08:18:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=KnTEvAMZCIuFwkIac15xLlzvjVskedNTKuHH6CJTdcYvyTKaU9EQyRd3m99Ka0KLEH
         PjNVApgI4RKnLoVg8VlyY51Po7iFJnUl8cZ6aMBSVMvK/C5XOW7AmXWv9FIPE4/aQKJ/
         PbBojVdAFn7nbz+vHDao5BYjUQD0k5Winhxyw=
Message-ID: <4B375EAD.8050204@gmail.com>
Date: Sun, 27 Dec 2009 08:18:37 -0500
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
References: <4B1D4F29.8020309@gmail.com> <87637zdy9g.fsf@basil.nowhere.org>	 <4B30E654.40702@codemonkey.ws> <200912221701.56840.bzolnier@gmail.com>	 <4B30F214.80206@codemonkey.ws> <20091223065129.GA19600@elte.hu>	 <20091223101340.GC20539@basil.fritz.box> <4B31EF65.6070000@redhat.com>	 <4B325E33.8060407@gmail.com> <4B327B90.2050403@redhat.com> <b233dd490912231321p5e09946at5ea63cb0d0fa1489@mail.gmail.com> <4B3725CE.8040004@redhat.com>
In-Reply-To: <4B3725CE.8040004@redhat.com>
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCEA7ECC3B2352EBD1FC39526"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCEA7ECC3B2352EBD1FC39526
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12/27/09 4:15 AM, Avi Kivity wrote:
> On 12/23/2009 11:21 PM, Gregory Haskins wrote:
>> That said, you are still incorrect.  With what I proposed, the model
>> will run as an in-kernel vbus device, and no longer run in userspace.
>> It would therefore improve virtio-net as I stated, much in the same
>> way vhost-net or venet-tap do today.
>>   =20
>=20
> That can't work.  virtio-net has its own ABI on top of virtio, for
> example it prepends a header for TSO information.  Maybe if you disable=

> all features it becomes compatible with venet, but that cripples it.
>=20


You are confused.  The backend would be virtio-net specific, and would
therefore understand the virtio-net ABI.  It would support any feature
of virtio-net as long as it was implemented and negotiated by both sides
of the link.

-Greg


--------------enigCEA7ECC3B2352EBD1FC39526
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAks3Xq4ACgkQP5K2CMvXmqHbiwCeKMgfNMrh945lTeDWfBTudQD+
SJEAn0YX/7oxvw/ASS+eyCm8bJLWoHM7
=s4ey
-----END PGP SIGNATURE-----

--------------enigCEA7ECC3B2352EBD1FC39526--
