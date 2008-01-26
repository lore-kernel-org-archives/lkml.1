Return-Path: <linux-kernel-owner+w=401wt.eu-S1754449AbYAZD1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449AbYAZD1I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 22:27:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751720AbYAZD04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 22:26:56 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:45729 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbYAZD0z (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 22:26:55 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] driver core patches against 2.6.24
In-Reply-To: Your message of "Sat, 26 Jan 2008 01:05:26 +0100."
             <20080126000526.GA24559@elte.hu>
From: Valdis.Kletnieks@vt.edu
References: <20080125071127.GA4860@kroah.com> <alpine.LFD.1.00.0801251035150.2979@hp.linux-foundation.org> <20080125185213.GA23475@suse.de> <alpine.LFD.1.00.0801251108480.2979@hp.linux-foundation.org> <479A3ED3.6020808@goop.org> <1201296027.32422.80.camel@perihelion> <alpine.LFD.1.00.0801251347010.5056@hp.linux-foundation.org> <479A5B72.6080701@goop.org> <1201299979.27573.11.camel@lappy>
            <20080126000526.GA24559@elte.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1201317875_2846P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 25 Jan 2008 22:24:35 -0500
Message-ID: <7976.1201317875@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1201317875_2846P
Content-Type: text/plain; charset=us-ascii

On Sat, 26 Jan 2008 01:05:26 +0100, Ingo Molnar said:

> all it takes for me on Fedora is to boot a modular distro kernel once, 
> then copy the /dev to the real (persistent) /dev:
> 
>    mkdir /tmp2
>    mount /dev/sda1 /tmp2
>    cp -a /dev/* /tmp2/dev/
> 
> and from that point on a bzImage/vmlinuz can boot up on Fedora without 
> any problems (as long as it has the right drivers built in), and the 
> initrd line can be removed from grub.conf.

Tried something like that once - it didn't play nice with the fact that I
have root-on-LVM, so you need an initrd to do the 'lvm vgchange -a' and get
it online.

--==_Exmh_1201317875_2846P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHmqfzcC3lWbTT17ARAmFoAKCaLkCegvjVuyVeUl/lMtK1azkXDwCgpL3v
tbZsNRIpU3O9zQ83gIa1NkI=
=MNIq
-----END PGP SIGNATURE-----

--==_Exmh_1201317875_2846P--
