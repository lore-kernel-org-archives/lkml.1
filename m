Return-Path: <linux-kernel-owner+w=401wt.eu-S1762895AbXHCRJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762895AbXHCRJg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 13:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbXHCRJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 13:09:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978AbXHCRJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 13:09:29 -0400
Message-ID: <46B3613C.60007@redhat.com>
Date: Fri, 03 Aug 2007 10:09:16 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Richard Henderson <rth@redhat.com>
Subject: arch maintainers: define O_CLOEXEC correctly!
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

A few architectures still don't have a correct O_CLOEXEC definition.
The default definition in <asm-generic/fcntl.h> is wrong for some archs
and you really don't want see 2.6.23 released with a broken ABI.

Affected as far as I know:

Alpha:   probably needs value 010000000

Sparc*:         -"-           0x400000

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGs2E82ijCOnn/RHQRArC+AKCT+/od1qzfC8t7r6jobwd7WS5nOwCgqlzn
ugozxlOLdgTVG0XMsJx0x7Q=
=PinC
-----END PGP SIGNATURE-----
