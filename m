Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbZGDPP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbZGDPP7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 11:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751509AbZGDPPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 11:15:50 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:49771 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbZGDPPt (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 11:15:49 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>,
       linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH] xen: wait up to 5 minutes for device connection
In-Reply-To: Your message of "Fri, 03 Jul 2009 23:21:35 +0200."
             <4A4E765F.4000501@redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <1246626771-11345-1-git-send-email-pbonzini@redhat.com> <20090703160046.GA4262@infradead.org>
            <4A4E765F.4000501@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1246720530_3612P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 04 Jul 2009 11:15:30 -0400
Message-ID: <15093.1246720530@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1246720530_3612P
Content-Type: text/plain; charset=us-ascii

On Fri, 03 Jul 2009 23:21:35 +0200, Gerd Hoffmann said:

> Usually it is *much* faster, but when the host is quite loaded it can 
> take a unusual long time.  With 10 seconds it happends in practice now 
> and then that a virtual machine fails to boot just because the virtual 
> root disk didn't show up fast enough.

Are people actually trying to boot a guest on a host machine so loaded that
disks take that long to show up - and expect things to work in any sane
matter?

I'm tempted to suggest that booting under conditions like that is almost
deserving of its own kernel Tainted flag.  If devices aren't showing up in
a timely manner, we probably need to be leery of any other kernel timeout
values as well...

--==_Exmh_1246720530_3612P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKT3IScC3lWbTT17ARAkR9AJ9k/hN0tcMyztbJgfDxjd5bGI8ypQCg/ORb
/TgucmDftVlTcXsxIAiBsNU=
=oHhk
-----END PGP SIGNATURE-----

--==_Exmh_1246720530_3612P--
