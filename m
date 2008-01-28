Return-Path: <linux-kernel-owner+w=401wt.eu-S1759373AbYA1Lx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759373AbYA1Lx1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 06:53:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbYA1LxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 06:53:19 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:34373 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbYA1LxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 06:53:18 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: ltp-list@lists.sourceforge.net, risrajak@in.ibm.com
Subject: Re: [LTP] [TEST] : LTP Build failure on 2.6.24 kernel
Date: Mon, 28 Jan 2008 06:53:15 -0500
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <1201508081.4029.4.camel@localhost.localdomain>
In-Reply-To: <1201508081.4029.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2357303.Axl4BXBuAn";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200801280653.16624.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2357303.Axl4BXBuAn
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 28 January 2008, Rishikesh K. Rajak wrote:
> Here i am getting failure on the x86_64 machine with new kernel.
>
> Here is the uname for that machine:
>
> rishi@:~/ltp-full-20071231# uname -a
> Linux rishi.in.ibm.com 2.6.24 #1 SMP PREEMPT Mon Jan 28 06:47:28 UTC
> 2008 x86_64 GNU/Linux

i'm guessing you're using ubuntu and thus dash is your /bin/sh ... shouldnt=
 be=20
a 2.6.24 issue

> make[4]: Entering directory
> `/root/ltp-full-20071231/testcases/network/tcp_cmds/ftp'
> ../../generate.sh
> ../../generate.sh: 60: arith: syntax error: "cnt=3Dcnt-1"

sadly, this is becoming a FAQ.  ubuntu ships a broken /bin/sh (dash) and th=
us=20
some LTP scripts fall apart.  i would prefer to not change the scripts as t=
he=20
message is simple in LTP: fix your shell, dont add hacks to LTP.  otherwise=
=20
we slowly back ourselves into this corner with the shell scripts where we t=
ry=20
to support every craptastic shell out there and we're afraid to make any=20
changes because we dont know what crappy shell is going to drop a brick.  L=
TP=20
scripts are written to be POSIX complaint and only POSIX complaint shells=20
should be provided by /bin/sh.
=2Dmike

--nextPart2357303.Axl4BXBuAn
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iQIVAwUAR53CLEFjO5/oN/WBAQIB8BAAuPmtWbuoOYunY4Qgr5OdD7yhT8dtxT2X
ycp56Zi7qDfGYp3QcHm1Mvt0OA1YFJ77R1Y4B3wBQUvJoUJRKS1NLLlnTUp8jr9Q
2Rv8Ef9cmgYScrr+7IB7XLMtefmGqwuoyMwCK0fxM7isvI+ewNFuVv4qmOyHVc9O
w4e2rEA3TAwoxCFKtVCPGhF4FFh1FdYCuLftr8AhWPsqKW+fxT8Fz5AZ/8dX41TX
nV1RgZpbJbjVJbIQIIfEqLPVESb5QLND8A0xp6Cvjf72czAndzMsiPDKKZMXqWkR
RU5vsmrYj0LSSGLxF+UHVQl70fH3COeUvf5gBU/NiCPOw2vllQ/m+Wn3PBxcTJJi
Dq0DJCas8IEnfhZEvkzoyN2zWRcq/MkaoMNAUSX8/dS1akd3ZabS2lRImXNmfRrP
XmMaB29kFVdqGI/3mAyGPBflX2SuHjMaXkvHSE2PbhkhGuwWo6R2mVCu/sQD/tIP
0DeWpqEeu4NNUzMCJejHY/rr8fO6ehZoYsNZx/GJsiOTfgp6g6DeVm0IDxk3RQ4H
3WbtYZkQQyiHIhHn7HDejEWXkT7zfxI8f5sTXjDCn2+JffDjee4X3Twjlc9wbAdp
sLEyXmKX5JPRlSsJQgeNcSBCPhL5WeH1y5bdiaZXYh4A+vk/YlV8wry1nZRHZjr7
+TaoPsreyTw=
=TtDb
-----END PGP SIGNATURE-----

--nextPart2357303.Axl4BXBuAn--
