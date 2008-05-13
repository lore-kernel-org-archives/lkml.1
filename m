Return-Path: <linux-kernel-owner+w=401wt.eu-S1758127AbYEMEV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127AbYEMEV4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 00:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbYEMEVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 00:21:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753332AbYEMEVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 00:21:43 -0400
Message-ID: <48291749.1060400@redhat.com>
Date: Mon, 12 May 2008 21:21:29 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, davidel@xmailserver.org, mtk.manpages@gmail.com,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 18/18] flag parameters: check magic constants
References: <200805062118.m46LI74j004096@devserv.devel.redhat.com>	<20080512201341.9ead6a9a.akpm@linux-foundation.org>	<482910FA.1080703@redhat.com> <20080512.210225.167924945.davem@davemloft.net>
In-Reply-To: <20080512.210225.167924945.davem@davemloft.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

David Miller wrote:
> You'll need to handle MIPS and PARISC as well, as they have
> similar conflicts.

Is MIPS really a problem?  The value is 0x80.  128 protocol types should
be enough.  Even if not, there is no reason why the numbers should be
consecutive.  It's easy enough to skip over a bit.  I.e., after procotol
0x7f the next one would be 0x100.

And PA seems to have gotten O_NONBLOCK wrong.  SPARC does it right AFAICS.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFIKRdJ2ijCOnn/RHQRAovKAKDFz2ZJ0E2XYVu5Qn8fME+ieZZopwCgmH4D
ldfvNrhK8LdvjZzNPViILV0=
=Z9Dj
-----END PGP SIGNATURE-----
