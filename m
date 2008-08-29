Return-Path: <linux-kernel-owner+w=401wt.eu-S1756205AbYH2JuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbYH2JuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 05:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759AbYH2JuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 05:50:08 -0400
Received: from main.gmane.org ([80.91.229.2]:35577 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685AbYH2JuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 05:50:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Walter Franzini <walter.franzini@gmail.com>
Subject: Re: mounting windows shares with path exactly like on windows
Date: Fri, 29 Aug 2008 11:49:52 +0200
Message-ID: <86vdxk881r.fsf@acer.nord-com.it>
References: <20080828095925.AB0ED313C53@f48.poczta.interia.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 217.141.18.130
X-Archive: encrypt
Mail-Copy-To: never
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
Cancel-Lock: sha1:BkgXImDohdNUN/y1hjWL7XYdfkI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

kovlensky@interia.pl writes:

> I'm sorry to be slightly off topic, when it comes to this list, but
> I have no clue where to look for that and I think it can be doe on
> kernel level only.
>
> In short - I've got bunch of applications running both on windows
> and linux and these applications exchange links to files mounted on
> both sides. The problem is that these paths are different, i.e. like
> D:/dir/file on windows and /mountpoint/dir/file on Linux. What I
> need is unifying them. So my idea is to have path translator on
> anything on kernel level, which will make Linux open call to
> D:/dir/file on Linux work and open /mountpoint/dir/file. Was
> anything close to that ever incorporated in kernel?
>
> Applications are, as usual, closed source, and support for them,
> also as usual, answers "won't be fixed, switch to Windows,
> please". Very helpful.
>
> Any other ideas of solving this problem are also warmly
> welcomed. Also on windows side.

You may want to look at plasticfs (http://plasticfs.sourceforge.net/)

It does not do what you need, but should not be to difficult to
change.

From=20the Home Page:
=2D-----------------------------------------------------------------------
The Plastic File System is an LD_PRELOAD module for manipulating what
the file system looks like for programs. This allows virtual file
systems to exist in user space, without kernel hacks or modules.
=2D-----------------------------------------------------------------------

HTH
=2D-=20
Walter Franzini
http://aegis.stepbuild.org/

PGP Public key ID: 1024D/CB3FEB43
Key fingerprint  : FA26 C33B CAFF 7848 EFEB  7327 96AA 2D57 CB3F EB43
Key server       : http://www.keyserver.net

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIt8ZClqotV8s/60MRAs4HAJ9CvC/WA2359znFbIH9h+QdWVm0GwCff1Bt
ev6ZO7MZDIUFUAMd6Pp+B0E=
=H3V3
-----END PGP SIGNATURE-----
--=-=-=--

