Return-Path: <linux-kernel-owner+w=401wt.eu-S1757753AbYEMFnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753AbYEMFnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 01:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928AbYEMFnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 01:43:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755219AbYEMFnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 01:43:22 -0400
Message-ID: <48292A5A.4050606@redhat.com>
Date: Mon, 12 May 2008 22:42:50 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, davidel@xmailserver.org, mtk.manpages@gmail.com,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 18/18] flag parameters: check magic constants
References: <200805062118.m46LI74j004096@devserv.devel.redhat.com>	<20080512201341.9ead6a9a.akpm@linux-foundation.org>	<482910FA.1080703@redhat.com>	<20080512.210225.167924945.davem@davemloft.net>	<20080512220416.ef9a9645.akpm@linux-foundation.org>	<482922E2.3040902@redhat.com> <20080512221917.07cf7b06.akpm@linux-foundation.org>
In-Reply-To: <20080512221917.07cf7b06.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andrew Morton wrote:
> Different bug, I think.
> 
> net/socket.c: In function 'sys_paccept':
> net/socket.c:1543: error: implicit declaration of function 'set_restore_sigmask'

Right, that's the signal mask stuff.  Should be fixed by the other patch
I sent.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFIKSpa2ijCOnn/RHQRAmPvAJ90D3ZHrIWs1ZE5K9XVEdZBh8vcdQCePcaw
1Hnyz58x9oizIXe6qiS82xU=
=o78L
-----END PGP SIGNATURE-----
