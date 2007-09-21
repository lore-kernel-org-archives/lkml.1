Return-Path: <linux-kernel-owner+w=401wt.eu-S1760953AbXIURRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760953AbXIURRE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 13:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755528AbXIURQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 13:16:53 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:40207 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020AbXIURQw (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 13:16:52 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Rob Landley <rob@landley.net>
Cc: Indan Zupancic <indan@nul.nu>, linux-tiny@selenic.com,
       Michael Opdenacker <michael@free-electrons.com>,
       CE Linux Developers List <celinux-dev@tree.celinuxforum.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Announce] Linux-tiny project revival
In-Reply-To: Your message of "Thu, 20 Sep 2007 18:18:41 CDT."
             <200709201818.42125.rob@landley.net>
From: Valdis.Kletnieks@vt.edu
References: <46F1645D.9050406@am.sony.com> <200709201538.43093.rob@landley.net> <59465.81.207.0.53.1190323573.squirrel@secure.samage.net>
            <200709201818.42125.rob@landley.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1190394985_2847P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 21 Sep 2007 13:16:25 -0400
Message-ID: <10228.1190394985@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1190394985_2847P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <10222.1190394985.1@turing-police.cc.vt.edu>

On Thu, 20 Sep 2007 18:18:41 CDT, Rob Landley said:

> Worse, if you feed an absolute path to O= when you build the kernel out of 
> tree, then it uses absolute paths for all the __FILE__ strings and that makes
> kernel BIIIIIG.  (Did that by accident a while back.)  Too bad there's no way
> to keep the __FILE__ strings compressed at runtime and gunzip them as needed 
> like busybox does with help messages... :)

What about something *really* hardcore ugly like:

#ifdef __FILE__
#undef __FILE__
#define __FILE__ ""
#endif

(or similar preprocessor blecherousness) if you want to *really* shrink
that binary down?

--==_Exmh_1190394985_2847P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG8/xpcC3lWbTT17ARAnhuAJ4mvOqAGfhMV4IlovK4MPAlIOJiuQCg6l5d
0oEGXRZh8SrfKK+qMXcGUUM=
=0tO1
-----END PGP SIGNATURE-----

--==_Exmh_1190394985_2847P--
