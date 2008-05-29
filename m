Return-Path: <linux-kernel-owner+w=401wt.eu-S1756236AbYE2NRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbYE2NRF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 09:17:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753067AbYE2NQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 09:16:51 -0400
Received: from intcomgrp.com ([216.54.13.120]:38057 "EHLO beta.intcomgrp.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751730AbYE2NQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 09:16:50 -0400
Message-ID: <483EAB9F.20508@beta.intcomgrp.com>
Date: Thu, 29 May 2008 09:11:59 -0400
From: James Kosin <jkosin@beta.intcomgrp.com>
Organization: International Communications Group, Inc.
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Johannes Weiner <hannes@saeurebad.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: optimizing out inline functions
References: <ayzYV-7mv-5@gated-at.bofh.it> <ayA8E-89e-29@gated-at.bofh.it>	<483DC28B.4060001@support.intcomgrp.com> <87lk1trdr8.fsf@saeurebad.de>
In-Reply-To: <87lk1trdr8.fsf@saeurebad.de>
X-Enigmail-Version: 0.95.6
OpenPGP: id=7BB59129
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig60A23811A5BA7AF15AE07AD8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig60A23811A5BA7AF15AE07AD8
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Johannes Weiner wrote:
> Hi,
>
> James Kosin <jkosin@beta.intcomgrp.com> writes:
>
>  =20
>> Sam Ravnborg wrote:
>>    =20
>>> On Wed, May 28, 2008 at 02:51:02PM -0500, Steve French wrote:
>>>      =20
>>>> In trying to remove some macros, I ran across another kernel style
>>>>        =20
>> <<--SNIP-->>
>>    =20
>>> With reference to a recent thread about kconfig
>>> I would prefer:
>>> static inline void some_debug_function(var1)
>>> {
>>> 	if (KCONFIG_DEBUG_SOMETHING) {
>>> 		something =3D var1;
>>> 		printk(some debug text);
>>> 	}
>>> }
>>>
>>>
>>> But we do not have KCONFIG_DEBUG_SOMETHING available
>>> so the second best is to use an empty function
>>> to keep the typechecking in place.
>>>
>>> IIRC gcc optimize both away.
>>>      =20
>> Another way would be to have:
>>
>> static inline void some_debug_function(var1)
>> {
>>    #ifdef KCONFIG_DEBUG_SOMETHING
>>       something =3D var1;
>>       printk(some debug text);
>>    #endif
>> }
>>
>> BUT, this probably violates some styling rules.
>>    =20
>
> Without indenting the ifdefs, I think this solution is the best.
>
> It gives you the advantages of type checking but saves a superfluous
> prototype.
>
> 	Hannes
>
>  =20
Actually, Joe Perches, gave a good reason for using the MACRO #define=20
method; so, this could really turn into an interesting discussion.
Pros and Cons are always interesting when there is more than one way to=20
do something.

James


--------------enig60A23811A5BA7AF15AE07AD8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkg+q6MACgkQkNLDmnu1kSnVPgCfeE9ehnsDDzywSiwyYDxTLNkb
d/sAn1Zud1SVjd2obdjjX952lGKofwXX
=J+LC
-----END PGP SIGNATURE-----

--------------enig60A23811A5BA7AF15AE07AD8--
