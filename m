Return-Path: <linux-kernel-owner+w=401wt.eu-S2993262AbXECPTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993262AbXECPTL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 11:19:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993260AbXECPTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 11:19:10 -0400
Received: from mail.samba.org ([66.70.73.150]:41428 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993254AbXECPTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 11:19:09 -0400
X-Greylist: delayed 1982 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 May 2007 11:19:09 EDT
Message-ID: <4639F5AD.20807@gmail.com>
Date: Thu, 03 May 2007 09:46:05 -0500
From: Gerald Carter <coffeedude.jerry@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: simo <idra@samba.org>
Cc: Christoph Hellwig <hch@infradead.org>, Steve French <smfrench@gmail.com>,
       linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-cifs-client] Re: SMB2 file system - should it be a	distinct
 module
References: <524f69650704301552j13cd46e5y53a233af753e0548@mail.gmail.com>	 <20070501090657.GA17949@infradead.org>	 <1178198489.28758.14.camel@localhost.localdomain>	 <20070503141742.GB20328@infradead.org> <1178203013.28758.29.camel@localhost.localdomain>
In-Reply-To: <1178203013.28758.29.camel@localhost.localdomain>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Simo,

> I guess DFS referrals can work cross protocol, so if you are redirected
> from a longhorn server to a windoes 2000 or a samba server you want to
> be able to follow the DFS referral and not return an error.
> To do that you need to have either 1 module that support both protocols
> or a way from one module to call the other. Just separating the 2
> without any glue will not work (or you will have to add some userspace
> upcall hack to make it work).

Long term I agree that CIFS and SMB2 should be in the same .ko
But NTLM 0.12 still works for Vista and DFS referrals.
Breaking out SMB2 initially means that it will not clutter
the working cifs.ko code.  Remember that an SMB2 client fs is
mostly research at this point, and not engineering.



cheers, jerry
=====================================================================
Samba                                    ------- http://www.samba.org
Centeris                         -----------  http://www.centeris.com
"What man is a man who does not make the world better?"      --Balian
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGOfWsIR7qMdg1EfYRAk35AJ9bCG/s2rIn2HVB4XehxBMY8XH1AQCgkQUj
Jy522rF0YIdICgd70IWKj4s=
=EWTL
-----END PGP SIGNATURE-----
