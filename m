Return-Path: <linux-kernel-owner+w=401wt.eu-S1759629AbXIRPHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759629AbXIRPHg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 11:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758997AbXIRPH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 11:07:29 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:54790 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757968AbXIRPH2 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 11:07:28 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6-mm1
In-Reply-To: Your message of "Tue, 18 Sep 2007 01:18:41 PDT."
             <20070918011841.2381bd93.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1190128042_2991P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 18 Sep 2007 11:07:23 -0400
Message-ID: <20159.1190128043@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1190128042_2991P
Content-Type: text/plain; charset=us-ascii

On Tue, 18 Sep 2007 01:18:41 PDT, Andrew Morton said:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc6/2.6.23-rc6-mm1/

> +gregkh-driver-driver-core-add-config_uevent_helper_path.patch

So I do a 'make silentoldconfig', and I get:

*
* Generic Driver Options
*
path to uevent helper (UEVENT_HELPER_PATH) [/sbin/hotplug] (NEW)

(Hey wow - the patch has a 'help' section, but no '?' listed because it's not a
bool or tristate. You can apparently get help during 'make menuconfig' but not
'make *oldconfig'. That rocks. ;)

Yeeh. Hah. I don't *have* a /sbin/hotplug on this udev-based Fedora box.  But
wait, reading the patch says that's usually during early boot. Now to figure
out what /sbin/nash does with its onboard 'hotplug' command... ;)

(In other words, this *really* needs some better help documentation, to explain
who needs this, and who doesn't need it, and what happens if you select it
and you shouldn't have, and what happens if you leave it out when you should
have set it....)

--==_Exmh_1190128042_2991P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG7+mqcC3lWbTT17ARAoyLAKCwGEY7BSgCeYH3mvIvaShAGoiQDgCeOwRK
/mFWSd6R21DiG8qw1/s5sQY=
=Fut9
-----END PGP SIGNATURE-----

--==_Exmh_1190128042_2991P--
