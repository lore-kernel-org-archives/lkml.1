Return-Path: <linux-kernel-owner+w=401wt.eu-S1754055AbYIDPcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbYIDPcZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 11:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbYIDPcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 11:32:18 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:45433 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbYIDPcS (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 11:32:18 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc5-mmotm0829 - CONFIG_HID_COMPAT causes hangs at boot
In-Reply-To: Your message of "Thu, 04 Sep 2008 16:55:23 +0200."
             <48BFF6DB.1060807@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <7419.1220261347@turing-police.cc.vt.edu> <48BD4D20.5020704@gmail.com> <13476.1220371878@turing-police.cc.vt.edu> <48BDA9F2.7000203@gmail.com> <4909.1220499086@turing-police.cc.vt.edu>
            <48BFF6DB.1060807@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1220542322_3385P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 04 Sep 2008 11:32:02 -0400
Message-ID: <17477.1220542322@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1220542322_3385P
Content-Type: text/plain; charset=us-ascii

On Thu, 04 Sep 2008 16:55:23 +0200, Jiri Slaby said:

> Hmm, *if* we stuck in request_module in hid, workqueue cannot be flushed and
> tty waits... Could you stick 2 printks into hid_compat_load if it finishes?

I severely doubt that it's going to finish, as it stayed stuck at that same
point for at least 10-15 minutes or so - it took a while for alt-sysrq-t to get
down to the tracemod because I booted with 'boot_delay=100', and then the
time to find paper and pen, write it down, etc..


--==_Exmh_1220542322_3385P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIv/9ycC3lWbTT17ARAraiAJ0UfOqR6+PkwIuKxdEmY8lrEe+Y3QCgqFMk
u/S6joYHBc+tHhm6met5x5Q=
=7Qeo
-----END PGP SIGNATURE-----

--==_Exmh_1220542322_3385P--
