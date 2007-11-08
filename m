Return-Path: <linux-kernel-owner+w=401wt.eu-S1762547AbXKHUJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762547AbXKHUJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 15:09:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758198AbXKHUJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 15:09:43 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:37181 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177AbXKHUJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 15:09:42 -0500
Subject: Re: 2.6.23 git current compile error on UP
From: Laurent Vivier <Laurent.Vivier@bull.net>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Avi Kivity <avi@qumranet.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       aliguori <aliguori@linux.vnet.ibm.com>
In-Reply-To: <1194551749.7078.78.camel@localhost>
References: <1194551749.7078.78.camel@localhost>
Organization: Bull S.A.S.
Date: Thu, 08 Nov 2007 21:09:16 +0100
Message-Id: <1194552556.32517.3.camel@frecb07144>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 08/11/2007 21:16:37,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 08/11/2007 21:16:39,
	Serialize complete at 08/11/2007 21:16:39
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SGMPHemMv2UaxLtiXWlK"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-SGMPHemMv2UaxLtiXWlK
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Le jeudi 08 novembre 2007 =C3=A0 11:55 -0800, Dave Hansen a =C3=A9crit :
> drivers/kvm/kvm_main.c: In function `kvm_flush_remote_tlbs':
> drivers/kvm/kvm_main.c:220: error: implicit declaration of function `smp_=
call_function_mask'
> make[2]: *** [drivers/kvm/kvm_main.o] Error 1
> make[1]: *** [drivers/kvm] Error 2
>=20
> http://sr71.net/~dave/linux/config-kvm-up
>=20
> Looks like that function calls smp_call_function_mask() which is never
> defined for UP.  Nobody else uses it that way, so I'm not sure what the
> right fix is.  I'm not even sure kvm_flush_remote_tlbs() is safe with
> its raw_smp_processor_id() use.  Is there a reason it can't get
> preempted?

Avi has already posted a patch to correct this.

http://lkml.org/lkml/2007/10/24/95

Laurent

--=-SGMPHemMv2UaxLtiXWlK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHM2zs9Kffa9pFVzwRAhp2AKCu6T+aDZDNz68fqHRdLavv2IPKFQCffNwy
9JG6+YungRvnZLlo8g1hR7I=
=6LRK
-----END PGP SIGNATURE-----

--=-SGMPHemMv2UaxLtiXWlK--

