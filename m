Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbYJZNR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbYJZNR7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 09:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbYJZNRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 09:17:51 -0400
Received: from ganymede.vroon.org ([195.66.242.11]:57835 "EHLO
	ganymede.vroon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbYJZNRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 09:17:50 -0400
Subject: Re: Linux 2.6.28-rc1
From: Tony Vroon <tony@vroon.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20081024160120.07d37930@infradead.org>
References: <alpine.LFD.2.00.0810232028500.3287@nehalem.linux-foundation.org>
	 <1224888808.3938.11.camel@localhost>
	 <20081024160120.07d37930@infradead.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BD8Gll9K8T4FbP5Mjcvw"
Date: Sun, 26 Oct 2008 13:17:42 +0000
Message-Id: <1225027062.4030.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-BD8Gll9K8T4FbP5Mjcvw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-10-24 at 16:01 -0700, Arjan van de Ven wrote:
> I suspect these are totally innocent; the reason I think this is that
> select/poll only get used once you hit userspace... and you're hanging
> way before that.

Entirely correct. It seems commit
4403b406d4369a275d483ece6ddee0088cc0d592 by Linus just fixed it for me.
My boot hang is gone.

Linux prometheus 2.6.28-rc1-00005-g23cf24c #1 SMP Sun Oct 26 13:12:55
GMT 2008 x86_64 Quad-Core AMD Opteron(tm) Processor 2354 AuthenticAMD
GNU/Linux

Regards,
Tony V.



--=-BD8Gll9K8T4FbP5Mjcvw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkkEbfYACgkQp5vW4rUFj5ryEACfdv8bw/g/cO1h+dO/PPy/GwqY
qGEAoIf5rqw3Z9XaJZsLFGUuYnTamFJD
=8L9k
-----END PGP SIGNATURE-----

--=-BD8Gll9K8T4FbP5Mjcvw--

