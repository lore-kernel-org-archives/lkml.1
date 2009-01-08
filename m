Return-Path: <linux-kernel-owner+w=401wt.eu-S1760904AbZAHPgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760904AbZAHPgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 10:36:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757096AbZAHPgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 10:36:46 -0500
Received: from ns1.wincor-nixdorf.com ([80.154.98.129]:58010 "EHLO
	mxpdbe1.wincor-nixdorf.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753791AbZAHPgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 10:36:45 -0500
Message-ID: <49661CD8.9060400@wincor-nixdorf.com>
Date: Thu, 08 Jan 2009 16:33:44 +0100
From: Niels de Vos <niels.devos@wincor-nixdorf.com>
Organization: Wincor Nixdorf International
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Eugene Teo <eugeneteo@kernel.org>
CC: linux-kernel@vger.kernel.org, rolandd@cisco.com, sean.hefty@intel.com,
       hal.rosenstock@gmail.com
Subject: Re: [PATCH] IB: check for memory allocation failure [v2]
References: <28fa9c5e0901080620g7f4707daxbffc9bf798581882@mail.gmail.com>
In-Reply-To: <28fa9c5e0901080620g7f4707daxbffc9bf798581882@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD7423BE752545296A1C40F72"
X-OriginalArrivalTime: 08 Jan 2009 15:36:34.0469 (UTC) FILETIME=[E30EFD50:01C971A6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD7423BE752545296A1C40F72
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Eugene Teo wrote:
> On Thu, Jan 8, 2009 at 10:05 PM, Niels de Vos
> <niels.devos@wincor-nixdorf.com> wrote:
>> Hi Eugene,
>>
>> please see below.
>=20
> Thanks for reviewing. Here's an updated patch:
>=20
> Fix error-path NULL deref in c2_register_device().
>=20
> Signed-off-by: Eugene Teo <eugeneteo@kernel.org>

(note: your patch was attached, not inlined...)

There is also an additional kfree() at the end of the patch. It wasn't
included in the first version you sent. Looks correct now imho.

Reviewed-by: Niels de Vos <niels.devos@wincor-nixdorf.com>


> ---
>  drivers/infiniband/hw/amso1100/c2_provider.c |   17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)



--------------enigD7423BE752545296A1C40F72
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFJZhzY5KAkGQPO/QoRApB7AJoCQad2AM8odhOTHyac+B00q0ZMqACgy4wX
Vsjnwnq1TtPTU3/OJdItwh4=
=TWf4
-----END PGP SIGNATURE-----

--------------enigD7423BE752545296A1C40F72--
