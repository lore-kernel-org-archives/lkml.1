Return-Path: <linux-kernel-owner+w=401wt.eu-S1758056AbZD2QUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056AbZD2QUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 12:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755050AbZD2QUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 12:20:37 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:39669 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbZD2QUg (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 12:20:36 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 5/5] ring-buffer: fix printk output
In-Reply-To: Your message of "Tue, 28 Apr 2009 23:20:00 PDT."
             <20090428232000.6c3d4ce1.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20090429044814.138790038@goodmis.org> <20090429045908.394874083@goodmis.org> <20090428222024.8db50539.akpm@linux-foundation.org> <20090429054359.GA6148@elte.hu> <20090428225541.9ca61a12.akpm@linux-foundation.org> <20090429060955.GD6148@elte.hu>
            <20090428232000.6c3d4ce1.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1241021943_4397P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 29 Apr 2009 12:19:03 -0400
Message-ID: <25555.1241021943@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1241021943_4397P
Content-Type: text/plain; charset=us-ascii

On Tue, 28 Apr 2009 23:20:00 PDT, Andrew Morton said:
> printk_once() is racy on smp and preempt btw ;)

Looks like at worst, it's prone to the usual printk racing, plus a possible
misfire causing it to print twice before shutting up?  Or is there something
I'm missing here?

--==_Exmh_1241021943_4397P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJ+H33cC3lWbTT17ARAp80AJ9yc9bbpMYNaij+MmVb8U5BXSHUIwCfc5xF
7XERaQjUyYu3/EZfgJPJf4s=
=eZKx
-----END PGP SIGNATURE-----

--==_Exmh_1241021943_4397P--
