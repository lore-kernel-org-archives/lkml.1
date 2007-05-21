Return-Path: <linux-kernel-owner+w=401wt.eu-S1763344AbXEUS1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763344AbXEUS1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 14:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756650AbXEUS1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 14:27:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756400AbXEUS1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 14:27:31 -0400
Message-ID: <4651E44A.9070301@redhat.com>
Date: Mon, 21 May 2007 11:26:18 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: second, bigger problem with private futexes
References: <4651D628.1070206@redhat.com> <4651E1D4.6010705@cosmosbay.com>
In-Reply-To: <4651E1D4.6010705@cosmosbay.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Eric Dumazet wrote:
> Do you mean POSIX allowed to mix PROCESS_PRIVATE and PROCESS_SHARED
> condvar and mutexes ? Seems silly to me :(

Don't judge what you don't understand.  If all waiters are always in one
process but the notifiers can be in different processes, this setup
might make a lot of sense.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGUeRK2ijCOnn/RHQRAqRuAKCpc7cmhsnwfclz1DU81RNXRjm68ACgosZc
RqWca4r+Ya54dp5zNztkYuk=
=sW/1
-----END PGP SIGNATURE-----
