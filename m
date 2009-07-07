Return-Path: <linux-kernel-owner+w=401wt.eu-S1756928AbZGGRqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928AbZGGRqW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 13:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755101AbZGGRqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 13:46:15 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:47955 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663AbZGGRqO (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 13:46:14 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 'config EVENT_PROFILE' - how does it ever work?
In-Reply-To: Your message of "Tue, 07 Jul 2009 16:34:55 +0200."
             <1246977295.8143.319.camel@twins>
From: Valdis.Kletnieks@vt.edu
References: <11231.1246973627@turing-police.cc.vt.edu>
            <1246977295.8143.319.camel@twins>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1246988738_3905P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 07 Jul 2009 13:45:38 -0400
Message-ID: <24545.1246988738@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1246988738_3905P
Content-Type: text/plain; charset=us-ascii

On Tue, 07 Jul 2009 16:34:55 +0200, Peter Zijlstra said:
> It used to work at some point in the past, but then I think it bitrotted
> a bit with the tracer changes. I think Jason Baron posted a few patches
> yesterday that fixed it all up and made it work nicely again.
> 
> http://lkml.org/lkml/2009/7/6/313

I stuck Jason's patches on my tree, and EVENT_PROFILE is again visible
in 'make menuconfig'.  So I'm going to assume that the appropriate maintainer
is going to shepherd these into mainline - looks small enough, and it's mostly
a bitrot-fix, that Linus may accept it for .31. If not, .32 isn't *that* far
off.. ;)

--==_Exmh_1246988738_3905P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKU4nCcC3lWbTT17ARAuIIAKDyejn3JONnODuOvgbnQu2QeWan8wCfdu5z
25npiP6Y4M6T/wqYObygppY=
=/Rbw
-----END PGP SIGNATURE-----

--==_Exmh_1246988738_3905P--
