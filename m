Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbYCXXpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbYCXXpv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 19:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbYCXXpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 19:45:43 -0400
Received: from mail.phnxsoft.com ([195.227.45.4]:2523 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbYCXXpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 19:45:43 -0400
Message-ID: <47E83D14.8070800@imap.cc>
Date: Tue, 25 Mar 2008 00:45:24 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [2.6.25-rc6] possible regression: X server dying
References: <47E82D68.5070305@imap.cc> <21d7e9970803241622v10b887a6p869535102b486279@mail.gmail.com>
In-Reply-To: <21d7e9970803241622v10b887a6p869535102b486279@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig07A399F85409092A97390B41"
X-Spam-Score: -0.652 () AWL,BAYES_50,RDNS_DYNAMIC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig07A399F85409092A97390B41
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, 25 Mar 2008 09:22:32 +1000, Dave Airlie wrote:
> On Tue, Mar 25, 2008 at 8:38 AM, Tilman Schmidt <tilman@imap.cc> wrote:=

>> In the five days since I booted a 2.6.25-rc6 kernel on my development
>>  machine, it has happened three times already that I came back to the
>>  machine to find that the X server had exited, killing all application=
s
>>  that still had a window open. [...]
>=20
> anything in the X.org logfiles?

Ah, of course. Sorry I forgot. Xorg.0.log.old ends with this:

| Backtrace:
| 0: /usr/bin/X(xf86SigHandler+0x81) [0x80e6d81]
| 1: [0xb7fc9400]
| 2:
/usr/lib/xorg/modules//extensions/libGLcore.so(_swrast_Triangle+0x2d)
[0xb51ea5dd]
| 3: /usr/lib/xorg/modules//extensions/libGLcore.so [0xb51f1075]
| 4: /usr/lib/xorg/modules//extensions/libGLcore.so [0xb5206f2e]
| 5: /usr/lib/xorg/modules//extensions/libGLcore.so [0xb52080b8]
| 6:
/usr/lib/xorg/modules//extensions/libGLcore.so(_tnl_run_pipeline+0x153)
[0xb520cb83]
| 7:
/usr/lib/xorg/modules//extensions/libGLcore.so(_tnl_draw_prims+0x3f0)
[0xb51f8340]
| 8:
/usr/lib/xorg/modules//extensions/libGLcore.so(vbo_exec_vtx_flush+0x1fb)
[0xb52471eb]
| 9:
/usr/lib/xorg/modules//extensions/libGLcore.so(vbo_exec_FlushVertices+0x7=
8)
[0xb52488e8]
| 10: /usr/lib/xorg/modules//extensions/libGLcore.so(_mesa_Flush+0x83)
[0xb5112663]
| 11: /usr/lib/xorg/modules//extensions/libglx.so [0xb7c6a107]
| 12: /usr/lib/xorg/modules//extensions/libglx.so [0xb7c4aa6d]
| 13: /usr/bin/X [0x815809e]
| 14: /usr/bin/X(Dispatch+0x1af) [0x808f68f]
| 15: /usr/bin/X(main+0x47e) [0x807717e]
| 16: /lib/libc.so.6(__libc_start_main+0xe0) [0xb7d5dfe0]
| 17: /usr/bin/X(FontFileCompleteXLFD+0x1e5) [0x8076501]
|
| Fatal server error:
| Caught signal 11.  Server aborting

I have put the entire file at
http://gollum.phnxsoft.com/~ts/linux/Xorg.0.log.old
in case you want to have a look.

> does it happen with DRI off?

I guess it does, as my Xorg.0.log{,.old} says:

| (WW) MGA(0): Direct rendering disabled

HTH
Tilman


--------------enig07A399F85409092A97390B41
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFH6D0fQ3+did9BuFsRAjpBAJ44HBJsNsDTzK15RoPb6GaVZH+OuACfeP6B
K1Ghl0E+ufVLrdi9qS4HZ8s=
=eIfi
-----END PGP SIGNATURE-----

--------------enig07A399F85409092A97390B41--
