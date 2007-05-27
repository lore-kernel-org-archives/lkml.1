Return-Path: <linux-kernel-owner+w=401wt.eu-S1760695AbXE0VvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760695AbXE0VvP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 17:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758823AbXE0Vu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 17:50:56 -0400
Received: from daemonizer.de ([87.230.16.230]:52434 "EHLO daemonizer.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758624AbXE0Vuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 17:50:54 -0400
From: Maximilian Engelhardt <maxi@daemonizer.de>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: b44: regression in 2.6.22 (resend)
Date: Sun, 27 May 2007 23:50:42 +0200
User-Agent: KMail/1.9.7
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-wireless" <linux-wireless@vger.kernel.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Jeff Garzik <jgarzik@pobox.com>, Gary Zambrano <zambrano@broadcom.com>,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <20070525172431.60affaca@freepuppy> <200705272313.33129.mb@bu3sch.de> <200705272316.07338.mb@bu3sch.de>
In-Reply-To: <200705272316.07338.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1803652.zZzKimUVej";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705272350.45843.maxi@daemonizer.de>
X-Spam-Score: -4.1 (----)
X-Spam-Report: No, hits=-4.1 required=5.0 tests=ALL_TRUSTED,AWL,BAYES_00 autolearn=ham version=3.1.7-deb 
	* -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	*  0.3 AWL AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1803652.zZzKimUVej
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 27 May 2007, Michael Buesch wrote:
> On Sunday 27 May 2007 23:13:32 Michael Buesch wrote:
> > On Sunday 27 May 2007 21:25:17 Maximilian Engelhardt wrote:
> > > 2.6.21.1:
> > > [  5] local 192.168.1.2 port 58414 connected with 192.168.1.1 port 50=
01
> > > [  5]  0.0-60.6 sec  1.13 MBytes    157 Kbits/sec
> > > [  4] local 192.168.1.2 port 5001 connected with 192.168.1.1 port 578=
37
> > > [  4]  0.0-63.1 sec  2.82 MBytes    375 Kbits/sec
> > >
> > > 2.6.22-rc3:
> > > [  5] local 192.168.1.2 port 46557 connected with 192.168.1.1 port 50=
01
> > > [  5]  0.0-60.4 sec  58.9 MBytes  8.18 Mbits/sec
> > > [  4] local 192.168.1.2 port 5001 connected with 192.168.1.1 port 516=
33
> > > [  4]  0.0-63.1 sec  7.27 MBytes    967 Kbits/sec
> >
> > This is the diff between these two kernels.
> > I'm not sure why you see a much better TX throughput here.
> >
> > Can you re-check to make sure it's not just some test-jitter?
>
> Oh, eh, and what I forgot to ask:
> Do you know an old kernel that works perfectly well for you,
> so I can look at a diff between this one and anything >=3D2.6.21.1.

I don't know any, most older kernels did work fine for me, but I never user=
=20
iperf there so I guess if the bug is there also I simply didn't trigger it.
If you think it's usefull I could go back and try different kernels, but th=
at=20
would take some time.
Except the iperf bug 2.6.21.1 and 2.6.22-rc3 work fine.

Maxi

--nextPart1803652.zZzKimUVej
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGWf01Oimwv528XGERAngXAJ9DNgcgpf07I00M7q4QlJnNcczVxACgyAdG
gWUkTYXKcBvO2SfHY5PP5u0=
=GPEv
-----END PGP SIGNATURE-----

--nextPart1803652.zZzKimUVej--
