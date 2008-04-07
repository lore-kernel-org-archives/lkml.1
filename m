Return-Path: <linux-kernel-owner+w=401wt.eu-S1753800AbYDGWXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbYDGWXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 18:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755901AbYDGWXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 18:23:13 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:59628 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755754AbYDGWXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 18:23:12 -0400
X-Sasl-enc: /ccyyVO0l44ujXT1hooBTRZ5A5zRRVyCCIoTqHDVh5Ww 1207606990
Message-ID: <47FA9EC2.6030801@imap.cc>
Date: Tue, 08 Apr 2008 00:22:58 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: linux-kernel@vger.kernel.org, pavel@ucw.cz
Subject: Re: [2.6.25-rc6] possible regression: X server dying
References: <47E82D68.5070305@imap.cc>	 <21d7e9970803241622v10b887a6p869535102b486279@mail.gmail.com>	 <47E83D14.8070800@imap.cc>	 <21d7e9970803241753q433e7545pdd00eae189846a8@mail.gmail.com> <21d7e9970803302153s314d48d3o7120a56092eeaede@mail.gmail.com> <47F1FA3F.3010206@imap.cc>
In-Reply-To: <47F1FA3F.3010206@imap.cc>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA0C15D6FE5D4B82DF2A9AF6A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA0C15D6FE5D4B82DF2A9AF6A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

This is still quite elusive. It only happens once every couple of days,
and the only thing that seems to be clear is that it's triggered by a GL
screensaver. So if it's ok I'll continue sharing X crash backtraces
while I go on groping for a lead. Here's my next one, this time with
kernel 2.6.25-rc8:

0: /usr/bin/X(xf86SigHandler+0x81) [0x80e6d81]
1: [0xb7f22400]
2:
/usr/lib/xorg/modules//extensions/libGLcore.so(_mesa_set_enable+0x1343)
[0xb50aa673]
3: /usr/lib/xorg/modules//extensions/libGLcore.so(_mesa_Disable+0x5a)
[0xb50abc1a]
4: /usr/lib/xorg/modules//extensions/libglx.so [0xb7ba8b98]
5: /usr/lib/xorg/modules//extensions/libglx.so(DoRender+0xdd) [0xb7ba145d=
]
6: /usr/lib/xorg/modules//extensions/libglx.so [0xb7ba157c]
7: /usr/lib/xorg/modules//extensions/libglx.so [0xb7ba5a6d]
8: /usr/bin/X [0x815809e]
9: /usr/bin/X(Dispatch+0x1af) [0x808f68f]
10: /usr/bin/X(main+0x47e) [0x807717e]
11: /lib/libc.so.6(__libc_start_main+0xe0) [0xb7cb6fe0]
12: /usr/bin/X(FontFileCompleteXLFD+0x1e5) [0x8076501]

As for Pavel's suggestion of disabling heap randomization, given the
current crash rate I'd have to try that for several weeks before I could
be reasonably sure that it helped. I think it'll be more useful if I go
on looking for a way to reproduce the crash more reliably. Perhaps I
should start playing some GL based games. :-)

Hope this helps (slim chance, I know)
T.


--------------enigA0C15D6FE5D4B82DF2A9AF6A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFH+p7MQ3+did9BuFsRAhOeAJ9RSNYrmZNFF/3XgF/5w1fmfQtsiQCgg4vp
JDwUwaLNjI93/hx8US4/jBg=
=Ih5l
-----END PGP SIGNATURE-----

--------------enigA0C15D6FE5D4B82DF2A9AF6A--
