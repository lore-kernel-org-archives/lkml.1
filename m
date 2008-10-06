Return-Path: <linux-kernel-owner+w=401wt.eu-S1755220AbYJFUWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbYJFUWn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 16:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbYJFUWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 16:22:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43560 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453AbYJFUWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 16:22:33 -0400
Message-ID: <48EA7367.10001@suse.com>
Date: Mon, 06 Oct 2008 16:21:59 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Grant Coady <gcoady.lk@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       reiserfs-devel@vger.kernel.org
Subject: Re: [Bug #11504] reiserfs ????BUG in 2.6.27-rc5
References: <0pOgGB.A.uLG.E475IB@wind> <yWwteD.A.dN.u575IB@wind> <48EA423F.50401@oracle.com> <jsrke45fle552s5p007o1pm77v7s3vk15p@4ax.com>
In-Reply-To: <jsrke45fle552s5p007o1pm77v7s3vk15p@4ax.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Grant Coady wrote:
> Did you unload the live filesystem's module above?  May it's a case of 
> don't do that?

When the file system is mounted, the module count is incremented. You
can't remove the module underneath a live file system.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkjqc2cACgkQLPWxlyuTD7ICtwCfabHYk34DH5pFDQyChfxpokdx
/EsAn1bpcobk7oLu1K0OwrzWIXj3r08e
=2yov
-----END PGP SIGNATURE-----
