Return-Path: <linux-kernel-owner+w=401wt.eu-S933045AbXCHUj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933045AbXCHUj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 15:39:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933056AbXCHUj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 15:39:59 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:34340 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933045AbXCHUj6 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 15:39:58 -0500
Message-Id: <200703082038.l28Kcowq023278@turing-police.cc.vt.edu>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
       Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       safford@watson.ibm.com, serue@linux.vnet.ibm.com,
       kjhall@linux.vnet.ibm.com, zohar@us.ibm.com
Subject: Re: [RFC][Patch 1/6] integrity: new hooks
In-Reply-To: Your message of "Thu, 08 Mar 2007 12:46:47 CST."
             <20070308184646.GC21099@sergelap.austin.ibm.com>
From: Valdis.Kletnieks@vt.edu
References: <20070308170001.GA17304@sergelap.austin.ibm.com> <33939.11500.qm@web36612.mail.mud.yahoo.com>
            <20070308184646.GC21099@sergelap.austin.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1173386330_10421P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 08 Mar 2007 15:38:50 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1173386330_10421P
Content-Type: text/plain; charset=us-ascii

On Thu, 08 Mar 2007 12:46:47 CST, "Serge E. Hallyn" said:
> I think it should be done as both.  The part which measures the
> integrity of files should be an integrity subsystem.  The part which
> uses those results to either allow/refuse actions or take some other
> action (i.e. shut down the system) should be an lsm.

That would be good - the allow/deny parts, being security, can use the
existing LSM hooks, and the integrity part can use the LIM hooks.

Umm... wait a minute - *what* Linux Integrity Module hooks? :)

--==_Exmh_1173386330_10421P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFF8HRacC3lWbTT17ARAj8WAJsHuuDA4SzMJuPbWLRQssyafUU6WQCgqXoE
VVsLi7Z1znXkS+vOmAdTc5E=
=RfDQ
-----END PGP SIGNATURE-----

--==_Exmh_1173386330_10421P--
