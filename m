Return-Path: <linux-kernel-owner+w=401wt.eu-S1760800AbYEWXuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760800AbYEWXuh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 19:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbYEWXua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 19:50:30 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:51550 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbYEWXu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 19:50:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type;
        b=uLiOV6solSSfm9UwduZiSITQ7y9oYvErBZvVtqxiLsvJ1XlTXe6FMdVjqSx+DR6qJFcQECuQTzMSijLYfvEl542Jy2OHdZtCXSN4LEYtsUTWV88KWHBS+I7cfZ+RED0CGXTJBI+xjrW636WnxW1GYyi9mO61C9vkQX342Jy5+tI=
Date: Sat, 24 May 2008 00:50:21 +0100
From: Ciaran McCreesh <ciaran.mccreesh@googlemail.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Bjorn Helgaas" <bjorn.helgaas@hp.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: kernel boot hangs after x86: insert_resorce for lapic addr
 after e820_reserve_resources
Message-ID: <20080524005021.67b98674@snowcone>
In-Reply-To: <86802c440805192022n29e191dfped3ee5afa7894288@mail.gmail.com>
References: <20080518014111.4f32298b@googlemail.com>
	<20080518164127.2236d82a@googlemail.com>
	<86802c440805181400m5a3b4e28oeab6245e9a2ffd00@mail.gmail.com>
	<20080518232347.7964835c@snowcone>
	<86802c440805182043n2a4855bcw6924f6df2fbdc9f4@mail.gmail.com>
	<20080520014405.5eb150cd@googlemail.com>
	<86802c440805191822v5b572d03t1568b27eb2defa4a@mail.gmail.com>
	<20080520022446.3b9c335a@googlemail.com>
	<86802c440805191948h29769798qecc93b7aa5c9cd91@mail.gmail.com>
	<20080520041655.0552236d@googlemail.com>
	<86802c440805192022n29e191dfped3ee5afa7894288@mail.gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ed0WtOidv=EaYByTy5VMJeS";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ed0WtOidv=EaYByTy5VMJeS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

(Apologies for the delay. I've not had physical access to the box for a
few days.)

On Mon, 19 May 2008 20:22:45 -0700
"Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
> >> seems acpi pnp resource cause some problem....
> >>
> >> please try attached patch and send out /proc/mtrr
> >
> > The patch doesn't help I'm afraid.
>=20
> sorry, please send /proc/iomem

Sorry, I'm getting confused here. I can't send /proc/iomem with the
ram_reserve patch applied since the system won't boot (and it appears
to collide with the original commit, so I can't revert that and apply
the patch to get a booting system). Without the ram_reserve
patch, /proc/iomem is as it was earlier in the discussion.

> can you boot with pnpacpi=3Doff ?

No, that doesn't help either.

Thanks,
--=20
Ciaran McCreesh

--Sig_/ed0WtOidv=EaYByTy5VMJeS
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkg3WEAACgkQ96zL6DUtXhEhJQCfRJwXGVmCNedvySW0k2Tw3BOw
6sgAoN8mhJx8l21SJxbh7/fq7EXKWvdF
=c76T
-----END PGP SIGNATURE-----

--Sig_/ed0WtOidv=EaYByTy5VMJeS--
