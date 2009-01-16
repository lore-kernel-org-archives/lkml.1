Return-Path: <linux-kernel-owner+w=401wt.eu-S1756284AbZAPPxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284AbZAPPxq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 10:53:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756923AbZAPPxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 10:53:15 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:33063 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756616AbZAPPxN (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 10:53:13 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Theodore Tso <tytso@mit.edu>
Cc: Pavel Machek <pavel@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Takashi Sato <t-sato@yk.jp.nec.com>
Subject: Re: [PATCH] Allow SysRq emergency sync to thaw frozen filesystems
In-Reply-To: Your message of "Fri, 16 Jan 2009 10:40:26 EST."
             <20090116154026.GG10683@mit.edu>
From: Valdis.Kletnieks@vt.edu
References: <496EB639.6090800@redhat.com> <20090116084828.GB4795@atrey.karlin.mff.cuni.cz> <16406.1232119029@turing-police.cc.vt.edu>
            <20090116154026.GG10683@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1232121154_11157P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 16 Jan 2009 10:52:34 -0500
Message-ID: <18022.1232121154@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1232121154_11157P
Content-Type: text/plain; charset=us-ascii

On Fri, 16 Jan 2009 10:40:26 EST, Theodore Tso said:

> My biggest complaint is that the two operations are largely
> orthogonal.  Emergency sync and unfreeze are two very different
> operations, and while emergency sync is largely harmless, it just
> seems really unclean to combine the two.  For one thing, it'll be
> extremely non-obvious that emergency sync implies unfreeze, and
> changing the sysrq help to say emergency-Sync-and-unfreeze just
> screams "kludge"....

Fair enough - as it is, I usually end up doing sysrq-s, -s, -u, -s, -b
anyhow because each sysrq- does one little thing, adding another little
thing on some other control-meta-alt-cokebottle key *is* probably the
right choice, we still have a few keyscan codes left.. ;)

--==_Exmh_1232121154_11157P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJcK1CcC3lWbTT17ARArKVAKCkacyG+Jy01mnlZmhIpzwYFZdAQACgoKcB
JIWLeo+NcaRCNGjQ0LlPtCM=
=4IF+
-----END PGP SIGNATURE-----

--==_Exmh_1232121154_11157P--
