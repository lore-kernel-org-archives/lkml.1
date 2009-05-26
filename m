Return-Path: <linux-kernel-owner+w=401wt.eu-S1755729AbZEZMn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729AbZEZMn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 08:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753998AbZEZMnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 08:43:17 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:33333 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626AbZEZMnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 08:43:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer;
        b=sStuWEI6R2EVdAZVRRJjFWTPjJki5nhoiPwff6ti1PbeF29U2nmwNtrSLvbedGl3A5
         YSdQmAKKaneM4fW57K2iLGfrrGDifhYYCfzGlm37cZUhq+jDjahF8ziM9Ha5uuLJuzlB
         sdKCw+U7lQ2de2rQJDKUfWArISWkDf0ViF1aw=
Subject: Re: [2.6.27-rc7 vs 2.6.29 Regresion] Wifi Network Slownes rt2500pci
From: Alejandro Riveira =?ISO-8859-1?Q?Fern=E1ndez?= 
	<alejandro.riveira@gmail.com>
Reply-To: alejandro.riveira@gmail.com
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linville@tuxdriver.com,
       Greg KH <greg@kroah.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <200905261235.36658.IvDoorn@gmail.com>
References: <1243247687.5322.8.camel@varda>
	 <200905261058.01039.IvDoorn@gmail.com> <1243333072.4888.2.camel@varda>
	 <200905261235.36658.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/EJ12HYXwbdaS93zvj3V"
Date: Tue, 26 May 2009 14:43:11 +0200
Message-Id: <1243341791.7607.4.camel@varda>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/EJ12HYXwbdaS93zvj3V
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

El mar, 26-05-2009 a las 12:35 +0200, Ivo van Doorn escribi=C3=B3:

> > What causes the regression then?
>=20
> No idea. Apparently the invalid bitmask is accepted by the device under
> certain conditions. Which would be very odd.... But since dozens
> of people reported this problem for 2.6.27 as well, it probably depends
> heavily on the actual chipset revision or configuration.
>=20
> > Anyway For the script to work what config options do I need? debugfs?
> > Anything else ?
>=20
> CONFIG_DEBUGFS
> CONFIG_MAC80211_DEBUGFS
> CONFIG_RT2X00_LIB_DEBUGFS
>=20
> And thats it, make sure debugfs is mounted and just run the script.
> The script will detect mount location and rt2x00 interface.


That's what I get[1] with the good kernel but I think the script failed
because I got a very short output

$ sudo bash rt2x00_regdump.sh | xclip

kernel: 2.6.29.4-00258-ga2c0a36
driver: rt2500pci
version: 2.2.3
compiled: May 26 2009 13:05:03
dev_flags: 0x00000a2f
rt chip: 0201
rf chip: 0003
revision:00000004

csr length: 93
eeprom length: 256
bbp length: 64
rf length: 5


And nothing more...

>=20
> Ivo

Alejandro

[1] Had to install gawk mawk does not have --posix.=20

--=-/EJ12HYXwbdaS93zvj3V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Esto es una parte de mensaje firmado digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQIcBAABAgAGBQJKG+PaAAoJEDO4iEReSTB2rF4P/2kYIa6k+zRB7VHNFA894EF7
ml0NC8kQZS6ze2Umjy/FCH9S7d68izmTHMzU5K7A65tPXBhp33uZ0Su7yi+lHOho
ftU5DTX+1+TiibbTwCcIICgyb0NzRfD4DG/ZIZbK0dd1wf3/xqGYL/VVoY98lGui
eJl1+q09UWCNAnIYwoLY9D3kudKD0ttW5JVVEippbgQN40iocDPosssMRpu9ODMt
+Q/vN9K3TXmnP82uu4S83A0jSJnlby+QrAnG2YNPxWrC8Pz9ieKJbD1Ah/00BG3l
FrVbbHtErUfnpWYxIdnB4T0AtkJIpuKZfIgX9I3yYjfO2qqnnwdJTpBKzGsESlFw
uD2LMVy0pKqrz/Lx437QKO/Y1tsS4sys+9e3Khay0FEafYz31Zj6LMgulCM7xonU
77TC9TuLaMp37yedBsN6A6mNSe239MGo/k8dgHvNpZxdc7/DiYXGSuEHybnZHYa1
xJcaA0UMBhGlth6GfemKQ1a2Vf+3xLWjr0Lu3CpyedRzgLItEAwEp7M3Jgel7RN7
Jr86wvxQXFJYls1WNHEWWRv/5MfRzBRn6XvPZUsn1Fet4DVduHdvN5G6BwdaCnLE
xvuyyJHeoTGAp1oIofQcKkabAZD3dcDqBWT7+0Pp+3NCpzd/ersfPC9vm/RPliET
DwtRYas9msE+SKlUjMp8
=2saU
-----END PGP SIGNATURE-----

--=-/EJ12HYXwbdaS93zvj3V--

