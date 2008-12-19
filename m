Return-Path: <linux-kernel-owner+w=401wt.eu-S1754353AbYLSXSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbYLSXSX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 18:18:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbYLSXSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 18:18:16 -0500
Received: from Powered.by.Root24.eu ([81.169.180.23]:60743 "EHLO Root24.de"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbYLSXSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 18:18:15 -0500
Message-ID: <494C2BA9.2080206@ionic.de>
Date: Sat, 20 Dec 2008 00:18:01 +0100
From: Mihai Moldovan <ionic@ionic.de>
User-Agent: Thunderbird 2.0.0.17 (X11/20081005)
MIME-Version: 1.0
To: Jesse Brandeburg <jesse.brandeburg@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Multiple minor glitches with 2.6.27.* and linux-NEXT
References: <494BABB0.8050309@ionic.de> <4807377b0812191419k42b7749chff70f0e217a24cfe@mail.gmail.com>
In-Reply-To: <4807377b0812191419k42b7749chff70f0e217a24cfe@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig4F9D5A09DD28526A89BA365D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4F9D5A09DD28526A89BA365D
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

* On 19.12.2008 23:19, Jesse Brandeburg wrote:
> On Fri, Dec 19, 2008 at 6:12 AM, Mihai Moldovan <ionic@ionic.de> wrote:=

>  =20
>> First of all, will the changes to e1000e be integrated in Linux 2.6.28=

>> as soon as it is released? 2.6.27 does not detect my onboard NIC, whil=
st
>> Linux-NEXT does. Some basic information about this:
>>    =20
>
> 2.6.28 should have support for 8086/10de.
>  =20
Thanks, this is great. :)

>> Might anyone here be so kind to explain me whether disabling specific
>> Cores of an Intel(R)=99 Core2Quad CPU completely ...
>>
>>  - is possible? I am not quite sure whether this would work at all.
>>  - would indeed safe power/lower the power consumption? Logically
>> disabling cores does safe hardly any power. :)
>>    =20
>
> I'm not the best person to answer, but if you enable TICKLESS kernel
> and ACPI power states (and run one of the powersave governors,
> basically treating your desktop like a laptop) then your CPUs will use
> very little power.
>  =20
Guess what I have done. ;-)
I'm already running CPUFreq using the "ondemand" governor. "Powersave",
by the way, is not the best method to actually save power, but I sure
believe you know this too well. :)

> You should be able to get an idea of the power being used by your
> system by seeing how much time it spends in C1/C2/C3, using the
> powertop application from http://www.lesswatts.org/projects/powertop/
>
> it will also give suggestions about how to optimize your system.
Thanks for this rant, I have totally forgotten about powertop, shame on m=
e!

Out of this scope, though, another question: why was the
CONFIG_DEBUG_KERNEL option "hardlinked" to CONFIG_FRAME_POINTER? (Well,
rather vice versa.) I don't really see the point in making the Kernel
larger and, even more imporant, slower when enabling CONFIG_TIMER_STATS
or CONFIG_SCHEDSTATS... I guess you'll get it.

A few month ago this was different and, to my mind, also more logical.
That is, one could disable CONFIG_FRAME_POINTER when not needed and
still use most of the nifty statistic/"pseudo-debugging" features. For
"real" debugging, of course, the frame pointers must be turned on. I
guess that's a question of definition...?
> Why
> disable cores when the system will effectively do it for you?  If
> you're really serious about conserving power, get a power meter that
> goes between your power plug and the wall and measure the wattage
> being consumed by your system.
>  =20
I already did play with this thought as well... Let's see where I can
borrow a quite good device for some time. :)

Thank you for your great and fast answers.

Best regards,


Mihai Moldovan


--------------enig4F9D5A09DD28526A89BA365D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIcBAEBCgAGBQJJTCuuAAoJEB/WLtluJTqHO/QQAMGcCby0rOxenht3+sRfTHVo
dcXvZvjLeom115jf/PTNJwccWmp2BXaKvxSnIY0KZBgw98rtSD9vPAAs4If6SfjY
H4u4mIw+FqjfEW8p1aOmhrWCeW8doksitWrJpZKwVv2KKnvWCatkBqLrDMmrw6mw
hBGFjb2VUKXglt0psmE9/jU3IwYzhVo5rI457qFJDGJAa5SFpnWLZy3+iorh9xNx
ecg101RnLYiwAm1Zf/LwMn/Hto/xW7pD6TPScp/rfihUORmxKp1X9FlwQSZozDBR
PWllSLF2hFIn5v9B4VaPeXmW7KU9XnIgc0VvyrwZZ49KUB+DcmRtvndvmULT51JD
pmKoPn3b5alpa3gGko8hMfQqh+v2yuWSzoFi/3c6Q/9u6ta/eHGijMLp+xltp0wF
L98HhCEisxT33Oy98slkZLe4CJbRDKi3hSwv0BU02ubACzim+0NtCtzlMd82iPR/
+wGDDz9b5BkVbePnq22fQacidomvjDGT8hdryHz7cOjgJjXqbZsaMPtH23thv8cz
pHusfgTcdGSpOkCyOwxsaoVjfMS4XApDY03HYLAexY27lFHVfYLB3g/c9Gu5OhFz
CUlEsnd29MhzOgbzARU3NIzWAIiDhNmDom/OFxf9+NXL7JzQ4NDgUW8m14sMLoYN
tMUpC2lmuex6pO80tSbC
=yc4Z
-----END PGP SIGNATURE-----

--------------enig4F9D5A09DD28526A89BA365D--
