Return-Path: <linux-kernel-owner+w=401wt.eu-S1760992AbXFQTWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760992AbXFQTWv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 15:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756328AbXFQTWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 15:22:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754554AbXFQTWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 15:22:42 -0400
Message-ID: <467589B1.9000309@redhat.com>
Date: Sun, 17 Jun 2007 12:21:21 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Linus Torvalds <torvalds@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@osdl.org>,
       Jakub Jelinek <jakub@redhat.com>,
       Pierre Peiffer <pierre.peiffer@bull.net>
Subject: Re: [PATCH] Futex: Revert the non-functional REQUEUE_PI
References: <1182107470.8176.455.camel@chaos>
In-Reply-To: <1182107470.8176.455.camel@chaos>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Thomas Gleixner wrote:
> The patch is non-functional and there is no way to fix it proper
> before the 2.6.22 release.

Indeed.  A lot more discussion is needed to handle this correctly.  No
committed code in glibc so far uses the function so removal is no problem.


> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Signed-off-by: Ulrich Drepper <drepper@redhat.com>

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGdYmx2ijCOnn/RHQRAqFEAJ9lwl52xOFl2rJ/sxrlaDtMDbU71wCfYgxS
VJUlQaO3Fba9aPUFWjrVjXI=
=GvES
-----END PGP SIGNATURE-----
