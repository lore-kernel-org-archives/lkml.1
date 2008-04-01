Return-Path: <linux-kernel-owner+w=401wt.eu-S1757443AbYDAJDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbYDAJDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 05:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755897AbYDAJDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 05:03:11 -0400
Received: from posthamster.phnxsoft.com ([195.227.45.4]:4128 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118AbYDAJDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 05:03:10 -0400
Message-ID: <47F1FA3F.3010206@imap.cc>
Date: Tue, 01 Apr 2008 10:02:55 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [2.6.25-rc6] possible regression: X server dying
References: <47E82D68.5070305@imap.cc>	 <21d7e9970803241622v10b887a6p869535102b486279@mail.gmail.com>	 <47E83D14.8070800@imap.cc>	 <21d7e9970803241753q433e7545pdd00eae189846a8@mail.gmail.com> <21d7e9970803302153s314d48d3o7120a56092eeaede@mail.gmail.com>
In-Reply-To: <21d7e9970803302153s314d48d3o7120a56092eeaede@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD2692D764B6E0E45CC601BBD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD2692D764B6E0E45CC601BBD
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

On Mon, 31 Mar 2008 14:53:29 +1000, Dave Airlie wrote:
> On Tue, Mar 25, 2008 at 10:53 AM, Dave Airlie <airlied@gmail.com> wrote=
:
>>
>> On Tue, Mar 25, 2008 at 9:45 AM, Tilman Schmidt <tilman@imap.cc> wrote=
:
[...]
>>  >  | Backtrace:
>>  >  | 0: /usr/bin/X(xf86SigHandler+0x81) [0x80e6d81]
>>  >  | 1: [0xb7fc9400]
>>  >  | 2: /usr/lib/xorg/modules//extensions/libGLcore.so(_swrast_Triang=
le+0x2d) [0xb51ea5dd]
>>  >  | 3: /usr/lib/xorg/modules//extensions/libGLcore.so [0xb51f1075]
>>  >  | 4: /usr/lib/xorg/modules//extensions/libGLcore.so [0xb5206f2e]
>>  >  | 5: /usr/lib/xorg/modules//extensions/libGLcore.so [0xb52080b8]
>>  >  | 6: /usr/lib/xorg/modules//extensions/libGLcore.so(_tnl_run_pipel=
ine+0x153) [0xb520cb83]
>>  >  | 7: /usr/lib/xorg/modules//extensions/libGLcore.so(_tnl_draw_prim=
s+0x3f0) [0xb51f8340]
>>  >  | 8: /usr/lib/xorg/modules//extensions/libGLcore.so(vbo_exec_vtx_f=
lush+0x1fb) [0xb52471eb]
>>  >  | 9: /usr/lib/xorg/modules//extensions/libGLcore.so(vbo_exec_Flush=
Vertices+0x78) [0xb52488e8]
>>  >  | 10: /usr/lib/xorg/modules//extensions/libGLcore.so(_mesa_Flush+0=
x83) [0xb5112663]
>>  >  | 11: /usr/lib/xorg/modules//extensions/libglx.so [0xb7c6a107]
>>  >  | 12: /usr/lib/xorg/modules//extensions/libglx.so [0xb7c4aa6d]
>>  >  | 13: /usr/bin/X [0x815809e]
>>  >  | 14: /usr/bin/X(Dispatch+0x1af) [0x808f68f]
>>  >  | 15: /usr/bin/X(main+0x47e) [0x807717e]
>>  >  | 16: /lib/libc.so.6(__libc_start_main+0xe0) [0xb7d5dfe0]
>>  >  | 17: /usr/bin/X(FontFileCompleteXLFD+0x1e5) [0x8076501]
>>  >  |
>>  >  | Fatal server error:
>>  >  | Caught signal 11.  Server aborting
>=20
> any look finding what might have caused this?

Not really. It's obviously triggered by the screensaver. The machine
runs SuSE's default: gnome-screensaver with mode =3D random and a list
of 189 candidate screensavers, so I can't tell which one(s) of those
actually triggers the problem.

But perhaps that doesn't matter anyway. I recently collected another
X backtrace with kernel 2.6.25-rc7 which looks quite different in
the libglx section:

0: /usr/bin/X(xf86SigHandler+0x81) [0x80e6d81]
1: [0xb7ef7400]
2: /usr/lib/xorg/modules//extensions/libglx.so [0xb7b7d8e8]
3: /usr/lib/xorg/modules//extensions/libglx.so(DoRender+0xdd) [0xb7b7645d=
]
4: /usr/lib/xorg/modules//extensions/libglx.so [0xb7b7657c]
5: /usr/lib/xorg/modules//extensions/libglx.so [0xb7b7aa6d]
6: /usr/bin/X [0x815809e]
7: /usr/bin/X(Dispatch+0x1af) [0x808f68f]
8: /usr/bin/X(main+0x47e) [0x807717e]
9: /lib/libc.so.6(__libc_start_main+0xe0) [0xb7c8bfe0]
10: /usr/bin/X(FontFileCompleteXLFD+0x1e5) [0x8076501]

But I know next to nothing about GL, so I'm out of my depth there.
I'd welcome any suggestions on how to provoke the crash more
regularly so that I could attempt to bisect.

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigD2692D764B6E0E45CC601BBD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFH8fpJQ3+did9BuFsRAg5lAJ9KyhcM83BGbjMEkVreoZsrvVIQLACfVti7
vutZteeSumzo42m716b4OTw=
=UQW4
-----END PGP SIGNATURE-----

--------------enigD2692D764B6E0E45CC601BBD--
