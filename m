Return-Path: <linux-kernel-owner+w=401wt.eu-S1755582AbXKSPtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582AbXKSPtW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 10:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753766AbXKSPtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 10:49:14 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbXKSPtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 10:49:14 -0500
Message-ID: <4741B047.9080601@redhat.com>
Date: Mon, 19 Nov 2007 07:48:23 -0800
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, torvalds@linux-foundation.org
Subject: Re: [PATCHv3 0/4] sys_indirect system call
References: <200711170531.lAH5VaXR025225@devserv.devel.redhat.com>	<20071119145224.31ee5242.dada1@cosmosbay.com>	<4741A7DD.1030407@redhat.com> <20071119164329.5a580b84.dada1@cosmosbay.com>
In-Reply-To: <20071119164329.5a580b84.dada1@cosmosbay.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Eric Dumazet wrote:
> So when you recompile your old program (as you post it and as I commented on),
> it will pass a >= 12 bytes data to kernel, with only first 4 bytes set to O_CLOEXEC.
> 
> Other bytes will contain junk 

If you don't initialize the entire structure and you use it all, of
course you get undefined behavior.  That's nothing new.  The program I
attached is not an example, it's a test for the functionality in this patch.

Like with every kernel interface, you have to use it correctly.  The
good news is that user programs should never use this syscall directly
(just like don't for existing ones).

I see no problem at all here.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHQbBH2ijCOnn/RHQRAkc3AKCxVTWQ3BiQnCBwdbAsT122QWWaiwCggKXN
Z5Sz9/NFojMHZXXTzIMoxX4=
=slte
-----END PGP SIGNATURE-----
