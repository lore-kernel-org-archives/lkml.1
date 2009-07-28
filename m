Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbZG1Mz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbZG1Mz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 08:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbZG1Mz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 08:55:27 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:37518 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbZG1Mz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 08:55:27 -0400
Subject: Re: iwlwifi (4965) regression since 2.6.30
From: Johannes Berg <johannes@sipsolutions.net>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: reinette chatre <reinette.chatre@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090728112102.GA3382@ics.muni.cz>
References: <20090726075738.GA21333@ics.muni.cz>
	 <1248710618.1216.452.camel@rc-desk>
	 <1248710775.9958.0.camel@johannes.local>
	 <20090728112102.GA3382@ics.muni.cz>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-jqesdeayUn5HBRq83Wc7"
Date: Tue, 28 Jul 2009 14:54:50 +0200
Message-Id: <1248785690.8113.9.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jqesdeayUn5HBRq83Wc7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Henrique, any ideas on this?

On Tue, 2009-07-28 at 13:21 +0200, Lukas Hejtmanek wrote:
> On Mon, Jul 27, 2009 at 06:06:15PM +0200, Johannes Berg wrote:
> > I'm not aware of any thinkpad-acpi rfkill problems, can you get the
> > rfkill tool and dump the status/list?
> >=20
> > http://wireless.kernel.org/en/users/Documentation/rfkill
>=20
> I figured it out.
>=20
> I disable bluetooth usually just after system startup.
>=20
> I disable bt using Fn+F5 which generates ACPI event:=20
> ibm/hotkey HKEY 00000080 00001005
>=20
> Which is OK.
>=20
> But now (sinc 2.6.31-rcX), it silently toggles Soft block of WIFI. I have
> separate HW rfkill switch, it is only soft blocked.=20
>=20

--=-jqesdeayUn5HBRq83Wc7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKbvUXAAoJEODzc/N7+QmarN0QAIbHYZnsaP/xRx0YEkOnT7mf
JExJeq4GGKKYfreaL1aoexydNRmA7Bv6mD1wdR613yUqq5FMSHD4NKq6prDiwLAt
M8SpjiqTh9MXuCN4vZBwix5j/jhcSM11r709kyT0mrDmiG4oEl0dTqnXZ9kRRfdV
eUUj6i/gEatcdS+v9FIVT20qceUHHwUncxGGQNlLrM0EF2/+0e1EeliEk9lp3xE1
YdaJynq5INUCRCMPL7W85W+/8ZwpQuRDjkhI5TbmevmvFORm0mWGhDMhvk+zHOoX
QABTrG24+rcrnMKi3464Hr3l6uft+S6Rj2bSQt3nRFAPCXFAj1LpYvGFU6qjiIy8
o8fRockgOu4J5mslsN54MNtuQSGuBGRLS+BFfwaGkT6WKqqnsmvr6ryho6arL+Pp
CvnGJ6rJDavrVk62MJ91LsNsj2M+IA0fbIncsi8Om3W3zxUBpmbFgxYYuG+7XenC
BPRVb7MpSElWDS1TfKcgzXQKGMKvRvDS4bv6A7qvXacX2bPFq2btTE69MFnCyzGV
/9aKT5zDWALJo3SR6ZEZ/WINnw9Fa3cjBgGcIdbthbBYrArOymAo2fEPf/X420IN
tRra881YcJ0CFl9Yt9xx85V111MzqvlBDMzqEbZUeBbPfO0YBJ0ZvpeW/WSfK+MZ
8vNr90QgS15Ob4mikJJ/
=Kmvg
-----END PGP SIGNATURE-----

--=-jqesdeayUn5HBRq83Wc7--

