Return-Path: <linux-kernel-owner+w=401wt.eu-S1758028AbZF3OhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbZF3OhS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 10:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753648AbZF3OhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 10:37:04 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:55370 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbZF3OhD (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 10:37:03 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Lennart Poettering <lennart@poettering.net>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       William Jon McCann <jmccann@redhat.com>
Subject: Re: [PATCH] vt: extend VT_WAITACTIVE ioctl to allow waiting until a specific VT becomes inactive
In-Reply-To: Your message of "Tue, 30 Jun 2009 02:00:04 +0200."
             <20090630000003.GA21004@omega>
From: Valdis.Kletnieks@vt.edu
References: <20090630000003.GA21004@omega>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1246366725_20486P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 30 Jun 2009 08:58:45 -0400
Message-ID: <21694.1246366725@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1246366725_20486P
Content-Type: text/plain; charset=us-ascii

On Tue, 30 Jun 2009 02:00:04 +0200, Lennart Poettering said:

> ConsoleKit would probably just call it in a loop like this:
> 
>   for (;;) {
>   	struct vt_stat st;
> 	ioctl(0, VT_GETSTATE, &st);
> 	printf("console %s is active.\n", st.v_active);
> 	ioctl(0, VT_WAITACTIVE, (signed long) - st.v_active);
>   }

We will include a documented way for ConsoleKit and similar to be able
to determine if the kernel has this feature, right? (If older kernels
return a -EBOGUS for ioctl(0,VT_WAITACTIVE,-1) that's probably good enough)

--==_Exmh_1246366725_20486P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKSgwFcC3lWbTT17ARAtv4AKDidtD/MhFEDQq9fjYJWCD+PA1qvACdE6vC
K2VR7Jia+GP9MEuvvjWqJSQ=
=DJ5J
-----END PGP SIGNATURE-----

--==_Exmh_1246366725_20486P--
