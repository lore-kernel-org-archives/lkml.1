Return-Path: <linux-kernel-owner+w=401wt.eu-S1753624AbYJ3Fio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624AbYJ3Fio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 01:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbYJ3Fie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 01:38:34 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:48298 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbYJ3Fid (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 01:38:33 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Halesh S <halesh.s@india.com>, linux-kernel@vger.kernel.org
Subject: Re: parent process behaviour to signal after vfork()
In-Reply-To: Your message of "Wed, 29 Oct 2008 08:17:36 CDT."
             <517f3f820810290617m49b5deccu5d639cd0d3c94592@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <loom.20081028T062822-852@post.gmane.org>
            <517f3f820810290617m49b5deccu5d639cd0d3c94592@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1225345110_4046P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 30 Oct 2008 01:38:30 -0400
Message-ID: <53383.1225345110@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1225345110_4046P
Content-Type: text/plain; charset=us-ascii

On Wed, 29 Oct 2008 08:17:36 CDT, Michael Kerrisk said:

> diff --git a/man2/vfork.2 b/man2/vfork.2
> index 55044ad..8a7ed50 100644
> --- a/man2/vfork.2
> +++ b/man2/vfork.2
> @@ -94,7 +94,10 @@ but may call
>  .PP
>  Signal handlers are inherited, but not shared.
>  Signals to the parent
> -arrive after the child releases the parent's memory.
> +arrive after the child releases the parent's memory (i.e., after the child calls
> +.BR _exit (2)
> +or
> +.BR execve (2)).

OK, I'll bite - when is the parent's memory released if the child doesn't
depart by calling _exit() or execve(), but manages to get killed by an
unhandled signal or the OOM killer or similar?

(That's the generic problem with adding itemized lists to an explanation - it's
rarely clear if the list is an exhaustive list, or a non-complete list of
examples.  Note how often we have flame wars regarding which EQUUX should be
returned in a corner case that hinge on whether Posix says "Only FOO, BAR,
and BAZ can be returned" or "FOO, BAR, BAZ are among the errors that can be
returned")


--==_Exmh_1225345110_4046P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJCUhWcC3lWbTT17ARAqtxAJ0WxsrZVlfEMhof44MX6ByLRBJATQCeJoTR
L36H9yMajqUjd8HfnPbOEPw=
=dGAN
-----END PGP SIGNATURE-----

--==_Exmh_1225345110_4046P--
