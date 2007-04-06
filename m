Return-Path: <linux-kernel-owner+w=401wt.eu-S1767662AbXDFOaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767662AbXDFOaX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 10:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767663AbXDFOaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 10:30:23 -0400
Received: from cel.leonerd.org.uk ([62.49.94.186]:2356 "EHLO cel.leo"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1767662AbXDFOaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 10:30:22 -0400
Date: Fri, 6 Apr 2007 15:30:19 +0100
From: Paul LeoNerd Evans <leonerd@leonerd.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Antonino A. Daplas" <adaplas@gmail.com>,
       Paul LeoNerd Evans <leonerd@leonerd.org.uk>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] vt: Expose system-wide UTF-8 default setting via sysfs
Message-ID: <20070406143019.GQ26707@cel.leo>
References: <4611ACCD.5000305@gmail.com> <20070403162051.GB5266@ucw.cz> <20070403163553.GO26707@cel.leo> <1175665163.4519.7.camel@daplas> <20070404080140.GC8256@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="svExV93C05KqedWb"
Content-Disposition: inline
In-Reply-To: <20070404080140.GC8256@elf.ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--svExV93C05KqedWb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 04, 2007 at 10:01:40AM +0200, Pavel Machek wrote:
> You could do that... during development series. But this is
> userspace-visible API change, and those are not allowed during stable.
>=20
> ...and having /sysctl configuring inital state for reset is just plain
> ugly.

Well, how else would you suggest to do it? Bearing in mind all other
terminal emulators (xterm, gnome-terminal, konsole, and so on) all have
other out-of-band ways to determine this - config files, menu options,
locale variables,... None of those are particularlly viable for the
kernel. I vote this is the closest thing we've got.

--=20
Paul "LeoNerd" Evans

leonerd@leonerd.org.uk
ICQ# 4135350       |  Registered Linux# 179460
http://www.leonerd.org.uk/

--svExV93C05KqedWb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGFll77eTlovtaLtYRAnIYAJ4zPeHFGvJwmissRayWA1fIN5KDsQCfTfGB
UnksWYe4cSCCQzZozURGMdM=
=/nGv
-----END PGP SIGNATURE-----

--svExV93C05KqedWb--
