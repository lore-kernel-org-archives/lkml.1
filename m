Return-Path: <linux-kernel-owner+w=401wt.eu-S1761277AbXKTQNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761277AbXKTQNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 11:13:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759202AbXKTQNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 11:13:44 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754242AbXKTQNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 11:13:43 -0500
Message-ID: <47430760.1030005@redhat.com>
Date: Tue, 20 Nov 2007 08:12:16 -0800
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, torvalds@linux-foundation.org
Subject: Re: [PATCHv4 2/6] x86&x86-64 support for sys_indirect
References: <200711200653.lAK6rEhQ025882@devserv.devel.redhat.com> <20071120092949.GD7992@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20071120092949.GD7992@osiris.boeblingen.de.ibm.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Heiko Carstens wrote:
> All these macros could be functions, or? Would give us some type checking
> and avoids the capital letters.

Should be possible now.  I didn't do it initially since the macro used
the macro for the largest syscall number.  That macro wasn't always
available.  I'll test it.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHQwdg2ijCOnn/RHQRAmh9AJ9EuthsaoupSHn3kR/x0cWxqR3FoQCfSbmE
8RIDWzPKZ6cv+QVGNl0fawM=
=ScgY
-----END PGP SIGNATURE-----
