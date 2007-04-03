Return-Path: <linux-kernel-owner+w=401wt.eu-S933999AbXDCQf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933999AbXDCQf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 12:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934011AbXDCQf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 12:35:56 -0400
Received: from cel.leonerd.org.uk ([62.49.94.186]:3644 "EHLO cel.leo"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933999AbXDCQf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 12:35:56 -0400
Date: Tue, 3 Apr 2007 17:35:54 +0100
From: Paul LeoNerd Evans <leonerd@leonerd.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Antonino A. Daplas" <adaplas@gmail.com>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Paul LeoNerd Evans <leonerd@leonerd.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] vt: Expose system-wide UTF-8 default setting via sysfs
Message-ID: <20070403163553.GO26707@cel.leo>
References: <4611ACCD.5000305@gmail.com> <20070403162051.GB5266@ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/Zw+/jwnNHcBRYYu"
Content-Disposition: inline
In-Reply-To: <20070403162051.GB5266@ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--/Zw+/jwnNHcBRYYu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 03, 2007 at 04:20:52PM +0000, Pavel Machek wrote:
> HPA is right... this should be fixed in userland. Reset should reset a
> console, and if you want utf-8, do \ec\ewhatever to get it.

As I've already said elsewhere, does anything say that "reset" means
that UTF-8 is turned off, or merely reset back to some known state? I
personally would consider that UTF-8 being on is the default, and if
something wants it off it should ask specifically..

Consider any other terminal emulator, such as those running on X11; when
they're reset, they know to keep UTF-8 mode turned on, because it said
so in their config, or in the locale. Kernel doesn't really have nice
access to the LANG environment variable, but we can give it something
similar; namely, via a module parameter.

--=20
Paul "LeoNerd" Evans

leonerd@leonerd.org.uk
ICQ# 4135350       |  Registered Linux# 179460
http://www.leonerd.org.uk/

--/Zw+/jwnNHcBRYYu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGEoJp7eTlovtaLtYRAg3ZAJ4hGKB5vSNnj6eldmSKOJxN6dulwgCfd4Ws
yOdmdgfB1tdYF8ium4ni0Bg=
=mezh
-----END PGP SIGNATURE-----

--/Zw+/jwnNHcBRYYu--
