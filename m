Return-Path: <linux-kernel-owner+w=401wt.eu-S1765648AbXHQUWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765648AbXHQUWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 16:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765258AbXHQUWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 16:22:05 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:59889 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765114AbXHQUWE (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 16:22:04 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH]: proc: export a processes resource limits via proc/<pid>
In-Reply-To: Your message of "Fri, 17 Aug 2007 12:45:47 PDT."
             <20070817124547.5415a839.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20070813140044.GB1960@hmsreliant.think-freely.org> <20070816123538.GA10430@hmsreliant.think-freely.org> <4379.1187338166@turing-police.cc.vt.edu> <20070817105918.GA13937@hmsreliant.think-freely.org>
            <20070817124547.5415a839.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1187382045_3142P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 17 Aug 2007 16:20:45 -0400
Message-ID: <21194.1187382045@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1187382045_3142P
Content-Type: text/plain; charset=us-ascii

On Fri, 17 Aug 2007 12:45:47 PDT, Andrew Morton said:
> On Fri, 17 Aug 2007 06:59:18 -0400
> Neil Horman <nhorman@tuxdriver.com> wrote:
> 
> > Currently, there exists no method for a process to query the resource
> > limits of another process.  They can be inferred via some mechanisms but they
> > cannot be explicitly determined.  Given that this information can be usefull to
> > know during the debugging of an application, I've written this patch which
> > exports all of a processes limits via /proc/<pid>/limits.
> 
> I'm struggling with this a bit.  Sure, it _might_ be handy on some
> occasions to be able to get at this information.  But I've never seen
> anyone ask for it before, and it _is_ determinable by other means, if only
> strace.

Most of the times *I*'ve struggled with this, it's been a case of "this program
forks that one that calls a PAM module that does this and then double-forks
yadda yadda".  So I know where Neil is coming from.

> How do we justify adding yet more stuff to the kernel?

I looked the code over, and *if* we want to do it, the code looks good.
Making that final call is why they pay you and Linus the big bucks. :)


--==_Exmh_1187382045_3142P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGxgMdcC3lWbTT17ARAvhyAJ9QgY7x1jUr/usj5uQSrj9MFhKUIQCg2Fk9
O9q2RySAH5/tjgo5cG3+Bk0=
=gvsZ
-----END PGP SIGNATURE-----

--==_Exmh_1187382045_3142P--
