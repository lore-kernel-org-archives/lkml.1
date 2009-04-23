Return-Path: <linux-kernel-owner+w=401wt.eu-S1758151AbZDWOKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151AbZDWOKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 10:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754574AbZDWOKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 10:10:33 -0400
Received: from liberdade.minaslivre.org ([72.232.18.203]:47260 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089AbZDWOKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 10:10:33 -0400
Date: Thu, 23 Apr 2009 11:10:26 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, e1000-devel@lists.sourceforge.net,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [E1000-devel] e1000: "eeprom checksum is not valid" after kexec
Message-ID: <20090423141026.GB4046@vespa.holoscopio.com>
References: <49F06EEB.9060500@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jq0ap7NbKX2Kqbes"
Content-Disposition: inline
In-Reply-To: <49F06EEB.9060500@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jq0ap7NbKX2Kqbes
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 23, 2009 at 03:36:43PM +0200, Jiri Slaby wrote:
> Hi,
>=20
> 4a865905f685eaefaedf6ade362323dc52aa703b
> (PCI PM: Make pci_set_power_state() handle devices with no PM support)
> breaks e1000 after being kexec'ed. These reverts fix the problem:
>     Revert "PCI PM: Make pci_set_power_state() handle devices with no PM
> support"
>     Revert "PCI PM: Introduce __pci_[start|complete]_power_transition()
> (rev. 2)"
>=20
> I reverted the second one just for an easy revert of the former one,
> which is actually the culprit.
>=20
> The symptoms:
> e1000 0000:02:01.0: enabling device (0000 -> 0003)
> e1000 0000:02:01.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ=
 11
> e1000 0000:02:01.0: setting latency timer to 64
> e1000: 0000:02:01.0: e1000_probe: The EEPROM Checksum Is Not Valid
> Switched to high resolution mode on CPU 0

Have you tried b43fcd7dc7b, found in v2.6.30-rc3?

--jq0ap7NbKX2Kqbes
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknwdtIACgkQyTpryRcqtS0y4wCfXQoVLgFbvcQJvljDh3Rulxut
ijgAnAvCWxx4IPaEjlaRvgKuwEtqEF7b
=jF31
-----END PGP SIGNATURE-----

--jq0ap7NbKX2Kqbes--
