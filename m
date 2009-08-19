Return-Path: <linux-kernel-owner+w=401wt.eu-S1751866AbZHSH7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbZHSH7K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 03:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbZHSH7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 03:59:10 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41657 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152AbZHSH7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 03:59:09 -0400
Date: Wed, 19 Aug 2009 17:59:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Robin Getz <rgetz@blackfin.uclinux.org>,
       Jason Wessel <jason.wessel@windriver.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the usb tree with the tip tree
Message-Id: <20090819175901.59f1af9e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__19_Aug_2009_17_59_01_+1000_p0eHXTaC4=rIIZA1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__19_Aug_2009_17_59_01_+1000_p0eHXTaC4=rIIZA1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
kernel/printk.c between commit 4d09161196c9a836eacea4b36e2f217bc34894cf
("printk: Enable the use of more than one CON_BOOT (early console)") from
the tip tree and commit e289e7dc72eb6bfce70e2722d97a00f5e02893e8 ("USB:
printk: early_printk,console: Allow more than one early console") from
the usb tree.

I assume that these are trying to do (more or less) the same thing.  I
have dropped the one from the usb tree for today.  Please sort this out -
at least remove the usb tree one until you have done so, thanks.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__19_Aug_2009_17_59_01_+1000_p0eHXTaC4=rIIZA1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqLsMUACgkQjjKRsyhoI8w7rgCfd9omF9FKSiHZUyOJIauG6Pa0
7JsAnR/1MXQg+At5weevabyV184DVeqe
=5GOa
-----END PGP SIGNATURE-----

--Signature=_Wed__19_Aug_2009_17_59_01_+1000_p0eHXTaC4=rIIZA1--
