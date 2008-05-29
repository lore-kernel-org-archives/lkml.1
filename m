Return-Path: <linux-kernel-owner+w=401wt.eu-S1755543AbYE2NOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbYE2NOn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 09:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751971AbYE2NOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 09:14:34 -0400
Received: from intcomgrp.com ([216.54.13.120]:38046 "EHLO beta.intcomgrp.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbYE2NOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 09:14:33 -0400
Message-ID: <483EABEE.7010807@beta.intcomgrp.com>
Date: Thu, 29 May 2008 09:13:18 -0400
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
 boundary="------------enigC48276C73ADE6EF6A6F16A9F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC48276C73ADE6EF6A6F16A9F
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


--------------enigC48276C73ADE6EF6A6F16A9F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkg+q+4ACgkQkNLDmnu1kSl9dACePGXSbJw4jCB8sVi1Xuk2Hm7o
d8cAn0i+IIPU8UcEhknJs0QhibzqLeig
=xbsh
-----END PGP SIGNATURE-----

--------------enigC48276C73ADE6EF6A6F16A9F--
