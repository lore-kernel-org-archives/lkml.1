Return-Path: <linux-kernel-owner+w=401wt.eu-S1753600AbYKYKpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbYKYKpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 05:45:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbYKYKpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 05:45:36 -0500
Received: from server.drzeus.cx ([85.8.24.28]:36397 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752602AbYKYKpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 05:45:35 -0500
Date: Tue, 25 Nov 2008 11:45:26 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Philip Langdale <philipl@overt.org>
Cc: linux kernel <linux-kernel@vger.kernel.org>, sdhci-devel@list.drzeus.cx,
       Frank Seidel <fseidel@suse.de>,
       Mathias Weyland <weyland@library.ethz.ch>
Subject: Re: [PATCH] ricoh_mmc: Handle newer models of Ricoh controllers
Message-ID: <20081125114526.715ebb23@mjolnir.drzeus.cx>
In-Reply-To: <492BBA91.5010302@overt.org>
References: <492BBA91.5010302@overt.org>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-1700-1227609931-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-1700-1227609931-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 25 Nov 2008 00:42:57 -0800
Philip Langdale <philipl@overt.org> wrote:

> The latest generation of laptops are shipping with a newer
> model of Ricoh chip where the firewire controller is the
> primary PCI function but a cardbus controller is also present.
>=20
> The existing code assumes that if a cardbus controller is,
> present, then it must be the one to manipulate - but the real
> rule is that you manipulate PCI function 0. This patch adds an
> additional constraint that the target must be function 0.
>=20
> Signed-off-by: Philip Langdale <philipl@overt.org>
> ---

Mathias, please try to test this ASAP so that I can push it to Linus
for .28 (provided it works).

Frank, if possibly it would be useful if you could also test this on
the hardware you wrote your patch for. Just so we don't break
anything. :)

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-1700-1227609931-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkkr10sACgkQ7b8eESbyJLjVoQCgwQLs4DXEePAJTXey4DWvqs08
7agAn1xTCtuF0lgyBk+aKVfIkC1jVTVn
=MVSy
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-1700-1227609931-0001-2--
