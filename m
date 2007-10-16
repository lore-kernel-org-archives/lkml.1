Return-Path: <linux-kernel-owner+w=401wt.eu-S1765134AbXJPRik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765134AbXJPRik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 13:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760018AbXJPRic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 13:38:32 -0400
Received: from sitemail2.everyone.net ([216.200.145.36]:40490 "EHLO
	omta16.mta.everyone.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758693AbXJPRic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 13:38:32 -0400
X-Eon-Dm: dm43
X-Eon-Sig: AQF97PZHFPG9jsNCjwIAAAAB,92059aaa6a54af123230e864da55015a
Message-ID: <4714F1BA.8020600@smsglobal.net>
Date: Wed, 17 Oct 2007 01:15:38 +0800
From: "Rogelio M. Serrano Jr." <rogelio@smsglobal.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: eevdf
X-Enigmail-Version: 0.95.3
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig0BCDC68EB3B581089C0B79AF"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0BCDC68EB3B581089C0B79AF
Content-Type: multipart/mixed;
 boundary="------------090309050600030003030607"

This is a multi-part message in MIME format.
--------------090309050600030003030607
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


i wrote a simple simulator for eevdf. im not sure if i got it right thoug=
h.

how does eevdf track the runtime usage of a process?

is it supposed to be like this?

int
tick()
{
    v_time +=3D 1.0/sum_weights;
    current->runtime +=3D 1.0/current->weight;=20
    //sched();
    time++;
    return 0;
}

i can forward the source to anyone who is willing to take a look.

Thanks.

--------------090309050600030003030607
Content-Type: text/x-vcard; charset=utf-8;
 name="rogelio.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="rogelio.vcf"

YmVnaW46dmNhcmQNCmZuOlJvZ2VsaW8gTS4gU2VycmFubyBKcg0KbjpNLiBTZXJyYW5vIEpy
O1JvZ2VsaW8NCm9yZzpTTVNHIENvbW11bmljYXRpb25zIFBoaWxpcHBpbmVzO1RlY2huaWNh
bCBEZXBhcnRtZW50DQphZHI6Ozs7Ozs7UmVwdWJsaWMgb2YgdGhlIFBoaWxpcHBpbmVzDQpl
bWFpbDtpbnRlcm5ldDpyb2dlbGlvQHNtc2dsb2JhbC5uZXQNCnRpdGxlOlByb2dyYW1tZXIN
CnRlbDt3b3JrOis2MzI3NTM0MTQ1DQp0ZWw7aG9tZTorNjMyOTUyNzAyNg0KdGVsO2NlbGw6
KzYzOTIwOTIwMjI2Nw0KeC1tb3ppbGxhLWh0bWw6RkFMU0UNCnZlcnNpb246Mi4xDQplbmQ6
dmNhcmQNCg0K
--------------090309050600030003030607--

--------------enig0BCDC68EB3B581089C0B79AF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHFPG6yihxuQOYt8wRAsgeAJ9p+QpXGV6hv5dbbR1Ol67EkCcVsQCglTxx
Zafn5H7D8D8nibDnjVyOWNU=
=nEgK
-----END PGP SIGNATURE-----

--------------enig0BCDC68EB3B581089C0B79AF--
