Return-Path: <linux-kernel-owner+w=401wt.eu-S1757474AbZLNO6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474AbZLNO6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 09:58:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757444AbZLNO6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 09:58:48 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:44942 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757405AbZLNO6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 09:58:46 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, amwang@redhat.com,
       mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: Remove usedac in feature-removal-schedule.txt
In-Reply-To: Your message of "Mon, 14 Dec 2009 07:58:01 GMT."
             <tip-06f8bda8324fa8bf39eed81d8b3df08063a37696@git.kernel.org>
From: Valdis.Kletnieks@vt.edu
References: <20091214104423X.fujita.tomonori@lab.ntt.co.jp>
            <tip-06f8bda8324fa8bf39eed81d8b3df08063a37696@git.kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1260802675_3801P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 14 Dec 2009 09:57:55 -0500
Message-ID: <17113.1260802675@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=zidane.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020202.4B265275.01A9,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1260802675_3801P
Content-Type: text/plain; charset=us-ascii

On Mon, 14 Dec 2009 07:58:01 GMT, tip-bot for FUJITA Tomonori said:
> Commit-ID:  06f8bda8324fa8bf39eed81d8b3df08063a37696

> x86: Remove usedac in feature-removal-schedule.txt

> The usedac option enables us to stop via_no_dac() setting
> forbid_dac to 1. That is, someone who uses VIA bridges can use
> DAC with this option even if some of VIA bridges seem to be
> broken about DAC.

Does there exist real hardware where this makes sense?  If the chipset
detects as "broken-DAC", is it in fact safe to use?  Or is it similar to
the 'force-enable HPET' code for some older boxes, where the HPET was in
fact there but simply not advertised, so going ahead and using it was
in fact perfectly safe? Allowing the use of "working but not advertised"
is probably a good thing, allowing the use of known-broken probably isn't.

If it's just unadvertised, I wonder if if there's a way to write a quirk
for VIA systems that will detect the situation and enable the support?



--==_Exmh_1260802675_3801P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLJlJzcC3lWbTT17ARAi8wAKDanbrAqma8J6Jbx+qmfOMYJLD19gCdHauP
u3ooRsuJe2XDygZ6ds5oULY=
=XroZ
-----END PGP SIGNATURE-----

--==_Exmh_1260802675_3801P--

