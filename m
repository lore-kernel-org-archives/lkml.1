Return-Path: <linux-kernel-owner+w=401wt.eu-S934612AbXGSWTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934612AbXGSWTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 18:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762987AbXGSWTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 18:19:22 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:45599 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761985AbXGSWTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 18:19:21 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
Subject: Re: which signal is sent to freeze process?
Date: Fri, 20 Jul 2007 08:19:11 +1000
User-Agent: KMail/1.9.6
Cc: nigel@suspend2.net, "Rafael Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org
References: <A3258B497F1C1441AD36A2E8B45FD6285507A5@scsmsx412.amr.corp.intel.com> <200707191459.20998.nigel@nigel.suspend2.net> <A3258B497F1C1441AD36A2E8B45FD628550DD6@scsmsx412.amr.corp.intel.com>
In-Reply-To: <A3258B497F1C1441AD36A2E8B45FD628550DD6@scsmsx412.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1210874.k3XOY2kr9m";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707200819.16100.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1210874.k3XOY2kr9m
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Friday 20 July 2007 07:06:01 Agarwal, Lomesh wrote:
> So basically I can not install a signal handler to catch freeze signal
> in the process. Right?
> Is there any other way to solve the problem I am facing? After resume
> some of the system calls are failing in some of my applications with
> errno set as EINTR. I wanted to explore a way to not check for this
> error all over the place and somehow retry failed system call. Any
> ideas?

Well, if you tell us which syscalls are returning with EINTR, maybe we can =
do=20
something on our side. The freezer is supposed to be as transparent as=20
possible to userspace, so it may be the case that we can do something to=20
continue waiting or whatever you were doing after the freezing is done.

Regards,

Nigel
=2D-=20
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.

--nextPart1210874.k3XOY2kr9m
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGn+NkN0y+n1M3mo0RAkDvAKDcmuv9azuINAcps4aE14EYlH+eIACfb1XR
lXmzV2wURN13JyucSPR5xeE=
=2H5h
-----END PGP SIGNATURE-----

--nextPart1210874.k3XOY2kr9m--
