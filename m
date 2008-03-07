Return-Path: <linux-kernel-owner+w=401wt.eu-S1763890AbYCGTbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763890AbYCGTbq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 14:31:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757532AbYCGTbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 14:31:38 -0500
Received: from hc65210ec.dhcp.vt.edu ([198.82.16.236]:55756 "EHLO
	hc65210ec.dhcp.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757337AbYCGTbi (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 14:31:38 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc3-mm1 - BUG at system shutdown time
In-Reply-To: Your message of "Fri, 07 Mar 2008 09:34:01 +0100."
             <alpine.LFD.1.00.0803070931470.3099@apollo.tec.linutronix.de>
From: Valdis.Kletnieks@vt.edu
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org> <10815.1204862325@turing-police.cc.vt.edu> <20080306221602.790cd26e.akpm@linux-foundation.org> <4954.1204876349@turing-police.cc.vt.edu> <alpine.LFD.1.00.0803070857360.3099@apollo.tec.linutronix.de> <3450.1204878180@turing-police.cc.vt.edu>
            <alpine.LFD.1.00.0803070931470.3099@apollo.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1204918220_4026P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 07 Mar 2008 14:30:21 -0500
Message-ID: <7962.1204918221@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1204918220_4026P
Content-Type: text/plain; charset=us-ascii

On Fri, 07 Mar 2008 09:34:01 +0100, Thomas Gleixner said:

> Yeah. Sorry for making you do useless work. The meat is here:
> 
> > > [   74.256373] PGD 203067 PUD 207063 PMD 7e4cc163 PTE 20a161
> 
> ----------------------------------------------------------^^^^^^
> 
> The PTE has the RW bit cleared, so the fault is not a big surprise.

Probably not surprisingly, the quilt bisect says the problem is git-x86,patch.

--==_Exmh_1204918220_4026P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFH0ZfMcC3lWbTT17ARAsKuAKDGS21zsd9jcrvq6ckJWi/8sPuonACeNWA/
cBqlp7cptpfLpwX3Du1YuzE=
=YOz5
-----END PGP SIGNATURE-----

--==_Exmh_1204918220_4026P--
