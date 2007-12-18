Return-Path: <linux-kernel-owner+w=401wt.eu-S1758260AbXLRPzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260AbXLRPzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 10:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756020AbXLRPza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 10:55:30 -0500
Received: from hc652a898.dhcp.vt.edu ([198.82.168.152]:34276 "EHLO
	hc652a898.dhcp.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755779AbXLRPza (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 10:55:30 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Pavel Machek <pavel@ucw.cz>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] [RFC] Simple tamper-proof device filesystem.
In-Reply-To: Your message of "Thu, 06 Dec 2007 15:29:07 GMT."
             <20071206152906.GA3974@ucw.cz>
From: Valdis.Kletnieks@vt.edu
References: <20071216080441.435456586@I-love.SAKURA.ne.jp> <20071216080628.061470932@I-love.SAKURA.ne.jp> <200712161944.HEI26071.MOtOFLVHFSQFOJ@I-love.SAKURA.ne.jp> <200712161956.BJE32406.FOOHtQJLMFOSVF@I-love.SAKURA.ne.jp>
            <20071206152906.GA3974@ucw.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1197993320_3561P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 18 Dec 2007 10:55:20 -0500
Message-ID: <22795.1197993320@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1197993320_3561P
Content-Type: text/plain; charset=us-ascii

On Thu, 06 Dec 2007 15:29:07 GMT, Pavel Machek said:
> 
> > Why not use SELinux?
> > 
> >  Because SELinux doesn't guarantee filename and its attribute.
> >  The purpose of this filesystem is to ensure filename and its attribute
> >  (e.g. /dev/null is guaranteed to be a character device file
> >  with major=1 and minor=3).
> 
> Why not improve selinux to be able to assign label of new file based
> on directory label and name?

The problem isn't the label, it's the *other* attributes...

What happens if /dev/null has the correct SELinux label, but the major/minor
is 1,27 rather than 1,3?

--==_Exmh_1197993320_3561P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHZ+1ocC3lWbTT17ARAngTAJ9QfwLJNFNr1P3xkx5sgdmSX8uKSQCg+PBx
xN3ncXAs8Pg/PHTZLgK4LyY=
=tYdE
-----END PGP SIGNATURE-----

--==_Exmh_1197993320_3561P--
