Return-Path: <linux-kernel-owner+w=401wt.eu-S1760389AbXHaPK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760389AbXHaPK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 11:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755120AbXHaPKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 11:10:19 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:33372 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890AbXHaPKR (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 11:10:17 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Ian Kent <raven@themaw.net>
Cc: John Stoffel <john@stoffel.org>, Peter Staubach <staubach@redhat.com>,
       Robin Lee Powell <rlpowell@digitalkingdom.org>,
       linux-kernel@vger.kernel.org
Subject: Re: NFS hang + umount -f: better behaviour requested.
In-Reply-To: Your message of "Fri, 31 Aug 2007 16:06:36 +0800."
             <Pine.LNX.4.64.0708311600120.12745@raven.themaw.net>
From: Valdis.Kletnieks@vt.edu
References: <20070820225415.GL3956@digitalkingdom.org> <18123.5699.405125.137517@stoffel.org> <46CB1A78.7040102@redhat.com> <18123.13314.43009.263383@stoffel.org>
            <Pine.LNX.4.64.0708311600120.12745@raven.themaw.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1188573002_3280P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 31 Aug 2007 11:10:02 -0400
Message-ID: <27240.1188573002@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1188573002_3280P
Content-Type: text/plain; charset=us-ascii

On Fri, 31 Aug 2007 16:06:36 +0800, Ian Kent said:
> So, there's a power outage and the UPS had a glitch.

Murphy can get a *lot* more creative than that.

So we'd outgrown the capacity on our UPS and diesel generator, and decided
to replace them.  So we schedule downtime for a Saturday.  Rather scary, we
had a Sun E10K that had been powered-up for several years, and just as expected,
a good fraction of the 400+ drives it had failed to re-spinup.  While recovering
from that, we discovered that although the vast majority of the 400 drives were
either mirrors or raidsets, due to a config error, the boot volume wasn't
mirrored (fortunately, it spun up OK so we dodged the bullet), so we fixed that.

Literally the next Friday, not even a week later, a contractor relocating a
door into our machine room shorted out a sensor circuit in our fire suppression
system, triggering a Halon dump.  Of course, no amount of UPS and diesel was
going to save us now, because there was a safety interlock that killed the
power feeds if the Halon dumped.  This time, since they'd all been stressed
just a week before, only 2 of the 400+ disks on the E10K failed to spin up.

Guess which two. ;)





--==_Exmh_1188573002_3280P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG2C9KcC3lWbTT17ARArKMAJ9tnX1PcWeSNF/UHBz6P8F0kGe+NQCfR4bp
7xy9N808fjHIbEu0ATlzuEE=
=e0se
-----END PGP SIGNATURE-----

--==_Exmh_1188573002_3280P--
