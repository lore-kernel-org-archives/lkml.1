Return-Path: <linux-kernel-owner+w=401wt.eu-S1761721AbZEGTM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761721AbZEGTM0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 15:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbZEGTMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 15:12:15 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:44081 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbZEGTMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 15:12:14 -0400
Message-ID: <4A033281.8050002@novell.com>
Date: Thu, 07 May 2009 15:12:01 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Avi Kivity <avi@redhat.com>, Gregory Haskins <gregory.haskins@gmail.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <4A018DF2.6010301@novell.com> <20090506160712.GW3036@sequoia.sous-sol.org> <4A031471.7000406@novell.com> <4A0322F1.2000905@redhat.com> <4A032390.6030100@gmail.com> <4A032472.4030106@redhat.com> <4A03259B.3050500@gmail.com> <4A032771.6050703@redhat.com> <4A032A74.2020809@novell.com> <4A032FDD.8020209@redhat.com> <20090507190751.GE3036@sequoia.sous-sol.org>
In-Reply-To: <20090507190751.GE3036@sequoia.sous-sol.org>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE02DF5DE5F625B87F8E9F136"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE02DF5DE5F625B87F8E9F136
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Chris Wright wrote:
> * Avi Kivity (avi@redhat.com) wrote:
>  =20
>> Gregory Haskins wrote:
>>    =20
>>> Cool,  I will code this up and submit it.  While Im at it, Ill run it=

>>> through the "nullio" ringer, too. ;)  It would be cool to see the
>>> pv-mmio hit that 2.07us number.  I can't think of any reason why this=

>>> will not be the case.
>>>      =20
>> Don't - it's broken.  It will also catch device assignment mmio and =20
>> hypercall them.
>>    =20
>
> Not necessarily.  It just needs to be creative w/ IO_COND
>  =20

Hi Chris,
   Could you elaborate?  How would you know which pages to hypercall and
which to let PF?

-Greg


--------------enigE02DF5DE5F625B87F8E9F136
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoDMoEACgkQlOSOBdgZUxnJmwCfcyuG0Y4MYLRp7lAnB6SsksNd
uhAAn2Q9FD8xZPfiMEqpQX0frsJEczf8
=u2bs
-----END PGP SIGNATURE-----

--------------enigE02DF5DE5F625B87F8E9F136--
