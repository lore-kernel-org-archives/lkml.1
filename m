Return-Path: <linux-kernel-owner+w=401wt.eu-S1761580AbXISQtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761580AbXISQtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 12:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759622AbXISQtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 12:49:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757654AbXISQtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 12:49:24 -0400
Message-ID: <46F15305.2030507@redhat.com>
Date: Wed, 19 Sep 2007 09:49:09 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: netdev <netdev@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: follow-up: discrepancy with POSIX
References: <46F13E8B.4050309@redhat.com> <p73sl5aveqh.fsf@bingen.suse.de>
In-Reply-To: <p73sl5aveqh.fsf@bingen.suse.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andi Kleen wrote:
> The standard way to undo connect is to use AF_UNSPEC. Code to handle
> that for dgram sockets is there. It's the same code for v4 and v6.

I quoted the standard and it does not say anything about AF_UNSPEC.  So
you cannot simply make such broad statements.

I also don't say that this behavior should be removed.  It's certainly
useful, very much so in fact.

But the spec calls for a "null address" to be used and that's in my
understanding something different from using AF_UNSPEC.

I looked through Stevens TCP Illustrated Vol 2 and it seems not to
mention resetting the address at all.  The POSIX spec certainly got this
text from .1g.

I cannot test it on other systems.  If somebody has access to some
certified systems (and maybe others), write a bit of code which creates
a DGRAM socket, connect to one address, call connect with a "null
address", then connect to another address (which likely has to use a
different interface since otherwise the connect will just succeed, it
seems).

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFG8VMF2ijCOnn/RHQRAr9NAJwLxyql0kQnMGJNaPZlRGsuB6rGEACgog88
WIWAFhuBWsjps7PdbcoumUQ=
=oLxP
-----END PGP SIGNATURE-----
