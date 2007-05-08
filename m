Return-Path: <linux-kernel-owner+w=401wt.eu-S968234AbXEHO4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968234AbXEHO4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 10:56:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968067AbXEHO4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 10:56:09 -0400
Received: from smtp-ext.int-evry.fr ([157.159.11.17]:51265 "EHLO
	smtp-ext.int-evry.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967870AbXEHO4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 10:56:08 -0400
From: Florian Fainelli <florian.fainelli@int-evry.fr>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] time locale in gen_initramfs_list.sh
Date: Tue, 8 May 2007 16:46:42 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <200705080755.31157.florian.fainelli@int-evry.fr> <464059BE.6010304@zytor.com>
In-Reply-To: <464059BE.6010304@zytor.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1739623.aTpPJMV2Wd";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705081646.47568.florian.fainelli@int-evry.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1739623.aTpPJMV2Wd
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello Peter,

This is true. According to GNU fileutils changelog, the nearest Changelog=20
message regarding this option is :

2004-11-19  Alfred M. Szmidt  <ams@gnu.org>

        * src/ls.c (usage): Clarified description of --no-group (-G),
        --human-readable (-h), --inode (-i), --size (-s), --time,
        and --time-style.

Le mardi 8 mai 2007, H. Peter Anvin a =E9crit=A0:
> Florian Fainelli wrote:
> > I noticed that some zsh users who forced their ls formatting to somethi=
ng
> > non standard could not generate the initramfs file list. Forcing the
> > locale to C while generating seems not to be enough. Adding
> > --time-style=3Dlocale will use C locale ls output and will let them
> > generate the initramfs list. It has no side effects for other users.
>
> ... except for those whose "ls" doesn't have "--time-style=3Dlocale"; how
> long has that been implemented?
>
> 	-hpa



=2D-=20
Cordialement, Florian Fainelli
=2D--------------------------------------------

--nextPart1739623.aTpPJMV2Wd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQBGQI1XkwOXMtq9F3IRAildAKCt/1NcpKxgHIkvA5OluwUmx8rPQQCfWPJx
y4/jdBdgLlbrgomU9EY3WkI=
=DkBH
-----END PGP SIGNATURE-----

--nextPart1739623.aTpPJMV2Wd--
