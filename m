Return-Path: <linux-kernel-owner+w=401wt.eu-S1752558AbYJAFGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558AbYJAFGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 01:06:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751086AbYJAFF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 01:05:58 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:36431 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbYJAFF5 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 01:05:57 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       Kentaro Takeda <takedakn@nttdata.co.jp>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       haradats@nttdata.co.jp,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [TOMOYO #9 (2.6.27-rc7-mm1) 1/6] LSM adapter functions.
In-Reply-To: Your message of "Tue, 30 Sep 2008 19:33:32 PDT."
             <48E2E17C.3040108@schaufler-ca.com>
From: Valdis.Kletnieks@vt.edu
References: <20080924090317.359685535@nttdata.co.jp> <20080924090338.407746083@nttdata.co.jp> <20080925165954.GA25587@us.ibm.com> <48DC7553.8040708@nttdata.co.jp> <20080926130409.GA14055@us.ibm.com> <48E053DB.3010201@nttdata.co.jp> <20080930154553.GA29249@us.ibm.com>
            <48E2E17C.3040108@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1222837526_2952P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 01 Oct 2008 01:05:26 -0400
Message-ID: <62704.1222837526@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1222837526_2952P
Content-Type: text/plain; charset=us-ascii

On Tue, 30 Sep 2008 19:33:32 PDT, Casey Schaufler said:
> I have always believed that MAC should come first, then DAC, because
> MAC may care if you can see the mode bits. The current DAC before MAC
> is an artifact of the desire for the LSM to behave cleanly as a
> strictly additional mechanism. From an ideal security perspective
> MAC should be first, but the pragmatic DAC first isn't going to cause
> too much grief. If Tomoyo wants to do what I think is the right thing,
> well, it's OK with me.

I'm OK with the MAC going first as well - but unless/until we convert the
rest of the kernel to do MAC-before-DAC, somebody better leave a comment:

/* Yes, this one spot *is* doing MAC-first intentionally */

or similar, just so we don't keep getting patches to "fix" it to DAC-first...

(And yes, newbie janitors *will* submit patches like that - how many times
have we had the 'ndiswrapper-taint-flag' flame war now?)

--==_Exmh_1222837526_2952P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFI4wUWcC3lWbTT17ARAhyEAKDSg42eOU/CWvWjQuiXhEslSZxJ0ACbB8DW
VjW3MTDjWfd3gyc4V0DXm5o=
=SCbM
-----END PGP SIGNATURE-----

--==_Exmh_1222837526_2952P--
