Return-Path: <linux-kernel-owner+w=401wt.eu-S1760217AbYEFDDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760217AbYEFDDW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 23:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbYEFDDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 23:03:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562AbYEFDDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 23:03:07 -0400
Message-ID: <481FCA5F.1000101@redhat.com>
Date: Mon, 05 May 2008 20:02:55 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       davidel@xmailserver.org, mtk.manpages@gmail.com,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 02/18] flag parameters: socket and socketpair
References: <200805050342.m453gktl029817@devserv.devel.redhat.com>	<20080505185850.789d870a.akpm@linux-foundation.org>	<481FC38A.6070805@redhat.com> <20080505194221.4349418b.akpm@linux-foundation.org>
In-Reply-To: <20080505194221.4349418b.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andrew Morton wrote:
> oh.  More overhead.

One alternative: I can simply do away with the remapping and just
allocate the bits for the new constants (EFD_CLOEXEC) to match those of
the O_* constants.  This means we can still reuse the low bits which
aren't available in the O_* constants.  It means, though, that the
constants are architecture specific since O_CLOEXEC, for instance, has
different values for different architectures.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFIH8pf2ijCOnn/RHQRAnlPAKCPxPVuaW+nXpCaxNsPmrAunBqt6gCfetlU
41ZicojDFl0TmVX34p8Z1CA=
=q+B/
-----END PGP SIGNATURE-----
