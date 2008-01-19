Return-Path: <linux-kernel-owner+w=401wt.eu-S1752871AbYASGWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbYASGWV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 01:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbYASGWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 01:22:14 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbYASGWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 01:22:13 -0500
Message-ID: <479196E4.3020001@redhat.com>
Date: Fri, 18 Jan 2008 22:21:24 -0800
From: Ulrich Drepper <drepper@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vinay Sridhar <vinay@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RUSAGE_THREAD
References: <1200558425.5992.17.camel@srivinay.in.ibm.com> <20080119011418.850DD26F9FD@magilla.localdomain>
In-Reply-To: <20080119011418.850DD26F9FD@magilla.localdomain>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Roland McGrath wrote:
> +#define	RUSAGE_LWP	RUSAGE_THREAD	/* Solaris name for same */

No need to clutter the kernel header with this, it'll be in the libc header.

Aside from that:

Acked-by: Ulrich Drepper <drpeper@redhat.com>

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFHkZbk2ijCOnn/RHQRAtohAKCyWgJsm20LSqxTznvff3LI8zplvgCgwttu
16eJFNgQXWNEk76b141uZvo=
=DzhA
-----END PGP SIGNATURE-----
