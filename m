Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbYIQRqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbYIQRqB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 13:46:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755524AbYIQRpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 13:45:49 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:36257 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755499AbYIQRps (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 13:45:48 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Singaravelan Nallasellan <singaravelann@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: New IOCTLs
In-Reply-To: Your message of "Wed, 17 Sep 2008 22:25:35 +0530."
             <3baf3d760809170955l5dec0495n93fc373a52a120ae@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <3baf3d760809170955l5dec0495n93fc373a52a120ae@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1221673545_5364P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 17 Sep 2008 13:45:45 -0400
Message-ID: <17437.1221673545@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1221673545_5364P
Content-Type: text/plain; charset=us-ascii

On Wed, 17 Sep 2008 22:25:35 +0530, Singaravelan Nallasellan said:
> I need to send device control messages to the driver. I am planning to
> use the IOCTLs. But I came to know that Linux community does not
> accept any new IOCTLs anymore.

New IOCTL's are *not* in the "not accepting any new" state.  However, there
*will* be questioning whether a new IOCTL is the proper API, or if there
should be some other interface instead (sysfs, debugfs, netlink, and so on).

The basic problem with IOCTLs is that they tend to quickly become ugly design,
with little attention paid to things like proper 32/64 bit interfaces (what
happens when a 32-bit program tries to pass a parameter to a 32-bit
kernel, and to a 64-bit kernel?).

Maybe an ioctl is the right way to send your device control messages. Maybe
some other API is better.  What sort of messages need to be sent, and what
sort of throughput/latency requirements are there, and so on?  If you tell us
more about what you're trying to get to/from userspace and the device, we
can better suggest what to do...

--==_Exmh_1221673545_5364P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFI0UJJcC3lWbTT17ARAvFaAJ9VZTU+meASi0t+B45EJjsXAWy3KwCfWgtu
OPTiJr+InBd6vwOisQMJPOI=
=JWne
-----END PGP SIGNATURE-----

--==_Exmh_1221673545_5364P--
