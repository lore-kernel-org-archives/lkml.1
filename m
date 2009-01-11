Return-Path: <linux-kernel-owner+w=401wt.eu-S1754676AbZAKPmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbZAKPmV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 10:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbZAKPmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 10:42:13 -0500
Received: from xsmtp1.ethz.ch ([82.130.70.13]:13924 "EHLO xsmtp1.ethz.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746AbZAKPmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 10:42:12 -0500
Message-ID: <496A1341.90009@gmx.de>
Date: Sun, 11 Jan 2009 16:41:53 +0100
From: Dieter Ries <clip2@gmx.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20090102)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc1 does not boot
References: <496A085E.8020604@gmx.de> <20090111151924.GA5722@elte.hu> <496A107A.2090301@gmx.de> <20090111153548.GB7401@elte.hu>
In-Reply-To: <20090111153548.GB7401@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig87B5C6DBD1BDAADB0EB2760A"
X-OriginalArrivalTime: 11 Jan 2009 15:42:10.0880 (UTC) FILETIME=[2AD07C00:01C97403]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig87B5C6DBD1BDAADB0EB2760A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Ingo Molnar schrieb:
> * Dieter Ries <clip2@gmx.de> wrote:
>=20
>> Ingo Molnar schrieb:
>>> * Dieter Ries <clip2@gmx.de> wrote:
>>>
>>>> Hi,
>>>>
>>>> I just pulled 2.6.29-rc1, ran oldconfig with defaults and built it.
>>>> When I try to boot it, that kind of works until init should start. T=
hen
>>>> nothing happens. I tried with init=3D/bin/bash, which sometimes work=
s, and
>>>> sometimes gets me a bash without the prompt flashing.
>>>>
>>>> I captured the output with netconsole, but I cannot see a problem th=
ere.
>>>> It is attached.
>>>>
>>>> My config is also attached.
>>>>
>>>> The machine:
>>>>
>>>> Lenovo Thinkpad T60
>>>> Core2Duo 2GHz
>>>>
>>>> Gentoo 64bit
>>>>
>>>> Everything worked fine with 83bc66f, which was my last pull.
>>>>
>>>> What else should I provide for debugging that?
>>> hm, there's no 83bc66f in Linus's tree.
>> Sorry, thats because I applied Timo Hoenigs patch for the fingerprint
>> reader. So the right commit where it worked is 6680598.
>>
>> Before pulling today, I reverted that patch, to avoid conflicts, so I
>> guess it should not matter.
>=20
> in the 6680598..v2.6.29-rc1 window there's more than 3000 commits: ther=
e=20
> were libata and IDE changes, x86 changes, cpumask changes, ACPI changes=
=20
> and more. Any of those categories could produce such error symptoms as =

> your box is showing.
>=20
> Unless you can see some particular badness in the kernel messages=20
> (something that changed to the last working version) that narrows it do=
wn=20
> to some subsystem, i suspect this would have to be bisected ...

I am starting to bisect now, will report back when I found something.

>=20
> 	Ingo
>=20

cu
Dieter


--=20
3rd Law of Computing:
        Anything that can go wr
fortune: Segmentation violation -- Core dumped


--------------enig87B5C6DBD1BDAADB0EB2760A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAklqE0QACgkQ5YzjaZZeXo2aOQCfc8fNbijJ4/FAaLNQkR+aXmqV
ofwAnRGn6NN7BrefLcQ1Wf70CYoQNEbB
=wUnH
-----END PGP SIGNATURE-----

--------------enig87B5C6DBD1BDAADB0EB2760A--
