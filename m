Return-Path: <linux-kernel-owner+w=401wt.eu-S2992842AbXDRWW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992842AbXDRWW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 18:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992844AbXDRWW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 18:22:26 -0400
Received: from lugor.de ([212.112.242.222]:35055 "EHLO solar.vpn.lugor.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992842AbXDRWWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 18:22:25 -0400
From: Christian Hesse <mail@earthworm.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: CFS and suspend2: hang in atomic copy
Date: Thu, 19 Apr 2007 00:22:12 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, suspend2-devel@lists.suspend2.net
References: <20070413202100.GA9957@elte.hu> <200704182357.28107.mail@earthworm.de> <20070418220228.GA14536@elte.hu>
In-Reply-To: <20070418220228.GA14536@elte.hu>
X-Face: 1\p'dhO'VZk,x0lx6U}!Y*9UjU4n2@4c<"a*K%3Eiu'VwM|-OYs;S-PH>4EdJMfGyycC)=?utf-8?q?k=0A=09=3Anv*xqk4C?=@1b8tdr||mALWpN[2|~h#Iv;)M"O$$#P9Kg+S8+O#%EJx0TBH7b&Q<m)=?utf-8?q?n=23Q=2Eo=0A=09kE=7E=26T=5D0cQX6=5D?=<q!HEE,F}O'Jd#lx/+){Gr@W~J`h7sTS(M+oe5<=?utf-8?q?3O7GY9y=5Fi!qG=26Vv=5CD8/=0A=09=254?=@&~$Z@UwV'NQ$Ph&3fZc(qbDO?{LN'nk>+kRh4`C3[KN`-1uT-TD_m
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1394330.ccY5FYGCHD";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704190022.12315.mail@earthworm.de>
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-2.0 (solar.vpn.lugor.de [10.5.1.1]); Thu, 19 Apr 2007 00:22:14 +0200 (CEST)
X-Spam-Flag: NO
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1394330.ccY5FYGCHD
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 19 April 2007, Ingo Molnar wrote:
> * Christian Hesse <mail@earthworm.de> wrote:
> > > although probably your suspend2 problem is still not fixed, it's
> > > worth a try nevertheless. Which suspend2 patch did you apply, and
> > > was it against -rc6 or -rc7?
> >
> > You are right again. ;-)
> >
> > Linux 2.6.21-rc7
> > Suspend2 2.2.9.11 (applies cleanly to -rc7)
> > CFS v3 (without any additional patches)
> >
> > And it still hangs on suspend.
>
> what's the easiest way for me to try suspend2? Apply the patch, reboot
> into the kernel, then execute what command to suspend? (there's a
> confusing mismash of initiators of all the suspend variants. Can i drive
> this by echoing to /sys/power/state?)

Perhaps you have to install suspend2-userui as well for the output (I'm not=
=20
shure whether it works without). Then you can trigger the suspend by echoin=
g=20
to /sys/power/suspend2/do_suspend.
Useful informations can be found in the Howto:

http://www.suspend2.net/HOWTO

I dropped some ccs to not abuse Linus and friends.
=2D-=20
Regards,
Chris

--nextPart1394330.ccY5FYGCHD
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGJpoUlZfG2c8gdSURAvETAJ9te6UvtVrA2prNyXe/T8+twPMDXgCfZ8P+
OlE6xQzlcjSxzwHhy316AR4=
=VJCS
-----END PGP SIGNATURE-----

--nextPart1394330.ccY5FYGCHD--
