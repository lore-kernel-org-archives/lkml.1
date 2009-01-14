Return-Path: <linux-kernel-owner+w=401wt.eu-S1761061AbZANAZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761061AbZANAZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 19:25:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760641AbZANAYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 19:24:53 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45522 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760451AbZANAYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 19:24:51 -0500
Message-ID: <496D30C7.4080001@redhat.com>
Date: Tue, 13 Jan 2009 16:24:39 -0800
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: mtk.manpages@gmail.com
CC: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       vegard.nossum@gmail.com, linux-man@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] sys_waitid: return -EFAULT for NULL
References: <cfd18e0f0901131436ud2cf61bkf0e6b00f4b765bb5@mail.gmail.com>	 <cfd18e0f0901131438n232ba114n27ea2d7964d071de@mail.gmail.com>	 <20090113224759.7DFB7FC3DD@magilla.sf.frob.com>	 <20090113224941.36F19FC3DD@magilla.sf.frob.com>	 <cfd18e0f0901131514i2f7be7f1t2c6275c26dbb6874@mail.gmail.com>	 <20090113152457.0d7685ad.akpm@linux-foundation.org>	 <20090113234716.765A8FC3DD@magilla.sf.frob.com> <cfd18e0f0901131613l65bff51fo22e86a01ba2c0720@mail.gmail.com>
In-Reply-To: <cfd18e0f0901131613l65bff51fo22e86a01ba2c0720@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Michael Kerrisk wrote:
> I don't feel strongly about this, but lean towards the idea that we
> should fix things, as per Roland's patch, and I suspect we can get
> away with it, for the reasons I mentioned already.

Yes, change it, it will only cause harm leaving it.  I very much doubt
any programmer deliberately uses this case and if it's not deliberate
they likely want to know about it.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkltMMcACgkQ2ijCOnn/RHQ8fQCgnghAaJQ4fkEMZCnQwsaza80X
WrIAn2z7tEsiMy8pYJs3gkdzO6CNiKTz
=WaAV
-----END PGP SIGNATURE-----
