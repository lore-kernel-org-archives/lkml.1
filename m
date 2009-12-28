Return-Path: <linux-kernel-owner+w=401wt.eu-S1751354AbZL1CIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751354AbZL1CIc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 21:08:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbZL1CIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 21:08:32 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:48972 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbZL1CIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 21:08:31 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: daw-news@taverner.cs.berkeley.edu (David Wagner)
Cc: linux-kernel@vger.kernel.org
Subject: Re: A basic question about the security_* hooks
In-Reply-To: Your message of "Sun, 27 Dec 2009 20:28:23 GMT."
             <hh8g17$qlu$1@taverner.cs.berkeley.edu>
From: Valdis.Kletnieks@vt.edu
References: <20091225055034.GA374@us.ibm.com> <20091227031631.GA17629@hallyn.com> <200912271302.JBH64754.JtLMFQVOSOFFHO@I-love.SAKURA.ne.jp> <22669.1261911374@localhost>
            <hh8g17$qlu$1@taverner.cs.berkeley.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1261966107_3923P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 27 Dec 2009 21:08:27 -0500
Message-ID: <16474.1261966107@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=steiner.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020205.4B38131C.0162,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1261966107_3923P
Content-Type: text/plain; charset=us-ascii

On Sun, 27 Dec 2009 20:28:23 GMT, David Wagner said:

> Read the thread, where you can find the answer *why*.  The question has
> already been answered.

That was the *original* use case for Michael Stone's module. However, in the
mail that I was specifically replying to:

On Sun, 27 Dec 2009 13:02:54 +0900, Tetsuo Handa said:
> I believe TOMOYO can safely coexist with other security modules.
> Why TOMOYO must not be used with SELinux or Smack or AppArmor?
> What interference are you worrying when enabling TOMOYO with SELinux or Smack
> or AppArmor?

Tetsuo asked specifically about the issues of composing two MAC implementations,
so I answered that issue as opposed to "composing a MAC with a small LSM".

I agree that composing a MAC system plus something small should be easier -
as far back as April 2002 there was discussion of stacking SELinux and the
OWLSM (openwall/grsecurity style patches).  And we've *still* not managed to
get a solution for that issue (though Serge Hallyn did a yeoman job in trying
to get a stacker accepted back in 2004 or so).

I wonder if we need to go look at Serge's patch set again.  It's getting tiring
to revisit the issue every 18 months when somebody wants a small LSM, but can't
do it because large MACs have essentially co-opted the interface.


--==_Exmh_1261966107_3923P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLOBMbcC3lWbTT17ARAmLgAJ9ReeHv0FKZF2hyWH+Ny/DqOQZs1QCfUU/+
f//ZHu8RryMdT6FEHlX2avM=
=5Ayg
-----END PGP SIGNATURE-----

--==_Exmh_1261966107_3923P--

