Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbZIIRfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbZIIRfi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 13:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753530AbZIIRfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 13:35:37 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:39456 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447AbZIIRfg (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 13:35:36 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Beth Kon <eak@us.ibm.com>, rostedt@goodmis.org, avi@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Wierdness - linux-next KVM patch breaks Dell Latitude D820, KVM not in kernel
In-Reply-To: Your message of "Tue, 08 Sep 2009 15:41:28 EDT."
             <22130.1252438888@turing-police.cc.vt.edu>
From: Valdis.Kletnieks@vt.edu
References: <3850.1252332427@turing-police.cc.vt.edu> <4AA65CFE.50402@us.ibm.com>
            <22130.1252438888@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1252517689_3993P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 09 Sep 2009 13:34:50 -0400
Message-ID: <21211.1252517690@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1252517689_3993P
Content-Type: text/plain; charset=us-ascii

On Tue, 08 Sep 2009 15:41:28 EDT, Valdis.Kletnieks@vt.edu said:

> Yeah, I was quite confused by the bisect results as well, I may end up
> re-doing it just to make sure I didn't screw something up along the way (since
> I started it with -rc7/HEAD as the good/bad, but most of the resulting
> kernels reported a pre-rc7 release (a 2.6.28 at one point, IIRC, and it
> finished at 31-rc2.

I've become convinced that Something Really Bad happened to the KVM tree in
linux-next on its way to my laptop - after 2 bisects, it reported I had some
2,000 commits left to check.  So I ran 'git bisect visualize' to sanity check.

And *every single one* of those 4,000 commits between 'good' and 'bad' was a
KVM commit, stretching all the way back to 2007.  Unless that's an artifact
of the way linux-next is built, I would have expected only "new-ish" commits
to be in the bisect window, and not just out of one tree...

So I ended up doing a 'WTF?', an 'rm -r', and am cloning over today's linux-next
and will see if that brings me any better joy.



--==_Exmh_1252517689_3993P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKp+c5cC3lWbTT17ARAqnbAKDYmiK0kIdJ1TF4JsKXOTdzrz+1ygCg6Q8k
wDbwLoFNPavRZXenal8Flfw=
=ZrGG
-----END PGP SIGNATURE-----

--==_Exmh_1252517689_3993P--
