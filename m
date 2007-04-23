Return-Path: <linux-kernel-owner+w=401wt.eu-S1753900AbXDWJbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbXDWJbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 05:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885AbXDWJbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 05:31:34 -0400
Received: from lugor.de ([212.112.242.222]:43331 "EHLO solar.vpn.lugor.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753900AbXDWJbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 05:31:33 -0400
From: Christian Hesse <mail@earthworm.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: crash with CFS v4 and qemu/kvm (was: [patch] CFS scheduler, v4)
Date: Mon, 23 Apr 2007 11:28:18 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       kvm-devel@lists.sourceforge.net, Avi Kivity <avi@qumranet.com>
References: <20070420140457.GA14017@elte.hu>
In-Reply-To: <20070420140457.GA14017@elte.hu>
X-Face: 1\p'dhO'VZk,x0lx6U}!Y*9UjU4n2@4c<"a*K%3Eiu'VwM|-OYs;S-PH>4EdJMfGyycC)=?iso-8859-1?q?k=0A=09=3Anv*xqk4C?=@1b8tdr||mALWpN[2|~h#Iv;)M"O$$#P9Kg+S8+O#%EJx0TBH7b&Q<m)=?iso-8859-1?q?n=23Q=2Eo=0A=09kE=7E=26T=5D0cQX6=5D?=<q!HEE,F}O'Jd#lx/+){Gr@W~J`h7sTS(M+oe5<=?iso-8859-1?q?3O7GY9y=5Fi!qG=26Vv=5CD8/=0A=09=254?=@&~$Z@UwV'NQ$Ph&3fZc(qbDO?{LN'nk>+kRh4`C3[KN`-1uT-TD_m
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart34633351.hpBHvvyKgc";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704231128.23594.mail@earthworm.de>
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-2.0 (solar.vpn.lugor.de [10.5.1.1]); Mon, 23 Apr 2007 11:28:24 +0200 (CEST)
X-Spam-Flag: NO
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart34633351.hpBHvvyKgc
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 20 April 2007, Ingo Molnar wrote:
> i'm pleased to announce release -v4 of the CFS patchset.

Hi Ingo, hi Avi, hi all,

I'm trying to use kvm-20 with cfs v4 and get a crash:

eworm@revo:~$ /usr/local/kvm/bin/qemu -snapshot /mnt/data/virtual/qemu/winx=
p.img
kvm_run: failed entry, reason 7
kvm_run returned -8

It works (though it is a bit slow) if I start qemu with strace, so for me i=
t=20
looks like a race condition?

I did not test any earlier versions of cfs and kvm in combination - I can't=
=20
say if it happens there as well.
=2D-=20
Regards,
Chris

--nextPart34633351.hpBHvvyKgc
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGLHw3lZfG2c8gdSURAix4AKDS/Y08t2fUn2PBJy/ADsdE83PmFwCdEDhp
JtIxPk/3jJA6+YoqOokcjKI=
=WNzd
-----END PGP SIGNATURE-----

--nextPart34633351.hpBHvvyKgc--
