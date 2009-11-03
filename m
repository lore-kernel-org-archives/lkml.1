Return-Path: <linux-kernel-owner+w=401wt.eu-S1754483AbZKCSOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbZKCSOu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 13:14:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbZKCSOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 13:14:49 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:50053 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbZKCSOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 13:14:49 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Hal Finney <hal.finney@gmail.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
       tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       srajiv@linux.vnet.ibm.com
Subject: Re: [tpmdd-devel] [PATCH] TPM: Let the tpm char device be openable multiple times
In-Reply-To: Your message of "Tue, 03 Nov 2009 09:31:55 PST."
             <da7b3ce30911030931u1ccbff69ted4206606475c83@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <20091103003511.GL7768@obsidianresearch.com>
            <da7b3ce30911030931u1ccbff69ted4206606475c83@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1257272068_4220P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 03 Nov 2009 13:14:28 -0500
Message-ID: <6926.1257272068@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 128.173.14.107 turing-police.cc.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020203.4AF07304.03C0,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-07-29 21:33:33,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1257272068_4220P
Content-Type: text/plain; charset=us-ascii

On Tue, 03 Nov 2009 09:31:55 PST, Hal Finney said:
> What if you don't want it accessible by user mode apps, you only want
> your middleware (ie tcs daemon, tcsd) to open it? Will this still
> allow that to be enforced, so nobody can interfere with tcsd's
> exclusive access to the device?

Couldn't tcsd just open the device with O_EXCL? Or am I missing something
subtle here?

--==_Exmh_1257272068_4220P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFK8HMEcC3lWbTT17ARAj8TAKCs7iFlkj7TEu3W4MhcdPUbpxrxrQCdEb6i
H6Ao5QXdAGzy0NG/kDbwlww=
=7qVT
-----END PGP SIGNATURE-----

--==_Exmh_1257272068_4220P--

