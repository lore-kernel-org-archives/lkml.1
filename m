Return-Path: <linux-kernel-owner+w=401wt.eu-S1753468AbZJ1MD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbZJ1MD5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 08:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbZJ1MD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 08:03:56 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:56477 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbZJ1MDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 08:03:55 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andi Kleen <ak@linux.intel.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Mike Travis <travis@sgi.com>, Roland Dreier <rdreier@cisco.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: [PATCH] x86, mce: disable MCE if cpu has no MCE banks
In-Reply-To: Your message of "Wed, 28 Oct 2009 06:24:45 BST."
             <4AE7D59D.9070307@linux.intel.com>
From: Valdis.Kletnieks@vt.edu
References: <adaeip473qt.fsf@cisco.com> <4AE74D25.8090901@sgi.com> <4AE75DB9.3040702@sgi.com> <4AE7C396.7040109@jp.fujitsu.com>
            <4AE7D59D.9070307@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1256731383_2776P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 28 Oct 2009 08:03:03 -0400
Message-ID: <32564.1256731383@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 128.173.34.98 turing-police.cc.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020205.4AE832F8.01D4,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-07-29 21:33:33,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1256731383_2776P
Content-Type: text/plain; charset=us-ascii

On Wed, 28 Oct 2009 06:24:45 BST, Andi Kleen said:

> >>> mce: CPU supports 0 MCE banks
> 
> That message can be just removed I think. I don't see much value in it
> because the value is in sysfs and when you see the CPU type you can easily
> determine it anyways.

Maybe it should only print a message if it finds an unexpected number of banks?
"Hey dood - we're on a Core3.5 and there should be 6 banks here, but the
hardware says there's only 4. What's up with that?"


--==_Exmh_1256731383_2776P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFK6DL3cC3lWbTT17ARAjBuAKDjuDXi1VI3ryqYxpy6C3qKcIkf3gCg6zGa
AbttAfi7QFrbby1u5mnxU7Y=
=gU3T
-----END PGP SIGNATURE-----

--==_Exmh_1256731383_2776P--

