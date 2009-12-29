Return-Path: <linux-kernel-owner+w=401wt.eu-S1752193AbZL2Vsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbZL2Vsr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 16:48:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbZL2Vso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 16:48:44 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:59696 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbZL2Vsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 16:48:43 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Bryan Donlan <bdonlan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Michael Stone <michael@laptop.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, David Lang <david@lang.hm>,
       Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>, Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>, Pavel Machek <pavel@ucw.cz>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: RFC: disablenetwork facility. (v4)
In-Reply-To: Your message of "Tue, 29 Dec 2009 15:27:22 CST."
             <20091229212722.GA20178@us.ibm.com>
From: Valdis.Kletnieks@vt.edu
References: <20091229050114.GC14362@heat> <m1y6km11lj.fsf@fess.ebiederm.org> <20091229151146.GA32153@us.ibm.com> <3e8340490912290805s103fb789y13acea4a84669b20@mail.gmail.com> <20091229163939.GA6984@us.ibm.com> <3e8340490912290901y60d7daf2w5778c25f44972955@mail.gmail.com> <m1fx6ty6ds.fsf@fess.ebiederm.org> <3e8340490912291108t7e000e75p8264fa585f831464@mail.gmail.com>
            <20091229212722.GA20178@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1262123182_4680P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 29 Dec 2009 16:46:22 -0500
Message-ID: <17290.1262123182@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020203.4B3A78B0.0044,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1262123182_4680P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, 29 Dec 2009 15:27:22 CST, =22Serge E. Hallyn=22 said:
> I think i disagree.  A uid is just a uid (or should be).  One day we ma=
y
> have a way for a factotum-style daemon to grant the ability to an unpri=
v
> task to setuid without CAP_SETUID.  I think slingling uids and gids
> around that you already have access to should be fine.

Yes, but not doing the clear and obvious simple thing now for a =22one da=
y
we may have=22 consideration seems a poor engineering tradeoff.

Yes, slinging uids and gids around *would* be nice.  But first we need a =
clear
plan for making /usr/bin/newgrp a shell builtin - once that happens, *the=
n*
we can re-address this code. ;)

--==_Exmh_1262123182_4680P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLOniucC3lWbTT17ARAs0iAKDROPsJGHgiRPPfWpj6729MmCkN9ACdH//t
XuiooxKyTetj7/KjkjrPQsI=
=vzQ/
-----END PGP SIGNATURE-----

--==_Exmh_1262123182_4680P--

