Return-Path: <linux-kernel-owner+w=401wt.eu-S1754331AbZD2Rhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331AbZD2Rhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 13:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbZD2Rhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 13:37:41 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:39911 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbZD2Rhl (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 13:37:41 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Martin Knoblauch <knobi@knobisoft.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org,
       tigran aivazian <tigran@aivazian.fsnet.co.uk>
Subject: Re: Analyzed/Solved: Booting 2.6.30-rc2-git7 very slow
In-Reply-To: Your message of "Wed, 29 Apr 2009 10:24:20 PDT."
             <884894.99151.qm@web32602.mail.mud.yahoo.com>
From: Valdis.Kletnieks@vt.edu
References: <409142.83316.qm@web32605.mail.mud.yahoo.com> <20090428182837.62c51f26.akpm@linux-foundation.org> <1240977096.5478.3.camel@marge.simson.net> <20090429011755.c141c599.akpm@linux-foundation.org> <20090429120827.GI8633@ZenIV.linux.org.uk>
            <884894.99151.qm@web32602.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1241026559_4397P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 29 Apr 2009 13:35:59 -0400
Message-ID: <30441.1241026559@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1241026559_4397P
Content-Type: text/plain; charset=us-ascii

On Wed, 29 Apr 2009 10:24:20 PDT, Martin Knoblauch said:

>  One definitely comes from /etc/fstab, but I am not aware of any other script
 mounting sysfs in my userspace.

You said it was a RedHat box?

Look in /etc/rc.sysinit:

        mount -n -t sysfs /sys /sys >/dev/null 2>&1

(Near line 28 for RHEL 4, line 23 for RHEL5, and line 21 for Fedora Rawhide)

Probably your culprit.


--==_Exmh_1241026559_4397P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJ+I//cC3lWbTT17ARAvfPAKC/ilZ7dTEQIqzJ8nhyL8ZA78fVMwCeOqbj
gT1v0BzA+l6ZhTCjP/BV79U=
=O0Qc
-----END PGP SIGNATURE-----

--==_Exmh_1241026559_4397P--
