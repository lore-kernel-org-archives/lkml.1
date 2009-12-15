Return-Path: <linux-kernel-owner+w=401wt.eu-S934105AbZLOWqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934105AbZLOWqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 17:46:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934098AbZLOWql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 17:46:41 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:46002 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934096AbZLOWqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 17:46:39 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Peter Zijlstra <peterz@infradead.org>
Cc: akpm@linux-foundation.org, h-shimamoto@ct.jp.nec.com, joe@perches.com,
       mingo@elte.hu, nooiwa@miraclelinux.com, mm-commits@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [folded] kernelh-add-printk_ratelimited-and-pr_level_rl-rename.patch removed from -mm tree
In-Reply-To: Your message of "Tue, 15 Dec 2009 11:28:02 +0100."
             <1260872882.4165.353.camel@twins>
From: Valdis.Kletnieks@vt.edu
References: <200912150108.nBF18TNx015047@imap1.linux-foundation.org>
            <1260872882.4165.353.camel@twins>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1260917095_4495P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 15 Dec 2009 17:44:55 -0500
Message-ID: <25197.1260917095@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020203.4B281167.01CE,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1260917095_4495P
Content-Type: text/plain; charset=us-ascii

On Tue, 15 Dec 2009 11:28:02 +0100, Peter Zijlstra said:
> On Mon, 2009-12-14 at 17:08 -0800, akpm@linux-foundation.org wrote:
> > s/_rl/_ratelimited/g
> 
> do we feel this pr_* wankery is worth the hassle? I'd as soon send a
> patch removing all this crap.

pr_foo() instead of printk(KERN_FOO) is probably worth the hassle, as it
allows more selective inclusion of messages if you're trying to build an
embedded kernel.  It's easy to say "I want pr_warning() to stay in, but
lower levels compile to nothing". Trying to keep a 'printk(KERN_WARNING'
while making a printk(KERN_DEBUG go away is just asking for some truly
astounding pre-processor gyrations.

Not an issue for my laptop with 4G of RAM - byt my cell phone says it has
26M of memory, 7M used (presumably all the software, my contact list isn't
*that* big).  No idea what the actual kernel is, but I know whatever it is,
the coders were using that kernel's equivalent of CONFIG_EMBEDDED and tossing
stuff over the side if they didn't need it. ;)



--==_Exmh_1260917095_4495P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLKBFncC3lWbTT17ARAurYAJ4qDRxDv4j1ZjdBODOqTUdXK/UzfwCg9ifp
sjSj6TOI+P+bG9sAQ556zVA=
=c7g5
-----END PGP SIGNATURE-----

--==_Exmh_1260917095_4495P--

