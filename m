Return-Path: <linux-kernel-owner+w=401wt.eu-S1751916AbZL1Opb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbZL1Opb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 09:45:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbZL1Opa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 09:45:30 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:34391 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbZL1Op3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 09:45:29 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: serge@hallyn.com, serue@us.ibm.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: A basic question about the security_* hooks
In-Reply-To: Your message of "Mon, 28 Dec 2009 20:51:49 +0900."
             <200912282051.BIF64080.VOMtFOOLSHJFFQ@I-love.SAKURA.ne.jp>
From: Valdis.Kletnieks@vt.edu
References: <20091225055034.GA374@us.ibm.com> <20091226195043.GA1945@heat> <20091227031631.GA17629@hallyn.com> <200912271302.JBH64754.JtLMFQVOSOFFHO@I-love.SAKURA.ne.jp> <22669.1261911374@localhost>
            <200912282051.BIF64080.VOMtFOOLSHJFFQ@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1262011518_3923P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 28 Dec 2009 09:45:18 -0500
Message-ID: <9071.1262011518@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=steiner.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A02020A.4B38C47E.025C,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1262011518_3923P
Content-Type: text/plain; charset=us-ascii

On Mon, 28 Dec 2009 20:51:49 +0900, Tetsuo Handa said:

> Yes, to fix SELinux is the right answer if we can integrate TOMOYO into
> SELinux. But SELinux had been advertised as label based access control and had
> been rejecting pathname based access control. I doubt SELinux wants to
> integrate pathname based access control.

No, that's missing the point.  Let's say you have an SELinux system, and
you want to use TOMOYO on top of it (or the other way around, it works either
way).  Now hopefully, you're not doing it just to prove it can be done, you're
doing it because you have a specific issue or threat model that TOMOYO can
address that SELinux can't - for instance "A program can do FOO, BAR, and
then BAZ, and SELinux is unable to stop that but TOMOYO can".

So the question becomes "*why* can't SELinux stop FOO, BAR, BAZ, and can it
be fixed to be able to do so?"


--==_Exmh_1262011518_3923P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLOMR+cC3lWbTT17ARAnJ5AJ0fA0y0nQQ2UEX0VEqrV3GQPWY20gCeMgL2
/aqOLJXng/m84uHVdGJ1XT4=
=sEf6
-----END PGP SIGNATURE-----

--==_Exmh_1262011518_3923P--

