Return-Path: <linux-kernel-owner+w=401wt.eu-S1756193AbZAVJHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbZAVJHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 04:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbZAVJHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 04:07:14 -0500
Received: from mxpdbe2.wincor-nixdorf.com ([80.154.98.130]:39799 "EHLO
	mxpdbe2.wincor-nixdorf.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752714AbZAVJHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 04:07:12 -0500
Message-ID: <49783679.8010005@wincor-nixdorf.com>
Date: Thu, 22 Jan 2009 10:03:53 +0100
From: Niels de Vos <niels.devos@wincor-nixdorf.com>
Organization: Wincor Nixdorf International
User-Agent: Thunderbird 2.0.0.19 (X11/20090107)
MIME-Version: 1.0
To: Tosoni <jp.tosoni@acksys.fr>
CC: "'Michael Bramer'" <michael@debsupport.de>,
       "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>,
       "'Paulius Zaleckas'" <paulius.zaleckas@teltonika.lt>,
       linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH] drivers/serial/8250_pci.c (add support for '8-port RS-232
 MIC-3620 from advantech'
References: <6E0880DF84464BF2AA0275ABFFCCDAF2@acksys.local>
In-Reply-To: <6E0880DF84464BF2AA0275ABFFCCDAF2@acksys.local>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigFEEE667096B364B681E561B2"
X-OriginalArrivalTime: 22 Jan 2009 09:06:51.0275 (UTC) FILETIME=[C35F3DB0:01C97C70]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFEEE667096B364B681E561B2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Tosoni wrote:
>> On Wed, Jan 21, 2009 at 12:32:15PM +0000, Alan Cox wrote:
>>>>>>  static struct pci_device_id serial_pci_tbl[] =3D {
>>>>>> +       {       PCI_VENDOR_ID_ADVANTECH,
>> PCI_DEVICE_ID_ADVANTECH_PCI3620,
>>>>>> +               0x3620, PCI_ANY_ID, 0, 0,
>>>> Why not use PCI_VENDOR_ID_ADVANTECH as PCI_SUBVENDOR_ID too?
>>> The Advantech vendor id is not 0x3620. This confused me as
>> well which is
>>> why I asked for an lspci. Advantech has stuck the device id in the
>>> subvendor bits and '1' in the subdevice (so it should be 1 not
>>> PCI_ANY_ID).
>> is this better?
>>
>> +       {       PCI_VENDOR_ID_ADVANTECH,
>> PCI_DEVICE_ID_ADVANTECH_PCI3620,
>> +               PCI_DEVICE_ID_ADVANTECH_PCI3620, 1, 0, 0,
>=20
> Since the name describes a device id where it should be a (sub)vendor i=
d,
> I would suggest that you add a line of comment to explain the case.
> So that no one will be tempted to change it back to PCI_VENDOR_ID_ADVAN=
TECH
> in the future.

Definitely!

Niels


--------------enigFEEE667096B364B681E561B2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFJeDZ55KAkGQPO/QoRAhWlAKDfr/kTM19Nf5amrlEVFpaadxB50QCeMehC
6XE0CeYNWP2iAam1+/dYRSA=
=lf7o
-----END PGP SIGNATURE-----

--------------enigFEEE667096B364B681E561B2--
