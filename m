Return-Path: <linux-kernel-owner+w=401wt.eu-S1753824AbYJ1XgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbYJ1XgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 19:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752134AbYJ1Xf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 19:35:56 -0400
Received: from mail.gmx.net ([213.165.64.20]:54909 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751548AbYJ1Xfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 19:35:55 -0400
X-Authenticated: #29043012
X-Provags-ID: V01U2FsdGVkX185s2ImTPI5a2mwUtYQlQrrJsgFMySiEynqJmVSrN
	rMACj4JiLYITYg
Date: Wed, 29 Oct 2008 00:35:47 +0100
From: Mirco Tischler <mircotischler@gmx.net>
To: Mirco Tischler <mt-ml@gmx.de>
Cc: Johannes Berg <johannes@sipsolutions.net>, Zhu Yi <yi.zhu@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "John W.Linville" <linville@tuxdriver.com>,
       "Chatre, Reinette" <reinette.chatre@intel.com>
Subject: Re: [2.6.28-rc2]: iwl4965 doesn't connect / cfg80211 failure
Message-ID: <20081029003547.773745ba@mtlp.12.dimension>
In-Reply-To: <20081028235841.78942d67@mtlp.12.dimension>
References: <20081028020212.0dfcb6c9@mtlp.12.dimension>
	<1225157618.2917.215.camel@debian.sh.intel.com>
	<20081027213217.53558319@infradead.org>
	<1225171414.2917.229.camel@debian.sh.intel.com>
	<20081028172418.3c8e91f1@mtlp.12.dimension>
	<1225218994.3598.41.camel@johannes.berg>
	<20081028235841.78942d67@mtlp.12.dimension>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/RLA2icrSvbyrMd=RJhoH=UC";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/RLA2icrSvbyrMd=RJhoH=UC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

In between I found out that suspend and hibernation are broken too. I would
open a new thread but in the "Suspend to RAM regression in 2.6.28-rc2
(bisected)" thread that handled a similar problem iwlwifi was blamed, at le=
ast
in the mails I read. So maybe this is related here too.

The machine suspends and hibernates fine, but doesn't wake up anymore corre=
ctly.
On hibernation I end up with a black screen and only the mouse which I can
still move. But anything else is locked up. I can't switch to virtual conso=
le
with ctrl+alt+f? nor can I restart the xserver. I can't even connect on
network. The only thing I can do is move the mouse on a black screen or push
the power button.

On suspend it is a little better. After wakeup I see the frames of the wind=
ows
but not the content, and the gnome panel. And again I can move the mouse bu=
t I
can't interact with anything. At least I can connect over network using ssh.
But processes like compiz don't respond to kill -9 PID and when I try to ki=
ll
Xorg the machine completely locks up.

Another thing that I just noticed is very slow boot. From startup of udev u=
ntil
short before X starts the boot lasts minutes. What I noticed is that there =
are
long phases of no hard disk activity. And I don't really  have the heart to
write this but I have the impression that keyboard activity (i.e. pressing
random keys) causes the harddisk to read again and the hole boot to go on.

Sorry for this long subjective description of symptoms only without any
kernel messages or anything but that's all I can deliver at the moment. May=
be
tomorrow I find more than only half an hour to dig into this.

Thanks again

Mirco

--Sig_/RLA2icrSvbyrMd=RJhoH=UC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkkHodcACgkQz+diZ7c2xfhhYgCfTFHzHbvSfFDBa5Ft3Z0rDKix
kMAAn2A6QNjIFWRZlOgcp28Zj4ZCvKoB
=7sfz
-----END PGP SIGNATURE-----

--Sig_/RLA2icrSvbyrMd=RJhoH=UC--
