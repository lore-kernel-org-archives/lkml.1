Return-Path: <linux-kernel-owner+w=401wt.eu-S1758683AbXEZJjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683AbXEZJjo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 05:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753948AbXEZJjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 05:39:37 -0400
Received: from daemonizer.de ([87.230.16.230]:36368 "EHLO daemonizer.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480AbXEZJjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 05:39:35 -0400
From: Maximilian Engelhardt <maxi@daemonizer.de>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: BUG in 2.6.22-rc2-mm1: NIC module b44.c broken (Broadcom 4400)
Date: Sat, 26 May 2007 11:39:28 +0200
User-Agent: KMail/1.9.7
Cc: Uwe Bugla <uwe.bugla@gmx.de>, linux-wireless@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20070524195616.234280@gmx.net> <200705252140.22635.uwe.bugla@gmx.de> <200705260700.28777.mb@bu3sch.de>
In-Reply-To: <200705260700.28777.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart14756496.I17Vm8ygjv";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705261139.31007.maxi@daemonizer.de>
X-Spam-Score: -4.0 (----)
X-Spam-Report: No, hits=-4.0 required=5.0 tests=ALL_TRUSTED,AWL,BAYES_00 autolearn=ham version=3.1.7-deb 
	* -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	*  0.4 AWL AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart14756496.I17Vm8ygjv
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 26 May 2007, Michael Buesch wrote:
> On Friday 25 May 2007 21:40, Uwe Bugla wrote:
> > Am Freitag, 25. Mai 2007 20:48 schrieben Sie:
> > > On Fri, 25 May 2007 17:59:29 +0200, Uwe Bugla wrote:
> > > > Perhaps someone reading this could try to reproduce that problem on
> > > > his machine.
> > > > Now who of the readers owes a Broadcom 4401 NIC and can please try =
to
> > > > test kernel 2.6.22-rc2-mm1?
> > > >
> > > > Those NICs have been used very very often as onboard controllers,
> > > > especially on ASUS boards.
> > >
> > > I've been using 2.6.22-rc2 for some time and now I compiled 2.6.22-rc=
2-
> > > mm1 and both work fine with the BCM4401 in my laptop.
> > >
> > > Maxi
> >
> > Hello Maxi,
> >
> > That may be true for your Laptop, but it unfortunately isn't true for my
> > ASUS mainboard onboard controller.
> >
> > Unfortunately I cannot confirm this:
> >
> > My broadcom 4401 driver is not part of a notebook, but instead part of =
an
> > ASUS P4PE mainboard.
> >
> > At my second attempt I went the conventional path (i. e. ignoring the
> > fact that
> > "Broadcom 4400 ethernet support appears twice in section "Network device
> > support":
> >
> > Whether you leave out "EISA, VLB, PCI and on board controllers" or not =
it
> > simply appears twice in kernel config! This is bug number 1.
>
> No it is NOT a bug.
> It simply shows again that you don't know how b44, ssb or anything related
> works.
>
> Would you _please_ take a look at the code, before calling features bugs.
> And yes, this IS a feature. It is a feature to get b44 running on an
> OpenWRT embedded device. These devices don't have a PCI bus. So b44 MUST
> NOT depend on "EISA, VLB, PCI and on board controllers".
> "Broadcom 4400 PCI device support" does depend on "EISA, VLB, PCI and on
> board controllers".
>
> Everything is correct.
> Bug number 1 is solved.
> qed
>
> > This time I do get a "good" interrupt: IRQ 21 for the the device.
> >
> > BUT:
> >
> > Trying to ping another machine fails saying:
> >
> > "destination host unreachable"
> >
> >
> > That means, Although the interrupt is fine now, the device is still not
> > functionable.
>
> And it's completely impossible that you did a mistake when configuring
> the device? Typo in the IP? Typo in the gateway or DNS entries?
> Try it again, please.
> And please try with current wireless-dev tree.
>
> And I simply do not get it why you suddenly get a good IRQ number, like
> everybody else does, without fixing The Bug (tm).

I did run my 2.6.22-rc2-mm1 kernel a bit longer and noticed that I was wron=
g=20
in my first mail. The driver does work with my 4401 and network traffic see=
m=20
to get out and in fine, but it has huge performance problems. If I do some=
=20
pings and traceroutes I sometimes get response times of only a few ms but I=
=20
also get times of a few seconds. Also trying to play games is totally=20
impossible. This doesn't happen with 2.6.22-rc2 and 2.6.22-rc3.

Maxi

--nextPart14756496.I17Vm8ygjv
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGWABSOimwv528XGERAkiaAKDptjswUs7gXj5teD0ww9AFyzz7uwCfdg85
5BiaqLMeNdGL93Xn0aQ35KE=
=wI4V
-----END PGP SIGNATURE-----

--nextPart14756496.I17Vm8ygjv--
