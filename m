Return-Path: <linux-kernel-owner+w=401wt.eu-S1759921AbXH2TnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759921AbXH2TnF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 15:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756565AbXH2Tm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 15:42:56 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:48696 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756399AbXH2Tmz (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 15:42:55 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Peter Staubach <staubach@redhat.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       "Dr. David Alan Gilbert" <linux@treblig.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, neilb@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add source address to sunrpc svc errors
In-Reply-To: Your message of "Wed, 29 Aug 2007 09:37:00 EDT."
             <46D5767C.9050206@redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <20070825012630.GB5431@gallifrey> <20070824185621.3f16f7c9.randy.dunlap@oracle.com> <20070825150927.GA29335@gallifrey> <20070827214333.GM3118@fieldses.org> <7788.1188328346@turing-police.cc.vt.edu>
            <46D5767C.9050206@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1188416518_2981P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 29 Aug 2007 15:41:58 -0400
Message-ID: <13825.1188416518@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1188416518_2981P
Content-Type: text/plain; charset=us-ascii

On Wed, 29 Aug 2007 09:37:00 EDT, Peter Staubach said:

> There are a lot of ways to discover who is throwing trash
> at your system other than the kernel printing messages.
> 
> Tools such as tcpdump and tethereal/wireshark make much better
> tools for this purpose.

Given the number of times I've had to use tcpdump and wireshark to wade
through literally gigabyte traces looking for stuff specifically because
the kernel *didn't* printk information it had handy, I'm not too sympathetic.
Especially when the printk in question is currently saying "I know who's
causing the problem but I'm not going to tell you, nyah nyah"....

(And if there's better ways than kernel printing messages, does that mean we
should deprecate the iptables '-j LOG' target while we're at it?)


--==_Exmh_1188416518_2981P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG1cwGcC3lWbTT17ARAkALAKDzAIKZPG13eEzctWWUzjlzarDLIQCgi8WD
hFfxw5h1oAwxgwexBAebcOw=
=mDJQ
-----END PGP SIGNATURE-----

--==_Exmh_1188416518_2981P--
