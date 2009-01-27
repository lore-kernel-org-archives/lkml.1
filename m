Return-Path: <linux-kernel-owner+w=401wt.eu-S1753558AbZA0Vpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbZA0Vpy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 16:45:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbZA0Vpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 16:45:45 -0500
Received: from mx1.suse.de ([195.135.220.2]:51126 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759AbZA0Vpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 16:45:44 -0500
Message-ID: <497F8027.2060809@suse.com>
Date: Tue, 27 Jan 2009 16:44:07 -0500
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] kmalloc: Return NULL instead of link failure
References: <4975F376.4010506@suse.com> <20090127133723.46eb7035.akpm@linux-foundation.org>
In-Reply-To: <20090127133723.46eb7035.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andrew Morton wrote:
> Strange patch format, but it applied.

Ugh, sorry about that. I forgot to disable the GPG signing. It escapes
- -'s like that.

> I'll punt this patch in the Pekka direction.
> 
> Do you think we should include it in 2.6.28.x?

I think so. It's a corner case, but does fix a build failure.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkl/gCcACgkQLPWxlyuTD7IdcwCgkdOmH3P8a9q1RQYsOcCkG8C0
TYsAn3rEJMROguhVqbWuFlzg58t+vVEL
=RM/e
-----END PGP SIGNATURE-----
