Return-Path: <linux-kernel-owner+w=401wt.eu-S1753789Ab0AVNp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab0AVNp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 08:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144Ab0AVNp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 08:45:27 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:42740 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab0AVNp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 08:45:26 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: ananth@in.ibm.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: add utrace tree
In-Reply-To: Your message of "Fri, 22 Jan 2010 10:51:39 +0530."
             <20100122052139.GA20532@in.ibm.com>
From: Valdis.Kletnieks@vt.edu
References: <20100120061551.GB6588@in.ibm.com> <20100120062834.GB12165@elte.hu> <20100120072925.GA11395@elte.hu> <20100121013822.28781960.sfr@canb.auug.org.au> <20100122111747.3c224dfd.sfr@canb.auug.org.au> <20100121163004.8779bd69.akpm@linux-foundation.org> <20100121163145.7e958c3f.akpm@linux-foundation.org> <20100122005147.GD22003@redhat.com> <20100121170541.7425ff10.akpm@linux-foundation.org> <alpine.LFD.2.00.1001211724500.13231@localhost.localdomain>
            <20100122052139.GA20532@in.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1264167798_4668P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 22 Jan 2010 08:43:18 -0500
Message-ID: <18867.1264167798@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=steiner.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020206.4B59AB79.0154,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1264167798_4668P
Content-Type: text/plain; charset=us-ascii

On Fri, 22 Jan 2010 10:51:39 +0530, Ananth N Mavinakayanahalli said:

> FWIW, Oleg's implementation of ptrace over utrace is 100% compatible
> with legacy ptrace; gdb testsuite indicates that
> (http://lkml.org/lkml/2009/12/21/98).

No, that only proves it's compatible enough for gdb to not care. The problem
is all those *other* packages that abuse ptrace in totally crackhead ways.

(No, I can't name them - but ptrace is the sort of interface that almost
encourages its use for things somewhere between crackhead and mad-scientist,
so they're almost certainly out there.. WAY out there.. :)

--==_Exmh_1264167798_4668P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLWat2cC3lWbTT17ARAgw1AKDXe9SH3oEUDuwTIceHaY6I2GlcbwCg4B7Z
WdWk82XsrZXGeTOGHXpiUkQ=
=2WnU
-----END PGP SIGNATURE-----

--==_Exmh_1264167798_4668P--

