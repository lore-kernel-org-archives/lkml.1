Return-Path: <linux-kernel-owner+w=401wt.eu-S1754366AbZJEUc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366AbZJEUc6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 16:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbZJEUc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 16:32:58 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:45995 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156AbZJEUc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 16:32:57 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.32-rc3: low mem - only 378MB on x86_32 with 64GB. Why?
In-Reply-To: Your message of "Mon, 05 Oct 2009 21:42:09 +0200."
             <4ACA4C11.9060107@wpkg.org>
From: Valdis.Kletnieks@vt.edu
References: <4ACA4C11.9060107@wpkg.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1254774707_3393P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 05 Oct 2009 16:31:47 -0400
Message-ID: <168769.1254774707@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 128.173.35.168 turing-police.cc.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020208.4ACA57B6.005D,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-07-29 21:33:33,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1254774707_3393P
Content-Type: text/plain; charset=us-ascii

On Mon, 05 Oct 2009 21:42:09 +0200, Tomasz Chmielewski said:
> > Heh.  You've really squeezed yourself into a bad situation.  Go get a
> > 64-bit kernel... please.  You should be able to run 32-bit userspace
> > with a 64-bit kernel.  Do you have some 32-bit kernel component that you
> > are relying on?
> 
> Note that in such setups (64 bit kernels and 32 bit userspace) *some* 
> software will not work correctly (perhaps it's limited to tightly 
> kernel-userspace integrated software).
> 
> One example is open-iscsi - you won't run 32 bit open-iscsi userspace on 
> a 64 bit kernel (at least it was impossible a couple of months ago).

Sounds like somebody blew it on 32/64 bit combatability on a syscall,
most likely a parameter to an ioctl?

--==_Exmh_1254774707_3393P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKylezcC3lWbTT17ARArceAKCfOtk4q0lQKT93wLGJH/iAYgaGHgCeINjT
SYolbs76Fy8uc/HV+17THYc=
=PXHM
-----END PGP SIGNATURE-----

--==_Exmh_1254774707_3393P--

