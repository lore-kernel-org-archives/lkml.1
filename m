Return-Path: <linux-kernel-owner+w=401wt.eu-S935273AbXFFUX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935273AbXFFUX0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 16:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753608AbXFFUXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 16:23:18 -0400
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4415 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655AbXFFUXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 16:23:17 -0400
Date: Wed, 6 Jun 2007 22:23:03 +0200
From: Erik Mouw <mouw@nl.linux.org>
To: jidong xiao <jidong.xiao@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Question about spinlock in linux kernel
Message-ID: <20070606202301.GB4911@gateway.home>
References: <4104961b0706060940y6b43c496n6eca7099499fff58@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="St7VIuEGZ6dlpu13"
Content-Disposition: inline
In-Reply-To: <4104961b0706060940y6b43c496n6eca7099499fff58@mail.gmail.com>
Organization: Eric Conspiracy Secret Labs
X-Eric-Conspiracy: There is no conspiracy!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--St7VIuEGZ6dlpu13
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 07, 2007 at 12:40:58AM +0800, jidong xiao wrote:
> I found there is such a kernel symbol ".text.lock.spinlock",
> for example,
> # cat /proc/kallsyms | grep spinlock
> ffffffff8011e440 T bust_spinlocks
> ffffffff802d00fc t .text.lock.spinlock
> ffffffff8832ae20 d state_spinlock       [nfs]
> but I can not find that who exported such a symbol?I am wondering
> where is this kernel originated from? I mean, if I faced any oops,
> which shows RIP is for example:
> RIP: 0010:[<ffffffff8031a4d9>] <ffffffff8031a4d9>{.text.lock.spinlock+0}
> then how can i locate the oops?it seems that .text.lock.spinlock is
> neither a function name, nor a variable name, so i am confused, who
> can help me out of here? Any advises is really really appreciated!

It's the name of the ELF section that holds the spinlocks. I wouldn't
know how you could get the name of a particular spinlock from there.


Erik

--=20
They're all fools. Don't worry. Darwin may be slow, but he'll
eventually get them. -- Matthew Lammers in alt.sysadmin.recovery

--St7VIuEGZ6dlpu13
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGZxel/PlVHJtIto0RAqcgAJ0dmZGmVIctdZdBTOWzOeVqRPQG3wCgjAt1
bLv9RNjZp7YjyQNPW30WnnY=
=31s4
-----END PGP SIGNATURE-----

--St7VIuEGZ6dlpu13--
