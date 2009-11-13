Return-Path: <linux-kernel-owner+w=401wt.eu-S1757429AbZKMVXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429AbZKMVXX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 16:23:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756624AbZKMVXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 16:23:18 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:52075 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756502AbZKMVXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 16:23:17 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: James Morris <jmorris@namei.org>, Julia Lawall <julia@diku.dk>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/4] security/selinux: decrement sizeof size in strncmp
In-Reply-To: Your message of "Thu, 12 Nov 2009 18:11:55 PST."
             <4AFCC06B.1030302@schaufler-ca.com>
From: Valdis.Kletnieks@vt.edu
References: <Pine.LNX.4.64.0911120849050.16627@ask.diku.dk> <alpine.LRH.2.00.0911121857110.31071@tundra.namei.org> <20091112145314.GA24682@us.ibm.com> <Pine.LNX.4.64.0911121556390.19779@ask.diku.dk> <4AFC3620.2020809@schaufler-ca.com> <alpine.LRH.2.00.0911130833220.5497@tundra.namei.org>
            <4AFCC06B.1030302@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1258147396_3022P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 13 Nov 2009 16:23:16 -0500
Message-ID: <19857.1258147396@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 128.173.14.107 turing-police.cc.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020206.4AFDCE45.0042,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1258147396_3022P
Content-Type: text/plain; charset=us-ascii

On Thu, 12 Nov 2009 18:11:55 PST, Casey Schaufler said:
> James Morris wrote:
> > Do you see potential for a buffer overrun in this case?

> No, but I hate arguing with people who think that every time
> they see strcmp that they have found a security flaw.

How do you feel about people who think every time they see strcmp()
"Oh crap, something that needs auditing"? ;)

The biggest problem with strcmp() is that even if it got audited when that code
went in, it's prone to unaudited breakage when somebody changes something in
some other piece of code, quite often in some other .c file in some other
directory.

Julia, is there a way to use coccinelle to detect unsafe changes like that?  Or
is expressing those semantics too difficult?



--==_Exmh_1258147396_3022P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFK/c5EcC3lWbTT17ARAtzSAJ4zRrjfCDH9OiVnNIwb11O2VStmUgCgwgGp
3FRC6DGlT8ojgdYTaf5hsdI=
=WBd9
-----END PGP SIGNATURE-----

--==_Exmh_1258147396_3022P--

