Return-Path: <linux-kernel-owner+w=401wt.eu-S1758090AbYAYJ63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090AbYAYJ63 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 04:58:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbYAYJ6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 04:58:22 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:58129 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351AbYAYJ6U (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 04:58:20 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "Giacomo A. Catenazzi" <cate@cateee.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.24
In-Reply-To: Your message of "Fri, 25 Jan 2008 10:10:11 +0100."
             <4799A773.2030702@cateee.net>
From: Valdis.Kletnieks@vt.edu
References: <alpine.LFD.1.00.0801241506500.15329@hp.linux-foundation.org> <alpine.LFD.1.00.0801241529440.15329@hp.linux-foundation.org>
            <4799A773.2030702@cateee.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1201255093_2846P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 25 Jan 2008 04:58:13 -0500
Message-ID: <22000.1201255093@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1201255093_2846P
Content-Type: text/plain; charset=us-ascii

On Fri, 25 Jan 2008 10:10:11 +0100, "Giacomo A. Catenazzi" said:

> As a tester I would like:
> - slow merges, so that developer could rebase and test
>    (compile test) the interaction of the new code.

An amazing amount of stuff gets caught when it's tested in Andrew Morton's -mm
tree.  You think -rc1's are bad now, consider that much of what will be
25-rc1 already got tried as 24-rc6-mm1 and 24-rc8-mm1.  Without those, the
-rc1 releases would be truly horrific.. ;)

> - you will introduce a new step on git management:
>    Every changeset is compile-tested before going out to the world.
>    I think this can be done automatically, and I think that one or
>    two configurations are enough to find most of the problems.

It's true that a compile on x86 and a compile on PowerPC should flush out
most of the truly stupid mistakes, but those are usually found and fixed
literally within hours.  Anyhow, the proper time for test compiles is *before*
it goes into the git trees at all - it should have been tested before it
gets sent to a maintainer for inclusion.

Plus, there's a *lot* of issues that "one or two configurations" won't
find - we continually find build issues that literally depend on 3 or 4
different CONFIG_* settings, and only misbehave for one specific combination.
And all the things that compile clean but explode at runtime.



--==_Exmh_1201255093_2846P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHmbK1cC3lWbTT17ARAvIeAJ48h6Z9r1tJwAGXZAMx09xKW8jzVQCfZFwq
YdRlYKi3Qn+wba4obxtYl24=
=yQ/f
-----END PGP SIGNATURE-----

--==_Exmh_1201255093_2846P--
