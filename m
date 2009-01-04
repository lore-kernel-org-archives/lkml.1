Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbZADDxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbZADDxY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 22:53:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbZADDxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 22:53:16 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:53414 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbZADDxP (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 22:53:15 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Duane Griffin <duaneg@dghda.com>
Cc: =?WINDOWS-1252?Q?Martin_MOKREJ=8A?= 
	<mmokrejs@ribosome.natur.cuni.cz>,
       Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, tytso@mit.edu, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
In-Reply-To: Your message of "Sun, 04 Jan 2009 00:41:51 GMT."
             <e9e943910901031641x4c900b6ar5d0f50b648584b7b@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <20090103123813.GA1512@ucw.cz> <495FD5D7.2040907@ribosome.natur.cuni.cz> <e9e943910901031417m51c847fepf304650862f0cbc2@mail.gmail.com> <20090103222957.GG1666@elf.ucw.cz> <495FEE66.9080903@ribosome.natur.cuni.cz> <e9e943910901031538m24ff9616na2aaf3a57f161655@mail.gmail.com> <495FF9CE.2020908@ribosome.natur.cuni.cz> <e9e943910901031600o1705dfb3j197f90b62d1f75a6@mail.gmail.com> <495FFECB.5040001@ribosome.natur.cuni.cz>
            <e9e943910901031641x4c900b6ar5d0f50b648584b7b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1231041158_3941P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 03 Jan 2009 22:52:38 -0500
Message-ID: <15786.1231041158@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1231041158_3941P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Sun, 04 Jan 2009 00:41:51 GMT, Duane Griffin said:

> I agree, it isn't a great situation. Nonetheless, it has always been
> thus for ext3, and so far we've muddled along. Unless and until we can
> replay the journal in-memory without touching the on-disk data, we are
> stuck with it.

Is there a way using md/dm/lvm etc to make the source partition R/O and
replay the journal onto a CoW snapshop?  Admittedly, not easy to do insid=
e
the 'mount' command itself, but at least it might be workable for LiveCD =
R/O
mounts and forensics work, where you can *tell* beforehand that's what yo=
u
want and can jump through setup games before doing the mount...

--==_Exmh_1231041158_3941P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJYDKGcC3lWbTT17ARAgZXAJ9y4dook94ms5ahZ2T3MOAcTXuD2QCggsAV
gCXJVTkl7wopFPQgbjEwN+Q=
=YWYg
-----END PGP SIGNATURE-----

--==_Exmh_1231041158_3941P--
