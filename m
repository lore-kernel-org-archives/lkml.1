Return-Path: <linux-kernel-owner+w=401wt.eu-S1945949AbXDCVOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945949AbXDCVOu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 17:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945950AbXDCVOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 17:14:50 -0400
Received: from cel.leonerd.org.uk ([62.49.94.186]:3212 "EHLO cel.leo"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1945949AbXDCVOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 17:14:49 -0400
Date: Tue, 3 Apr 2007 22:14:38 +0100
From: Paul LeoNerd Evans <leonerd@leonerd.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       "Antonino A. Daplas" <adaplas@gmail.com>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vt: Do not clear UTF when resetting console
Message-ID: <20070403221438.77c40a53@nim.leo>
In-Reply-To: <4611A60F.90505@zytor.com>
References: <46110F88.5040905@gmail.com>
	<46113ED6.4060005@zytor.com>
	<1175559377.7267.13.camel@daplas>
	<Pine.LNX.4.61.0704030220140.18387@yvahk01.tjqt.qr>
	<4611A60F.90505@zytor.com>
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_q_I11bhqybqwE=Xs_QqfpMI";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_q_I11bhqybqwE=Xs_QqfpMI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 02 Apr 2007 17:55:43 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> I think you're missing the whole point of console reset.  Its purpose is=
=20
> to force the console into a known-good state.  The fewer pieces of state=
=20
> it leaves unset, the better.  To some degree it's less important what=20
> that state actually is.

Ultimately, does the patch actually change that?

Without this change, utf mode gets reset to zero because that's what the
kernel source code says.

With this change, utf mode gets reset to zero because that's what the
module parameter says and the user hasn't changed it..

.. only with the change, users get the ability to change that policy.

For the last 2 years since I originally submitted that patch, I've been
running it on my box. For those last 2 years, finally, UTF-8 input
actually worked on the VTs. Previous to that, lots of things broke.

--=20
Paul "LeoNerd" Evans

leonerd@leonerd.org.uk
ICQ# 4135350       |  Registered Linux# 179460
http://www.leonerd.org.uk/

--Sig_q_I11bhqybqwE=Xs_QqfpMI
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGEsPG7eTlovtaLtYRArKwAJ9u0lGkLdeaBOUfk7ur1Fj+0AkXXQCdEvgi
1Yq7xzfM3Wkx9pdqsgOfktk=
=bbBu
-----END PGP SIGNATURE-----

--Sig_q_I11bhqybqwE=Xs_QqfpMI--
