Return-Path: <linux-kernel-owner+w=401wt.eu-S1758134AbXKGJhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134AbXKGJhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 04:37:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755492AbXKGJhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 04:37:39 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:37987 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323AbXKGJhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 04:37:38 -0500
Subject: Re: 2.6.24-rc1-git15 Kernel build fails on powerpc - Unrecognized
	opcode: `dssall'
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, linuxppc-dev@ozlabs.org,
       sam@ravnborg.org, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071106154439.GK5080@shadowen.org>
References: <47304343.2010709@linux.vnet.ibm.com>
	 <661de9470711060246s3040f68drf0a6310aeec4e1e8@mail.gmail.com>
	 <1194346486.4066.13.camel@johannes.berg>
	 <20071106.031001.189578769.davem@davemloft.net>
	 <47304FE5.2010309@linux.vnet.ibm.com> <47306E9C.4090202@linux.vnet.ibm.com>
	 <20071106154439.GK5080@shadowen.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yyWM7j9Zq7eK+k39kw1Q"
Date: Wed, 07 Nov 2007 10:38:43 +0100
Message-Id: <1194428323.4055.3.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-yyWM7j9Zq7eK+k39kw1Q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable



> So that sounds like a Kconfig problem then?  That HIBERATION requires
> ALITIVEC and yet does not depend on it or set it.

Yes. I'm guessing that it broke with Rafael's hibernation/suspend
Kconfig changes but will take a look. I think it used to depend on
powermac.

johannes

--=-yyWM7j9Zq7eK+k39kw1Q
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzGHoqVg1VMiehFYAQJYNA/+Mx3H4kj3FC7hYVt24kvlgrUPQR7JnR7B
9gBirtakOE3Zjq/GhQiX3z5JxYDMIjIeWkAZdPmZ2uIE+sqb6nzA+7gJcdq8/0vs
QcJfwa0QZiQU3OCflFK/gTiNHNNLCVBDIOZgpIlwG7tWtNo1MJ/FFJltndkOnqpf
gxnB5TDKRio4c6K7L9L6IQSZiLsPmHnbP/ez7r7i6JKq8EoKkm/ZXehaeVjU0DwE
rM4ySRmsQhsMBMqLtymLy06AS8vSMfiZvFLZh54KTGo6kDbMqWf6lI/W6LtL59nD
EBjTlNkML8xLGswEQTo/IWgUFdGO0vhfriqICM2zfbOi8NmQIwBLqOO6CfZOgXFV
e6vO+vdrHOlyjTpwoXdfPoC68PNmdASappPIl5718kTRzJ78jcPkQhJJ0PxA382T
SvFzDXjs6xPgOvWYDuVsqROkrzTAAzv6XlHul7KDi4yK4EvBMqbDZHeB7RAWeP+l
ibLuyb7KjHTfSD5NOWgKJay2/mykqKYWW9SQhakN4Rw7v3NLpnKq9DNza3PJ7M5Y
VN1S2FmIVpNiWjqdqD7SReKfigkOC+8JZp3SZvJYq2cC9TzA6mzBn7MQyQukJzr2
aE5M+LEyaetvLFwjdrfkKN4ePH1m6NsdLB+LgyRDM8uXLt3IPwtSwcoS5Q3jy05x
D/bTbZCUliM=
=EVAc
-----END PGP SIGNATURE-----

--=-yyWM7j9Zq7eK+k39kw1Q--

