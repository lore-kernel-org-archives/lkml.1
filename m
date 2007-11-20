Return-Path: <linux-kernel-owner+w=401wt.eu-S1759758AbXKTQFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759758AbXKTQFy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 11:05:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759108AbXKTQF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 11:05:29 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757288AbXKTQF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 11:05:27 -0500
Message-ID: <474305A5.7070100@redhat.com>
Date: Tue, 20 Nov 2007 08:04:53 -0800
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, torvalds@linux-foundation.org
Subject: Re: [PATCHv4 5/6] Allow setting O_NONBLOCK flag for new sockets
References: <200711200653.lAK6rE6B025891@devserv.devel.redhat.com> <20071119.235944.82120402.davem@davemloft.net>
In-Reply-To: <20071119.235944.82120402.davem@davemloft.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

David Miller wrote:
> FWIW, I think this indirect syscall stuff is the most ugly interface
> I've ever seen proposed for the kernel.

Well, the alternative is to introduce a dozens of new interfaces.  It
was Linus who suggested this alternative.  Plus, it seems that for
syslets we need basically the same interface anyway.


> And I agree with all of the objections raised by both H. Pater Anvin
> and Eric Dumazet.

Eric had no arguments and HP's comments lack a viable alternative proposal.


> Where does this INDIRECT_PARAM() macro get defined?  I do not
> see it being defined anywhere in these patches.

Defined in <linux/indirect.h>:

+#define INDIRECT_PARAM(set, name) current->indirect_params.set.name

Not my idea, I was following one review comment.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHQwWl2ijCOnn/RHQRAhEbAJ9/bkrb/phOMRl16Fb0N1TDYglSsgCeNhHQ
3huhdKCAVTu4CJnktf/ufy4=
=Jj6h
-----END PGP SIGNATURE-----
